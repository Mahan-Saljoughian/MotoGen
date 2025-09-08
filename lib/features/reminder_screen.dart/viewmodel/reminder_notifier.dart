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
  Future<void> toggleReminder(String reminderId, bool isEnable) async {
    final currentState = state.value;
    if (currentState == null) return;
    try {
      final currentCarId = ref
          .watch(carStateNotifierProvider)
          .getCurrentCarId();

      await reminderRepository.patchReminderById(
        {'enabled': isEnable},
        currentCarId!,
        reminderId,
      );

      state = AsyncData([
        for (final r in currentState)
          if (r.reminderId == reminderId) r.copyWith(enabled: isEnable) else r,
      ]);
    } catch (e, st) {
      logger.e(
        "toggleReminderForDisable failed for reminderId $reminderId,$e,$st",
      );
    }
  }

  Future<void> updateFromPicked(
    String reminderId,
    String type,
    dynamic picked,
    bool? isEnable,
  ) async {
    if (picked == null) return;

    if (picked is DateTime) {
      await updateReminder(reminderId, lastDate: picked, isEnable: isEnable);
    } else if (picked is int) {
      await updateReminder(
        reminderId,
        lastKilometer: picked,
        isEnable: isEnable,
      );
    } else if (picked is Map) {
      if (picked["created"] != true) return;
      final oilType = picked["oilType"] as String?;
      if (oilType == "BRAKE") {
        final date = picked["date"] as DateTime?;
        if (date != null) {
          await updateReminder(reminderId, lastDate: date, isEnable: isEnable);
        }
      } else if (oilType == "ENGINE" ||
          oilType == "STEERING" ||
          oilType == "GEARBOX") {
        final km = picked["km"] as int?;
        if (km != null) {
          await updateReminder(
            reminderId,
            lastKilometer: km,
            isEnable: isEnable,
          );
        }
      }
    }
  }

  Future<void> updateReminder(
    String reminderId, {
    int? lastKilometer,
    DateTime? lastDate,
    bool? isEnable,
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
          if (isEnable == true) 'enabled': true,
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
              enabled: isEnable! ? isEnable : r.enabled,
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
