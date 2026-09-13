import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/search/search.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.query, this.editing = false});

  final SearchQuery query;
  final bool editing;

  @override
  Widget build(BuildContext context) => editing || query.isEmpty
      ? SearchForm(query: query, refining: editing)
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
  const SearchForm({super.key, required this.query, this.refining = false});

  final SearchQuery query;
  final bool refining;

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final GlobalKey<TermFieldState> _field = GlobalKey<TermFieldState>();
  late SearchQuery _query = widget.query;

  void _update(SearchQuery next) => setState(() => _query = next);

  void _submit() {
    _field.currentState?.commit();
    if (_query.isEmpty) return;
    if (widget.refining) {
      context.runSearch(_query);
      return;
    }
    context.openQuery(_query);
  }

  Set<T> _toggled<T>(Set<T> current, T value) {
    final Set<T> next = {...current};
    if (!next.remove(value)) next.add(value);
    return next.isEmpty ? current : next;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding:
                Layout.pageOf(context) +
                const EdgeInsets.only(top: Space.page, bottom: Space.small),
            sliver: SliverToBoxAdapter(
              child: TermField(
                key: _field,
                terms: _query.terms,
                autofocus: widget.refining,
                onChanged: (terms) => _update(_query.copyWith(terms: terms)),
                onSubmitted: _submit,
              ),
            ),
          ),
          PersistentSliverSection(
            name: 'searchFilters',
            title: 'Filters',
            sliver: SliverList.list(
              children: [
                FilterRow(
                  label: 'Sort',
                  children: [
                    for (final SearchSort sort in SearchSort.values)
                      ChoiceChip(
                        showCheckmark: false,
                        avatar: Icon(sort.icon),
                        label: Text(sort.label),
                        selected: _query.sort == sort,
                        onSelected: (value) =>
                            _update(_query.copyWith(sort: sort)),
                      ),
                  ],
                ),
                FilterRow(
                  label: 'Rating',
                  children: [
                    for (final SearchRating rating in SearchRating.values)
                      FilterChip(
                        showCheckmark: false,
                        avatar: Icon(
                          Icons.shield_outlined,
                          color: readableOn(
                            rating.colorIn(theme.ratings),
                            theme.colorScheme.surfaceContainer,
                          ),
                        ),
                        label: Text(rating.label),
                        selected: _query.ratings.contains(rating),
                        onSelected: (value) => _update(
                          _query.copyWith(
                            ratings: _toggled(_query.ratings, rating),
                          ),
                        ),
                      ),
                  ],
                ),
                FilterRow(
                  label: 'Type',
                  children: [
                    for (final SearchKind kind in SearchKind.values)
                      FilterChip(
                        showCheckmark: false,
                        avatar: Icon(kind.icon),
                        label: Text(kind.label),
                        selected: _query.kinds.contains(kind),
                        onSelected: (value) => _update(
                          _query.copyWith(kinds: _toggled(_query.kinds, kind)),
                        ),
                      ),
                  ],
                ),
                FilterRow(
                  label: 'When',
                  children: [
                    for (final SearchRange range in SearchRange.values)
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text(range.label),
                        selected: _query.range == range,
                        onSelected: (value) =>
                            _update(_query.copyWith(range: range)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  const FilterRow({super.key, required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Space.small,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Wrap(
            spacing: Space.small,
            runSpacing: Space.small,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }
}

extension SearchSortLabel on SearchSort {
  String get label => switch (this) {
    SearchSort.relevance => 'Relevance',
    SearchSort.newest => 'Newest',
    SearchSort.oldest => 'Oldest',
    SearchSort.popular => 'Popular',
  };

  IconData get icon => switch (this) {
    SearchSort.relevance => Icons.manage_search,
    SearchSort.newest => Icons.schedule,
    SearchSort.oldest => Icons.history,
    SearchSort.popular => Icons.trending_up,
  };
}

extension SearchRatingLabel on SearchRating {
  String get label => switch (this) {
    SearchRating.general => 'General',
    SearchRating.mature => 'Mature',
    SearchRating.adult => 'Adult',
  };

  Color colorIn(Ratings ratings) => switch (this) {
    SearchRating.general => ratings.general,
    SearchRating.mature => ratings.mature,
    SearchRating.adult => ratings.adult,
  };
}

extension SearchKindLabel on SearchKind {
  String get label => switch (this) {
    SearchKind.art => 'Art',
    SearchKind.music => 'Music',
    SearchKind.flash => 'Flash',
    SearchKind.story => 'Story',
    SearchKind.photo => 'Photo',
    SearchKind.poetry => 'Poetry',
  };

  IconData get icon => switch (this) {
    SearchKind.art => Icons.brush_outlined,
    SearchKind.music => Icons.music_note_outlined,
    SearchKind.flash => Icons.animation,
    SearchKind.story => Icons.auto_stories_outlined,
    SearchKind.photo => Icons.photo_camera_outlined,
    SearchKind.poetry => Icons.format_quote,
  };
}

extension SearchRangeLabel on SearchRange {
  String get label => switch (this) {
    SearchRange.any => 'Any time',
    SearchRange.day => 'Day',
    SearchRange.threeDays => '3 days',
    SearchRange.week => 'Week',
    SearchRange.month => 'Month',
    SearchRange.threeMonths => '3 months',
    SearchRange.year => 'Year',
    SearchRange.threeYears => '3 years',
    SearchRange.fiveYears => '5 years',
  };
}
