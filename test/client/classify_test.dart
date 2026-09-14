import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';

import '../_support/documents.dart';

Response<Object?> _response(
  int status, {
  String body = '<html></html>',
  Map<String, String> headers = const {},
}) => Response<Object?>(
  requestOptions: RequestOptions(path: '/'),
  statusCode: status,
  data: body,
  headers: Headers.fromMap({
    for (final MapEntry<String, String> e in headers.entries) e.key: [e.value],
  }),
);

void main() {
  test('reads a missing page as gone rather than success', () {
    expect(classify(_response(404)), isA<Gone>());
    expect(classify(_response(410)), isA<Gone>());
  });

  test('reads an unauthorised status as needing a sign in', () {
    expect(classify(_response(401)), isA<AuthenticationRequired>());
  });

  test('does not pass other client errors off as a page', () {
    expect(classify(_response(400)), isA<RequestRejected>());
    expect(classify(_response(405)), isA<RequestRejected>());
  });

  test('still lets a real page through', () {
    expect(classify(_response(200)), isNull);
    expect(classify(_response(301)), isNull);
  });

  test('keeps the failures it already understood', () {
    expect(classify(_response(403)), isA<Forbidden>());
    expect(classify(_response(500)), isA<ServerFailure>());
    expect(classify(_response(429)), isA<RateLimited>());
  });

  test('reads retry-after as seconds or as a date', () {
    final RateLimited seconds =
        classify(_response(429, headers: {'retry-after': '120'}))!
            as RateLimited;
    expect(seconds.retryAfter, const Duration(seconds: 120));

    final DateTime soon = DateTime.now().toUtc().add(
      const Duration(minutes: 5),
    );
    final RateLimited dated =
        classify(
              _response(429, headers: {'retry-after': HttpDate.format(soon)}),
            )!
            as RateLimited;
    expect(dated.retryAfter, isNotNull);
    expect(dated.retryAfter!.inSeconds, closeTo(300, 5));
  });

  test('a past retry-after date does not come back negative', () {
    final DateTime past = DateTime.now().toUtc().subtract(
      const Duration(minutes: 5),
    );
    final RateLimited stale =
        classify(
              _response(429, headers: {'retry-after': HttpDate.format(past)}),
            )!
            as RateLimited;
    expect(stale.retryAfter, Duration.zero);
  });

  test('reads the mature content notice as filtered content', () {
    expect(
      classify(_response(200, body: fixture('alder71_mature'))),
      isA<ContentFiltered>(),
    );
  });

  test('reads a registered users only notice as needing a log in', () {
    expect(
      classify(_response(200, body: fixture('alder71_registered'))),
      isA<AuthenticationRequired>(),
    );
  });

  test('retries a lost connection twice and nothing else', () {
    const TransportFailure lost = TransportFailure('offline');
    expect(retryFailure(0, lost), isNotNull);
    expect(retryFailure(1, lost), isNotNull);
    expect(retryFailure(2, lost), isNull);
    expect(retryFailure(0, const ContentFiltered()), isNull);
    expect(retryFailure(0, const AuthenticationRequired()), isNull);
    expect(retryFailure(0, const ParseFailure('submission', {})), isNull);
  });
}
