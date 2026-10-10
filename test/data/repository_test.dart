import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reminders/data/database.dart';
import 'package:reminders/data/repository.dart';
import 'package:reminders/core/models.dart';

void main() {
  late AppDatabase db;
  late Repository repo;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = Repository(db, clock: FixedClock(DateTime(2026, 10, 10)));
  });
  tearDown(() async => db.close());
  const r = Reminder(
    id: 'uuid',
    title: 'Birthday',
    anchor: DateOnly(2026, 10, 24),
    type: ReminderType.birthday,
    repeat: RepeatMode.yearly,
    knownYear: 1968,
  );
  test('Missed history requires an elapsed scheduled alarm', () async {
    await repo.save(r);
    await repo.markMissed();
    expect(await repo.logs(), isEmpty);
    await db
        .into(db.scheduledAlarms)
        .insert(
          ScheduledAlarmsCompanion.insert(
            notificationId: const Value(1),
            reminderId: r.id,
            occurrenceDate: '2026-10-09',
            lead: 'day0',
            fireAt: '2026-10-09T09:00:00',
            fingerprint: 'test',
          ),
        );
    await repo.markMissed();
    await repo.markMissed();
    expect((await repo.logs()).single.status, 'missed');
  });
  test('Bad foreign key import rolls back replacement', () async {
    await repo.save(r);
    await expectLater(
      repo.importJson(
        '{"version":1,"reminders":[],"occurrence_log":[{"reminder_id":"missing","occurrence_date":"2026-01-01","status":"done","acted_at":"now"}]}',
        merge: false,
      ),
      throwsFormatException,
    );
    expect((await repo.reminders()).single.id, r.id);
  });
  test('Create, update, cascade delete', () async {
    await repo.save(r);
    expect((await repo.reminders()).single.title, 'Birthday');
    await repo.save(
      const Reminder(
        id: 'uuid',
        title: 'Changed',
        anchor: DateOnly(2026, 10, 24),
      ),
    );
    await repo.act(r.id, r.anchor, 'done');
    expect((await repo.reminders()).single.title, 'Changed');
    expect((await repo.logs()).length, 1);
    await repo.delete(r.id);
    expect(await repo.logs(), isEmpty);
  });
  test('Backup round trip and merge', () async {
    await repo.save(r);
    await repo.act(r.id, r.anchor, 'snoozed', until: DateTime(2026, 10, 25, 9));
    final source = await repo.exportJson();
    await repo.delete(r.id);
    await repo.importJson(source, merge: false);
    expect((await repo.reminders()).single.knownYear, 1968);
    expect((await repo.logs()).single.snoozedUntil, DateTime(2026, 10, 25, 9));
    await repo.importJson(source, merge: true);
    expect((await repo.reminders()).length, 1);
  });
  test('Invalid backup does not replace local data', () async {
    await repo.save(r);
    await expectLater(
      repo.importJson('{"version":2}', merge: false),
      throwsFormatException,
    );
    expect((await repo.reminders()).length, 1);
  });
}
