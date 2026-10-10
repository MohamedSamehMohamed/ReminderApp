// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ReminderRowsTable extends ReminderRows
    with TableInfo<$ReminderRowsTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<String> repeat = GeneratedColumn<String>(
    'repeat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorDateMeta = const VerificationMeta(
    'anchorDate',
  );
  @override
  late final GeneratedColumn<String> anchorDate = GeneratedColumn<String>(
    'anchor_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knownYearMeta = const VerificationMeta(
    'knownYear',
  );
  @override
  late final GeneratedColumn<int> knownYear = GeneratedColumn<int>(
    'known_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alertMinutesMeta = const VerificationMeta(
    'alertMinutes',
  );
  @override
  late final GeneratedColumn<int> alertMinutes = GeneratedColumn<int>(
    'alert_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leadsMeta = const VerificationMeta('leads');
  @override
  late final GeneratedColumn<int> leads = GeneratedColumn<int>(
    'leads',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    type,
    repeat,
    anchorDate,
    weekdays,
    dayOfMonth,
    knownYear,
    alertMinutes,
    leads,
    note,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('repeat')) {
      context.handle(
        _repeatMeta,
        repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatMeta);
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
        _anchorDateMeta,
        anchorDate.isAcceptableOrUnknown(data['anchor_date']!, _anchorDateMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorDateMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('known_year')) {
      context.handle(
        _knownYearMeta,
        knownYear.isAcceptableOrUnknown(data['known_year']!, _knownYearMeta),
      );
    }
    if (data.containsKey('alert_minutes')) {
      context.handle(
        _alertMinutesMeta,
        alertMinutes.isAcceptableOrUnknown(
          data['alert_minutes']!,
          _alertMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_alertMinutesMeta);
    }
    if (data.containsKey('leads')) {
      context.handle(
        _leadsMeta,
        leads.isAcceptableOrUnknown(data['leads']!, _leadsMeta),
      );
    } else if (isInserting) {
      context.missing(_leadsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      repeat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat'],
      )!,
      anchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_date'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      )!,
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      )!,
      knownYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}known_year'],
      ),
      alertMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alert_minutes'],
      )!,
      leads: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leads'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReminderRowsTable createAlias(String alias) {
    return $ReminderRowsTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final String id;
  final String title;
  final String type;
  final String repeat;
  final String anchorDate;
  final int weekdays;
  final int dayOfMonth;
  final int? knownYear;
  final int alertMinutes;
  final int leads;
  final String note;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  const ReminderRow({
    required this.id,
    required this.title,
    required this.type,
    required this.repeat,
    required this.anchorDate,
    required this.weekdays,
    required this.dayOfMonth,
    this.knownYear,
    required this.alertMinutes,
    required this.leads,
    required this.note,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['repeat'] = Variable<String>(repeat);
    map['anchor_date'] = Variable<String>(anchorDate);
    map['weekdays'] = Variable<int>(weekdays);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    if (!nullToAbsent || knownYear != null) {
      map['known_year'] = Variable<int>(knownYear);
    }
    map['alert_minutes'] = Variable<int>(alertMinutes);
    map['leads'] = Variable<int>(leads);
    map['note'] = Variable<String>(note);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ReminderRowsCompanion toCompanion(bool nullToAbsent) {
    return ReminderRowsCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      repeat: Value(repeat),
      anchorDate: Value(anchorDate),
      weekdays: Value(weekdays),
      dayOfMonth: Value(dayOfMonth),
      knownYear: knownYear == null && nullToAbsent
          ? const Value.absent()
          : Value(knownYear),
      alertMinutes: Value(alertMinutes),
      leads: Value(leads),
      note: Value(note),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      repeat: serializer.fromJson<String>(json['repeat']),
      anchorDate: serializer.fromJson<String>(json['anchorDate']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      knownYear: serializer.fromJson<int?>(json['knownYear']),
      alertMinutes: serializer.fromJson<int>(json['alertMinutes']),
      leads: serializer.fromJson<int>(json['leads']),
      note: serializer.fromJson<String>(json['note']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'repeat': serializer.toJson<String>(repeat),
      'anchorDate': serializer.toJson<String>(anchorDate),
      'weekdays': serializer.toJson<int>(weekdays),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'knownYear': serializer.toJson<int?>(knownYear),
      'alertMinutes': serializer.toJson<int>(alertMinutes),
      'leads': serializer.toJson<int>(leads),
      'note': serializer.toJson<String>(note),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ReminderRow copyWith({
    String? id,
    String? title,
    String? type,
    String? repeat,
    String? anchorDate,
    int? weekdays,
    int? dayOfMonth,
    Value<int?> knownYear = const Value.absent(),
    int? alertMinutes,
    int? leads,
    String? note,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
  }) => ReminderRow(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    repeat: repeat ?? this.repeat,
    anchorDate: anchorDate ?? this.anchorDate,
    weekdays: weekdays ?? this.weekdays,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    knownYear: knownYear.present ? knownYear.value : this.knownYear,
    alertMinutes: alertMinutes ?? this.alertMinutes,
    leads: leads ?? this.leads,
    note: note ?? this.note,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderRow copyWithCompanion(ReminderRowsCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      anchorDate: data.anchorDate.present
          ? data.anchorDate.value
          : this.anchorDate,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      knownYear: data.knownYear.present ? data.knownYear.value : this.knownYear,
      alertMinutes: data.alertMinutes.present
          ? data.alertMinutes.value
          : this.alertMinutes,
      leads: data.leads.present ? data.leads.value : this.leads,
      note: data.note.present ? data.note.value : this.note,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('repeat: $repeat, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('weekdays: $weekdays, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('knownYear: $knownYear, ')
          ..write('alertMinutes: $alertMinutes, ')
          ..write('leads: $leads, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    type,
    repeat,
    anchorDate,
    weekdays,
    dayOfMonth,
    knownYear,
    alertMinutes,
    leads,
    note,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.repeat == this.repeat &&
          other.anchorDate == this.anchorDate &&
          other.weekdays == this.weekdays &&
          other.dayOfMonth == this.dayOfMonth &&
          other.knownYear == this.knownYear &&
          other.alertMinutes == this.alertMinutes &&
          other.leads == this.leads &&
          other.note == this.note &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReminderRowsCompanion extends UpdateCompanion<ReminderRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> type;
  final Value<String> repeat;
  final Value<String> anchorDate;
  final Value<int> weekdays;
  final Value<int> dayOfMonth;
  final Value<int?> knownYear;
  final Value<int> alertMinutes;
  final Value<int> leads;
  final Value<String> note;
  final Value<bool> isActive;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ReminderRowsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.repeat = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.knownYear = const Value.absent(),
    this.alertMinutes = const Value.absent(),
    this.leads = const Value.absent(),
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderRowsCompanion.insert({
    required String id,
    required String title,
    required String type,
    required String repeat,
    required String anchorDate,
    required int weekdays,
    required int dayOfMonth,
    this.knownYear = const Value.absent(),
    required int alertMinutes,
    required int leads,
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       type = Value(type),
       repeat = Value(repeat),
       anchorDate = Value(anchorDate),
       weekdays = Value(weekdays),
       dayOfMonth = Value(dayOfMonth),
       alertMinutes = Value(alertMinutes),
       leads = Value(leads),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? repeat,
    Expression<String>? anchorDate,
    Expression<int>? weekdays,
    Expression<int>? dayOfMonth,
    Expression<int>? knownYear,
    Expression<int>? alertMinutes,
    Expression<int>? leads,
    Expression<String>? note,
    Expression<bool>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (repeat != null) 'repeat': repeat,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (weekdays != null) 'weekdays': weekdays,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (knownYear != null) 'known_year': knownYear,
      if (alertMinutes != null) 'alert_minutes': alertMinutes,
      if (leads != null) 'leads': leads,
      if (note != null) 'note': note,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? type,
    Value<String>? repeat,
    Value<String>? anchorDate,
    Value<int>? weekdays,
    Value<int>? dayOfMonth,
    Value<int?>? knownYear,
    Value<int>? alertMinutes,
    Value<int>? leads,
    Value<String>? note,
    Value<bool>? isActive,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReminderRowsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      repeat: repeat ?? this.repeat,
      anchorDate: anchorDate ?? this.anchorDate,
      weekdays: weekdays ?? this.weekdays,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      knownYear: knownYear ?? this.knownYear,
      alertMinutes: alertMinutes ?? this.alertMinutes,
      leads: leads ?? this.leads,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(repeat.value);
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<String>(anchorDate.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (knownYear.present) {
      map['known_year'] = Variable<int>(knownYear.value);
    }
    if (alertMinutes.present) {
      map['alert_minutes'] = Variable<int>(alertMinutes.value);
    }
    if (leads.present) {
      map['leads'] = Variable<int>(leads.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRowsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('repeat: $repeat, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('weekdays: $weekdays, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('knownYear: $knownYear, ')
          ..write('alertMinutes: $alertMinutes, ')
          ..write('leads: $leads, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OccurrenceLogsTable extends OccurrenceLogs
    with TableInfo<$OccurrenceLogsTable, LogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OccurrenceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reminders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _occurrenceDateMeta = const VerificationMeta(
    'occurrenceDate',
  );
  @override
  late final GeneratedColumn<String> occurrenceDate = GeneratedColumn<String>(
    'occurrence_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snoozedUntilMeta = const VerificationMeta(
    'snoozedUntil',
  );
  @override
  late final GeneratedColumn<String> snoozedUntil = GeneratedColumn<String>(
    'snoozed_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actedAtMeta = const VerificationMeta(
    'actedAt',
  );
  @override
  late final GeneratedColumn<String> actedAt = GeneratedColumn<String>(
    'acted_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    reminderId,
    occurrenceDate,
    status,
    snoozedUntil,
    actedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'occurrence_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<LogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('occurrence_date')) {
      context.handle(
        _occurrenceDateMeta,
        occurrenceDate.isAcceptableOrUnknown(
          data['occurrence_date']!,
          _occurrenceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
        _snoozedUntilMeta,
        snoozedUntil.isAcceptableOrUnknown(
          data['snoozed_until']!,
          _snoozedUntilMeta,
        ),
      );
    }
    if (data.containsKey('acted_at')) {
      context.handle(
        _actedAtMeta,
        actedAt.isAcceptableOrUnknown(data['acted_at']!, _actedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_actedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {reminderId, occurrenceDate};
  @override
  LogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogRow(
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      )!,
      occurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurrence_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      snoozedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snoozed_until'],
      ),
      actedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acted_at'],
      )!,
    );
  }

  @override
  $OccurrenceLogsTable createAlias(String alias) {
    return $OccurrenceLogsTable(attachedDatabase, alias);
  }
}

class LogRow extends DataClass implements Insertable<LogRow> {
  final String reminderId;
  final String occurrenceDate;
  final String status;
  final String? snoozedUntil;
  final String actedAt;
  const LogRow({
    required this.reminderId,
    required this.occurrenceDate,
    required this.status,
    this.snoozedUntil,
    required this.actedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reminder_id'] = Variable<String>(reminderId);
    map['occurrence_date'] = Variable<String>(occurrenceDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<String>(snoozedUntil);
    }
    map['acted_at'] = Variable<String>(actedAt);
    return map;
  }

  OccurrenceLogsCompanion toCompanion(bool nullToAbsent) {
    return OccurrenceLogsCompanion(
      reminderId: Value(reminderId),
      occurrenceDate: Value(occurrenceDate),
      status: Value(status),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      actedAt: Value(actedAt),
    );
  }

  factory LogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogRow(
      reminderId: serializer.fromJson<String>(json['reminderId']),
      occurrenceDate: serializer.fromJson<String>(json['occurrenceDate']),
      status: serializer.fromJson<String>(json['status']),
      snoozedUntil: serializer.fromJson<String?>(json['snoozedUntil']),
      actedAt: serializer.fromJson<String>(json['actedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reminderId': serializer.toJson<String>(reminderId),
      'occurrenceDate': serializer.toJson<String>(occurrenceDate),
      'status': serializer.toJson<String>(status),
      'snoozedUntil': serializer.toJson<String?>(snoozedUntil),
      'actedAt': serializer.toJson<String>(actedAt),
    };
  }

  LogRow copyWith({
    String? reminderId,
    String? occurrenceDate,
    String? status,
    Value<String?> snoozedUntil = const Value.absent(),
    String? actedAt,
  }) => LogRow(
    reminderId: reminderId ?? this.reminderId,
    occurrenceDate: occurrenceDate ?? this.occurrenceDate,
    status: status ?? this.status,
    snoozedUntil: snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
    actedAt: actedAt ?? this.actedAt,
  );
  LogRow copyWithCompanion(OccurrenceLogsCompanion data) {
    return LogRow(
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      status: data.status.present ? data.status.value : this.status,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      actedAt: data.actedAt.present ? data.actedAt.value : this.actedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogRow(')
          ..write('reminderId: $reminderId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('status: $status, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('actedAt: $actedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(reminderId, occurrenceDate, status, snoozedUntil, actedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogRow &&
          other.reminderId == this.reminderId &&
          other.occurrenceDate == this.occurrenceDate &&
          other.status == this.status &&
          other.snoozedUntil == this.snoozedUntil &&
          other.actedAt == this.actedAt);
}

class OccurrenceLogsCompanion extends UpdateCompanion<LogRow> {
  final Value<String> reminderId;
  final Value<String> occurrenceDate;
  final Value<String> status;
  final Value<String?> snoozedUntil;
  final Value<String> actedAt;
  final Value<int> rowid;
  const OccurrenceLogsCompanion({
    this.reminderId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.status = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.actedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OccurrenceLogsCompanion.insert({
    required String reminderId,
    required String occurrenceDate,
    required String status,
    this.snoozedUntil = const Value.absent(),
    required String actedAt,
    this.rowid = const Value.absent(),
  }) : reminderId = Value(reminderId),
       occurrenceDate = Value(occurrenceDate),
       status = Value(status),
       actedAt = Value(actedAt);
  static Insertable<LogRow> custom({
    Expression<String>? reminderId,
    Expression<String>? occurrenceDate,
    Expression<String>? status,
    Expression<String>? snoozedUntil,
    Expression<String>? actedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reminderId != null) 'reminder_id': reminderId,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (status != null) 'status': status,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (actedAt != null) 'acted_at': actedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OccurrenceLogsCompanion copyWith({
    Value<String>? reminderId,
    Value<String>? occurrenceDate,
    Value<String>? status,
    Value<String?>? snoozedUntil,
    Value<String>? actedAt,
    Value<int>? rowid,
  }) {
    return OccurrenceLogsCompanion(
      reminderId: reminderId ?? this.reminderId,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      status: status ?? this.status,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      actedAt: actedAt ?? this.actedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<String>(occurrenceDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<String>(snoozedUntil.value);
    }
    if (actedAt.present) {
      map['acted_at'] = Variable<String>(actedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OccurrenceLogsCompanion(')
          ..write('reminderId: $reminderId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('status: $status, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('actedAt: $actedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledAlarmsTable extends ScheduledAlarms
    with TableInfo<$ScheduledAlarmsTable, ScheduledAlarm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledAlarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reminders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _occurrenceDateMeta = const VerificationMeta(
    'occurrenceDate',
  );
  @override
  late final GeneratedColumn<String> occurrenceDate = GeneratedColumn<String>(
    'occurrence_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leadMeta = const VerificationMeta('lead');
  @override
  late final GeneratedColumn<String> lead = GeneratedColumn<String>(
    'lead',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fireAtMeta = const VerificationMeta('fireAt');
  @override
  late final GeneratedColumn<String> fireAt = GeneratedColumn<String>(
    'fire_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    notificationId,
    reminderId,
    occurrenceDate,
    lead,
    fireAt,
    fingerprint,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledAlarm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('occurrence_date')) {
      context.handle(
        _occurrenceDateMeta,
        occurrenceDate.isAcceptableOrUnknown(
          data['occurrence_date']!,
          _occurrenceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceDateMeta);
    }
    if (data.containsKey('lead')) {
      context.handle(
        _leadMeta,
        lead.isAcceptableOrUnknown(data['lead']!, _leadMeta),
      );
    } else if (isInserting) {
      context.missing(_leadMeta);
    }
    if (data.containsKey('fire_at')) {
      context.handle(
        _fireAtMeta,
        fireAt.isAcceptableOrUnknown(data['fire_at']!, _fireAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fireAtMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {notificationId};
  @override
  ScheduledAlarm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledAlarm(
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      )!,
      occurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurrence_date'],
      )!,
      lead: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lead'],
      )!,
      fireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fire_at'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
    );
  }

  @override
  $ScheduledAlarmsTable createAlias(String alias) {
    return $ScheduledAlarmsTable(attachedDatabase, alias);
  }
}

class ScheduledAlarm extends DataClass implements Insertable<ScheduledAlarm> {
  final int notificationId;
  final String reminderId;
  final String occurrenceDate;
  final String lead;
  final String fireAt;
  final String fingerprint;
  const ScheduledAlarm({
    required this.notificationId,
    required this.reminderId,
    required this.occurrenceDate,
    required this.lead,
    required this.fireAt,
    required this.fingerprint,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['notification_id'] = Variable<int>(notificationId);
    map['reminder_id'] = Variable<String>(reminderId);
    map['occurrence_date'] = Variable<String>(occurrenceDate);
    map['lead'] = Variable<String>(lead);
    map['fire_at'] = Variable<String>(fireAt);
    map['fingerprint'] = Variable<String>(fingerprint);
    return map;
  }

  ScheduledAlarmsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledAlarmsCompanion(
      notificationId: Value(notificationId),
      reminderId: Value(reminderId),
      occurrenceDate: Value(occurrenceDate),
      lead: Value(lead),
      fireAt: Value(fireAt),
      fingerprint: Value(fingerprint),
    );
  }

  factory ScheduledAlarm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledAlarm(
      notificationId: serializer.fromJson<int>(json['notificationId']),
      reminderId: serializer.fromJson<String>(json['reminderId']),
      occurrenceDate: serializer.fromJson<String>(json['occurrenceDate']),
      lead: serializer.fromJson<String>(json['lead']),
      fireAt: serializer.fromJson<String>(json['fireAt']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'notificationId': serializer.toJson<int>(notificationId),
      'reminderId': serializer.toJson<String>(reminderId),
      'occurrenceDate': serializer.toJson<String>(occurrenceDate),
      'lead': serializer.toJson<String>(lead),
      'fireAt': serializer.toJson<String>(fireAt),
      'fingerprint': serializer.toJson<String>(fingerprint),
    };
  }

  ScheduledAlarm copyWith({
    int? notificationId,
    String? reminderId,
    String? occurrenceDate,
    String? lead,
    String? fireAt,
    String? fingerprint,
  }) => ScheduledAlarm(
    notificationId: notificationId ?? this.notificationId,
    reminderId: reminderId ?? this.reminderId,
    occurrenceDate: occurrenceDate ?? this.occurrenceDate,
    lead: lead ?? this.lead,
    fireAt: fireAt ?? this.fireAt,
    fingerprint: fingerprint ?? this.fingerprint,
  );
  ScheduledAlarm copyWithCompanion(ScheduledAlarmsCompanion data) {
    return ScheduledAlarm(
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      lead: data.lead.present ? data.lead.value : this.lead,
      fireAt: data.fireAt.present ? data.fireAt.value : this.fireAt,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledAlarm(')
          ..write('notificationId: $notificationId, ')
          ..write('reminderId: $reminderId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('lead: $lead, ')
          ..write('fireAt: $fireAt, ')
          ..write('fingerprint: $fingerprint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    notificationId,
    reminderId,
    occurrenceDate,
    lead,
    fireAt,
    fingerprint,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledAlarm &&
          other.notificationId == this.notificationId &&
          other.reminderId == this.reminderId &&
          other.occurrenceDate == this.occurrenceDate &&
          other.lead == this.lead &&
          other.fireAt == this.fireAt &&
          other.fingerprint == this.fingerprint);
}

class ScheduledAlarmsCompanion extends UpdateCompanion<ScheduledAlarm> {
  final Value<int> notificationId;
  final Value<String> reminderId;
  final Value<String> occurrenceDate;
  final Value<String> lead;
  final Value<String> fireAt;
  final Value<String> fingerprint;
  const ScheduledAlarmsCompanion({
    this.notificationId = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.lead = const Value.absent(),
    this.fireAt = const Value.absent(),
    this.fingerprint = const Value.absent(),
  });
  ScheduledAlarmsCompanion.insert({
    this.notificationId = const Value.absent(),
    required String reminderId,
    required String occurrenceDate,
    required String lead,
    required String fireAt,
    required String fingerprint,
  }) : reminderId = Value(reminderId),
       occurrenceDate = Value(occurrenceDate),
       lead = Value(lead),
       fireAt = Value(fireAt),
       fingerprint = Value(fingerprint);
  static Insertable<ScheduledAlarm> custom({
    Expression<int>? notificationId,
    Expression<String>? reminderId,
    Expression<String>? occurrenceDate,
    Expression<String>? lead,
    Expression<String>? fireAt,
    Expression<String>? fingerprint,
  }) {
    return RawValuesInsertable({
      if (notificationId != null) 'notification_id': notificationId,
      if (reminderId != null) 'reminder_id': reminderId,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (lead != null) 'lead': lead,
      if (fireAt != null) 'fire_at': fireAt,
      if (fingerprint != null) 'fingerprint': fingerprint,
    });
  }

  ScheduledAlarmsCompanion copyWith({
    Value<int>? notificationId,
    Value<String>? reminderId,
    Value<String>? occurrenceDate,
    Value<String>? lead,
    Value<String>? fireAt,
    Value<String>? fingerprint,
  }) {
    return ScheduledAlarmsCompanion(
      notificationId: notificationId ?? this.notificationId,
      reminderId: reminderId ?? this.reminderId,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      lead: lead ?? this.lead,
      fireAt: fireAt ?? this.fireAt,
      fingerprint: fingerprint ?? this.fingerprint,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<String>(occurrenceDate.value);
    }
    if (lead.present) {
      map['lead'] = Variable<String>(lead.value);
    }
    if (fireAt.present) {
      map['fire_at'] = Variable<String>(fireAt.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledAlarmsCompanion(')
          ..write('notificationId: $notificationId, ')
          ..write('reminderId: $reminderId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('lead: $lead, ')
          ..write('fireAt: $fireAt, ')
          ..write('fingerprint: $fingerprint')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReminderRowsTable reminderRows = $ReminderRowsTable(this);
  late final $OccurrenceLogsTable occurrenceLogs = $OccurrenceLogsTable(this);
  late final $ScheduledAlarmsTable scheduledAlarms = $ScheduledAlarmsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    reminderRows,
    occurrenceLogs,
    scheduledAlarms,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('occurrence_log', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scheduled_alarms', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ReminderRowsTableCreateCompanionBuilder =
    ReminderRowsCompanion Function({
      required String id,
      required String title,
      required String type,
      required String repeat,
      required String anchorDate,
      required int weekdays,
      required int dayOfMonth,
      Value<int?> knownYear,
      required int alertMinutes,
      required int leads,
      Value<String> note,
      Value<bool> isActive,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$ReminderRowsTableUpdateCompanionBuilder =
    ReminderRowsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> type,
      Value<String> repeat,
      Value<String> anchorDate,
      Value<int> weekdays,
      Value<int> dayOfMonth,
      Value<int?> knownYear,
      Value<int> alertMinutes,
      Value<int> leads,
      Value<String> note,
      Value<bool> isActive,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$ReminderRowsTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderRowsTable, ReminderRow> {
  $$ReminderRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OccurrenceLogsTable, List<LogRow>>
  _occurrenceLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.occurrenceLogs,
    aliasName: 'reminders__id__occurrence_log__reminder_id',
  );

  $$OccurrenceLogsTableProcessedTableManager get occurrenceLogsRefs {
    final manager = $$OccurrenceLogsTableTableManager(
      $_db,
      $_db.occurrenceLogs,
    ).filter((f) => f.reminderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_occurrenceLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScheduledAlarmsTable, List<ScheduledAlarm>>
  _scheduledAlarmsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduledAlarms,
    aliasName: 'reminders__id__scheduled_alarms__reminder_id',
  );

  $$ScheduledAlarmsTableProcessedTableManager get scheduledAlarmsRefs {
    final manager = $$ScheduledAlarmsTableTableManager(
      $_db,
      $_db.scheduledAlarms,
    ).filter((f) => f.reminderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduledAlarmsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReminderRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderRowsTable> {
  $$ReminderRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get knownYear => $composableBuilder(
    column: $table.knownYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alertMinutes => $composableBuilder(
    column: $table.alertMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leads => $composableBuilder(
    column: $table.leads,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> occurrenceLogsRefs(
    Expression<bool> Function($$OccurrenceLogsTableFilterComposer f) f,
  ) {
    final $$OccurrenceLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occurrenceLogs,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccurrenceLogsTableFilterComposer(
            $db: $db,
            $table: $db.occurrenceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scheduledAlarmsRefs(
    Expression<bool> Function($$ScheduledAlarmsTableFilterComposer f) f,
  ) {
    final $$ScheduledAlarmsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduledAlarms,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduledAlarmsTableFilterComposer(
            $db: $db,
            $table: $db.scheduledAlarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReminderRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderRowsTable> {
  $$ReminderRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get knownYear => $composableBuilder(
    column: $table.knownYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alertMinutes => $composableBuilder(
    column: $table.alertMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leads => $composableBuilder(
    column: $table.leads,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderRowsTable> {
  $$ReminderRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumn<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get knownYear =>
      $composableBuilder(column: $table.knownYear, builder: (column) => column);

  GeneratedColumn<int> get alertMinutes => $composableBuilder(
    column: $table.alertMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leads =>
      $composableBuilder(column: $table.leads, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> occurrenceLogsRefs<T extends Object>(
    Expression<T> Function($$OccurrenceLogsTableAnnotationComposer a) f,
  ) {
    final $$OccurrenceLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occurrenceLogs,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccurrenceLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.occurrenceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scheduledAlarmsRefs<T extends Object>(
    Expression<T> Function($$ScheduledAlarmsTableAnnotationComposer a) f,
  ) {
    final $$ScheduledAlarmsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduledAlarms,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduledAlarmsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduledAlarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReminderRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderRowsTable,
          ReminderRow,
          $$ReminderRowsTableFilterComposer,
          $$ReminderRowsTableOrderingComposer,
          $$ReminderRowsTableAnnotationComposer,
          $$ReminderRowsTableCreateCompanionBuilder,
          $$ReminderRowsTableUpdateCompanionBuilder,
          (ReminderRow, $$ReminderRowsTableReferences),
          ReminderRow,
          PrefetchHooks Function({
            bool occurrenceLogsRefs,
            bool scheduledAlarmsRefs,
          })
        > {
  $$ReminderRowsTableTableManager(_$AppDatabase db, $ReminderRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> repeat = const Value.absent(),
                Value<String> anchorDate = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<int?> knownYear = const Value.absent(),
                Value<int> alertMinutes = const Value.absent(),
                Value<int> leads = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderRowsCompanion(
                id: id,
                title: title,
                type: type,
                repeat: repeat,
                anchorDate: anchorDate,
                weekdays: weekdays,
                dayOfMonth: dayOfMonth,
                knownYear: knownYear,
                alertMinutes: alertMinutes,
                leads: leads,
                note: note,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String type,
                required String repeat,
                required String anchorDate,
                required int weekdays,
                required int dayOfMonth,
                Value<int?> knownYear = const Value.absent(),
                required int alertMinutes,
                required int leads,
                Value<String> note = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReminderRowsCompanion.insert(
                id: id,
                title: title,
                type: type,
                repeat: repeat,
                anchorDate: anchorDate,
                weekdays: weekdays,
                dayOfMonth: dayOfMonth,
                knownYear: knownYear,
                alertMinutes: alertMinutes,
                leads: leads,
                note: note,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderRowsTable, ReminderRow>(table),
                  $$ReminderRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({occurrenceLogsRefs = false, scheduledAlarmsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (occurrenceLogsRefs) db.occurrenceLogs,
                    if (scheduledAlarmsRefs) db.scheduledAlarms,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (occurrenceLogsRefs)
                        await $_getPrefetchedData<
                          ReminderRow,
                          $ReminderRowsTable,
                          LogRow
                        >(
                          currentTable: table,
                          referencedTable: $$ReminderRowsTableReferences
                              ._occurrenceLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReminderRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).occurrenceLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reminderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scheduledAlarmsRefs)
                        await $_getPrefetchedData<
                          ReminderRow,
                          $ReminderRowsTable,
                          ScheduledAlarm
                        >(
                          currentTable: table,
                          referencedTable: $$ReminderRowsTableReferences
                              ._scheduledAlarmsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReminderRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduledAlarmsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reminderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReminderRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderRowsTable,
      ReminderRow,
      $$ReminderRowsTableFilterComposer,
      $$ReminderRowsTableOrderingComposer,
      $$ReminderRowsTableAnnotationComposer,
      $$ReminderRowsTableCreateCompanionBuilder,
      $$ReminderRowsTableUpdateCompanionBuilder,
      (ReminderRow, $$ReminderRowsTableReferences),
      ReminderRow,
      PrefetchHooks Function({
        bool occurrenceLogsRefs,
        bool scheduledAlarmsRefs,
      })
    >;
typedef $$OccurrenceLogsTableCreateCompanionBuilder =
    OccurrenceLogsCompanion Function({
      required String reminderId,
      required String occurrenceDate,
      required String status,
      Value<String?> snoozedUntil,
      required String actedAt,
      Value<int> rowid,
    });
typedef $$OccurrenceLogsTableUpdateCompanionBuilder =
    OccurrenceLogsCompanion Function({
      Value<String> reminderId,
      Value<String> occurrenceDate,
      Value<String> status,
      Value<String?> snoozedUntil,
      Value<String> actedAt,
      Value<int> rowid,
    });

final class $$OccurrenceLogsTableReferences
    extends BaseReferences<_$AppDatabase, $OccurrenceLogsTable, LogRow> {
  $$OccurrenceLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ReminderRowsTable _reminderIdTable(_$AppDatabase db) =>
      db.reminderRows.createAlias('occurrence_log__reminder_id__reminders__id');

  $$ReminderRowsTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<String>('reminder_id')!;

    final manager = $$ReminderRowsTableTableManager(
      $_db,
      $_db.reminderRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OccurrenceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OccurrenceLogsTable> {
  $$OccurrenceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ReminderRowsTableFilterComposer get reminderId {
    final $$ReminderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRowsTableFilterComposer(
            $db: $db,
            $table: $db.reminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OccurrenceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OccurrenceLogsTable> {
  $$OccurrenceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReminderRowsTableOrderingComposer get reminderId {
    final $$ReminderRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRowsTableOrderingComposer(
            $db: $db,
            $table: $db.reminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OccurrenceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OccurrenceLogsTable> {
  $$OccurrenceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actedAt =>
      $composableBuilder(column: $table.actedAt, builder: (column) => column);

  $$ReminderRowsTableAnnotationComposer get reminderId {
    final $$ReminderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OccurrenceLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OccurrenceLogsTable,
          LogRow,
          $$OccurrenceLogsTableFilterComposer,
          $$OccurrenceLogsTableOrderingComposer,
          $$OccurrenceLogsTableAnnotationComposer,
          $$OccurrenceLogsTableCreateCompanionBuilder,
          $$OccurrenceLogsTableUpdateCompanionBuilder,
          (LogRow, $$OccurrenceLogsTableReferences),
          LogRow,
          PrefetchHooks Function({bool reminderId})
        > {
  $$OccurrenceLogsTableTableManager(
    _$AppDatabase db,
    $OccurrenceLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OccurrenceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OccurrenceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OccurrenceLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> reminderId = const Value.absent(),
                Value<String> occurrenceDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> snoozedUntil = const Value.absent(),
                Value<String> actedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OccurrenceLogsCompanion(
                reminderId: reminderId,
                occurrenceDate: occurrenceDate,
                status: status,
                snoozedUntil: snoozedUntil,
                actedAt: actedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String reminderId,
                required String occurrenceDate,
                required String status,
                Value<String?> snoozedUntil = const Value.absent(),
                required String actedAt,
                Value<int> rowid = const Value.absent(),
              }) => OccurrenceLogsCompanion.insert(
                reminderId: reminderId,
                occurrenceDate: occurrenceDate,
                status: status,
                snoozedUntil: snoozedUntil,
                actedAt: actedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OccurrenceLogsTable, LogRow>(table),
                  $$OccurrenceLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reminderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reminderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.reminderId,
                        referencedTable: $$OccurrenceLogsTableReferences
                            ._reminderIdTable(db),
                        referencedColumn: $$OccurrenceLogsTableReferences
                            ._reminderIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OccurrenceLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OccurrenceLogsTable,
      LogRow,
      $$OccurrenceLogsTableFilterComposer,
      $$OccurrenceLogsTableOrderingComposer,
      $$OccurrenceLogsTableAnnotationComposer,
      $$OccurrenceLogsTableCreateCompanionBuilder,
      $$OccurrenceLogsTableUpdateCompanionBuilder,
      (LogRow, $$OccurrenceLogsTableReferences),
      LogRow,
      PrefetchHooks Function({bool reminderId})
    >;
typedef $$ScheduledAlarmsTableCreateCompanionBuilder =
    ScheduledAlarmsCompanion Function({
      Value<int> notificationId,
      required String reminderId,
      required String occurrenceDate,
      required String lead,
      required String fireAt,
      required String fingerprint,
    });
typedef $$ScheduledAlarmsTableUpdateCompanionBuilder =
    ScheduledAlarmsCompanion Function({
      Value<int> notificationId,
      Value<String> reminderId,
      Value<String> occurrenceDate,
      Value<String> lead,
      Value<String> fireAt,
      Value<String> fingerprint,
    });

final class $$ScheduledAlarmsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ScheduledAlarmsTable, ScheduledAlarm> {
  $$ScheduledAlarmsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ReminderRowsTable _reminderIdTable(_$AppDatabase db) => db
      .reminderRows
      .createAlias('scheduled_alarms__reminder_id__reminders__id');

  $$ReminderRowsTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<String>('reminder_id')!;

    final manager = $$ReminderRowsTableTableManager(
      $_db,
      $_db.reminderRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduledAlarmsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledAlarmsTable> {
  $$ScheduledAlarmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lead => $composableBuilder(
    column: $table.lead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  $$ReminderRowsTableFilterComposer get reminderId {
    final $$ReminderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRowsTableFilterComposer(
            $db: $db,
            $table: $db.reminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledAlarmsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledAlarmsTable> {
  $$ScheduledAlarmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lead => $composableBuilder(
    column: $table.lead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReminderRowsTableOrderingComposer get reminderId {
    final $$ReminderRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRowsTableOrderingComposer(
            $db: $db,
            $table: $db.reminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledAlarmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledAlarmsTable> {
  $$ScheduledAlarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lead =>
      $composableBuilder(column: $table.lead, builder: (column) => column);

  GeneratedColumn<String> get fireAt =>
      $composableBuilder(column: $table.fireAt, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  $$ReminderRowsTableAnnotationComposer get reminderId {
    final $$ReminderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledAlarmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledAlarmsTable,
          ScheduledAlarm,
          $$ScheduledAlarmsTableFilterComposer,
          $$ScheduledAlarmsTableOrderingComposer,
          $$ScheduledAlarmsTableAnnotationComposer,
          $$ScheduledAlarmsTableCreateCompanionBuilder,
          $$ScheduledAlarmsTableUpdateCompanionBuilder,
          (ScheduledAlarm, $$ScheduledAlarmsTableReferences),
          ScheduledAlarm,
          PrefetchHooks Function({bool reminderId})
        > {
  $$ScheduledAlarmsTableTableManager(
    _$AppDatabase db,
    $ScheduledAlarmsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledAlarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledAlarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledAlarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                Value<String> reminderId = const Value.absent(),
                Value<String> occurrenceDate = const Value.absent(),
                Value<String> lead = const Value.absent(),
                Value<String> fireAt = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
              }) => ScheduledAlarmsCompanion(
                notificationId: notificationId,
                reminderId: reminderId,
                occurrenceDate: occurrenceDate,
                lead: lead,
                fireAt: fireAt,
                fingerprint: fingerprint,
              ),
          createCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                required String reminderId,
                required String occurrenceDate,
                required String lead,
                required String fireAt,
                required String fingerprint,
              }) => ScheduledAlarmsCompanion.insert(
                notificationId: notificationId,
                reminderId: reminderId,
                occurrenceDate: occurrenceDate,
                lead: lead,
                fireAt: fireAt,
                fingerprint: fingerprint,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScheduledAlarmsTable, ScheduledAlarm>(table),
                  $$ScheduledAlarmsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reminderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reminderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.reminderId,
                        referencedTable: $$ScheduledAlarmsTableReferences
                            ._reminderIdTable(db),
                        referencedColumn: $$ScheduledAlarmsTableReferences
                            ._reminderIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScheduledAlarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledAlarmsTable,
      ScheduledAlarm,
      $$ScheduledAlarmsTableFilterComposer,
      $$ScheduledAlarmsTableOrderingComposer,
      $$ScheduledAlarmsTableAnnotationComposer,
      $$ScheduledAlarmsTableCreateCompanionBuilder,
      $$ScheduledAlarmsTableUpdateCompanionBuilder,
      (ScheduledAlarm, $$ScheduledAlarmsTableReferences),
      ScheduledAlarm,
      PrefetchHooks Function({bool reminderId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReminderRowsTableTableManager get reminderRows =>
      $$ReminderRowsTableTableManager(_db, _db.reminderRows);
  $$OccurrenceLogsTableTableManager get occurrenceLogs =>
      $$OccurrenceLogsTableTableManager(_db, _db.occurrenceLogs);
  $$ScheduledAlarmsTableTableManager get scheduledAlarms =>
      $$ScheduledAlarmsTableTableManager(_db, _db.scheduledAlarms);
}
