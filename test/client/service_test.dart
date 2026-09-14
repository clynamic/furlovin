import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';

class _Recording implements HttpClientAdapter {
  _Recording(this.name, this.seen);

  final String name;
  final List<String> seen;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(name);
    return ResponseBody.fromBytes(const [], 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('downloads with the client that is current at request time', () async {
    final List<String> seen = [];
    Dio current = Dio()..httpClientAdapter = _Recording('guest', seen);
    final DioFileService service = DioFileService(() async => current);

    await service.get('https://t.furaffinity.net/1@200-1.jpg');
    current = Dio()..httpClientAdapter = _Recording('member', seen);
    await service.get('https://t.furaffinity.net/1@200-1.jpg');

    expect(seen, ['guest', 'member']);
  });
}
