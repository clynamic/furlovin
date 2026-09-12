import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/search/search.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.query, this.editing = false});

  final SearchQuery query;
  final bool editing;

  @override
  Widget build(BuildContext context) => editing || query.isEmpty
      ? SearchForm(query: query)
      : SearchResults(query: query);
}

class SearchResults extends ConsumerWidget {
  const SearchResults({super.key, required this.query});

  final SearchQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SubmissionPagedGrid(
    controller: ref.watch(searchProvider(query)),
    header: SliverAppBar(
      floating: true,
      snap: true,
      title: Text(query.text),
      actions: [
        IconButton(
          tooltip: 'Edit search',
          onPressed: () => context.editSearch(query),
          icon: const Icon(Icons.tune),
        ),
      ],
    ),
  );
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key, required this.query});

  final SearchQuery query;

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  late final TextEditingController _text = TextEditingController(
    text: widget.query.text,
  );
  late SearchQuery _query = widget.query;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit() {
    final SearchQuery next = _query.copyWith(text: _text.text);
    if (next.isEmpty) return;
    context.runSearch(next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding:
            Layout.pageOf(context) + const EdgeInsets.only(top: Space.page),
        children: [
          TextField(
            controller: _text,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) => _submit(),
            decoration: const InputDecoration(
              hintText: 'Type here to search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: Corner.panels),
            ),
          ),
          const SizedBox(height: Space.large),
          Text('Sort', style: theme.textTheme.titleSmall),
          const SizedBox(height: Space.small),
          Wrap(
            spacing: Space.small,
            children: [
              for (final SearchOrder order in SearchOrder.values)
                ChoiceChip(
                  label: Text(order.name),
                  selected: _query.order == order,
                  onSelected: (value) =>
                      setState(() => _query = _query.copyWith(order: order)),
                ),
            ],
          ),
          const SizedBox(height: Space.snug),
          Wrap(
            spacing: Space.small,
            children: [
              for (final SearchDirection direction in SearchDirection.values)
                ChoiceChip(
                  label: Text(direction.name),
                  selected: _query.direction == direction,
                  onSelected: (value) => setState(
                    () => _query = _query.copyWith(direction: direction),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Space.section),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.search),
            label: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
