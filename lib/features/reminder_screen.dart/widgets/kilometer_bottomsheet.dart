import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/widgets/field_text.dart';

class BottomsheetTimingBeltKM extends ConsumerStatefulWidget {
  const BottomsheetTimingBeltKM({super.key});

  @override
  ConsumerState<BottomsheetTimingBeltKM> createState() =>
      _BottomsheetTimingBeltKMState();
}

class _BottomsheetTimingBeltKMState
    extends ConsumerState<BottomsheetTimingBeltKM> {
  late TextEditingController kmController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(carDraftProvider);
    kmController = TextEditingController(
      text: draft.kilometer?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    kmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(carDraftProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 41.w, vertical: 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "کیلومتر آخرین تعویض تسمه تایم",
            style: TextStyle(
              color: AppColors.blue600,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 45.h),

          FieldText(
            controller: kmController,
            labelText: "کیلومتر",
            hintText: "41,000",
            isValid: draft.isKilometerValid,
            //error: draft.kilometerError,
            isNumberOnly: true,
            onChanged: ref.setRawKilometer,
          ),

          SizedBox(height: 22.h),

          OnboardingButton(
            onPressed: () {
              final rawText = kmController.text.trim();
              if (rawText.isNotEmpty) {
                final km = int.tryParse(rawText.replaceAll(",", ""));
                Navigator.of(context).pop(km);
              } else {
                Navigator.of(context).pop(null);
              }
            },
            pagesTitleEnum: PagesTitleEnum.TIMING_BELT_CHANGE,
          ),
        ],
      ),
    );
  }
}
