import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SubmissionPagedGrid(
    controller: ref.watch(inboxProvider),
    header: SliverAppBar(
      title: const Text('Inbox'),
      floating: true,
      snap: true,
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: context.openSearch,
          icon: const Icon(Icons.search),
        ),
      ],
    ),
  );
}
