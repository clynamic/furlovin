import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

final RegExp _hump = RegExp('(?<=[a-z])(?=[A-Z])');

String spokenName(String key) => key.split(_hump).join(' ').toLowerCase();

extension FieldErrorWording on FieldError {
  String headline(String Function(String key) label) {
    final List<String> names = segments.map(label).toList();
    final String name = names.last;
    final String place = names.length > 1
        ? ' in ${names[names.length - 2]}'
        : '';
    return switch (kind) {
      FieldErrorKind.unreadable => "Couldn't read $name$place",
      FieldErrorKind.dropped =>
        'Skipped $count ${count == 1 ? 'item' : 'items'} in $name',
      FieldErrorKind.missing =>
        '$name missing$place${count > 1 ? ' ($count times)' : ''}',
    };
  }

  IconData get icon => switch (kind) {
    FieldErrorKind.unreadable => Icons.block,
    FieldErrorKind.dropped => Icons.filter_alt_off_outlined,
    FieldErrorKind.missing => Icons.help_outline,
  };
}

String errorDetails(
  DocumentErrors errors,
  List<FieldError> issues,
  PackageInfo? app,
) {
  final String version = app == null
      ? 'furlovin'
      : '${app.appName} ${app.version}+${app.buildNumber}';
  return [
    [
      version,
      if (errors.rules case final String rules) 'rules $rules',
      defaultTargetPlatform.name,
      if (errors.theme case final String theme) 'theme $theme',
    ].join(' · '),
    ?errors.page,
    for (final FieldError issue in issues) '$issue',
  ].join('\n');
}

Future<void> showDocumentErrors(
  BuildContext context,
  DocumentErrors errors, {
  List<FieldError>? issues,
  void Function(HiddenBoundaries hidden)? onHide,
  String Function(String key) label = spokenName,
}) => showDialog<void>(
  context: context,
  builder: (context) => DocumentErrorsDialog(
    errors: errors,
    issues: issues,
    onHide: onHide,
    label: label,
  ),
);

class DocumentErrorsDialog extends ConsumerWidget {
  const DocumentErrorsDialog({
    super.key,
    required this.errors,
    this.issues,
    this.onHide,
    this.label = spokenName,
  });

  final DocumentErrors errors;
  final List<FieldError>? issues;
  final void Function(HiddenBoundaries hidden)? onHide;
  final String Function(String key) label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final List<FieldError> issues = this.issues ?? errors.all;
    final PackageInfo? app = ref.watch(packageInfoProvider).asData?.value;
    return AlertDialog(
      title: const Text('Some of this page could not be read'),
      contentPadding: const EdgeInsets.symmetric(vertical: Space.small),
      content: SizedBox(
        width: 420,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final FieldError issue in issues)
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
            ClipboardData(text: errorDetails(errors, issues, app)),
          ),
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy details'),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onHide case final void Function(HiddenBoundaries) hide)
              TextButton(
                onPressed: () {
                  hide(ref.read(hiddenBoundariesProvider));
                  Navigator.of(context).pop();
                },
                child: const Text('Hide until restart'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ],
    );
  }
}

class DocumentErrorsButton extends ConsumerWidget {
  const DocumentErrorsButton({
    super.key,
    required this.errors,
    this.label = spokenName,
    this.onImage = false,
  });

  final DocumentErrors? errors;
  final String Function(String key) label;
  final bool onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HiddenBoundaries hidden = ref.watch(hiddenBoundariesProvider);
    return ListenableBuilder(
      listenable: hidden,
      builder: (context, _) {
        final DocumentErrors? known = errors;
        if (known == null) return const SizedBox.shrink();
        final List<FieldError> issues = hidden.visible(known);
        if (issues.isEmpty) return const SizedBox.shrink();
        final ThemeData theme = Theme.of(context);
        return IconButton(
          tooltip: 'Some of this page could not be read',
          onPressed: () => showDocumentErrors(
            context,
            known,
            issues: issues,
            onHide: (hidden) => hidden.hideAll(known, issues),
            label: label,
          ),
          icon: Badge.count(
            count: issues.length,
            child: Icon(
              Icons.report_problem_outlined,
              color: onImage ? Colors.white : theme.colorScheme.error,
              shadows: onImage
                  ? const [Shadow(color: scrimShadow, blurRadius: 10)]
                  : null,
            ),
          ),
        );
      },
    );
  }
}
