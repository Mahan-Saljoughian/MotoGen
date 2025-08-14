import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_services/refuel/data/refuel_sort.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_list_notifier.dart';
import 'package:motogen/features/car_services/refuel/widget/refuel_item.dart';
import 'package:motogen/features/car_services/widgets/add_button.dart';
import 'package:motogen/features/car_services/widgets/help_to_add_text_box.dart';

class FuelScreen extends ConsumerWidget {
  const FuelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carId = ref.watch(carStateNotifierProvider).currentCarId;
    final refuelsAsync = ref.watch(refuelListProvider(carId ?? ""));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, "/mainApp"),
                        child: SvgPicture.asset(
                          AppIcons.arrowRight,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      SizedBox(width: 135.w),
                      Text(
                        "سوخت",
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  refuelsAsync.when(
                    data: (refuels) {
                      debugPrint('debug Current refuels list: $refuels');
                      for (final r in refuels) {
                        debugPrint('debug Refuel | refuelId : {${r.refuelId}}');
                      }

                      if (refuels.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 252.h, bottom: 7.h),
                          child: _buildEmptyStateUI(),
                        );
                      } else {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: _buildFilledStateUI(ref, refuels),
                          ),
                        );
                      }
                    },
                    loading: () => Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.blue500,
                        ),
                      ),
                    ),
                    error: (err, stack) {
                      debugPrint('⛔ Refuel list load error: $err');
                      debugPrintStack(stackTrace: stack);

                      return Expanded(
                        child: Center(
                          child: Text(
                            'خطا در بارگذاری سوخت‌ها',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(child: AddButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateUI() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Image.asset(AppImages.fuel, width: 315.4.w, height: 177.h),
            SizedBox(height: 19.h),
            Text(
              "هنوز سوختی رو ثبت نکردی!",
              style: TextStyle(
                color: AppColors.blue600,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 160.h),
          ],
        ),
        Positioned(
          child: HelpToAddTextBox(
            helpText: "برای اضافه کردن سوخت جدید روی این دکمه بزن.",
          ),
        ),
      ],
    );
  }

  Widget _buildFilledStateUI(WidgetRef ref, List<RefuelStateItem> refuels) {
    final currentSort = ref.watch(refuelSortProvider);
    final newestSortColor = currentSort == RefuelSortType.newest
        ? Color(0xFFC60B0B)
        : AppColors.blue500;
    final oldestSortColor = currentSort == RefuelSortType.oldest
        ? Color(0xFFC60B0B)
        : AppColors.blue500;
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(AppIcons.sort),
            SizedBox(width: 7.w),
            Text(
              "مرتب سازی:",
              style: TextStyle(
                color: AppColors.blue500,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 14.w),
            GestureDetector(
              onTap: () => ref.read(refuelSortProvider.notifier).state =
                  RefuelSortType.newest,
              child: Text(
                "جدیدترین",
                style: TextStyle(
                  color: newestSortColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            GestureDetector(
              onTap: () => ref.read(refuelSortProvider.notifier).state =
                  RefuelSortType.oldest,
              child: Text(
                "قدیمی‌ترین",
                style: TextStyle(
                  color: oldestSortColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 37.h),
        Expanded(
          child: ListView.builder(
            itemCount: refuels.length,
            itemBuilder: (context, index) {
              final refuelItem = refuels[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: RefuelItem(refuelItem: refuelItem),
              );
            },
          ),
        ),
      ],
    );
  }
}
