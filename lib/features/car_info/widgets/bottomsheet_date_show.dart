import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

import 'package:motogen/features/car_info/models/car_form_state.dart';
import 'package:motogen/features/car_info/viewmodels/date_input_view_model.dart';
import 'package:motogen/features/car_info/config/date_set_field_config.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:shamsi_date/shamsi_date.dart';

class BottomsheetDateShow extends ConsumerStatefulWidget {
  final DateSetFieldConfig dateSetFieldConfig;
  final CarFormState state;

  const BottomsheetDateShow({
    super.key,
    required this.dateSetFieldConfig,
    required this.state,
  });

  @override
  ConsumerState<BottomsheetDateShow> createState() =>
      _BottomsheetDateShowState();
}

class _BottomsheetDateShowState extends ConsumerState<BottomsheetDateShow> {
  late TextEditingController dayController;
  late TextEditingController monthController;
  late TextEditingController yearController;
  late final List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    final date = widget.dateSetFieldConfig.getter(widget.state);
    Jalali? jalaliDate;
    if (date != null) {
      jalaliDate = Jalali.fromDateTime(date);
    }

    dayController = TextEditingController(
      text: jalaliDate?.day.toString() ?? "",
    );
    monthController = TextEditingController(
      text: jalaliDate?.month.toString() ?? "",
    );
    yearController = TextEditingController(
      text: jalaliDate?.year.toString() ?? "",
    );
    focusNodes = List.generate(3, (_) => FocusNode());
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();

    for (final f in focusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  List<Map<String, dynamic>> getInputConfigs(DateInputViewModel dateVm) => [
    {
      'label': 'روز',
      'controller': dayController,
      'focusNode': focusNodes[0],
      'hint': '12',
      'width': 56.w,
      'maxLength': 2,
      'onChanged': (String v) => dateVm.setDay(v),
      'valid': dateVm.dayValid,
      'value': dateVm.day,
      'isInteractedOnce': dateVm.isDayInteractedOnce,
    },
    {
      'label': 'ماه',
      'controller': monthController,
      'focusNode': focusNodes[1],
      'hint': '12',
      'width': 56.w,

      'maxLength': 2,
      'onChanged': (String v) => dateVm.setMonth(v),
      'valid': dateVm.monthValid,
      'value': dateVm.month,
      'isInteractedOnce': dateVm.isMonthInteractedOnce,
    },
    {
      'label': 'سال',
      'controller': yearController,
      'focusNode': focusNodes[2],
      'hint': '1404',
      'width': 80.w,
      'maxLength': 4,
      'onChanged': (String v) => dateVm.setYear(v),
      'valid': dateVm.yearValid,
      'value': dateVm.year,
      'isInteractedOnce': dateVm.isYearInteractedOnce,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dateVM = ref.watch(dateInputProvider);
    final inputConfigs = getInputConfigs(dateVM);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.4,
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 41.w, vertical: 34.h),
          child: Column(
            children: [
              Text(
                widget.dateSetFieldConfig.labelText,
                style: TextStyle(
                  color: AppColors.blue600,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 40.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: inputConfigs.map((config) {
                  return SizedBox(
                    width: (config['width'] as num?)?.toDouble(),
                    child: Center(
                      child: Text(
                        config['label'],
                        style: TextStyle(
                          color: AppColors.black300,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 18.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < inputConfigs.length; i++) ...[
                    Container(
                      width: (inputConfigs[i]['width'] as num?)?.toDouble(),
                      height: 56.w,
                      decoration: BoxDecoration(
                        color:
                            inputConfigs[i]['valid'] ||
                                inputConfigs[i]['isInteractedOnce'] == false
                            ? AppColors.white300
                            : const Color(0xFFC60B0B).withAlpha(33),

                        border: Border.all(
                          color:
                              inputConfigs[i]['valid'] ||
                                  inputConfigs[i]['isInteractedOnce'] == false
                              ? AppColors.white300
                              : const Color(0xFFC60B0B),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: TextField(
                        controller:
                            inputConfigs[i]['controller']
                                as TextEditingController,
                        focusNode: inputConfigs[i]['focusNode'] as FocusNode,
                        keyboardType: TextInputType.number,

                        textAlign: TextAlign.center,
                        maxLength: (inputConfigs[i]['maxLength'] as num?)
                            ?.toInt(),
                        style: TextStyle(
                          color:
                              inputConfigs[i]['valid'] ||
                                  inputConfigs[i]['isInteractedOnce'] == false
                              ? AppColors.blue500
                              : const Color(0xFFC60B0B),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                            inputConfigs[i]['maxLength'] as int,
                          ),
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          hintText: (inputConfigs[i]['controller'].text.isEmpty
                              ? inputConfigs[i]['hint']
                              : inputConfigs[i]['controller'].text.padLeft(
                                  inputConfigs[i]['maxLength'],
                                  '0',
                                )),
                          hintStyle: TextStyle(
                            color: AppColors.black200,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onChanged: (value) {
                          final onChanged =
                              inputConfigs[i]['onChanged']
                                  as void Function(String);
                          onChanged(value);
                          if (i == 0 && !dateVM.isDayInteractedOnce) {
                            dateVM.markDayInteracted();
                          }
                          if (i == 1 && !dateVM.isMonthInteractedOnce) {
                            dateVM.markMonthInteracted();
                          }
                          if (i == 2 && !dateVM.isYearInteractedOnce) {
                            dateVM.markYearInteracted();
                          }
                          if (value.length == inputConfigs[i]['maxLength'] &&
                              i < inputConfigs.length - 1) {
                            (inputConfigs[i + 1]['focusNode'] as FocusNode)
                                .requestFocus();
                          }
                          setState(() {});
                        },
                        onEditingComplete: () {
                          if ((i == 0 || i == 1) &&
                              inputConfigs[i]['controller'].text.length == 1) {
                            final padded = inputConfigs[i]['controller'].text
                                .padLeft(2, '0');
                            inputConfigs[i]['controller'].text = padded;
                            final onChanged =
                                inputConfigs[i]['onChanged']
                                    as void Function(String);
                            onChanged(padded);
                            setState(() {});
                          }

                          if (i == 0 && !dateVM.isDayInteractedOnce) {
                            dateVM.markDayInteracted();
                          }
                          if (i == 1 && !dateVM.isMonthInteractedOnce) {
                            dateVM.markMonthInteracted();
                          }
                          if (i == 2 && !dateVM.isYearInteractedOnce) {
                            dateVM.markYearInteracted();
                          }

                          if (i < inputConfigs.length - 1) {
                            (inputConfigs[i + 1]['focusNode'] as FocusNode)
                                .requestFocus();
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                    ),

                    // ---- DIVIDER ----
                    if (i != inputConfigs.length - 1)
                      Text(
                        "/",
                        style: TextStyle(
                          color: AppColors.black200,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                  ],
                ],
              ),
              if (!dateVM.isFutureDateValid && dateVM.isFieldsValid)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      dateVM.errorWhenFutureDate,
                      style: TextStyle(
                        color: Color(0xFFC60B0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (!dateVM.isFieldsValid) SizedBox(height: 60.h),
              OnboardingButton(
                onPressed: () {
                  final pickedDate = dateVM.asDateTime;
                  widget.dateSetFieldConfig.setter(ref, pickedDate);
                  Navigator.of(context).pop(pickedDate);
                },
                currentPage: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
