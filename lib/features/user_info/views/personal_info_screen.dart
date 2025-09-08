import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/features/user_info/viewmodels/user_use_case_api.dart';
import 'package:motogen/widgets/field_text.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/widgets/loading_animation.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentPage;
  final int? count;

  const PersonalInfoScreen({
    super.key,
    required this.onNext,
    this.onBack,
    this.isEdit = false,
    this.currentPage,
    this.count,
  });

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(personalInfoProvider).setDraftFromMain();
      });
    }
  }

  Future<void> _saveProfile() async {
    final vm = ref.read(personalInfoProvider);

    final nameUnchanged =
        vm.draftNameController.text.trim() == vm.nameController.text.trim();
    final lastNameUnchanged =
        vm.draftLastNameController.text.trim() ==
        vm.lastNameController.text.trim();

    if (nameUnchanged && lastNameUnchanged) {
      // No changes → skip bottom sheet, skip saving
      Navigator.pop(context); // Just close screen
      return;
    }

    await showConfirmBottomSheet(
      titleText: "از ویرایش پروفایلت مطمئنی؟",
      context: context,
      onConfirm: () async {
        setState(() => _isSaving = true);
        await ref.updateUserProfile(
          vm.draftNameController,
          vm.draftLastNameController,
        );
        vm.applyDraftToMain();
      },
    );

    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(personalInfoProvider);

    final titleText = widget.isEdit ? "ویرایش اطلاعات کاربری" : "مشخصات فردی";

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  MyAppBar(
                    titleText: titleText,
                    isBack: widget.isEdit,
                    ontapFunction: widget.isEdit
                        ? () => Navigator.of(context).pop()
                        : widget.onBack,
                  ),

                  Padding(
                    padding: widget.isEdit
                        ? EdgeInsets.only(top: 50.h, bottom: 15.h)
                        : EdgeInsets.only(top: 100.h),
                    child: widget.isEdit
                        ? SvgPicture.asset(
                            AppIcons.profileCircle,
                            width: 150.w,
                            height: 150.w,
                            colorFilter: ColorFilter.mode(
                              AppColors.blue500,
                              BlendMode.srcIn,
                            ),
                          )
                        : null,
                  ),

                  /// Fields
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      children: [
                        FieldText(
                          controller: widget.isEdit
                              ? vm.draftNameController
                              : vm.nameController,
                          isValid: widget.isEdit
                              ? vm.isDraftNameValid
                              : vm.isNameValid,
                          labelText: "نام",
                          hintText: "علی",
                          error: widget.isEdit
                              ? vm.errorDraftName
                              : vm.errorName,
                        ),
                        FieldText(
                          controller: widget.isEdit
                              ? vm.draftLastNameController
                              : vm.lastNameController,
                          isValid: widget.isEdit
                              ? vm.isDraftLastNameValid
                              : vm.isLastNameValid,
                          labelText: "نام خانوادگی",
                          hintText: "علیزاده",
                          error: widget.isEdit
                              ? vm.errorDraftLastName
                              : vm.errorLastName,
                        ),
                      ],
                    ),
                  ),

                  if (!widget.isEdit)
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.43,
                        ),
                        DotIndicator(
                          currentPage: widget.currentPage!,
                          count: widget.count!,
                        ),
                        SizedBox(height: 24.h),
                        OnboardingButton(
                          currentPage: widget.currentPage,
                          onPressed: widget.onNext,
                        ),
                      ],
                    )
                  else
                    OnboardingButton(
                      pagesTitleEnum: PagesTitleEnum.editPersonalInfo,
                      onPressed: _saveProfile,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_isSaving)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.black.withAlpha(51), // semi-transparent tint
                child: const Center(child: LoadingAnimation()),
              ),
            ),
          ),
      ],
    );
  }
}
