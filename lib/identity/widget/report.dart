import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key, required this.link});

  final String link;

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  final TextEditingController subject = TextEditingController();
  final TextEditingController details = TextEditingController();
  TicketForm? ticket;
  int? issue;
  bool shareNotes = false;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(ticketProvider(widget.link), (previous, next) {
      if (ticket != null) return;
      if (next.value case final TicketDocument document) {
        setState(() => _fill(document.ticket));
      }
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    subject.dispose();
    details.dispose();
    super.dispose();
  }

  void _fill(TicketForm form) {
    ticket = form;
    subject.text = form.subject?.value ?? '';
    details.text = form.details.value ?? '';
    final int chosen = form.issue.options.indexWhere(
      (e) => (e.selected ?? false) && !(e.placeholder ?? false),
    );
    issue = chosen < 0 ? null : chosen;
    shareNotes = form.shareNotes?.checked ?? false;
  }

  bool _ready(TicketForm form) {
    final int least = form.details.minLength ?? 1;
    return issue != null && details.text.trim().length >= least && !sending;
  }

  Future<void> _send(TicketForm form) async {
    final bool? sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send this report?'),
        content: const Text('You send it to the staff as a trouble ticket.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);
    setState(() => sending = true);
    final FormRequest request = FormRequest(form.action, form.controls)
      ..set(form.issue, form.issue.options[issue!].value)
      ..set(form.details, details.text);
    if (form.subject case final FormControl field) {
      request.set(field, subject.text);
    }
    if (form.shareNotes case final FormControl field) {
      request.check(field, checked: shareNotes);
    }
    try {
      final ViewerClient client = await ref.read(viewerClientProvider.future);
      await client.fileTicket(request);
      messenger.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Report sent'),
        ),
      );
      navigator.pop();
    } on Object catch (error) {
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(describeFailure(error)),
        ),
      );
      if (mounted) setState(() => sending = false);
    }
  }

  List<DropdownMenuItem<int>> _issues(TicketForm form, ThemeData theme) {
    final List<DropdownMenuItem<int>> items = [];
    String? group;
    for (final (int index, FormOption option) in form.issue.options.indexed) {
      if (option.placeholder ?? false) continue;
      if (option.group != group) {
        group = option.group;
        if (group != null) {
          items.add(
            DropdownMenuItem<int>(
              value: -1 - index,
              enabled: false,
              child: Text(
                group,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          );
        }
      }
      items.add(
        DropdownMenuItem<int>(
          value: index,
          child: Text(option.label ?? option.value),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<TicketDocument> loading = ref.watch(
      ticketProvider(widget.link),
    );
    final TicketForm? form = ticket;
    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: switch ((form, loading)) {
        (final TicketForm form, _) => ListView(
          padding:
              Layout.pageOf(context) +
              EdgeInsets.only(
                top: Space.page,
                bottom: Space.page + MediaQuery.paddingOf(context).bottom,
              ),
          children: [
            DropdownButtonFormField<int>(
              initialValue: issue,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Issue type',
                border: OutlineInputBorder(),
              ),
              items: _issues(form, theme),
              onChanged: sending
                  ? null
                  : (value) => setState(() => issue = value),
            ),
            if (form.subject case final FormControl field) ...[
              const SizedBox(height: Space.medium),
              TextField(
                controller: subject,
                enabled: !sending,
                maxLength: field.maxLength,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: Space.medium),
            TextField(
              controller: details,
              enabled: !sending,
              minLines: 6,
              maxLines: null,
              maxLength: form.details.maxLength,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Details',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            if (form.shareNotes case final FormControl field)
              CheckboxListTile(
                value: shareNotes,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(field.label ?? 'Share the notes you link to'),
                onChanged: sending
                    ? null
                    : (value) => setState(() => shareNotes = value ?? false),
              ),
            const SizedBox(height: Space.medium),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.icon(
                onPressed: _ready(form) ? () => _send(form) : null,
                icon: sending
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined),
                label: const Text('Send report'),
              ),
            ),
          ],
        ),
        (_, AsyncError(:final Object error)) => failureFor(
          error,
          onRetry: () => ref.invalidate(ticketProvider(widget.link)),
          onVerify: context.openChallenge,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
