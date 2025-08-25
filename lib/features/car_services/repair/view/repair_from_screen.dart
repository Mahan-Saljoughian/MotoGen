import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/bottom_sheet/widgets/build_form_fields.dart';
import 'package:motogen/features/car_services/repair/config/repair_info_list.dart';
import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_draft_setters.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_list_notifier.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_use_case_api.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_validation.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class RepairFromScreen extends ConsumerStatefulWidget {
  final RepairStateItem? initialItem;
  const RepairFromScreen({super.key, this.initialItem});

  @override
  ConsumerState<RepairFromScreen> createState() => _RepairFormScreenState();
}

class _RepairFormScreenState extends ConsumerState<RepairFromScreen> {
  final partController = TextEditingController();
  final kilometerController = TextEditingController();
  final locationController = TextEditingController();
  final costController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialItem != null) {
      Future.microtask(() {
        ref.read(repairDraftProvider.notifier).state = widget.initialItem!
            .copyWith(
              isDateInteractedOnce: true,
              isRepairActionInteractedOnce: true,
            );

        partController.text = widget.initialItem!.part!;
        kilometerController.text = widget.initialItem!.kilometer!.toString();
        locationController.text = widget.initialItem!.location!;
        costController.text = widget.initialItem!.cost!.toString();
        notesController.text = widget.initialItem!.notes ?? '';

        ref.setRawPart(partController.text);
        ref.setRawKilometer(kilometerController.text);
        ref.setRawLocation(locationController.text);
        ref.setRawCost(costController.text);
        ref.setRawNotes(notesController.text);
      });
    }
  }

  @override
  void dispose() {
    partController.dispose();
    kilometerController.dispose();
    locationController.dispose();
    costController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;
    final draft = ref.watch(repairDraftProvider);
    final carId = ref.read(carStateNotifierProvider).currentCarId;

    debugPrint(
      'debug repair DRAFT: id=${draft.repairId}, '
      'date=${draft.date}, '
      'part=${draft.part}'
      'repairAction=${draft.repairAction}, '
      'kilometer=${draft.kilometer}'
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
                  titleText: isEdit ? "ویرایش تعمیرات" : "ثبت تعمیرات جدید",
                  ontapFunction: () {
                    ref.invalidate(repairDraftProvider);
                    Navigator.of(context).pop();
                  },
                  isBack: true,
                ),

                Padding(
                  padding: EdgeInsets.only(
                    right: 41.w,
                    left: 41.w,
                    top: isEdit ? 0 : 26.h,
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
                                          repairListProvider(carId!).notifier,
                                        )
                                        .deleteSelectedRepairItemById(
                                          carId,
                                          draft.repairId!,
                                        );

                                    ref
                                        .read(repairDraftProvider.notifier)
                                        .state = RepairStateItem(
                                      repairId: "repair_temp_id",
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
                      BuildFormFields<RepairStateItem>(
                        provider: repairDraftProvider,
                        fieldsBuilder: (state, ref) => buildRepairInfoFields(
                          state,
                          ref,
                          partController,
                          kilometerController,
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
              enabled: ref.watch(isRepairInfoButtonEnabled),
              text: "ثبت",
              onPressed: () async {
                try {
                  if (isEdit) {
                    await showConfirmBottomSheet(
                      context: context,
                      onConfirm: () async {
                        await ref
                            .read(repairListProvider(carId!).notifier)
                            .updateRepairFromDraft(
                              draft,
                              widget.initialItem!,
                              carId,
                            );
                        // refreshes the repair list
                        ref.invalidate(repairListProvider(carId));
                        // Reset draft
                        ref.read(repairDraftProvider.notifier).state =
                            RepairStateItem(repairId: "repair_temp_id");
                      },
                    );
                  } else {
                    await ref
                        .read(repairListProvider(carId!).notifier)
                        .addRepairFromDraft(draft, carId);
                    // refreshes the repair list
                    ref.invalidate(repairListProvider(carId));
                    // Reset draft
                    ref.read(repairDraftProvider.notifier).state =
                        RepairStateItem(repairId: "repair_temp_id");
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
                            ? Text('خطا در ویرایش تعمیرات ')
                            : Text('خطا در ثبت تعمیرات جدید'),
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
