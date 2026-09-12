import 'package:furlovin/client/client.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

FailureView failureFor(Object error, {VoidCallback? onRetry}) =>
    switch (error) {
      TransportFailure() => FailureView(
        icon: Icons.cloud_off_outlined,
        title: 'No connection',
        detail: 'Could not reach Fur Affinity.',
        onRetry: onRetry,
      ),
      RateLimited(:final Duration? retryAfter) => FailureView(
        icon: Icons.hourglass_empty,
        title: 'Slow down',
        detail: retryAfter == null
            ? 'Fur Affinity asked us to wait.'
            : 'Fur Affinity asked us to wait '
                  '${retryAfter.inSeconds} seconds.',
        onRetry: onRetry,
      ),
      Challenged() => const FailureView(
        icon: Icons.verified_user_outlined,
        title: 'Verification needed',
        detail: 'Fur Affinity wants to check that you are a person.',
      ),
      AuthenticationRequired() => const FailureView(
        icon: Icons.login,
        title: 'Signed out',
        detail: 'This needs you to be signed in.',
      ),
      Gone(:final String reason) => FailureView(
        icon: Icons.search_off,
        title: 'Not here',
        detail: reason,
      ),
      Forbidden() => const FailureView(
        icon: Icons.block,
        title: 'Not allowed',
        detail: 'Fur Affinity refused this.',
      ),
      ServerFailure(:final int status) => FailureView(
        icon: Icons.error_outline,
        title: 'Fur Affinity is struggling',
        detail: 'The site answered with $status.',
        onRetry: onRetry,
      ),
      _ => FailureView(
        icon: Icons.error_outline,
        title: 'Something broke',
        detail: '$error',
        onRetry: onRetry,
      ),
    };
