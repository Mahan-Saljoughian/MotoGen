import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/reminder_screen.dart/model/reminder_state_item.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';
import 'package:motogen/widgets/snack_bar.dart';

class EnableToggle extends ConsumerStatefulWidget {
  final ReminderStateItem reminderItem;
  final Future<dynamic> Function() reminderAction;

  const EnableToggle({
    super.key,
    required this.reminderItem,
    required this.reminderAction,
  });

  @override
  EnableToggleState createState() => EnableToggleState();
}

class EnableToggleState extends ConsumerState<EnableToggle>
    with SingleTickerProviderStateMixin {
  late bool _value;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _value = widget.reminderItem.enabled;
  }

  void _toggle() async {
    final newValue = !_value;

    if (newValue) {
      // Enabling
      dynamic picked;
      bool useNew = true;
      if (widget.reminderItem.haveBaseValue) {
        final confirmedSecond = await showConfirmBottomSheet(
          titleText: "تاریخ یادآور قبلی رو میخوای یا جدید تنظیم میکنی؟",
          intervalReminderText:
              "در صورت تنظیم تاریخ جدید، تاریخ قبلی حذف میشه.",
          context: context,
          isConfirmDate: true,
          autoPop: false,
        );

        if (confirmedSecond == null) return;

        useNew =
            !confirmedSecond; // true if "قبلی" (keep previous), false for new -> useNew = true if !confirmedSecond
      }

      if (useNew) {
        picked = await widget.reminderAction();
        if (picked == null) return;

        final intervalUnit =
            widget.reminderItem.intervalType.name.toLowerCase() ==
                IntervalType.DAYS.name.toLowerCase()
            ? "روز"
            : "کیلومتر";
        final confirmed = await showConfirmBottomSheet(
          titleText:
              "از فعال کردن یادآور “${ReminderStateItem.translate(widget.reminderItem.type)}” اطمینان داری؟",
          intervalReminderText:
              "بازه یادآوری: هر ${widget.reminderItem.intervalValue} $intervalUnit یکبار",
          context: context.mounted ? context : context,
          autoPop: false,
        );
        if (confirmed != true) return;
      }

      setState(() => _loading = true);
      try {
        if (useNew) {
          await ref
              .read(reminderNotifierProvider.notifier)
              .updateFromPicked(
                widget.reminderItem.reminderId,
                widget.reminderItem.type,
                picked,
                true,
              );
          if (!widget.reminderItem.haveBaseValue) {
            ref
                .read(reminderNotifierProvider.notifier)
                .setHaveBaseValueLocally(widget.reminderItem.type, true);
          }
        } else {
          await ref
              .read(reminderNotifierProvider.notifier)
              .toggleReminder(widget.reminderItem.reminderId, true);
        }

        setState(() {
          _value = true;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              message: "خطا در تغییر وضعیت یادآور",
              type: SnackBarType.error,
            ),
          );
        }
      } finally {
        setState(() => _loading = false);
      }
    } else {
      // Disabling
      await _performToggle(false);
    }
  }

  Future<void> _performToggle(bool newValue) async {
    setState(() => _loading = true);
    try {
      await ref
          .read(reminderNotifierProvider.notifier)
          .toggleReminder(widget.reminderItem.reminderId, false);
      setState(() {
        _value = newValue;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildCustomSnackBar(
            message: "خطا در تغییر وضعیت یادآور",
            type: SnackBarType.error,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _toggle,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: _loading
            ? SizedBox(
                key: const ValueKey('loading'),
                width: 24.w,
                height: 24.w,
                child: const CupertinoActivityIndicator(
                  radius: 10, // small size for icon areas
                  color: AppColors.blue500,
                ),
              )
            : _value
            ? SvgPicture.asset(AppIcons.toggleOn, key: const ValueKey(true))
            : SvgPicture.asset(AppIcons.toggleOff, key: const ValueKey(false)),
      ),
    );
  }
}
