import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

final RegExp _hump = RegExp('(?<=[a-z])(?=[A-Z])');

String spokenName(String key) => key.split(_hump).join(' ').toLowerCase();

extension ReadIssueWording on ReadIssue {
  String headline(String Function(String slot) label) => switch (kind) {
    IssueKind.unreadable => "Couldn't read ${label(slot)}",
    IssueKind.dropped =>
      'Skipped $count ${count == 1 ? 'item' : 'items'} in ${label(slot)}',
    IssueKind.missing =>
      '${spokenName(field!)} missing in ${label(slot)}'
          '${count > 1 ? ' ($count times)' : ''}',
  };

  IconData get icon => switch (kind) {
    IssueKind.unreadable => Icons.block,
    IssueKind.dropped => Icons.filter_alt_off_outlined,
    IssueKind.missing => Icons.help_outline,
  };
}

String issueDetails(
  ReadReport report,
  List<ReadIssue> issues,
  PackageInfo? app,
) {
  final String version = app == null
      ? 'furlovin'
      : '${app.appName} ${app.version}+${app.buildNumber}';
  return [
    [
      version,
      if (report.rules case final String rules) 'rules $rules',
      defaultTargetPlatform.name,
      if (report.theme case final String theme) 'theme $theme',
    ].join(' · '),
    ?report.page,
    for (final ReadIssue issue in issues) '$issue',
  ].join('\n');
}

Future<void> showReadIssues(
  BuildContext context,
  ReadReport report, {
  String? slot,
  String Function(String slot) label = spokenName,
}) => showDialog<void>(
  context: context,
  builder: (context) =>
      ReadIssuesDialog(report: report, slot: slot, label: label),
);

class ReadIssuesDialog extends ConsumerWidget {
  const ReadIssuesDialog({
    super.key,
    required this.report,
    this.slot,
    this.label = spokenName,
  });

  final ReadReport report;
  final String? slot;
  final String Function(String slot) label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final List<ReadIssue> issues = switch (slot) {
      final String only => report.of(only).toList(),
      null => report.issues,
    };
    final PackageInfo? app = ref.watch(packageInfoProvider).asData?.value;
    return AlertDialog(
      title: const Text('Some of this page could not be read'),
      contentPadding: const EdgeInsets.symmetric(vertical: Space.small),
      content: SizedBox(
        width: 420,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final ReadIssue issue in issues)
              ListTile(
                leading: Icon(issue.icon, color: theme.colorScheme.error),
                title: Text(issue.headline(label)),
                subtitle: Text(
                  '$issue'.split('\n').map((e) => e.trim()).join('\n'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton.icon(
          onPressed: () => Clipboard.setData(
            ClipboardData(text: issueDetails(report, issues, app)),
          ),
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy details'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class ReadIssuesButton extends StatelessWidget {
  const ReadIssuesButton({
    super.key,
    required this.report,
    this.label = spokenName,
    this.onImage = false,
  });

  final ReadReport? report;
  final String Function(String slot) label;
  final bool onImage;

  @override
  Widget build(BuildContext context) {
    final ReadReport? known = report;
    if (known == null || known.isEmpty) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    return IconButton(
      tooltip: 'Some of this page could not be read',
      onPressed: () => showReadIssues(context, known, label: label),
      icon: Badge.count(
        count: known.issues.length,
        child: Icon(
          Icons.report_problem_outlined,
          color: onImage ? Colors.white : theme.colorScheme.error,
          shadows: onImage
              ? const [Shadow(color: scrimShadow, blurRadius: 10)]
              : null,
        ),
      ),
    );
  }
}

class ReadIssueFallback extends StatelessWidget {
  const ReadIssueFallback({
    super.key,
    required this.report,
    required this.slot,
    required this.name,
    this.label = spokenName,
  });

  final ReadReport report;
  final String slot;
  final String name;
  final String Function(String slot) label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Space.snug,
        Space.small,
        Space.tight,
        Space.small,
      ),
      decoration: BoxDecoration(
        borderRadius: Corner.cards,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        spacing: Space.snug,
        children: [
          Icon(Icons.block, size: 20, color: theme.colorScheme.error),
          Expanded(
            child: Text(
              "Couldn't read $name",
              style: theme.textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () =>
                showReadIssues(context, report, slot: slot, label: label),
            child: const Text('Details'),
          ),
        ],
      ),
    );
  }
}
