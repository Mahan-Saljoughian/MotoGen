// custom_nav_bar_curved.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class CustomNavBarCurved extends StatefulWidget {
  final int selected;
  final Function(int) onTap;
  final TickerProvider vsync;

  const CustomNavBarCurved({
    super.key,
    required this.selected,
    required this.onTap,
    required this.vsync,
  });

  @override
  State<CustomNavBarCurved> createState() => _CustomNavBarCurvedState();
}

class _CustomNavBarCurvedState extends State<CustomNavBarCurved> {
  final List<String> icons = [
    AppIcons.home,
    AppIcons.notifier,
    AppIcons.chatbot,
    AppIcons.profile,
  ];

  final List<String> selectedIcons = [
    AppIcons.homeSelected,
    AppIcons.notifierSelected,
    AppIcons.chatbotSelected,
    AppIcons.profileSelected,
  ];

  final List<String> labels = ['خانه', 'یادآور', 'چت‌بات', 'پروفایل'];

  int getVisualIndex(int index) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return isRTL ? index : (icons.length - 1 - index);
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth =
        MediaQuery.of(context).size.width - 40.w; // padding left+right
    final itemWidth = totalWidth / icons.length;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final selectedVisualIndex = getVisualIndex(widget.selected);

    return Padding(
      padding: EdgeInsets.only(left: 20.w, bottom: 7.h, right: 20.w, top: 30.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rounded nav bar background
          ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: CurvedNavigationBar(
              index: selectedVisualIndex,
              onTap: (newIndex) => widget.onTap(getVisualIndex(newIndex)),
              height: 65.h,
              backgroundColor: Colors.transparent,
              color: AppColors.white50,
              buttonBackgroundColor: Colors.transparent,
              animationCurve: Curves.easeOutBack,
              animationDuration: const Duration(microseconds: 300),
              items: List.generate(icons.length, (index) {
                final visualIndex = getVisualIndex(index);
                final isSelected = widget.selected == visualIndex;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isSelected
                          ? selectedIcons[visualIndex]
                          : icons[visualIndex],
                      width: 24.w,
                      height: 24.w,
                      colorFilter: isSelected
                          ? const ColorFilter.mode(
                              AppColors.orange600,
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(
                              AppColors.blue300,
                              BlendMode.srcIn,
                            ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      labels[visualIndex],
                      style: TextStyle(
                        fontSize: isSelected ? 11.71.sp : 9.76.sp,
                        fontFamily: "IRANSansXFaNum",
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.orange600
                            : AppColors.blue300,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          // Selected bubble — drawn over curve
          Positioned(
            top: -20.h,
            // Correct horizontal placement for LTR/RTL
            left: isRTL
                ? (totalWidth - (selectedVisualIndex + 0.5) * itemWidth) - 27.w
                : (selectedVisualIndex * itemWidth) + (itemWidth / 2) - 27.w,
            child: Container(
              width: 54.w,
              height: 54.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange600,
              ),
              child: Center(
                child: SvgPicture.asset(
                  selectedIcons[widget.selected],
                  width: 26.w,
                  height: 26.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
