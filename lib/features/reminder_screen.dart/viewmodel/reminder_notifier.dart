import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/reminder_screen.dart/data/reminder_repository.dart';
import 'package:motogen/features/reminder_screen.dart/model/reminder_state_item.dart';

var logger = Logger();

final reminderNotifierProvider =
    AsyncNotifierProvider<ReminderNotifier, List<ReminderStateItem>>(
      ReminderNotifier.new,
    );

class ReminderNotifier extends AsyncNotifier<List<ReminderStateItem>> {
  final reminderRepository = ReminderRepository();
  @override
  Future<List<ReminderStateItem>> build() async {
    // Initial load happens automatically here
    final currentCarId = ref.watch(carStateNotifierProvider).getCurrentCarId();
    final reminderListJson = await reminderRepository.getAllReminders(
      currentCarId!,
    );

    return reminderListJson
        .map((json) => ReminderStateItem.fromAPIJson(json))
        .toList();
  }

  // Toggle enable/disable
  Future<void> toggleReminder(String reminderId, bool enabled) async {
    final currentState = state.value;
    if (currentState == null) return;
    try {
      final currentCarId = ref
          .watch(carStateNotifierProvider)
          .getCurrentCarId();

      await reminderRepository.patchReminderById(
        {'enabled': enabled},
        currentCarId!,
        reminderId,
      );

      state = AsyncData([
        for (final r in currentState)
          if (r.reminderId == reminderId) r.copyWith(enabled: enabled) else r,
      ]);
    } catch (e, st) {
      logger.e("toggleReminder failed for reminderId $reminderId,$e,$st");
    }
  }

  Future<void> updateReminder(
    String reminderId, {
    int? lastKilometer,
    DateTime? lastDate,
  }) async {
    final currentState = state.value;
    if (currentState == null) return;
    try {
      final currentCarId = ref
          .watch(carStateNotifierProvider)
          .getCurrentCarId();
      await reminderRepository.patchReminderById(
        {
          if (lastKilometer != null) 'lastKilometer': lastKilometer,
          if (lastDate != null) 'lastDate': lastDate.toIso8601String(),
        },
        currentCarId!,
        reminderId,
      );
      state = AsyncData([
        for (final r in currentState)
          if (r.reminderId == reminderId)
            r.copyWith(
              lastKilometer: lastKilometer ?? r.lastKilometer,
              lastDate: lastDate ?? r.lastDate,
            )
          else
            r,
      ]);

      // then get fresh remainingValue from API
      await refreshRemainingValueForReminder(reminderId);
    } catch (e, st) {
      logger.e(
        "debug error occured in updateReminder for reminderId $reminderId , $e,$st",
      );
    }
  }

  void setHaveBaseValueLocally(String type, bool value) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData([
      for (final r in currentState)
        if (r.type == type) r.copyWith(hasBaseValue: value) else r,
    ]);
  }

  Future<void> refreshRemainingValueForReminder(String reminderId) async {
    final currentCarId = ref.watch(carStateNotifierProvider).getCurrentCarId();

    try {
      // 1. Get fresh list from API
      final remindersJson = await reminderRepository.getAllReminders(
        currentCarId!,
      );

      // 2. Find the matching reminder in API response
      final freshReminder = remindersJson.firstWhere(
        (json) => json['id'] == reminderId,
        orElse: () => throw Exception("Reminder with id $reminderId not found"),
      );

      // 3. Extract remainingValue from fresh data
      final int? newRemainingValue = freshReminder['remainingValue'] as int?;

      // 4. Update just that reminder in local state
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncData([
          for (final r in currentState)
            if (r.reminderId == reminderId)
              r.copyWith(remainingValue: newRemainingValue)
            else
              r,
        ]);
      }
    } catch (e, st) {
      logger.e("Failed to refresh remainingValue for $reminderId, $e, $st");
    }
  }
}
