import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(authenticatedProvider)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inbox')),
        body: FailureView(
          icon: Icons.inbox_outlined,
          title: 'Not logged in',
          detail: 'Log in to see new submissions from people you watch.',
          actionLabel: 'Log in',
          onAction: context.openLogin,
        ),
      );
    }
    return SubmissionPagedGrid(
      controller: ref.watch(inboxProvider),
      header: const SliverAppBar(
        title: Text('Inbox'),
        floating: true,
        snap: true,
      ),
    );
  }
}
