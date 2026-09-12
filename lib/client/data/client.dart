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
  FaClient({Session session = const Session()})
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
          ..interceptors.add(_session);
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

  Future<String> get(String path) async {
    final Logger scope = logger.child({'path': path});
    scope.debug('Fetching {path}');
    late final Response<String> response;
    try {
      response = await dio.get<String>(path);
    } on DioException catch (e) {
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
