import 'package:flutter/foundation.dart';

enum TermScope {
  anything(null, null),
  tags('@keywords', 'tags'),
  title('@title', 'title'),
  description('@message', 'desc'),
  uploader('@lower', 'by');

  const TermScope(this.field, this.key);

  final String? field;
  final String? key;

  static TermScope? ofField(String field) {
    for (final TermScope scope in values) {
      if (scope.field == field) return scope;
    }
    return null;
  }

  static TermScope? ofKey(String key) {
    for (final TermScope scope in values) {
      if (scope.key == key) return scope;
    }
    return null;
  }
}

@immutable
class SearchTerm {
  const SearchTerm(
    this.words, {
    this.scope = TermScope.anything,
    this.excluded = false,
    this.verbatim = false,
  });

  final List<String> words;
  final TermScope scope;
  final bool excluded;
  final bool verbatim;

  SearchTerm copyWith({
    List<String>? words,
    TermScope? scope,
    bool? excluded,
  }) => SearchTerm(
    words ?? this.words,
    scope: scope ?? this.scope,
    excluded: excluded ?? this.excluded,
    verbatim: verbatim,
  );

  String get syntax {
    final String body = switch (words) {
      _ when verbatim => words.single,
      [final String word] => _quoted(word),
      _ => '(${words.map(_quoted).join(' | ')})',
    };
    return excluded ? '-$body' : body;
  }

  @override
  bool operator ==(Object other) =>
      other is SearchTerm &&
      listEquals(other.words, words) &&
      other.scope == scope &&
      other.excluded == excluded &&
      other.verbatim == verbatim;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(words), scope, excluded, verbatim);
}

String _quoted(String word) => word.contains(' ') ? '"$word"' : word;

enum SearchSort {
  relevance('relevancy', 'desc'),
  newest('date', 'desc'),
  oldest('date', 'asc'),
  popular('popularity', 'desc');

  const SearchSort(this.orderBy, this.direction);

  final String orderBy;
  final String direction;
}

enum SearchRating { general, mature, adult }

enum SearchKind { art, music, flash, story, photo, poetry }

enum SearchRange {
  any('all'),
  day('1day'),
  threeDays('3days'),
  week('7days'),
  month('30days'),
  threeMonths('90days'),
  year('1year'),
  threeYears('3years'),
  fiveYears('5years');

  const SearchRange(this.value);

  final String value;
}

const int searchPageSize = 72;

const Set<SearchRating> everyRating = {
  SearchRating.general,
  SearchRating.mature,
  SearchRating.adult,
};

const Set<SearchKind> everyKind = {
  SearchKind.art,
  SearchKind.music,
  SearchKind.flash,
  SearchKind.story,
  SearchKind.photo,
  SearchKind.poetry,
};

final RegExp _word = RegExp(r'[^\s()|"]+');
final RegExp _key = RegExp(r'(\w+):(?=[^\s|)])');
final RegExp _tail = RegExp(r'[~/]\d+');

List<SearchTerm> parseTerms(String input) => _TermReader(input).read();

class _TermReader {
  _TermReader(this.input);

  final String input;
  int at = 0;

  bool get done => at >= input.length;
  String get next => input[at];

  void _skip() {
    while (!done && next.trim().isEmpty) {
      at++;
    }
  }

  String _until(bool Function(String char) stop) {
    final int from = at;
    while (!done && !stop(next)) {
      at++;
    }
    return input.substring(from, at);
  }

  String _quote() {
    final int from = at++;
    _until((e) => e == '"');
    if (!done) at++;
    return input.substring(from, at);
  }

  String _group() {
    final int from = at;
    int depth = 0;
    while (!done) {
      if (next == '"') {
        _quote();
        continue;
      }
      if (next == '(') depth++;
      if (next == ')') depth--;
      at++;
      if (depth == 0) break;
    }
    return input.substring(from, at);
  }

  List<String>? _alternatives(String group) {
    if (!group.endsWith(')')) return null;
    final List<String> words = [];
    for (final String part in group.substring(1, group.length - 1).split('|')) {
      final String word = part.trim();
      if (_word.hasMatch(word) && _word.stringMatch(word) == word) {
        words.add(word);
      } else if (word.length > 2 &&
          word.startsWith('"') &&
          word.endsWith('"') &&
          !word.substring(1, word.length - 1).contains('"')) {
        words.add(word.substring(1, word.length - 1));
      } else {
        return null;
      }
    }
    return words;
  }

  SearchTerm? _atom(TermScope scope, bool excluded) {
    if (next == '(') {
      final String group = _group();
      final List<String>? words = _alternatives(group);
      if (words == null) {
        return SearchTerm(
          [group],
          scope: scope,
          excluded: excluded,
          verbatim: true,
        );
      }
      return SearchTerm(words, scope: scope, excluded: excluded);
    }
    if (next == '"') {
      final String phrase = _quote();
      final String tail = _tail.matchAsPrefix(input, at)?.group(0) ?? '';
      at += tail.length;
      if (tail.isNotEmpty || !phrase.endsWith('"') || phrase.length < 2) {
        return SearchTerm(
          ['$phrase$tail'],
          scope: scope,
          excluded: excluded,
          verbatim: true,
        );
      }
      final String body = phrase.substring(1, phrase.length - 1).trim();
      if (body.isEmpty) return null;
      return SearchTerm([body], scope: scope, excluded: excluded);
    }
    final String word = _until((e) => e.trim().isEmpty || '()|"'.contains(e));
    if (word.isEmpty) {
      at++;
      return null;
    }
    return SearchTerm([word], scope: scope, excluded: excluded);
  }

  List<SearchTerm> read() {
    final List<SearchTerm> terms = [];
    TermScope scope = TermScope.anything;
    bool either = false;
    while (true) {
      _skip();
      if (done) break;
      if (next == '|') {
        at++;
        either = terms.isNotEmpty;
        continue;
      }
      if (next == '&') {
        at++;
        continue;
      }
      if (next == '@') {
        final int from = at;
        final String field = _until(
          (e) => e.trim().isEmpty || '()|"'.contains(e),
        );
        final TermScope? found = TermScope.ofField(field);
        if (found != null) {
          scope = found;
          continue;
        }
        at = from;
      }
      bool excluded = false;
      if ((next == '-' || next == '!') &&
          at + 1 < input.length &&
          input[at + 1].trim().isNotEmpty) {
        excluded = true;
        at++;
      }
      TermScope own = scope;
      if (_key.matchAsPrefix(input, at) case final RegExpMatch match) {
        if (TermScope.ofKey(match.group(1)!) case final TermScope keyed) {
          own = keyed;
          at = match.end;
        }
      }
      final SearchTerm? term = _atom(own, excluded);
      if (term == null) continue;
      if (either) {
        either = false;
        final SearchTerm last = terms.removeLast();
        terms.add(_either(last, term));
        continue;
      }
      terms.add(term);
    }
    return terms;
  }

  SearchTerm _either(SearchTerm left, SearchTerm right) {
    if (!left.verbatim &&
        !right.verbatim &&
        !left.excluded &&
        !right.excluded &&
        left.scope == right.scope) {
      return left.copyWith(words: [...left.words, ...right.words]);
    }
    if (left.scope == right.scope) {
      return SearchTerm(
        ['${left.syntax} | ${right.syntax}'],
        scope: left.scope,
        verbatim: true,
      );
    }
    final List<SearchTerm> sides = [left, right]
      ..sort((a, b) => a.scope.index.compareTo(b.scope.index));
    final String joined = sides
        .map((e) => [?e.scope.field, e.syntax].join(' '))
        .join(' | ');
    return SearchTerm(['($joined)'], verbatim: true);
  }
}

String composeTerms(List<SearchTerm> terms) {
  final List<String> parts = [];
  for (final TermScope scope in TermScope.values) {
    final List<SearchTerm> group = [
      for (final SearchTerm term in terms)
        if (term.scope == scope) term,
    ];
    if (group.isEmpty) continue;
    if (scope.field case final String field) parts.add(field);
    parts.addAll(group.map((e) => e.syntax));
  }
  return parts.join(' ');
}

T _named<T extends Enum>(List<T> values, String? name, T fallback) {
  for (final T value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

Set<T> _namedSet<T extends Enum>(
  List<T> values,
  String? joined,
  Set<T> fallback,
) {
  if (joined == null) return fallback;
  final Set<T> found = {
    for (final String name in joined.split(','))
      for (final T value in values)
        if (value.name == name) value,
  };
  return found.isEmpty ? fallback : found;
}

@immutable
class SearchQuery {
  const SearchQuery({
    this.terms = const [],
    this.sort = SearchSort.relevance,
    this.ratings = everyRating,
    this.kinds = everyKind,
    this.range = SearchRange.any,
    this.category,
    this.artType,
    this.species,
  });

  factory SearchQuery.parse(String text) =>
      SearchQuery(terms: parseTerms(text));

  factory SearchQuery.fromLocation(
    Map<String, String> parameters,
  ) => SearchQuery(
    terms: parseTerms(parameters['q'] ?? ''),
    sort: _named(SearchSort.values, parameters['sort'], SearchSort.relevance),
    ratings: _namedSet(SearchRating.values, parameters['rating'], everyRating),
    kinds: _namedSet(SearchKind.values, parameters['type'], everyKind),
    range: _named(SearchRange.values, parameters['range'], SearchRange.any),
    category: int.tryParse(parameters['category'] ?? ''),
    artType: int.tryParse(parameters['arttype'] ?? ''),
    species: int.tryParse(parameters['species'] ?? ''),
  );

  final List<SearchTerm> terms;
  final SearchSort sort;
  final Set<SearchRating> ratings;
  final Set<SearchKind> kinds;
  final SearchRange range;
  final int? category;
  final int? artType;
  final int? species;

  String get text => composeTerms(terms);

  bool get isEmpty =>
      terms.isEmpty && category == null && artType == null && species == null;

  SearchQuery copyWith({
    List<SearchTerm>? terms,
    SearchSort? sort,
    Set<SearchRating>? ratings,
    Set<SearchKind>? kinds,
    SearchRange? range,
    int? Function()? category,
    int? Function()? artType,
    int? Function()? species,
  }) => SearchQuery(
    terms: terms ?? this.terms,
    sort: sort ?? this.sort,
    ratings: ratings ?? this.ratings,
    kinds: kinds ?? this.kinds,
    range: range ?? this.range,
    category: category == null ? this.category : category(),
    artType: artType == null ? this.artType : artType(),
    species: species == null ? this.species : species(),
  );

  Map<String, String> parameters({required int page}) => {
    'q': text,
    'page': '$page',
    'perpage': '$searchPageSize',
    'order-by': sort.orderBy,
    'order-direction': sort.direction,
    'mode': 'extended',
    'range': range.value,
    for (final SearchRating rating in ratings) 'rating-${rating.name}': '1',
    for (final SearchKind kind in kinds) 'type-${kind.name}': '1',
    if (category case final int value) 'category': '$value',
    if (artType case final int value) 'arttype': '$value',
    if (species case final int value) 'species': '$value',
  };

  Map<String, String> get location => {
    if (terms.isNotEmpty) 'q': text,
    if (sort != SearchSort.relevance) 'sort': sort.name,
    if (!setEquals(ratings, everyRating))
      'rating': ratings.map((e) => e.name).join(','),
    if (!setEquals(kinds, everyKind))
      'type': kinds.map((e) => e.name).join(','),
    if (range != SearchRange.any) 'range': range.name,
    if (category case final int value) 'category': '$value',
    if (artType case final int value) 'arttype': '$value',
    if (species case final int value) 'species': '$value',
  };

  @override
  bool operator ==(Object other) =>
      other is SearchQuery &&
      listEquals(other.terms, terms) &&
      other.sort == sort &&
      setEquals(other.ratings, ratings) &&
      setEquals(other.kinds, kinds) &&
      other.range == range &&
      other.category == category &&
      other.artType == artType &&
      other.species == species;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(terms),
    sort,
    Object.hashAllUnordered(ratings),
    Object.hashAllUnordered(kinds),
    range,
    category,
    artType,
    species,
  );
}
