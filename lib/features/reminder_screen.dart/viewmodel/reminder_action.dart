import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart'; // For DateUsageType
import 'package:motogen/features/car_services/oil/data/oil_repository.dart';
import 'package:motogen/features/car_services/oil/view/oil_form_screen.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/date_picker.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/kilometer_bottomsheet.dart';

extension ReminderToggle on ReminderNotifier {
  Map<String, Future<dynamic> Function()> buildReminderAction(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> reminderIdByType,
  ) {
    return {
      "ENGINE_OIL_CHECK": () async {
        final date = await handleReminderToggle(context, "ENGINE_OIL_CHECK");
        return date;
      },
      "RADIATOR_WATER_CHECK": () async {
        final date = await handleReminderToggle(
          context,
          "RADIATOR_WATER_CHECK",
        );
        return date;
      },
      "TIRE_PRESSURE_ADJUSTMENT": () async {
        final date = await handleReminderToggle(
          context,
          "TIRE_PRESSURE_ADJUSTMENT",
        );
        return date;
      },
      "SPARE_TIRE_PRESSURE_ADJUSTMENT": () async {
        final date = await handleReminderToggle(
          context,
          "SPARE_TIRE_PRESSURE_ADJUSTMENT",
        );
        return date;
      },
      "TURN_ON_AC": () async {
        final date = await handleReminderToggle(context, "TURN_ON_AC");
        return date;
      },
      "BODY_INSURANCE_VALIDITY": () async {
        final date = await handleReminderToggle(
          context,
          "BODY_INSURANCE_VALIDITY",
        );
        return date;
      },
      "THIRD_PARTY_INSURANCE_VALIDITY": () async {
        final date = await handleReminderToggle(
          context,
          "THIRD_PARTY_INSURANCE_VALIDITY",
        );
        return date;
      },
      "VEHICLE_INSPECTION_VALIDITY": () async {
        final date = await handleReminderToggle(
          context,
          "VEHICLE_INSPECTION_VALIDITY",
        );
        return date;
      },
      "BRAKE_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.brake;
        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        return result;
      },
      "ENGINE_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.engine;
        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        return result;
      },
      "STEERING_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.steering;
        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        return result;
      },
      "GEARBOX_OIL_CHANGE": () async {
        ref.read(oilTypeTabProvider.notifier).state = OilTypeTab.gearbox;
        final result = await Navigator.push(
          context,
          FadeRoute(page: OilFormScreen(fromReminderToggle: true)),
        );
        return result;
      },
      "TIMING_BELT_CHANGE": () async {
        final kilometer = await _openTimingBeltKM(context);
        return kilometer;
      },
    };
  }

  Future<DateTime?> handleReminderToggle(
    BuildContext context,
    String type,
  ) async {
    String labelText;
    DateUsageType usageType;
    PagesTitleEnum pagesTitleEnum;

    switch (type) {
      case "ENGINE_OIL_CHECK":
        labelText = "یادآور بررسی روغن موتور";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.firstTimeEnablingReminder;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "RADIATOR_WATER_CHECK":
        labelText = "یادآور بررسی آب رادیاتور";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.firstTimeEnablingReminder;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "TIRE_PRESSURE_ADJUSTMENT":
        labelText = "یادآور تنظیم باد لاستیک";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.firstTimeEnablingReminder;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "SPARE_TIRE_PRESSURE_ADJUSTMENT":
        labelText = "یادآور تنظیم باد لاستیک زاپاس";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.firstTimeEnablingReminder;
        return await _openDatePicker(
          context,
          labelText: labelText,
          usageType: usageType,
          pagesTitleEnum: pagesTitleEnum,
        );
      case "TURN_ON_AC":
        labelText = "یادآور روشن کردن کولر (فقط زمستان)";
        usageType = DateUsageType.services;
        pagesTitleEnum = PagesTitleEnum.firstTimeEnablingReminder;
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
        appLogger.i("No action defined for $type");
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
