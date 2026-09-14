import 'dart:async';

import 'package:dio/dio.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

class SessionInterceptor extends Interceptor {
  SessionInterceptor(this.session);

  Session session;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(session.headersFor(options.uri.toString()));
    handler.next(options);
  }
}

class FaClient {
  FaClient({Session session = const Session(), Cooldown? cooldown})
    : _session = SessionInterceptor(session) {
    dio =
        Dio(
            BaseOptions(
              baseUrl: faOrigin,
              responseType: ResponseType.plain,
              validateStatus: (status) => status != null && status < 600,
              followRedirects: true,
            ),
          )
          ..httpClientAdapter = NativeAdapter()
          ..interceptors.addAll([
            CooldownInterceptor(cooldown ?? Cooldown()),
            _session,
          ]);
  }

  final Logger logger = Logger('FaClient');
  final SessionInterceptor _session;
  final StreamController<FaException> _failures =
      StreamController<FaException>.broadcast();
  late final Dio dio;

  Stream<FaException> get failures => _failures.stream;

  void close() {
    _failures.close();
    dio.close(force: true);
  }

  Session get session => _session.session;

  set session(Session value) => _session.session = value;

  Future<String> get(String path) =>
      _send(path, 'Fetching {path}', () => dio.get<String>(path));

  Future<String> post(String path, Map<String, String> fields) => _send(
    path,
    'Posting to {path}',
    () => dio.post<String>(
      path,
      data: fields,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    ),
  );

  Future<String> _send(
    String path,
    String event,
    Future<Response<String>> Function() request,
  ) async {
    final Logger scope = logger.child({'path': path});
    scope.debug(event);
    late final Response<String> response;
    try {
      response = await request();
    } on DioException catch (e) {
      if (e.error case final FaException held) {
        scope.warn('Held back as {failure}', {
          'failure': held.runtimeType.toString(),
        });
        throw held;
      }
      scope.warn('Request failed', {'type': e.type.name}, e);
      throw TransportFailure(e);
    }
    final FaException? failure = classify(response);
    if (failure != null) {
      scope.warn('Rejected as {failure}', {
        'failure': failure.runtimeType.toString(),
        'status': response.statusCode,
      });
      if (!_failures.isClosed) _failures.add(failure);
      throw failure;
    }
    scope.debug('Fetched {path} ({status}, {bytes} bytes)', {
      'status': response.statusCode,
      'bytes': response.data?.length ?? 0,
    });
    return response.data ?? '';
  }
}
