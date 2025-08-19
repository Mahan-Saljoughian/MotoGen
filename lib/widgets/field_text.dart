import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';

class FieldText extends StatefulWidget {
  final TextEditingController? controller;
  final bool isValid;
  final String labelText;
  final String hintText;
  final String? error;
  final bool isNumberOnly;
  final bool isBackError;
  final bool isShowNeededIcon;
  final bool isTomanCost;

  final bool isNotes;
  final void Function(String)? onChanged;

  const FieldText({
    super.key,
    this.controller,
    required this.isValid,
    required this.labelText,
    required this.hintText,
    this.onChanged,
    this.error,
    this.isBackError = false,
    this.isNumberOnly = false,

    this.isShowNeededIcon = true,
    this.isTomanCost = false,
    this.isNotes = false,
  });

  @override
  State<FieldText> createState() => _FieldTextState();
}

class _FieldTextState extends State<FieldText> {
  late final TextEditingController _internalController;
  bool isInteractedOnce = false;

  TextEditingController get _ctrl => widget.controller ?? _internalController;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("debug ${widget.error}");
    final showError =
        widget.error != null && (isInteractedOnce || widget.isBackError);
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            SizedBox(
              height: widget.isNotes ? 180.h : null,
              child: TextField(
                style: TextStyle(
                  color: Color(0xFF080E1A),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: widget.isNumberOnly
                    ? TextInputType.number
                    : TextInputType.text,
                maxLines: widget.isNotes ? null : 1,

                inputFormatters: widget.isNumberOnly
                    ? [FarsiOrEnglishDigitsInputFormatter()]
                    : null,
                controller: _ctrl,
                onChanged: widget.onChanged,
                onSubmitted: (_) {
                  if (!isInteractedOnce) {
                    setState(() {
                      isInteractedOnce = true;
                    });
                  }
                },

                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: widget.isValid || isInteractedOnce == false
                        ? AppColors.blue500
                        : Color(0xFFC60B0B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      width: 1.5.w,
                      color: widget.isValid || isInteractedOnce == false
                          ? AppColors.blue500
                          : Color(0xFFC60B0B),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: widget.isValid || isInteractedOnce == false
                          ? AppColors.blue500
                          : Color(0xFFC60B0B),
                    ),
                  ),

                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: AppColors.black100,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: widget.isNotes
                      ? EdgeInsets.only(right: 24.w, left: 10.w, top: 21.h)
                      : EdgeInsets.only(right: 24.w, left: 10.w),
                  suffixIcon:
                      widget.error != null &&
                          isInteractedOnce == true &&
                          widget.isShowNeededIcon
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: SvgPicture.asset(
                            AppIcons.errorCircle,
                            height: 24.h,
                            width: 24.w,
                          ),
                        )
                      : null,

                  suffixIconConstraints: BoxConstraints(
                    minWidth: 24.w,
                    minHeight: 24.w,
                  ),
                ),
              ),
            ),
            if (widget.isTomanCost && !showError)
              Positioned(
                left: 15.w,
                child: Text(
                  "تومان",
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),

        if (showError)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.error ?? "",
                style: TextStyle(
                  color: Color(0xFFC60B0B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

        if (widget.error != null &&
            isInteractedOnce == false &&
            !widget.isBackError)
          SizedBox(height: 26.h),
        if (widget.error == null) SizedBox(height: 26.h),
      ],
    );
  }
}
