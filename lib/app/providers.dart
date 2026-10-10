import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models.dart';
import '../data/repository.dart';
import '../notifications/scheduler.dart';
import 'settings.dart';

final repositoryProvider = Provider<Repository>(
  (ref) => throw UnimplementedError('Override at startup'),
);
final settingsProvider = Provider<AppSettings>(
  (ref) => throw UnimplementedError('Override at startup'),
);
final schedulerProvider = Provider<AlarmScheduler>(
  (ref) => throw UnimplementedError('Override at startup'),
);
final remindersProvider = StreamProvider<List<Reminder>>(
  (ref) => ref.watch(repositoryProvider).watchReminders(),
);
final logsProvider = StreamProvider<List<OccurrenceLog>>(
  (ref) => ref.watch(repositoryProvider).watchLogs(),
);
