import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class MyNavBar extends StatefulWidget {
  final int selected;
  final Function(int) onTap;
  final TickerProvider vsync;

  const MyNavBar({
    super.key,
    required this.selected,
    required this.onTap,
    required this.vsync,
  });

  @override
  State<MyNavBar> createState() => _CurvedNavBarState();
}

class _CurvedNavBarState extends State<MyNavBar>
    with SingleTickerProviderStateMixin {
  int noOfIcons = 4;

  List<String> icons = [
    AppIcons.home,
    AppIcons.notifier,
    AppIcons.chatbot,
    AppIcons.profile,
  ];

  List<String> selectedIcons = [
    AppIcons.homeSelected,
    AppIcons.notifierSelected,
    AppIcons.chatbotSelected,
    AppIcons.profileSelected,
  ];

  List<String> labels = ['خانه', 'یادآور', 'چت‌بات', 'پروفایل'];

  late AnimationController _controller;
  late Animation<double> _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: widget.vsync,
      duration: const Duration(milliseconds: 300),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void didUpdateWidget(MyNavBar oldWidget) {
    if (widget.selected != oldWidget.selected) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItem({
    required String icon,
    required String selectedIcon,
    required String label,
    required bool isSelected,
    required int index,
    required double maxWidth,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            widget.onTap(index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: 75.h,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: SvgPicture.asset(
                  isSelected ? selectedIcon : icon,
                  height: 24.w,
                  width: 24.w,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.orange600 : AppColors.blue300,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontFamily: "IRANSansXFaNum",
                  fontSize: isSelected ? 11.5.sp : 9.7.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.orange600 : AppColors.blue300,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.white50,
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.asMap().entries.map((entry) {
          int index = entry.key;
          final isSelected = widget.selected == index;

          return _buildItem(
            icon: icons[index],
            selectedIcon: selectedIcons[index],
            label: labels[index],
            isSelected: isSelected,
            index: index,
            maxWidth: width / noOfIcons,
          );
        }).toList(),
      ),
    );
  }
}
