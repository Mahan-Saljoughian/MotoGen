import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/global_error_handling/app_with_container.dart';
import 'package:motogen/core/global_error_handling/viewmodel/global_error_provider.dart';
import 'package:motogen/core/services/custom_exceptions.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/car_info/config/car_info_config_list.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/bottom_sheet/widgets/build_form_fields.dart';
import 'package:motogen/features/car_info/viewmodels/car_use_case_api.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/widgets/loading_animation.dart';
import 'package:motogen/widgets/my_app_bar.dart';
import 'package:motogen/widgets/snack_bar.dart';

enum CarInfoFormMode { addEdit, completeProfile }

class CarFormScreen extends ConsumerStatefulWidget {
  final CarFormStateItem? initialItem;
  final CarInfoFormMode mode;
  final int? currentPage;
  final int? count;
  final VoidCallback? onCompleteProfileNext;
  final VoidCallback? onCompleteProfileBack;

  const CarFormScreen({
    super.key,
    this.initialItem,
    required this.mode,
    this.currentPage,
    this.count,
    this.onCompleteProfileNext,
    this.onCompleteProfileBack,
  });

  @override
  ConsumerState<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends ConsumerState<CarFormScreen> {
  late final TextEditingController kmController;
  late final TextEditingController nickNameController;
  late final String formTitle;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final isEdit = widget.initialItem != null;
    formTitle = widget.mode == CarInfoFormMode.completeProfile
        ? "مشخصات خودرو"
        : isEdit
        ? "ویرایش مشخصات خودرو"
        : "افزودن خودرو جدید";
    kmController = TextEditingController();
    nickNameController = TextEditingController();

    if (widget.mode == CarInfoFormMode.addEdit && isEdit) {
      _loadLatestCar(widget.initialItem!.carId!);
    }
  }

  Future<void> _loadLatestCar(String carId) async {
    setState(() => isLoading = true);

    try {
      await ref.read(carStateNotifierProvider.notifier).fetchCarWithId(carId);

      final updatedCar = ref
          .read(carStateNotifierProvider.notifier)
          .getCarById(carId);

      kmController.text = updatedCar.kilometer?.toString() ?? '';
      nickNameController.text = updatedCar.nickName ?? '';
      ref.read(carDraftProvider.notifier).state = updatedCar;
      ref.setRawKilometer(updatedCar.kilometer.toString());
      ref.setNickName(updatedCar.nickName);
    } on ForceUpdateException catch (e) {
      GlobalErrorHandler.handle(e);
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return;
    } catch (err, st) {
      debugPrint('❌debug update loadLatestCar error: $err\n$st');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    kmController.dispose();
    nickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;
    final draft = ref.watch(carDraftProvider);
    final carNotifier = ref.read(carStateNotifierProvider.notifier);

    if (isLoading) {
      return const Scaffold(body: Center(child: LoadingAnimation()));
    }
    debugPrint(
      'debug car DRAFT: id=${draft.carId}, '
      'brand=${draft.brand}, '
      'model=${draft.model}, '
      'type=${draft.type}'
      'yearMade=${draft.yearMade}'
      'color=${draft.color}'
      'kilometer=${draft.kilometer}'
      'fuelType=${draft.fuelType}'
      'bodyInsuranceExpiry=${draft.bodyInsuranceExpiry}'
      'thirdPartyInsuranceExpiry=${draft.thirdPartyInsuranceExpiry}'
      'nextTechnicalCheck=${draft.nextTechnicalCheck}'
      'nickName=${draft.nickName}',
    );
    debugPrint(
      'debug car initialItem: id=${widget.initialItem?.carId}, '
      'brand=${widget.initialItem?.brand}, '
      'model=${widget.initialItem?.model}, '
      'type=${widget.initialItem?.type}'
      'yearMade=${widget.initialItem?.yearMade}'
      'color=${widget.initialItem?.color}'
      'kilometer=${widget.initialItem?.kilometer}'
      'fuelType=${widget.initialItem?.fuelType}'
      'bodyInsuranceExpiry=${widget.initialItem?.bodyInsuranceExpiry}'
      'thirdPartyInsuranceExpiry=${widget.initialItem?.thirdPartyInsuranceExpiry}'
      'nextTechnicalCheck=${draft.nextTechnicalCheck}'
      'nickName=${widget.initialItem?.nickName}',
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              titleText: formTitle,
              ontapFunction: widget.mode == CarInfoFormMode.completeProfile
                  ? widget.onCompleteProfileBack
                  : () {
                      Navigator.of(context).pop();
                      ref.invalidate(carDraftProvider);
                    },
              isBack: true,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (widget.mode == CarInfoFormMode.completeProfile) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: MediaQuery.of(context).size.height * 0.13.h,
                        ),
                        child: widget.currentPage == 3
                            ? BuildFormFields<CarFormStateItem>(
                                provider: carDraftProvider,
                                fieldsBuilder: (state, ref) =>
                                    buildCarInfoFirstPageFields(false),
                              )
                            : BuildFormFields<CarFormStateItem>(
                                provider: carDraftProvider,
                                fieldsBuilder: (state, ref) =>
                                    buildCarInfoSecondPageFields(
                                      state,
                                      kmController,
                                      ref,
                                    ),
                              ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05.h,
                      ),
                      DotIndicator(
                        currentPage: widget.currentPage!,
                        count: widget.count!,
                      ),
                      SizedBox(height: 24.h),
                      OnboardingButton(
                        currentPage: widget.currentPage,
                        onPressed: widget.onCompleteProfileNext!,
                      ),
                    ] else ...[
                      if (isEdit) ...[
                        //update case
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 40.h,
                          ),
                          child: BuildFormFields<CarFormStateItem>(
                            provider: carDraftProvider,
                            fieldsBuilder: (state, ref) =>
                                buildFullCarInfoFields(
                                  state,
                                  kmController,
                                  nickNameController,
                                  ref,
                                  true,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 40.h),
                          child: OnboardingButton(
                            pagesTitleEnum: PagesTitleEnum.addEditCar,
                            onPressed: () async {
                              await showConfirmBottomSheet(
                                titleText: "از ویرایش جدید مطمئنی؟",
                                context: context,
                                onConfirm: () async {
                                  try {
                                    final draft = ref.watch(carDraftProvider);
                                    await carNotifier.updateCarFromDraft(
                                      draft,
                                      widget.initialItem!,
                                    );
                                    ref.invalidate(carDraftProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        buildCustomSnackBar(
                                          type: SnackBarType.success,
                                        ),
                                      );
                                    }
                                  } on ForceUpdateException catch (e) {
                                    GlobalErrorHandler.handle(e);
                                    if (mounted &&
                                        Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                    return;
                                  } catch (e, st) {
                                    if (context.mounted) {
                                      appLogger.e(
                                        "debug the errors is $e , $st",
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        buildCustomSnackBar(
                                          message: 'خطا در ویرایش خودرو',
                                          type: SnackBarType.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        //add case
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 40.h,
                          ),
                          child: BuildFormFields<CarFormStateItem>(
                            provider: carDraftProvider,
                            fieldsBuilder: (state, ref) =>
                                buildFullCarInfoFields(
                                  state,
                                  kmController,
                                  nickNameController,
                                  ref,
                                  false,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 40.h),
                          child: OnboardingButton(
                            pagesTitleEnum: PagesTitleEnum.addEditCar,
                            onPressed: () async {
                              await showConfirmBottomSheet(
                                titleText: "از ثبت ماشین جدید مطمئنی؟",
                                context: context,
                                onConfirm: () async {
                                  try {
                                    final draft = ref.watch(carDraftProvider);
                                    await carNotifier.addCarFromDraft(draft);
                                    ref.invalidate(carDraftProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        buildCustomSnackBar(
                                          type: SnackBarType.success,
                                        ),
                                      );
                                    }
                                  } on ForceUpdateException catch (e) {
                                    GlobalErrorHandler.handle(e);
                                    if (mounted &&
                                        Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                    return;
                                  } catch (e, st) {
                                    // handle error (snackbar, dialog, etc.)
                                    if (context.mounted) {
                                      appLogger.e(
                                        "debug the errros is $e , $st",
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        buildCustomSnackBar(
                                          message: 'خطا در ثبت خودرو جدید',
                                          type: SnackBarType.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
