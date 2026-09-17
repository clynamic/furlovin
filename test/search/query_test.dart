import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/search/search.dart';

void main() {
  group('terms', () {
    test('reads plain, excluded and quoted terms', () {
      expect(parseTerms('fennel114 -fox "red panda"'), const [
        SearchTerm(['fennel114']),
        SearchTerm(['fox'], excluded: true),
        SearchTerm(['red panda']),
      ]);
    });

    test('accepts both exclusion marks', () {
      expect(parseTerms('!fox'), const [
        SearchTerm(['fox'], excluded: true),
      ]);
    });

    test('a field operator scopes every term after it', () {
      expect(
        parseTerms('fennel114 @keywords ginkgo29 -fox @lower someone'),
        const [
          SearchTerm(['fennel114']),
          SearchTerm(['ginkgo29'], scope: TermScope.tags),
          SearchTerm(['fox'], scope: TermScope.tags, excluded: true),
          SearchTerm(['someone'], scope: TermScope.uploader),
        ],
      );
    });

    test('a field operator alone makes no terms', () {
      expect(parseTerms('@keywords '), isEmpty);
    });

    test('a typed key scopes only its own term', () {
      expect(parseTerms('by:someone fennel114'), const [
        SearchTerm(['someone'], scope: TermScope.uploader),
        SearchTerm(['fennel114']),
      ]);
    });

    test('an unknown key stays part of the text', () {
      expect(parseTerms('foo:bar'), const [
        SearchTerm(['foo:bar']),
      ]);
    });

    test('or joins its neighbours into one term', () {
      expect(parseTerms('moth fennel114 | fox'), const [
        SearchTerm(['moth']),
        SearchTerm(['fennel114', 'fox']),
      ]);
    });

    test('reads a group of alternatives', () {
      expect(parseTerms('-(box | "red socks") @keywords (a|b)'), const [
        SearchTerm(['box', 'red socks'], excluded: true),
        SearchTerm(['a', 'b'], scope: TermScope.tags),
      ]);
    });

    test('keeps what chips cannot hold exactly as written', () {
      expect(parseTerms('fox & (box (socks | shoes)) "quick fox"~3'), const [
        SearchTerm(['fox']),
        SearchTerm(['(box (socks | shoes))'], verbatim: true),
        SearchTerm(['"quick fox"~3'], verbatim: true),
      ]);
    });

    test('keeps or between mixed terms as written', () {
      expect(parseTerms('-fennel114 | fox'), const [
        SearchTerm(['-fennel114 | fox'], verbatim: true),
      ]);
    });

    test('keeps or between scopes without leaking a field', () {
      expect(
        composeTerms(parseTerms('tags:fennel114 | fox')),
        '(fox | @keywords fennel114)',
      );
    });

    test('composes unscoped terms before any field operator', () {
      expect(
        composeTerms(const [
          SearchTerm(['ginkgo29'], scope: TermScope.tags),
          SearchTerm(['fennel114']),
          SearchTerm(['red panda', 'fox'], excluded: true),
        ]),
        'fennel114 -("red panda" | fox) @keywords ginkgo29',
      );
    });

    test('composed text parses back to the same terms', () {
      const List<SearchTerm> terms = [
        SearchTerm(['fennel114']),
        SearchTerm(['"quick fox"~3'], verbatim: true),
        SearchTerm(['red panda'], excluded: true),
        SearchTerm(['moth', 'butterfly']),
        SearchTerm(['ginkgo29'], scope: TermScope.tags),
        SearchTerm(['someone'], scope: TermScope.uploader),
      ];
      expect(parseTerms(composeTerms(terms)), terms);
    });
  });

  group('parameters', () {
    test('sends everything FA expects', () {
      final Map<String, String> sent = SearchQuery.parse('fennel114')
          .parameters(page: 2);
      expect(sent['q'], 'fennel114');
      expect(sent['page'], '2');
      expect(sent['perpage'], '$searchPageSize');
      expect(sent['mode'], 'extended');
      expect(sent['order-by'], 'date');
      expect(sent['order-direction'], 'desc');
      expect(sent['range'], 'all');
      for (final SearchRating rating in SearchRating.values) {
        expect(sent['rating-${rating.name}'], '1');
      }
      expect(sent['type-${SearchKind.art.name}'], '1');
      for (final SearchKind kind in SearchKind.values) {
        if (kind == SearchKind.art) continue;
        expect(sent.containsKey('type-${kind.name}'), isFalse);
      }
    });

    test('sort carries its own direction', () {
      final Map<String, String> sent = const SearchQuery(
        sort: SearchSort.oldest,
      ).parameters(page: 1);
      expect(sent['order-by'], 'date');
      expect(sent['order-direction'], 'asc');
    });

    test('leaves out ratings and kinds that are switched off', () {
      final Map<String, String> sent = const SearchQuery(
        ratings: {SearchRating.general},
      ).parameters(page: 1);
      expect(sent.containsKey('rating-adult'), isFalse);
      expect(sent.containsKey('type-music'), isFalse);
      expect(sent['rating-general'], '1');
    });

    test('sends a species only when one is chosen', () {
      expect(
        const SearchQuery().parameters(page: 1).containsKey('species'),
        isFalse,
      );
      expect(
        const SearchQuery(species: 6008).parameters(page: 1)['species'],
        '6008',
      );
    });
  });

  group('location', () {
    test('keeps the url short by dropping defaults', () {
      expect(SearchQuery.parse('ginkgo29').location, {'q': 'ginkgo29'});
    });

    test('round trips everything through a location', () {
      final SearchQuery query = SearchQuery(
        terms: parseTerms('fennel114 -fox @keywords ginkgo29'),
        sort: SearchSort.oldest,
        ratings: const {SearchRating.general, SearchRating.mature},
        kinds: const {SearchKind.art, SearchKind.music},
        range: SearchRange.month,
        category: 2,
        artType: 7,
        species: 6008,
      );
      expect(SearchQuery.fromLocation(query.location), query);
    });

    test('falls back on a location it does not understand', () {
      final SearchQuery query = SearchQuery.fromLocation(const {
        'q': 'ginkgo29',
        'sort': 'sideways',
        'rating': 'nonsense',
        'range': 'forever',
      });
      expect(query.sort, SearchSort.newest);
      expect(query.ratings, everyRating);
      expect(query.range, SearchRange.any);
    });
  });

  test('nothing to search when there are no terms and no big filters', () {
    expect(const SearchQuery().isEmpty, isTrue);
    expect(SearchQuery.parse('   ').isEmpty, isTrue);
    expect(SearchQuery.parse('a').isEmpty, isFalse);
    expect(const SearchQuery(species: 1).isEmpty, isFalse);
  });

  test('compares by value so paging controllers can key on it', () {
    expect(SearchQuery.parse('a'), SearchQuery.parse('a'));
    expect(SearchQuery.parse('a') == SearchQuery.parse('b'), isFalse);
    expect(
      const SearchQuery(ratings: {SearchRating.general, SearchRating.adult}),
      const SearchQuery(ratings: {SearchRating.adult, SearchRating.general}),
    );
  });
}
