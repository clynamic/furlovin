import 'package:furlovin/client/client.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

typedef FailureText = ({IconData icon, String title, String detail});

FailureText failureText(Object error, {bool loggedIn = true}) =>
    switch (error) {
      final FaException known => _faFailureText(known, loggedIn: loggedIn),
      _ => (
        icon: Icons.error_outline,
        title: 'Something broke',
        detail: '$error',
      ),
    };

FailureText _faFailureText(FaException error, {required bool loggedIn}) =>
    switch (error) {
      TransportFailure() => (
        icon: Icons.cloud_off_outlined,
        title: 'No connection',
        detail: 'Could not reach Fur Affinity.',
      ),
      RateLimited(:final Duration? retryAfter) => (
        icon: Icons.hourglass_empty,
        title: 'Slow down',
        detail: retryAfter == null
            ? 'Fur Affinity asked us to wait.'
            : 'Fur Affinity asked us to wait '
                  '${retryAfter.inSeconds} seconds.',
      ),
      Challenged() => (
        icon: Icons.verified_user_outlined,
        title: 'Verification needed',
        detail: 'Fur Affinity wants to check that you are a person.',
      ),
      AuthenticationRequired() => (
        icon: Icons.login,
        title: 'Logged out',
        detail: 'This needs you to be logged in.',
      ),
      ContentFiltered() => (
        icon: Icons.visibility_off_outlined,
        title: 'Mature or Adult content',
        detail: loggedIn
            ? 'Your Fur Affinity content settings hide this.'
            : 'Log in and allow Mature or Adult content in your Fur Affinity '
                  'settings to see this.',
      ),
      Gone(:final String reason) => (
        icon: Icons.search_off,
        title: 'Not here',
        detail: reason,
      ),
      ActionRejected(:final String reason) => (
        icon: Icons.block,
        title: 'Refused',
        detail: reason,
      ),
      Forbidden() => (
        icon: Icons.block,
        title: 'Not allowed',
        detail: 'Fur Affinity refused this.',
      ),
      RequestRejected(:final int status) => (
        icon: Icons.error_outline,
        title: 'Request rejected',
        detail: 'Fur Affinity rejected this request ($status).',
      ),
      ServerFailure(:final int status) => (
        icon: Icons.error_outline,
        title: 'Fur Affinity is struggling',
        detail: 'Fur Affinity answered with $status.',
      ),
    };

String describeFailure(Object error) => failureText(error).detail;

FailureView failureFor(
  Object error, {
  VoidCallback? onRetry,
  VoidCallback? onLogin,
  Future<bool?> Function(String url)? onVerify,
}) {
  final FailureText text = failureText(error, loggedIn: onLogin == null);
  final bool retries = switch (error) {
    AuthenticationRequired() ||
    ContentFiltered() ||
    Gone() ||
    ActionRejected() ||
    Forbidden() ||
    RequestRejected() => false,
    _ => true,
  };
  final ({String label, IconData icon, VoidCallback? action})? extra =
      switch (error) {
        Challenged(:final String url) => (
          label: 'Verify',
          icon: Icons.verified_user_outlined,
          action: onVerify == null
              ? null
              : () async {
                  if (await onVerify(url) ?? false) onRetry?.call();
                },
        ),
        AuthenticationRequired() || ContentFiltered() => (
          label: 'Log in to Fur Affinity',
          icon: Icons.login,
          action: onLogin,
        ),
        _ => null,
      };
  return FailureView(
    icon: text.icon,
    title: text.title,
    detail: text.detail,
    onRetry: retries ? onRetry : null,
    actionLabel: extra?.label,
    actionIcon: extra?.icon,
    onAction: extra?.action,
  );
}
