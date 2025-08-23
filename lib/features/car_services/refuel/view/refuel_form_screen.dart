import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_colors.dart';
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
            child: Padding(
              padding: EdgeInsets.only(top: 20.h, right: 20.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref.invalidate(refuelDraftProvider);
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(
                          AppIcons.arrowRight,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      SizedBox(width: 100.w),
                      Text(
                        "ثبت سوخت جدید",
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      right: 24.w,
                      left: 38.w,
                      top: isEdit ? 20.h : 88.h,
                    ),
                    child: Column(
                      children: [
                        if (isEdit)
                          Padding(
                            padding: EdgeInsets.only(bottom: 26.h),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () async {
                                  await showConfirmBottomSheet(
                                    context: context,
                                    isDelete: true,
                                    onConfirm: () async {
                                      await ref
                                          .read(
                                            refuelListProvider(carId!).notifier,
                                          )
                                          .deleteSelectedRefuelItemById(
                                            carId,
                                            draft.refuelId!,
                                          );

                                      ref
                                          .read(refuelDraftProvider.notifier)
                                          .state = RefuelStateItem(
                                        refuelId: "refuel_temp_id",
                                      );
                                    },
                                  );
                                },
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
          ),
          Positioned(
            bottom: 70.h,
            right: 43.w,
            child: OnboardingButton(
              enabled: ref.watch(isRefuelInfoButtonEnabled),
              text: "ثبت",
              onPressed: () async {
                try {
                  if (isEdit) {
                    await showConfirmBottomSheet(
                      context: context,
                      onConfirm: () async {
                        await ref
                            .read(refuelListProvider(carId!).notifier)
                            .updateRefuelFromDraft(
                              draft,
                              widget.initialItem!,
                              carId,
                            );
                        // refreshes the refuel list
                        ref.invalidate(refuelListProvider(carId));
                        // Reset draft
                        ref.read(refuelDraftProvider.notifier).state =
                            RefuelStateItem(refuelId: "refuel_temp_id");
                      },
                    );
                  } else {
                    await ref
                        .read(refuelListProvider(carId!).notifier)
                        .addRefuelFromDraft(draft, carId);
                    // refreshes the refuel list
                    ref.invalidate(refuelListProvider(carId));
                    // Reset draft
                    ref.read(refuelDraftProvider.notifier).state =
                        RefuelStateItem(refuelId: "refuel_temp_id");
                  }

                  if (!isEdit) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                } catch (e, st) {
                  // handle error (snackbar, dialog, etc.)
                  if (context.mounted) {
                    Logger().e("debug the errros is $e , $st");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: isEdit
                            ? Text('خطا در ویرایش سوخت ')
                            : Text('خطا در ثبت سوخت جدید'),
                      ),
                    );
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
