import 'dart:math';

abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();
  @override
  DateTime now() => DateTime.now();
}

class FixedClock implements Clock {
  final DateTime value;
  const FixedClock(this.value);
  @override
  DateTime now() => value;
}

class DateOnly implements Comparable<DateOnly> {
  final int year, month, day;
  const DateOnly(this.year, this.month, this.day);
  factory DateOnly.from(DateTime d) => DateOnly(d.year, d.month, d.day);
  factory DateOnly.parse(String s) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s)) {
      throw const FormatException('Invalid calendar date');
    }
    final parts = s.split('-').map(int.parse).toList();
    final d = DateOnly(parts[0], parts[1], parts[2]);
    if (d.utc.year != d.year || d.utc.month != d.month || d.utc.day != d.day) {
      throw const FormatException('Invalid calendar date');
    }
    return d;
  }
  DateTime get date => DateTime(year, month, day);
  DateTime get utc => DateTime.utc(year, month, day);
  int get weekday => utc.weekday;
  DateOnly addDays(int n) => DateOnly.from(utc.add(Duration(days: n)));
  DateOnly addMonths(int n) {
    final m = DateTime.utc(year, month + n, 1);
    return DateOnly(
      m.year,
      m.month,
      min(day, DateTime.utc(m.year, m.month + 1, 0).day),
    );
  }

  DateOnly inYear(int y) =>
      DateOnly(y, month, min(day, DateTime.utc(y, month + 1, 0).day));
  int daysUntil(DateOnly other) => other.utc.difference(utc).inDays;
  @override
  int compareTo(DateOnly other) => utc.compareTo(other.utc);
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  @override
  bool operator ==(Object other) => other is DateOnly && compareTo(other) == 0;
  @override
  int get hashCode => Object.hash(year, month, day);
}

enum RepeatMode { once, daily, weekly, monthly, yearly }

enum ReminderType { birthday, anniversary, bill, other }

class Reminder {
  final String id, title, note;
  final ReminderType type;
  final RepeatMode repeat;
  final DateOnly anchor;
  final int weekdays, dayOfMonth, alertMinutes, leads;
  final int? knownYear;
  final bool active;
  final String createdAt, updatedAt;
  const Reminder({
    required this.id,
    required this.title,
    required this.anchor,
    this.type = ReminderType.other,
    this.repeat = RepeatMode.once,
    this.weekdays = 1,
    this.dayOfMonth = 1,
    this.alertMinutes = 540,
    this.leads = 1,
    this.knownYear,
    this.note = '',
    this.active = true,
    this.createdAt = '',
    this.updatedAt = '',
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.name,
    'repeat': repeat.name,
    'anchor_date': anchor.toString(),
    'weekdays': weekdays,
    'day_of_month': dayOfMonth,
    'known_year': knownYear,
    'alert_minutes': alertMinutes,
    'leads': leads,
    'note': note,
    'is_active': active,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
  factory Reminder.fromJson(Map<String, dynamic> j) => Reminder(
    id: j['id'] as String,
    title: j['title'] as String,
    type: ReminderType.values.byName(j['type'] as String),
    repeat: RepeatMode.values.byName(j['repeat'] as String),
    anchor: DateOnly.parse(j['anchor_date'] as String),
    weekdays: j['weekdays'] as int,
    dayOfMonth: j['day_of_month'] as int,
    knownYear: j['known_year'] as int?,
    alertMinutes: j['alert_minutes'] as int,
    leads: j['leads'] as int,
    note: j['note'] as String? ?? '',
    active: j['is_active'] == true || j['is_active'] == 1,
    createdAt: j['created_at'] as String? ?? '',
    updatedAt: j['updated_at'] as String? ?? '',
  );
  List<String> validate() {
    final errors = <String>[];
    if (title.trim().isEmpty || title.length > 80) errors.add('title');
    if (note.length > 500) errors.add('note');
    if (repeat == RepeatMode.weekly && (weekdays < 1 || weekdays > 127)) {
      errors.add('weekdays');
    }
    if (leads < 1 || leads > 15) errors.add('leads');
    if (alertMinutes < 0 || alertMinutes > 1439) errors.add('time');
    if (dayOfMonth < 1 || dayOfMonth > 31) errors.add('day');
    if (anchor.utc.year != anchor.year ||
        anchor.utc.month != anchor.month ||
        anchor.utc.day != anchor.day) {
      errors.add('date');
    }
    if (knownYear != null && (knownYear! < 1 || knownYear! > 9999)) {
      errors.add('year');
    }
    return errors;
  }
}

class OccurrenceLog {
  final String reminderId, status, actedAt;
  final DateOnly date;
  final DateTime? snoozedUntil;
  const OccurrenceLog(
    this.reminderId,
    this.date,
    this.status,
    this.actedAt, [
    this.snoozedUntil,
  ]);
  String get key => '$reminderId|$date';
  Map<String, dynamic> toJson() => {
    'reminder_id': reminderId,
    'occurrence_date': date.toString(),
    'status': status,
    'acted_at': actedAt,
    'snoozed_until': snoozedUntil?.toIso8601String(),
  };
  factory OccurrenceLog.fromJson(Map<String, dynamic> j) => OccurrenceLog(
    j['reminder_id'] as String,
    DateOnly.parse(j['occurrence_date'] as String),
    j['status'] as String,
    j['acted_at'] as String,
    j['snoozed_until'] == null
        ? null
        : DateTime.parse(j['snoozed_until'] as String),
  );
}

String newId() {
  final r = Random.secure();
  final b = List<int>.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 15) | 64;
  b[8] = (b[8] & 63) | 128;
  final s = b.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
  return '${s.substring(0, 8)}-${s.substring(8, 12)}-${s.substring(12, 16)}-${s.substring(16, 20)}-${s.substring(20)}';
}
