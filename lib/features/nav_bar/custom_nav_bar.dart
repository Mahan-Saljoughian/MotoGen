// nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/nav_bar/nav_bar_painter.dart';

class CustomNavBar extends StatefulWidget {
  final int selected;
  final Function(int) onTap;
  final TickerProvider vsync;

  const CustomNavBar({
    super.key,
    required this.selected,
    required this.onTap,
    required this.vsync,
  });

  @override
  State<CustomNavBar> createState() => _NavBarState();
}

class _NavBarState extends State<CustomNavBar> {
  int noOfIcons = 4;

  List<String> icons = [
    AppIcons.home,
    AppIcons.notifier,
    AppIcons.chatbot,
    AppIcons.profile,
  ];

  List<String> labels = ['خانه', 'یادآور', 'چت‌بات', 'پروفایل'];

  late double position;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: widget.vsync,
      duration: const Duration(milliseconds: 200),
    );

    animation = Tween<double>(begin: 0.0, end: 0.0).animate(controller);
  }

  int getVisualIndex(int index) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return isRTL ? index : (noOfIcons - 1 - index);
  }

  double getEndPosition(
    int index,
    double screenWidth,
    double horzPadding,
    double horzMargin,
  ) {
    double totalMargin = 2 * horzMargin;
    double totalPadding = 2 * horzPadding;
    double valueToOmit = totalMargin + totalPadding;
    int slot = getVisualIndex(index);
    double slotWidth = (screenWidth - valueToOmit) / noOfIcons;
    return (slotWidth * slot + horzPadding) + (slotWidth / 2) - 70.w;
  }

  void _setPosition(
    int idx,
    double screenWidth,
    double horzPadding,
    double horzMargin,
  ) {
    position = getEndPosition(idx, screenWidth, horzPadding, horzMargin);
    animation = Tween<double>(
      begin: position,
      end: position,
    ).animate(controller);
    setState(() {});
  }

  void animateDrop(
    int index,
    double screenWidth,
    double horzPadding,
    double horzMargin,
  ) {
    final newPos = getEndPosition(index, screenWidth, horzPadding, horzMargin);
    animation = Tween<double>(
      begin: position,
      end: newPos,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    controller.forward(from: 0).then((_) {
      position = newPos;
    });
    setState(() {});
  }

  @override
  void didUpdateWidget(CustomNavBar oldWidget) {
    if (widget.selected != oldWidget.selected) {
      final mq = MediaQuery.of(context);
      final horzPadding = 25.0.w;
      final horzMargin = 7.0.w;
      animateDrop(widget.selected, mq.size.width, horzPadding, horzMargin);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final mq = MediaQuery.of(context);
        final horzPadding = 25.0.w;
        final horzMargin = 7.0.w;
        _setPosition(widget.selected, mq.size.width, horzPadding, horzMargin);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final horizontalPadding = 25.0.w;
    final horizontalMargin = 7.0.w;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 20.h,
        left: horizontalMargin,
        right: horizontalMargin,
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: NavBarPainter(animation.value, isRTL),
            size: Size(screenWidth - (2 * horizontalMargin), 80.0.h),
            child: SizedBox(
              height: 120.0.h,
              width: screenWidth - (2 * horizontalMargin),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: icons.asMap().entries.map((entry) {
                    int index = entry.key;
                    String icon = entry.value;
                    String label = labels[index];
                    final isSelected = widget.selected == index;

                    return GestureDetector(
                      onTap: () {
                        debugPrint(
                          'debug Tapped index $index, visual slot: ${getVisualIndex(index)}',
                        );
                        if (widget.selected != index) {
                          widget.onTap(index);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 375),
                        curve: Curves.easeOut,
                        width:
                            (screenWidth -
                                (2 * horizontalMargin) -
                                (2 * horizontalPadding)) /
                            noOfIcons,
                        padding: EdgeInsets.only(top: 0.h, bottom: 9.39.h),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedPadding(
                              duration: const Duration(milliseconds: 375),
                              curve: Curves.easeOutCubic,
                              padding: EdgeInsets.only(
                                bottom: isSelected ? 31.h : 6.h,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 375),
                                child: SvgPicture.asset(
                                  icon,
                                  key: ValueKey(
                                    isSelected ? 'yellow$index' : 'gray$index',
                                  ),
                                  width: 24.0.w,
                                  height: 24.w,
                                  colorFilter: ColorFilter.mode(
                                    isSelected
                                        ? AppColors.orange600
                                        : AppColors.blue300,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            AnimatedPadding(
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.only(
                                bottom: isSelected ? 2.81.h : 0.0.h,
                              ),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontFamily: "IRANSansXFaNum",
                                  fontSize: isSelected ? 11.71.sp : 9.76.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.orange600
                                      : AppColors.blue300,
                                ),
                                child: Text(label),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
