import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_services/refuel/config/refuel_info_list.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_draft_setters.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_list_notifier.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_use_case_api.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_validation.dart';
import 'package:motogen/features/bottom_sheet/widgets/build_form_fields.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class RefuelFormScreen extends ConsumerStatefulWidget {
  final RefuelStateItem? initialItem;
  const RefuelFormScreen({super.key, this.initialItem});

  @override
  ConsumerState<RefuelFormScreen> createState() => _RefuelFormScreenState();
}

class _RefuelFormScreenState extends ConsumerState<RefuelFormScreen> {
  final litersController = TextEditingController();
  final costController = TextEditingController();
  final notesController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialItem != null) {
      Future.microtask(() {
        ref.read(refuelDraftProvider.notifier).state = widget.initialItem!
            .copyWith(
              isDateInteractedOnce: true,
              ispaymentMethodInteractedOnce: true,
            );

        litersController.text = widget.initialItem!.liters!.toString();
        costController.text = widget.initialItem!.cost!.toString();
        notesController.text = widget.initialItem!.notes ?? '';

        ref.setRawLiters(litersController.text);
        ref.setRawCost(costController.text);
        ref.setRawNotes(notesController.text);
      });
    }
  }

  Future<void> _handleSaveOrUpdate({
    required BuildContext context,
    required WidgetRef ref,
    required bool isEdit,
    required RefuelStateItem draft,
    required String carId,
  }) async {
    if (isEdit) {
      await showConfirmBottomSheet(
        context: context,
        titleText: "از ویرایش جدیدت مطمئنی؟",

        onConfirm: () async {
          await ref
              .read(refuelListProvider(carId).notifier)
              .updateRefuelFromDraft(draft, widget.initialItem!, carId);
          ref.invalidate(refuelListProvider(carId));
          ref.invalidate(refuelDraftProvider);
        },
      );
    } else {
      await ref
          .read(refuelListProvider(carId).notifier)
          .addRefuelFromDraft(draft, carId);
      ref.invalidate(refuelListProvider(carId));
      ref.invalidate(refuelDraftProvider);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _handleDelete({
    required BuildContext context,
    required WidgetRef ref,
    required String carId,
    required String refuelId,
  }) async {
    await showConfirmBottomSheet(
      context: context,
      titleText: "برای حذف کردنش مطمئنی؟",
      isDelete: true,
      onConfirm: () async {
        await ref
            .read(refuelListProvider(carId).notifier)
            .deleteSelectedRefuelItemById(carId, refuelId);

        ref.invalidate(refuelListProvider(carId));
        ref.invalidate(refuelDraftProvider);
      },
    );
  }

  @override
  void dispose() {
    litersController.dispose();
    costController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;
    final draft = ref.watch(refuelDraftProvider);
    final carId = ref.read(carStateNotifierProvider).currentCarId;

    debugPrint(
      'debug refuel DRAFT: id=${draft.refuelId}, '
      'date=${draft.date}, '
      'paymentMethod=${draft.paymentMethod}, '
      'liter=${draft.liters}'
      'cost=${draft.cost}'
      'note=${draft.notes}',
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                MyAppBar(
                  titleText: isEdit ? "ویرایش سوخت" : "ثبت سوخت جدید",
                  ontapFunction: () {
                    ref.invalidate(refuelDraftProvider);
                    Navigator.of(context).pop();
                  },
                  isBack: true,
                ),

                Padding(
                  padding: EdgeInsets.only(
                    right: 41.w,
                    left: 41.w,
                    top: isEdit ? 0 : 68.h,
                  ),
                  child: Column(
                    children: [
                      if (isEdit)
                        Padding(
                          padding: EdgeInsets.only(bottom: 26.h),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => _handleDelete(
                                context: context,
                                ref: ref,
                                carId: carId!,
                                refuelId: draft.refuelId!,
                              ),
                              child: SvgPicture.asset(
                                AppIcons.trash,
                                width: 24.w,
                                height: 24.h,
                                colorFilter: ColorFilter.mode(
                                  Color(0xFFC60B0B),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      BuildFormFields<RefuelStateItem>(
                        provider: refuelDraftProvider,
                        fieldsBuilder: (state, ref) => buildRefuelInfoFields(
                          state,
                          ref,
                          litersController,
                          costController,
                          notesController,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70.h,
            right: 43.w,
            child: OnboardingButton(
              enabled: ref.watch(isRefuelInfoButtonEnabled),
              text: "ثبت",
              loading: isLoading,
              onPressed: () async {
                if (isEdit) {
                  try {
                    await _handleSaveOrUpdate(
                      context: context,
                      ref: ref,
                      isEdit: true,
                      draft: draft,
                      carId: carId!,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('خطا در سوخت خرید')),
                      );
                    }
                  }
                } else {
                  setState(() => isLoading = true);
                  try {
                    await _handleSaveOrUpdate(
                      context: context,
                      ref: ref,
                      isEdit: false,
                      draft: draft,
                      carId: carId!,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('خطا در ثبت سوخت جدید')),
                      );
                    }
                  } finally {
                    if (mounted) setState(() => isLoading = false);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
