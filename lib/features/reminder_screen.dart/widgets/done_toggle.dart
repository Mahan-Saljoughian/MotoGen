import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/reminder_screen.dart/model/reminder_state_item.dart';

class DoneToggle extends StatefulWidget {
  final bool enabled;
  final bool isAdd;
  final String intervalType;
  final Future<void> Function() actionsForTap;

  const DoneToggle({
    super.key,
    required this.enabled,
    required this.actionsForTap,
    required this.intervalType,
    this.isAdd = false,
  });

  @override
  State<DoneToggle> createState() => _DoneToggleState();
}

class _DoneToggleState extends State<DoneToggle> {
  bool _isLoading = false;

  Future<void> _done(BuildContext context) async {
    final confirmedFirst = await showConfirmBottomSheet(
      titleText: "بررسی یا تنظیم مورد نظرت رو انجام دادی؟",
      intervalReminderText:
          "در صورت تایید یادآور برای بازه یادآوری بعدی تنظیم می‌شه.",
      context: context,
      autoPop: false,
      onConfirm: () async {
        final confirmedSecond = await showConfirmBottomSheet(
          titleText: widget.intervalType == IntervalType.KILOMETERS.name
              ? "کیلومتر یادآور قبلی رو میخوای یا جدید تنظیم میکنی؟"
              : "تاریخ یادآور قبلی رو میخوای یا جدید تنظیم میکنی؟",
          intervalReminderText:
              widget.intervalType == IntervalType.KILOMETERS.name
              ? "در صورت تنظیم کیلومتر جدید، تاریخ قبلی حذف میشه."
              : "در صورت تنظیم تاریخ جدید، تاریخ قبلی حذف میشه.",
          context: context,
          isConfirmDate: widget.intervalType != IntervalType.KILOMETERS.name,
          isConfirmKilometer:
              widget.intervalType == IntervalType.KILOMETERS.name,
          onConfirm: () async {},
        );

        // Run `actionsForTap` only when conditions match your logic
        if (confirmedSecond == true || confirmedSecond == false) {
          setState(() => _isLoading = true);
          try {
            await widget.actionsForTap();
            if (context.mounted) {
              Navigator.of(context).pop(); // Closes the confirm bottomsheet
            }
          } finally {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          }
        }
      },
    );

    if (confirmedFirst != true) return;
  }

  @override
  Widget build(BuildContext context) {
    final String iconPath = widget.isAdd
        ? AppIcons.addCircleReminder
        : AppIcons.tickCircleReminder;

    final ColorFilter? colorFilter = !widget.enabled
        ? const ColorFilter.mode(AppColors.black100, BlendMode.srcIn)
        : null;

    return GestureDetector(
      onTap: widget.enabled && !_isLoading ? () => _done(context) : null,
      child: _isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : SvgPicture.asset(iconPath, colorFilter: colorFilter),
    );
  }
}
