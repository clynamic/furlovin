import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/search/search.dart';

void main() {
  test('sends every parameter FA expects', () {
    const SearchQuery query = SearchQuery(text: '  ginkgo29  ');
    expect(query.parameters(page: 2), {
      'q': 'ginkgo29',
      'page': '2',
      'order-by': 'relevancy',
      'order-direction': 'desc',
    });
  });

  test('keeps our own url short by dropping defaults', () {
    expect(const SearchQuery(text: 'ginkgo29').location, {'q': 'ginkgo29'});
    expect(
      const SearchQuery(
        text: 'ginkgo29',
        order: SearchOrder.date,
        direction: SearchDirection.ascending,
      ).location,
      const {'q': 'ginkgo29', 'order': 'date', 'direction': 'asc'},
    );
  });

  test('round trips through a location', () {
    const SearchQuery query = SearchQuery(
      text: 'fox & (box | socks)',
      order: SearchOrder.popularity,
      direction: SearchDirection.ascending,
    );
    expect(SearchQuery.fromLocation(query.location), query);
  });

  test('falls back on a location it does not understand', () {
    final SearchQuery query = SearchQuery.fromLocation(const {
      'q': 'ginkgo29',
      'order': 'nonsense',
      'direction': 'sideways',
    });
    expect(query.order, SearchOrder.relevancy);
    expect(query.direction, SearchDirection.descending);
  });

  test('treats blank text as no query', () {
    expect(const SearchQuery(text: '   ').isEmpty, isTrue);
    expect(const SearchQuery(text: 'a').isEmpty, isFalse);
  });

  test('compares by value so paging controllers can key on it', () {
    expect(const SearchQuery(text: 'a'), const SearchQuery(text: 'a'));
    expect(
      const SearchQuery(text: 'a') == const SearchQuery(text: 'b'),
      isFalse,
    );
  });
}
