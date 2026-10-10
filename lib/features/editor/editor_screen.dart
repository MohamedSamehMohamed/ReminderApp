import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/tokens.dart';
import '../../core/models.dart';
import '../common.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String? id;
  const EditorScreen({super.key, this.id});
  @override
  ConsumerState<EditorScreen> createState() => _EditorState();
}

class _EditorState extends ConsumerState<EditorScreen> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController(),
      note = TextEditingController(),
      year = TextEditingController();
  ReminderType type = ReminderType.birthday;
  RepeatMode mode = RepeatMode.yearly;
  late DateOnly anchor;
  late int minutes, leads;
  int weekdays = 1, day = 1;
  bool busy = false, submitted = false;
  Reminder? original;
  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsProvider);
    anchor = DateOnly.from(ref.read(repositoryProvider).clock.now());
    day = anchor.day;
    minutes = s.defaultMinutes;
    leads = s.defaultLeads;
    weekdays = 1 << (anchor.weekday - 1);
    if (widget.id != null) {
      for (final r in ref.read(remindersProvider).value ?? <Reminder>[]) {
        if (r.id == widget.id) original = r;
      }
      final r = original;
      if (r != null) {
        title.text = r.title;
        note.text = r.note;
        year.text = r.knownYear?.toString() ?? '';
        type = r.type;
        mode = r.repeat;
        anchor = r.anchor;
        minutes = r.alertMinutes;
        leads = r.leads;
        weekdays = r.weekdays;
        day = r.dayOfMonth;
      }
    }
  }

  @override
  void dispose() {
    title.dispose();
    note.dispose();
    year.dispose();
    super.dispose();
  }

  Reminder get draft => Reminder(
    id: original?.id ?? '',
    title: title.text.trim(),
    anchor: anchor,
    type: type,
    repeat: mode,
    weekdays: weekdays,
    dayOfMonth: day,
    alertMinutes: minutes,
    leads: leads,
    knownYear: int.tryParse(year.text),
    note: note.text.trim(),
    active: original?.active ?? true,
    createdAt: original?.createdAt ?? '',
  );
  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: anchor.date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (date != null) {
      setState(() {
        anchor = DateOnly.from(date);
        day = anchor.day;
      });
    }
  }

  Future<void> save() async {
    setState(() => submitted = true);
    if (!form.currentState!.validate() ||
        leads == 0 ||
        mode == RepeatMode.weekly && weekdays == 0) {
      return;
    }
    setState(() => busy = true);
    try {
      final r = draft;
      await ref
          .read(repositoryProvider)
          .save(
            Reminder(
              id: original?.id ?? newId(),
              title: r.title,
              anchor: r.anchor,
              type: r.type,
              repeat: r.repeat,
              weekdays: r.weekdays,
              dayOfMonth: r.dayOfMonth,
              alertMinutes: r.alertMinutes,
              leads: r.leads,
              knownYear:
                  (type == ReminderType.birthday ||
                      type == ReminderType.anniversary)
                  ? r.knownYear
                  : null,
              note: r.note,
              active: r.active,
              createdAt: r.createdAt,
            ),
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.t('error'))));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t(widget.id == null ? 'newReminder' : 'editReminder'),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Form(
        key: form,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.t('title'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: const Key('title'),
                controller: title,
                maxLength: 80,
                decoration: const InputDecoration(counterText: ''),
                validator: (v) => v == null || v.trim().isEmpty
                    ? context.t('invalidTitle')
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                context.t('type'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (final t in ReminderType.values)
                    ChoiceChip(
                      label: Text(context.t(t.name)),
                      selected: type == t,
                      onSelected: (_) => setState(() => type = t),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                context.t('repeats'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(Tokens.control),
                ),
                child: Row(
                  children: [
                    for (final m in RepeatMode.values)
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => mode = m),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: mode == m
                                  ? Theme.of(context).colorScheme.surface
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              context.t(m.name),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: mode == m
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(summary(draft, context.l, s)),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: Text(
                        context.t(
                          mode == RepeatMode.daily || mode == RepeatMode.weekly
                              ? 'starts'
                              : 'date',
                        ),
                      ),
                      trailing: Text(
                        dateText(
                          anchor,
                          s,
                          pattern: mode == RepeatMode.yearly
                              ? 'd MMM'
                              : 'd MMM y',
                        ),
                      ),
                      onTap: pickDate,
                    ),
                    if (mode == RepeatMode.monthly)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<int>(
                          initialValue: day,
                          decoration: InputDecoration(
                            labelText: context.t('dayMonth'),
                          ),
                          items: [
                            for (var n = 1; n <= 31; n++)
                              DropdownMenuItem(
                                value: n,
                                child: Text(numText(n, s)),
                              ),
                          ],
                          onChanged: (v) => setState(() => day = v!),
                        ),
                      ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(context.t('time')),
                      trailing: Text(timeText(minutes, s)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: minutes ~/ 60,
                            minute: minutes % 60,
                          ),
                        );
                        if (time != null) {
                          setState(
                            () => minutes = time.hour * 60 + time.minute,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (mode == RepeatMode.weekly) ...[
                const SizedBox(height: 12),
                Text(context.t('weekdays')),
                Wrap(
                  spacing: 6,
                  children: [
                    for (var i = 0; i < 7; i++)
                      FilterChip(
                        label: Text(
                          dateText(
                            DateOnly(2026, 10, 5).addDays(i),
                            s,
                            pattern: 'EEE',
                          ),
                        ),
                        selected: weekdays & (1 << i) != 0,
                        onSelected: (_) => setState(() => weekdays ^= 1 << i),
                      ),
                  ],
                ),
                if (submitted && weekdays == 0)
                  Text(
                    context.t('invalidDays'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
              if (type == ReminderType.birthday ||
                  type == ReminderType.anniversary) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: year,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: context.t(
                      type == ReminderType.birthday
                          ? 'birthYear'
                          : 'originalYear',
                    ),
                    helperText: context.t('optionalYear'),
                    counterText: '',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    final y = int.tryParse(v);
                    return y == null ||
                            y < 1 ||
                            y > ref.read(repositoryProvider).clock.now().year
                        ? context.t('invalidYear')
                        : null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              Text(
                context.t('remindMe'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (var i = 0; i < 4; i++)
                    FilterChip(
                      label: Text(
                        context.t(['day0', 'day1', 'week1', 'month1'][i]),
                      ),
                      selected: leads & (1 << i) != 0,
                      onSelected: (_) => setState(() => leads ^= 1 << i),
                    ),
                ],
              ),
              if (submitted && leads == 0)
                Text(
                  context.t('invalidLeads'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: note,
                maxLength: 500,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.t('note'),
                  hintText: context.t('noteHint'),
                ),
                validator: (v) =>
                    (v?.length ?? 0) > 500 ? context.t('invalidNote') : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 20),
          child: FilledButton(
            onPressed: busy ? null : save,
            child: busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(context.t('saveReminder')),
          ),
        ),
      ),
    );
  }
}
