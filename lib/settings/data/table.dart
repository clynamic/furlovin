import 'package:drift/drift.dart';

class Preferences extends Table {
  TextColumn get name => text()();

  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {name};
}
