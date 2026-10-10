import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'database.g.dart';

class ReminderRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 80)();
  TextColumn get type => text()();
  TextColumn get repeat => text()();
  TextColumn get anchorDate => text()();
  IntColumn get weekdays => integer()();
  IntColumn get dayOfMonth => integer()();
  IntColumn get knownYear => integer().nullable()();
  IntColumn get alertMinutes => integer()();
  IntColumn get leads => integer()();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  String get tableName => 'reminders';
}

@DataClassName('LogRow')
class OccurrenceLogs extends Table {
  TextColumn get reminderId =>
      text().references(ReminderRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get occurrenceDate => text()();
  TextColumn get status => text()();
  TextColumn get snoozedUntil => text().nullable()();
  TextColumn get actedAt => text()();
  @override
  Set<Column> get primaryKey => {reminderId, occurrenceDate};
  @override
  String get tableName => 'occurrence_log';
}

class ScheduledAlarms extends Table {
  IntColumn get notificationId => integer()();
  TextColumn get reminderId =>
      text().references(ReminderRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get occurrenceDate => text()();
  TextColumn get lead => text()();
  TextColumn get fireAt => text()();
  TextColumn get fingerprint => text()();
  @override
  Set<Column> get primaryKey => {notificationId};
}

@DriftDatabase(tables: [ReminderRows, OccurrenceLogs, ScheduledAlarms])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            LazyDatabase(() async {
              final dir = await getApplicationDocumentsDirectory();
              return NativeDatabase.createInBackground(
                File(p.join(dir.path, 'reminders.sqlite')),
              );
            }),
      );
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA busy_timeout = 30000');
    },
  );
}
