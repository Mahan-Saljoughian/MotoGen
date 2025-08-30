import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/reminder_screen.dart/model/reminder_state_item.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';

class EnableToggle extends ConsumerStatefulWidget {
  final ReminderStateItem reminderItem;
  final Future<bool> Function() actionsForToggle;

  const EnableToggle({
    super.key,
    required this.reminderItem,
    required this.actionsForToggle,
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
      // Enabling flow with confirmation
      final confirmed = await showConfirmBottomSheet(
        titleText:
            "از فعال کردن یادآور “${ReminderStateItem.translate(widget.reminderItem.type)}” اطمینان داری؟",
        intervalReminderText:
            "بازه یادآوری: هر ${widget.reminderItem.intervalValue} روز یکبار",
        context: context,
        autoPop: false,
        onConfirm: () async {
          if (!widget.reminderItem.haveBaseValue) {
            final picked = await widget.actionsForToggle();
            if (picked) {
              ref
                  .read(reminderNotifierProvider.notifier)
                  .setHaveBaseValueLocally(widget.reminderItem.type, true);
              Navigator.pop(context); // Close confirm

              await _performToggle(newValue);
            } else {
              Navigator.pop(context); // Just close confirm
            }
          } else {
            Navigator.pop(context); // Just close confirm
            await _performToggle(newValue);
          }
        },
      );
      if (confirmed != true) return;
    } else {
      await _performToggle(newValue);
    }
  }

  Future<void> _performToggle(bool newValue) async {
    setState(() => _loading = true);
    try {
      await ref
          .read(reminderNotifierProvider.notifier)
          .toggleReminder(widget.reminderItem.reminderId, newValue);
      setState(() {
        _value = newValue;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("خطا در تغییر وضعیت یادآور")),
      );
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
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation(AppColors.blue500),
                ),
              )
            : _value
            ? SvgPicture.asset(AppIcons.toggleOn, key: const ValueKey(true))
            : SvgPicture.asset(AppIcons.toggleOff, key: const ValueKey(false)),
      ),
    );
  }
}
