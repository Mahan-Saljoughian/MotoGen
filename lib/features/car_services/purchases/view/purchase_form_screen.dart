import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/bottom_sheet/widgets/build_form_fields.dart';
import 'package:motogen/features/car_services/purchases/config/purchase_info_list.dart';
import 'package:motogen/features/car_services/purchases/model/purhcase_state_item.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_draft_setters.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_list_notifier.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_use_case_api.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_validation.dart';

import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class PurchaseFromScreen extends ConsumerStatefulWidget {
  final PurhcaseStateItem? initialItem;
  const PurchaseFromScreen({super.key, this.initialItem});

  @override
  ConsumerState<PurchaseFromScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends ConsumerState<PurchaseFromScreen> {
  final partController = TextEditingController();
  final locationController = TextEditingController();
  final costController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialItem != null) {
      Future.microtask(() {
        ref.read(purchaseDraftProvider.notifier).state = widget.initialItem!
            .copyWith(
              isDateInteractedOnce: true,
              isPurchaseCategoryInteractedOnce: true,
            );

        partController.text = widget.initialItem!.part!;
        locationController.text = widget.initialItem!.location!;
        costController.text = widget.initialItem!.cost!.toString();
        notesController.text = widget.initialItem!.notes ?? '';

        ref.setRawPart(partController.text);
        ref.setRawLocation(locationController.text);
        ref.setRawCost(costController.text);
        ref.setRawNotes(notesController.text);
      });
    }
  }

  @override
  void dispose() {
    partController.dispose();
    locationController.dispose();
    costController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;
    final draft = ref.watch(purchaseDraftProvider);
    final carId = ref.read(carStateNotifierProvider).currentCarId;

    debugPrint(
      'debug purchase DRAFT: id=${draft.purchaseId}, '
      'date=${draft.date}, '
      'part=${draft.part}'
      'purchaseAction=${draft.purchaseCategory}, '
      'location=${draft.location}'
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
                  titleText: isEdit ? "ویرایش خرید" : "ثبت خرید جدید",
                  ontapFunction: () {
                    ref.invalidate(purchaseDraftProvider);
                    Navigator.of(context).pop();
                  },
                  isBack: true,
                ),

                Padding(
                  padding: EdgeInsets.only(
                    right: 41.w,
                    left: 41.w,
                    top: isEdit ? 0.h : 26.h,
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
                                  titleText: "برای حذف کردنش مطمئنی؟",
                                  context: context,
                                  isDelete: true,
                                  onConfirm: () async {
                                    await ref
                                        .read(
                                          purchaseListProvider(carId!).notifier,
                                        )
                                        .deleteSelectedPurchaseItemById(
                                          carId,
                                          draft.purchaseId!,
                                        );

                                    ref
                                        .read(purchaseDraftProvider.notifier)
                                        .state = PurhcaseStateItem(
                                      purchaseId: "purchase_temp_id",
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
                      BuildFormFields<PurhcaseStateItem>(
                        provider: purchaseDraftProvider,
                        fieldsBuilder: (state, ref) => buildPurchasesInfoFields(
                          state,
                          ref,
                          partController,

                          locationController,
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
              enabled: ref.watch(isPurchaseInfoButtonEnabled),
              text: "ثبت",
              onPressed: () async {
                try {
                  if (isEdit) {
                    await showConfirmBottomSheet(
                      titleText: "از ویرایش جدیدت مطمئنی؟",
                      context: context,
                      onConfirm: () async {
                        await ref
                            .read(purchaseListProvider(carId!).notifier)
                            .updatePurchaseFromDraft(
                              draft,
                              widget.initialItem!,
                              carId,
                            );
                        // refreshes the purchase list
                        ref.invalidate(purchaseListProvider(carId));
                        // Reset draft
                        ref.read(purchaseDraftProvider.notifier).state =
                            PurhcaseStateItem(purchaseId: "purchase_temp_id");
                      },
                    );
                  } else {
                    await ref
                        .read(purchaseListProvider(carId!).notifier)
                        .addPurchaseFromDraft(draft, carId);
                    // refreshes the purchase list
                    ref.invalidate(purchaseListProvider(carId));
                    // Reset draft
                    ref.read(purchaseDraftProvider.notifier).state =
                        PurhcaseStateItem(purchaseId: "purchase_temp_id");
                  }

                  if (!isEdit) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                } catch (e) {
                  // handle error (snackbar, dialog, etc.)
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: isEdit
                            ? Text('خطا در ویرایش خرید ')
                            : Text('خطا در ثبت خرید جدید'),
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
