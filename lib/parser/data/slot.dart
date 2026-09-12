import 'package:furlovin/parser/parser.dart';
import 'package:meta/meta.dart';

@immutable
sealed class Slot<T> {
  const Slot(this.page, this.name, this.entity, this.build);

  final String page;
  final String name;
  final String entity;
  final T? Function(ParseOutcome outcome) build;
}

class SingleSlot<T> extends Slot<T> {
  const SingleSlot(super.page, super.name, super.entity, super.build);
}

class ListSlot<T> extends Slot<T> {
  const ListSlot(super.page, super.name, super.entity, super.build);
}
