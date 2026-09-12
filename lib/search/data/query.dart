import 'package:meta/meta.dart';

const String keywordField = '@keywords';

enum SearchOrder {
  relevancy('relevancy'),
  date('date'),
  popularity('popularity');

  const SearchOrder(this.value);

  final String value;
}

enum SearchDirection {
  ascending('asc'),
  descending('desc');

  const SearchDirection(this.value);

  final String value;
}

@immutable
class SearchQuery {
  const SearchQuery({
    required this.text,
    this.order = SearchOrder.relevancy,
    this.direction = SearchDirection.descending,
  });

  factory SearchQuery.fromLocation(Map<String, String> parameters) =>
      SearchQuery(
        text: parameters['q'] ?? '',
        order: SearchOrder.values.firstWhere(
          (e) => e.value == parameters['order'],
          orElse: () => SearchOrder.relevancy,
        ),
        direction: SearchDirection.values.firstWhere(
          (e) => e.value == parameters['direction'],
          orElse: () => SearchDirection.descending,
        ),
      );

  final String text;
  final SearchOrder order;
  final SearchDirection direction;

  bool get isEmpty => text.trim().isEmpty;

  SearchQuery copyWith({
    String? text,
    SearchOrder? order,
    SearchDirection? direction,
  }) => SearchQuery(
    text: text ?? this.text,
    order: order ?? this.order,
    direction: direction ?? this.direction,
  );

  Map<String, String> parameters({required int page}) => {
    'q': text.trim(),
    'page': '$page',
    'order-by': order.value,
    'order-direction': direction.value,
  };

  Map<String, String> get location => {
    'q': text.trim(),
    if (order != SearchOrder.relevancy) 'order': order.value,
    if (direction != SearchDirection.descending) 'direction': direction.value,
  };

  @override
  bool operator ==(Object other) =>
      other is SearchQuery &&
      other.text == text &&
      other.order == order &&
      other.direction == direction;

  @override
  int get hashCode => Object.hash(text, order, direction);
}
