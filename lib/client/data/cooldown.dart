import 'package:dio/dio.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/shared/shared.dart';

const Duration rateLimitPause = Duration(seconds: 30);
const Duration challengePause = Duration(seconds: 60);

class Cooldown {
  Cooldown({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  DateTime? _until;
  FaException? _cause;

  FaException? get holding {
    final DateTime? until = _until;
    if (until == null) return null;
    final Duration left = until.difference(_now());
    if (left <= Duration.zero) {
      _until = null;
      _cause = null;
      return null;
    }
    return switch (_cause) {
      RateLimited() => RateLimited(left),
      final FaException cause => cause,
      null => null,
    };
  }

  void hold(FaException cause, Duration wait) {
    final DateTime until = _now().add(wait);
    if (_until case final DateTime current when current.isAfter(until)) return;
    _until = until;
    _cause = cause;
  }
}

class CooldownInterceptor extends Interceptor {
  CooldownInterceptor(this.cooldown);

  final Cooldown cooldown;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (cooldown.holding case final FaException held) {
      return handler.reject(DioException(requestOptions: options, error: held));
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final Duration? retryAfter = retryAfterOf(response);
    if (isChallenge(response)) {
      cooldown.hold(
        Challenged(response.realUri.toString()),
        retryAfter ?? challengePause,
      );
    } else if (response.statusCode case 429 || 503) {
      cooldown.hold(RateLimited(retryAfter), retryAfter ?? rateLimitPause);
    }
    handler.next(response);
  }
}

Duration? pauseOnRateLimit(Object error, int attempt) => switch (error) {
  RateLimited(:final Duration? retryAfter) =>
    retryAfter ?? actionSpacing * attempt,
  _ => null,
};
