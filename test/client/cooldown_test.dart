import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';

class _Site implements HttpClientAdapter {
  _Site(this.answers);

  final List<ResponseBody Function()> answers;
  int asked = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => answers[asked++ % answers.length]();

  @override
  void close({bool force = false}) {}
}

ResponseBody _slowDown() => ResponseBody.fromString(
  '',
  429,
  headers: {
    'retry-after': ['10'],
  },
);

ResponseBody _challenge() => ResponseBody.fromString(
  'Just a moment...',
  403,
  headers: {
    'cf-mitigated': ['challenge'],
  },
);

ResponseBody _timedChallenge() => ResponseBody.fromString(
  'Just a moment...',
  403,
  headers: {
    'cf-mitigated': ['challenge'],
    'retry-after': ['5'],
  },
);

ResponseBody _page() => ResponseBody.fromString('<html></html>', 200);

void main() {
  late DateTime clock;
  late Cooldown cooldown;

  setUp(() {
    clock = DateTime(2026);
    cooldown = Cooldown(now: () => clock);
  });

  FaClient client(_Site site) =>
      FaClient(cooldown: cooldown)..dio.httpClientAdapter = site;

  test('a rate limit holds every request until it has passed', () async {
    final _Site site = _Site([_slowDown, _page]);
    final FaClient fa = client(site);

    await expectLater(fa.get('/browse/1/'), throwsA(isA<RateLimited>()));
    await expectLater(fa.get('/browse/2/'), throwsA(isA<RateLimited>()));
    expect(site.asked, 1);

    clock = clock.add(const Duration(seconds: 11));
    expect(await fa.get('/browse/2/'), '<html></html>');
    expect(site.asked, 2);
  });

  test('image downloads wait out the same rate limit', () async {
    final _Site site = _Site([_slowDown]);
    final FaClient fa = client(site);
    await expectLater(fa.get('/browse/1/'), throwsA(isA<RateLimited>()));

    final DioFileService images = DioFileService(() async => fa.dio);
    await expectLater(
      images.get('https://t.furaffinity.net/1@200-1.jpg'),
      throwsA(
        isA<DioException>().having((e) => e.error, 'error', isA<RateLimited>()),
      ),
    );
    expect(site.asked, 1);
  });

  test('a limit without a retry-after pauses for the default', () {
    cooldown.hold(const RateLimited(null), rateLimitPause);
    clock = clock.add(rateLimitPause - const Duration(seconds: 1));
    expect(cooldown.holding, isA<RateLimited>());
    clock = clock.add(const Duration(seconds: 2));
    expect(cooldown.holding, isNull);
  });

  test('a shorter hold never cuts a longer one short', () {
    cooldown.hold(const RateLimited(null), const Duration(seconds: 60));
    cooldown.hold(const RateLimited(null), const Duration(seconds: 5));
    clock = clock.add(const Duration(seconds: 30));
    expect(cooldown.holding, isA<RateLimited>());
  });

  test('a challenge holds requests for the challenge pause', () async {
    final _Site site = _Site([_challenge, _page]);
    final FaClient fa = client(site);

    await expectLater(fa.get('/browse/1/'), throwsA(isA<Challenged>()));
    await expectLater(fa.get('/browse/1/'), throwsA(isA<Challenged>()));
    expect(site.asked, 1);

    clock = clock.add(challengePause + const Duration(seconds: 1));
    expect(await fa.get('/browse/1/'), '<html></html>');
  });

  test('a challenge that says when to come back is held that long', () async {
    final _Site site = _Site([_timedChallenge, _page]);
    final FaClient fa = client(site);

    await expectLater(fa.get('/browse/1/'), throwsA(isA<Challenged>()));
    clock = clock.add(const Duration(seconds: 6));
    expect(await fa.get('/browse/1/'), '<html></html>');
  });
}
