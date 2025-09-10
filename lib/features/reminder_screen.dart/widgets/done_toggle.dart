import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/reminder_screen.dart/model/reminder_state_item.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';

class DoneToggle extends ConsumerStatefulWidget {
  final ReminderStateItem reminderItem;
  final bool isAdd;
  final Future<dynamic> Function() reminderAction;

  const DoneToggle({
    super.key,
    required this.reminderItem,
    required this.reminderAction,
    this.isAdd = false,
  });

  @override
  ConsumerState<DoneToggle> createState() => _DoneToggleState();
}

class _DoneToggleState extends ConsumerState<DoneToggle> {
  bool _isLoading = false;

  Future<void> _done(BuildContext context) async {
    final confirmedFirst = await showConfirmBottomSheet(
      titleText: "بررسی یا تنظیم مورد نظرت رو انجام دادی؟",
      intervalReminderText:
          "در صورت تایید یادآور برای بازه یادآوری بعدی تنظیم می‌شه.",
      context: context,
      autoPop: false,
    );

    if (confirmedFirst != true) return;

    final picked = await widget.reminderAction();
    if (picked == null) return;

    /*    final intervalUnit =
        widget.reminderItem.intervalType.name.toLowerCase() ==
            IntervalType.DAYS.name.toLowerCase()
        ? "روز"
        : "کیلومتر"; */
    final confirmed = await showConfirmBottomSheet(
      titleText: "از ثبت انجام یادآور اطمینان داری؟",
      intervalReminderText:
          "با مقدار جدید، یادآور برای بازه یادآوری بعدی تنظیم می‌شه.", // New text for the done concept
      context: context.mounted ? context : context,
      autoPop: false,
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(reminderNotifierProvider.notifier)
          .updateFromPicked(
            widget.reminderItem.reminderId,
            widget.reminderItem.type,
            picked,
            false,
          );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String iconPath = widget.isAdd
        ? AppIcons.addCircleReminder
        : AppIcons.tickCircleReminder;

    final ColorFilter? colorFilter = !widget.reminderItem.enabled
        ? const ColorFilter.mode(AppColors.black100, BlendMode.srcIn)
        : null;

    return GestureDetector(
      onTap: widget.reminderItem.enabled && !_isLoading
          ? () => _done(context)
          : null,
      child: _isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: const CupertinoActivityIndicator(
                radius: 10, // small size for icon areas
                color: AppColors.blue500,
              ),
            )
          : SvgPicture.asset(iconPath, colorFilter: colorFilter),
    );
  }
}
