import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_icons.dart';

class AiLoadingAnimation extends StatefulWidget {
  const AiLoadingAnimation({super.key});

  @override
  State<AiLoadingAnimation> createState() => _AiLoadingAnimationState();
}

class _AiLoadingAnimationState extends State<AiLoadingAnimation> {
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _current = 1 - _current;
      });
    });
  }

   @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String assetPath = _current == 0
        ? AppIcons.loadingDotBottom
        : AppIcons.loadingDotTop;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: SvgPicture.asset(
        assetPath,
        key: ValueKey(assetPath),
        width: 91.w,
        height: 39.h,
      ),
    );
  }
}
