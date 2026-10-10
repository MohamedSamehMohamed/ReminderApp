import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/tokens.dart';
import '../../core/models.dart';
import '../../notifications/scheduler.dart';
import '../common.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  Future<void> transfer(
    BuildContext context,
    WidgetRef ref,
    bool importing,
  ) async {
    try {
      if (!importing) {
        final json = await ref.read(repositoryProvider).exportJson();
        final result = await FilePicker.saveFile(
          fileName: 'reminders-backup.json',
          type: FileType.custom,
          allowedExtensions: ['json'],
          bytes: Uint8List.fromList(utf8.encode(json)),
        );
        if (result == null) return;
      } else {
        final file = await FilePicker.pickFile(
          type: FileType.custom,
          allowedExtensions: ['json'],
        );
        if (file == null || !context.mounted) return;
        final merge = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(context.t('importTitle')),
            content: Text(context.t('importBody')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(context.t('cancel')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(context.t('merge')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(context.t('replace')),
              ),
            ],
          ),
        );
        if (merge == null) return;
        final source = utf8.decode(await file.readAsBytes());
        await ref.read(repositoryProvider).importJson(source, merge: merge);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t(importing ? 'imported' : 'exported')),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.t('error'))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final scheduler = ref.watch(schedulerProvider);
    Future<void> change(String key, Object value) async {
      await s.set(key, value);
      await scheduler.syncAlarms();
    }

    Widget section(String key, List<Widget> children) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              context.t(key),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Card(child: Column(children: children)),
        ],
      ),
    );
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) => ListenableBuilder(
        listenable: scheduler,
        builder: (context, _) => ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
          children: [
            Text(
              context.t('settings'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            section('appearance', [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(context.t('language')),
                trailing: DropdownButton<String>(
                  value: s.arabic ? 'ar' : 'en',
                  underline: const SizedBox.shrink(),
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(context.t('english')),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text(context.t('arabic')),
                    ),
                  ],
                  onChanged: (v) => change('language', v!),
                ),
              ),
              SwitchListTile(
                title: Text(context.t('numbers')),
                subtitle: const Text('123 / ١٢٣'),
                value: s.arabicDigits,
                onChanged: (v) => change('arabicDigits', v),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6_outlined),
                title: Text(context.t('theme')),
                trailing: DropdownButton<String>(
                  value: s.theme.name,
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final t in ['system', 'light', 'dark'])
                      DropdownMenuItem(value: t, child: Text(context.t(t))),
                  ],
                  onChanged: (v) => s.set('theme', v!),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_view_week),
                title: Text(context.t('weekStart')),
                trailing: DropdownButton<int>(
                  value: s.weekStart,
                  underline: const SizedBox.shrink(),
                  items: [
                    for (var d = 1; d <= 7; d++)
                      DropdownMenuItem(
                        value: d,
                        child: Text(
                          dateText(
                            DateOnly(2026, 10, 5).addDays(d - 1),
                            s,
                            pattern: 'EEE',
                          ),
                        ),
                      ),
                  ],
                  onChanged: (v) => s.set('weekStart', v!),
                ),
              ),
            ]),
            section('defaults', [
              ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(context.t('defaultTime')),
                trailing: Text(timeText(s.defaultMinutes, s)),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: s.defaultMinutes ~/ 60,
                      minute: s.defaultMinutes % 60,
                    ),
                  );
                  if (t != null) {
                    await s.set('defaultMinutes', t.hour * 60 + t.minute);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.t('defaultLeads')),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (var i = 0; i < 4; i++)
                          FilterChip(
                            label: Text(
                              context.t(['day0', 'day1', 'week1', 'month1'][i]),
                            ),
                            selected: s.defaultLeads & (1 << i) != 0,
                            onSelected: (_) {
                              final mask = s.defaultLeads ^ (1 << i);
                              if (mask != 0) s.set('defaultLeads', mask);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
            section('permissions', [
              for (final p in [
                (
                  'notifications',
                  scheduler.notificationsAllowed,
                  Icons.notifications_none,
                ),
                ('exactAlarms', scheduler.exactAllowed, Icons.alarm),
                (
                  'battery',
                  scheduler.batteryAllowed,
                  Icons.battery_saver_outlined,
                ),
              ])
                ListTile(
                  leading: Icon(p.$3),
                  title: Text(context.t(p.$1)),
                  subtitle: Text(
                    context.t(
                      p.$2
                          ? 'allowed'
                          : p.$1 == 'battery'
                          ? 'restricted'
                          : 'disabled',
                    ),
                    style: TextStyle(
                      color: p.$2 ? Tokens.monthly : Tokens.warning,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    if (p.$1 == 'exactAlarms') {
                      await scheduler.android?.requestExactAlarmsPermission();
                    } else {
                      await systemChannel.invokeMethod(
                        p.$1 == 'battery'
                            ? 'batterySettings'
                            : 'notificationSettings',
                      );
                    }
                    await scheduler.refreshPermissions();
                    await scheduler.syncAlarms();
                  },
                ),
            ]),
            section('backup', [
              ListTile(
                leading: const Icon(Icons.upload_outlined),
                title: Text(context.t('export')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => transfer(context, ref, false),
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: Text(context.t('import')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => transfer(context, ref, true),
              ),
            ]),
            Text(context.t('about'), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(numText('1.0.0', s), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
