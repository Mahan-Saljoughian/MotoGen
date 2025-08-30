import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart'; // For DateUsageType
import 'package:motogen/features/car_services/oil/data/oil_repository.dart';
import 'package:motogen/features/car_services/oil/view/oil_form_screen.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/date_picker.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/kilometer_bottomsheet.dart';
// Import your PagesTitleEnum here (e.g., from onboarding)

extension ReminderOntap on ReminderNotifier {
  Map<String, Future<void> Function()> buildReminderActionsForTap(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> reminderIdByType,
  ) {
    return {
      "ENGINE_OIL_CHECK": () async {
        final date = await handleReminderTap(context, "ENGINE_OIL_CHECK");
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["ENGINE_OIL_CHECK"]!,
                lastDate: date,
              );
        }
      },
      "RADIATOR_WATER_CHECK": () async {
        final date = await handleReminderTap(context, "RADIATOR_WATER_CHECK");
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["RADIATOR_WATER_CHECK"]!,
                lastDate: date,
              );
        }
      },

      "TIRE_PRESSURE_ADJUSTMENT": () async {
        final date = await handleReminderTap(
          context,
          "TIRE_PRESSURE_ADJUSTMENT",
        );
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["TIRE_PRESSURE_ADJUSTMENT"]!,
                lastDate: date,
              );
        }
      },
      "SPARE_TIRE_PRESSURE_ADJUSTMENT": () async {
        final date = await handleReminderTap(
          context,
          "SPARE_TIRE_PRESSURE_ADJUSTMENT",
        );
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["SPARE_TIRE_PRESSURE_ADJUSTMENT"]!,
                lastDate: date,
              );
        }
      },
      "TURN_ON_AC": () async {
        final date = await handleReminderTap(context, "TURN_ON_AC");
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(reminderIdByType["TURN_ON_AC"]!, lastDate: date);
        }
      },

      "BODY_INSURANCE_VALIDITY": () async {
        final date = await handleReminderTap(
          context,
          "BODY_INSURANCE_VALIDITY",
        );
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["BODY_INSURANCE_VALIDITY"]!,
                lastDate: date,
              );
        }
      },
      "THIRD_PARTY_INSURANCE_VALIDITY": () async {
        final date = await handleReminderTap(
          context,
          "THIRD_PARTY_INSURANCE_VALIDITY",
        );
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["THIRD_PARTY_INSURANCE_VALIDITY"]!,
                lastDate: date,
              );
        }
      },
      "VEHICLE_INSPECTION_VALIDITY": () async {
        final date = await handleReminderTap(
          context,
          "VEHICLE_INSPECTION_VALIDITY",
        );
        if (date != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["VEHICLE_INSPECTION_VALIDITY"]!,
                lastDate: date,
              );
        }
      },

      // Navigate to another screen (unchanged)
      "BRAKE_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.brake;
        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        debugPrint("debug see this ${result.toString()}");
        if (result is Map &&
            result["created"] == true &&
            result["oilType"] == "BRAKE") {
          await ref
              .read(reminderNotifierProvider.notifier)
              .toggleReminder(reminderIdByType["BRAKE_OIL_CHANGE"]!, true);

          final date = result["date"] as DateTime?;
          if (date != null) {
            await ref
                .read(reminderNotifierProvider.notifier)
                .updateReminder(
                  reminderIdByType["BRAKE_OIL_CHANGE"]!,
                  lastDate: date,
                );
          }
        }
      },
      "ENGINE_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.engine;

        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        debugPrint("debug see this ${result.toString()}");
        if (result is Map &&
            result["created"] == true &&
            result["oilType"] == "ENGINE") {
          debugPrint("debug see this ${result.toString()}");
          await ref
              .read(reminderNotifierProvider.notifier)
              .toggleReminder(reminderIdByType["ENGINE_OIL_CHANGE"]!, true);

          final km = result["km"] as int?;
          if (km != null) {
            await ref
                .read(reminderNotifierProvider.notifier)
                .updateReminder(
                  reminderIdByType["ENGINE_OIL_CHANGE"]!,
                  lastKilometer: km,
                );
          }
        }
      },
      "STEERING_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.steering;
        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        debugPrint("debug see this ${result.toString()}");
        if (result is Map &&
            result["created"] == true &&
            result["oilType"] == "STEERING") {
          await ref
              .read(reminderNotifierProvider.notifier)
              .toggleReminder(reminderIdByType["STEERING_OIL_CHANGE"]!, true);

          final km = result["km"] as int?;
          if (km != null) {
            await ref
                .read(reminderNotifierProvider.notifier)
                .updateReminder(
                  reminderIdByType["STEERING_OIL_CHANGE"]!,
                  lastKilometer: km,
                );
          }
        }
      },
      "GEARBOX_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.gearbox;

        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        debugPrint("debug see this ${result.toString()}");
        if (result is Map &&
            result["created"] == true &&
            result["oilType"] == "GEARBOX") {
          await ref
              .read(reminderNotifierProvider.notifier)
              .toggleReminder(reminderIdByType["GEARBOX_OIL_CHANGE"]!, true);

          final km = result["km"] as int?;
          if (km != null) {
            await ref
                .read(reminderNotifierProvider.notifier)
                .updateReminder(
                  reminderIdByType["GEARBOX_OIL_CHANGE"]!,
                  lastKilometer: km,
                );
          }
        }
      },

      "TIMING_BELT_CHANGE": () async {
        final kilometer = await _openTimingBeltKM(context);
        if (kilometer != null) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateReminder(
                reminderIdByType["TIMING_BELT_CHANGE"]!,
                lastKilometer: kilometer,
              );
        }
      },
    };
  }

  Future<DateTime?> handleReminderTap(BuildContext context, String type) async {
    String labelText;
    DateUsageType usageType;
    PagesTitleEnum pagesTitleEnum;

    switch (type) {
      case "ENGINE_OIL_CHECK":
        labelText = "یادآور بررسی روغن موتور";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetServices;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "RADIATOR_WATER_CHECK":
        labelText = "یادآور بررسی آب رادیاتور";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetServices;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "TIRE_PRESSURE_ADJUSTMENT":
        labelText = "یادآور تنظیم باد لاستیک";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetServices;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "SPARE_TIRE_PRESSURE_ADJUSTMENT":
        labelText = "یادآور تنظیم باد لاستیک زاپاس";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetServices;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "TURN_ON_AC":
        labelText = "یادآور روشن کردن کولر (فقط زمستان)";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetServices;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "BODY_INSURANCE_VALIDITY":
        labelText = "تاریخ انقضای بیمه بدنه";
        usageType = DateUsageType.insurance;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetInsurance;

        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "THIRD_PARTY_INSURANCE_VALIDITY":
        labelText = "تاریخ انقضای بیمه شخص ثالث";
        usageType = DateUsageType.insurance;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetInsurance;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "VEHICLE_INSPECTION_VALIDITY":
        labelText = "تاریخ معاینه فنی";
        usageType = DateUsageType.insurance;
        pagesTitleEnum = PagesTitleEnum.dateBottomSheetInsurance;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      default:
        logger.i("No action defined for $type");
        return null;
    }
  }

  Future<DateTime?> _openDatePicker(
    BuildContext context, {
    required String labelText,
    required DateUsageType usageType,
    required PagesTitleEnum pagesTitleEnum,
  }) async {
    return await showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      builder: (_) => BottomsheetDatePicker(
        labelText: labelText,
        usageType: usageType,
        pagesTitleEnum: pagesTitleEnum,
      ),
    );
  }

  Future<int?> _openTimingBeltKM(BuildContext context) async {
    return await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      builder: (_) => const BottomsheetTimingBeltKM(),
    );
  }
}
