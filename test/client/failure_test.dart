import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';

void main() {
  test('the failure text for a rejected request carries its status code', () {
    expect(failureFor(const RequestRejected(400)).detail, contains('400'));
  });

  test('a rejected request withholds retry', () {
    expect(
      failureFor(const RequestRejected(400), onRetry: () {}).onRetry,
      isNull,
    );
  });

  test('a snackbar carries the same sentence as the page detail', () {
    const RateLimited failure = RateLimited(Duration(seconds: 30));
    expect(describeFailure(failure), contains('30'));
    expect(failureFor(failure).detail, describeFailure(failure));
  });

  test('a disabled account offers no retry', () {
    expect(failureFor(const AccountDisabled(), onRetry: () {}).onRetry, isNull);
  });
}
