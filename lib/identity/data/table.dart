import 'package:drift/drift.dart';

class Identities extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get username => text().nullable()();

  TextColumn get cookies => text()();

  TextColumn get userAgent => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
