abstract class Ghost<T extends Object> {
  const Ghost();

  T at(int index);

  List<T> list([int count = 12]) => [
    for (int index = 0; index < count; index++) at(index),
  ];
}
