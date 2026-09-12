import 'dart:io';

import 'package:dio/dio.dart';

String describeFailure(Object error) => switch (error) {
  TransportFailure() => 'Could not reach Fur Affinity.',
  RateLimited() => 'Fur Affinity asked us to slow down.',
  Challenged() => 'Fur Affinity wants to check that you are a person.',
  AuthenticationRequired() => 'That needs you to be signed in.',
  Gone(:final String reason) => reason,
  Forbidden() => 'Fur Affinity refused that.',
  RequestRejected(:final int status) =>
    'Fur Affinity rejected that request ($status).',
  ServerFailure(:final int status) => 'Fur Affinity answered with $status.',
  _ => 'Something broke.',
};

sealed class FaException implements Exception {
  const FaException();
}

class TransportFailure extends FaException {
  const TransportFailure(this.cause);

  final Object cause;

  @override
  String toString() => 'TransportFailure: $cause';
}

class RateLimited extends FaException {
  const RateLimited(this.retryAfter);

  final Duration? retryAfter;

  @override
  String toString() => 'RateLimited: retry after $retryAfter';
}

class Challenged extends FaException {
  const Challenged(this.url);

  final String url;

  @override
  String toString() => 'Challenged: $url';
}

class AuthenticationRequired extends FaException {
  const AuthenticationRequired();

  @override
  String toString() => 'AuthenticationRequired';
}

class Gone extends FaException {
  const Gone(this.reason);

  final String reason;

  @override
  String toString() => 'Gone: $reason';
}

class Forbidden extends FaException {
  const Forbidden();

  @override
  String toString() => 'Forbidden';
}

class RequestRejected extends FaException {
  const RequestRejected(this.status);

  final int status;

  @override
  String toString() => 'RequestRejected: $status';
}

class ServerFailure extends FaException {
  const ServerFailure(this.status);

  final int status;

  @override
  String toString() => 'ServerFailure: $status';
}

const List<String> _challengeMarkers = [
  'challenge-platform',
  'cf-chl',
  '_cf_chl_opt',
  'Just a moment...',
  'DDoS protection by',
];

bool isChallenge(Response<Object?> response) {
  final String? mitigated = response.headers.value('cf-mitigated');
  if (mitigated?.toLowerCase() == 'challenge') return true;
  final String? server = response.headers.value('server');
  if (server == null || !server.toLowerCase().contains('cloudflare')) {
    return false;
  }
  final Object? data = response.data;
  return data is String && _challengeMarkers.any(data.contains);
}

Duration? _retryAfter(Response<Object?> response) {
  final String? value = response.headers.value('retry-after');
  if (value == null) return null;
  final String trimmed = value.trim();
  final int? seconds = int.tryParse(trimmed);
  if (seconds != null) return Duration(seconds: seconds);
  final DateTime until;
  try {
    until = HttpDate.parse(trimmed);
  } on FormatException {
    return null;
  }
  final Duration wait = until.difference(DateTime.now().toUtc());
  return wait.isNegative ? Duration.zero : wait;
}

final RegExp _title = RegExp(
  r'<title>\s*System Error\s*</title>',
  caseSensitive: false,
);

FaException? classify(Response<Object?> response) {
  if (isChallenge(response)) {
    return Challenged(response.realUri.toString());
  }

  final int status = response.statusCode ?? 0;
  if (status == 429 || status == 503) return RateLimited(_retryAfter(response));
  if (status == 403) return const Forbidden();
  if (status >= 500) return ServerFailure(status);

  final Object? data = response.data;

  if (status == 401) return const AuthenticationRequired();
  if (status == 404) return const Gone('not found');
  if (status == 410) return const Gone('removed');

  if (data is! String) {
    return status >= 400 ? RequestRejected(status) : null;
  }

  if (_title.hasMatch(data)) {
    return Gone(
      data.contains('cannot be found')
          ? 'not found'
          : data.contains('not in our database')
          ? 'removed'
          : 'system error',
    );
  }

  if (data.contains('redirect-message') && data.contains('Please log in')) {
    return const AuthenticationRequired();
  }

  return status >= 400 ? RequestRejected(status) : null;
}
