import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/bottom_sheet/widgets/build_form_fields.dart';
import 'package:motogen/features/car_services/oil/config/oil_info_list.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_draft_setters.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_list_notifier.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_use_case_api.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_validation.dart';

import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class OilFormScreen extends ConsumerStatefulWidget {
  final OilStateItem? initialItem;
  const OilFormScreen({super.key, this.initialItem});

  @override
  ConsumerState<OilFormScreen> createState() => _OilFormScreenState();
}

class _OilFormScreenState extends ConsumerState<OilFormScreen> {
  final oilBrandAndModelController = TextEditingController();
  final kilometerController = TextEditingController();
  final locationController = TextEditingController();
  final costController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialItem != null) {
      Future.microtask(() {
        ref.read(oillDraftProvider.notifier).state = widget.initialItem!
            .copyWith(
              isDateInteractedOnce: true,
              isOilTypeInteractedOnce: true,
            );

        oilBrandAndModelController.text = widget.initialItem!.oilBrandAndModel!;
        kilometerController.text = widget.initialItem!.kilometer!.toString();
        locationController.text = widget.initialItem!.location!;
        costController.text = widget.initialItem!.cost!.toString();
        notesController.text = widget.initialItem!.notes ?? '';

        ref.setRawOilBrandAndModel(oilBrandAndModelController.text);
        ref.setRawKilometer(kilometerController.text);
        ref.setRawLocation(locationController.text);
        ref.setRawCost(costController.text);
        ref.setRawNotes(notesController.text);
      });
    }
  }

  @override
  void dispose() {
    oilBrandAndModelController.dispose();
    kilometerController.dispose();
    locationController.dispose();
    costController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;
    final draft = ref.watch(oillDraftProvider);
    final carId = ref.read(carStateNotifierProvider).currentCarId;

    debugPrint(
      'debug repair DRAFT: id=${draft.oilId}, '
      'date=${draft.date}, '
      'part=${draft.oilBrandAndModel}'
      'repairAction=${draft.oilType}, '
      'kilometer=${draft.kilometer}'
      'location=${draft.location}'
      'cost=${draft.cost}'
      'note=${draft.notes}'
      'oilFilterChanged=${draft.oilFilterChanged}'
      'airFilterChanged=${draft.airFilterChanged}'
      'cabinFilterChanged=${draft.cabinFilterChanged}'
      'fuelFilterChanged=${draft.fuelFilterChanged}',
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              titleText: isEdit ? "ویرایش روغن" : "ثبت روغن جدید",
              ontapFunction: () {
                ref.invalidate(oillDraftProvider);
                Navigator.of(context).pop();
              },
              isBack: true,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // force scrollability

                child: Padding(
                  padding: EdgeInsets.only(
                    right: 41.w,
                    left: 41.w,
                    top: isEdit ? 0.h : 15.h,
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
                                        .read(oilListProvider(carId!).notifier)
                                        .deleteSelectedOilItemById(
                                          carId,
                                          draft.oilId!,
                                        );

                                    ref.read(oillDraftProvider.notifier).state =
                                        OilStateItem(oilId: "oil_temp_id");
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
                      BuildFormFields<OilStateItem>(
                        provider: oillDraftProvider,
                        fieldsBuilder: (state, ref) => buildOilInfoFields(
                          state,
                          ref,
                          oilBrandAndModelController,
                          kilometerController,
                          locationController,
                          costController,
                          notesController,
                          isEdit,
                        ),
                      ),

                      OnboardingButton(
                        enabled: ref.watch(isOilInfoButtonEnabled(isEdit)),
                        text: "ثبت",
                        onPressed: () async {
                          try {
                            if (isEdit) {
                              await showConfirmBottomSheet(
                                titleText: "از ویرایش جدیدت مطمئنی؟",
                                context: context,
                                onConfirm: () async {
                                  await ref
                                      .read(oilListProvider(carId!).notifier)
                                      .updateOilFromDraft(
                                        draft,
                                        widget.initialItem!,
                                        carId,
                                      );
                                  // refreshes the repair list
                                  ref.invalidate(oilListProvider(carId));
                                  // Reset draft
                                  ref.read(oillDraftProvider.notifier).state =
                                      OilStateItem(oilId: "oil_temp_id");
                                },
                              );
                            } else {
                              await ref
                                  .read(oilListProvider(carId!).notifier)
                                  .addOilFromDraft(draft, carId);
                              // refreshes the repair list
                              ref.invalidate(oilListProvider(carId));
                              // Reset draft
                              ref.read(oillDraftProvider.notifier).state =
                                  OilStateItem(oilId: "oil_temp_id");
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
                                      ? Text('خطا در ویرایش روغن ')
                                      : Text('خطا در ثبت روغن جدید'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(height: 55.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
