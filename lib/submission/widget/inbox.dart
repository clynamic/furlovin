import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SubmissionPagedGrid(
    controller: ref.watch(inboxProvider),
    header: const SliverAppBar(
      title: Text('Inbox'),
      floating: true,
      snap: true,
    ),
  );
}
