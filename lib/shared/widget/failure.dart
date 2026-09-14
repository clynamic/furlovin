import 'package:furlovin/shared/data/data.dart';
import 'package:material_ui/material_ui.dart';

class FailureView extends StatelessWidget {
  const FailureView({
    super.key,
    required this.icon,
    required this.title,
    this.detail,
    this.onRetry,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? detail;
  final VoidCallback? onRetry;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: Space.medium),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (detail case final String value) ...[
              const SizedBox(height: Space.small),
              Text(
                value,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onRetry case final VoidCallback retry) ...[
              const SizedBox(height: Space.page),
              FilledButton.tonal(
                onPressed: retry,
                child: const Text('Try again'),
              ),
            ],
            if (onAction case final VoidCallback action) ...[
              const SizedBox(height: Space.small),
              TextButton.icon(
                onPressed: action,
                icon: actionIcon == null ? null : Icon(actionIcon),
                label: Text(actionLabel ?? 'Continue'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
