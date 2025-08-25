import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/base/view/service_item.dart';
import 'package:motogen/features/car_services/base/widgets/add_button.dart';
import 'package:motogen/features/car_services/base/widgets/help_to_add_text_box.dart';
import 'package:motogen/features/car_services/oil/data/oil_repository.dart';
import 'package:motogen/features/car_services/oil/view/oil_tab_button.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class ServiceScreen extends ConsumerWidget {
  final ServiceTitle serviceTitle;
  const ServiceScreen({super.key, required this.serviceTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carId = ref.watch(carStateNotifierProvider).currentCarId;
    final serviceListProvider = getServiceListProvider(serviceTitle);
    final serviceItemsAsync = ref.watch(serviceListProvider(carId!));
    final title = getServiceTitle(serviceTitle);
    double topSpacing(ServiceTitle serviceTitle) {
      return switch (serviceTitle) {
        ServiceTitle.refuel => 252.h,
        ServiceTitle.oil => 110.h,
        ServiceTitle.repair => 147.h,
        ServiceTitle.purchases => 222.h,
      };
    }

    final selectedTab = ref.watch(oilTypeTabProvider);

    return serviceItemsAsync.when(
      data: (serviceItems) {
        return _buildDataUI(
          context,
          ref,
          serviceItems,
          title,
          selectedTab,
          topSpacing(serviceTitle),
          isLoading: false,
        );
      },
      loading: () {
        final previousItems = serviceItemsAsync.value ?? [];
        if (previousItems.isNotEmpty) {
          return _buildDataUI(
            context,
            ref,
            previousItems,
            title,
            selectedTab,
            topSpacing(serviceTitle),
            isLoading: true,
          );
        } else {
          return _buildLoadingUI(context, ref, title, selectedTab);
        }
      },
      error: (err, stack) {
        debugPrint('❌ Error in loading $title list: $err');
        debugPrint('📍 Stacktrace:\n$stack');
        return _buildErrorUI(context, ref, title, selectedTab);
      },
    );
  }

  Widget _buildDataUI(
    BuildContext context,
    WidgetRef ref,
    List<ServiceModel> items,
    String title,
    OilTypeTab selectedTab,
    double topSpacingValue, {
    required bool isLoading,
  }) {
    final anyMoreItemsOpen = ref.watch(serviceAnyMoreOpenProvider(items));

    Widget wrapWithSwipe(Widget child) {
      if (serviceTitle == ServiceTitle.oil && !isLoading) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            final tabs = [
              OilTypeTab.engine,
              OilTypeTab.gearbox,
              OilTypeTab.brake,
              OilTypeTab.steering,
            ];
            final currentIndex = tabs.indexOf(selectedTab);
            int newIndex;
            if (details.primaryVelocity! > 0) {
              // Swipe right
              newIndex = (currentIndex + 1) % tabs.length;
            } else {
              // Swipe left
              newIndex = (currentIndex - 1 + tabs.length) % tabs.length;
            }
            ref.read(oilTypeTabProvider.notifier).state = tabs[newIndex];
          },
          child: child,
        );
      }
      return child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: anyMoreItemsOpen
          ? () {
              for (final r in items) {
                ref.read(serviceMoreEnabledProvider(r.id).notifier).state =
                    false;
              }
            }
          : null,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, ref, title, selectedTab, isLoading),
                  // Empty state with swipe
                  if (items.isEmpty)
                    wrapWithSwipe(
                      Padding(
                        padding: EdgeInsets.only(
                          top: topSpacingValue,
                          bottom: 7.h,
                          right: 20.w,
                          left: 20.w,
                        ),
                        child: _buildEmptyStateUI(),
                      ),
                    )
                  else
                    Expanded(
                      child: wrapWithSwipe(
                        Padding(
                          padding: EdgeInsets.only(
                            top: 23.h,
                            right: 20.w,
                            left: 20.w,
                          ),
                          child: _buildFilledStateUI(ref, items, isLoading),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (items.isEmpty)
              Positioned(
                bottom: 165.h,
                right: 105.w,
                child: HelpToAddTextBox(
                  helpText: "برای اضافه کردن $title جدید روی این دکمه بزن.",
                ),
              ),
            Positioned(
              bottom: 90.h,
              right: 43.w,
              child: AddButton(serviceTitle: serviceTitle),
            ),
            if (isLoading)
              Positioned(
                bottom: 20.h,
                left: 0,
                right: 0,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.blue500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingUI(
    BuildContext context,
    WidgetRef ref,
    String title,
    OilTypeTab selectedTab,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, ref, title, selectedTab, true),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.blue500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorUI(
    BuildContext context,
    WidgetRef ref,
    String title,
    OilTypeTab selectedTab,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, ref, title, selectedTab, false),
                Expanded(
                  child: Center(
                    child: Text(
                      'خطا در بارگذاری $titleها',
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    String title,
    OilTypeTab selectedTab,
    bool isLoading,
  ) {
    return Column(
      children: [
        // Top bar
        MyAppBar(
          titleText: title,
          ontapFunction: () {
            Navigator.pop(context);
            ref.invalidate(serviceSortProvider);
            ref.invalidate(serviceMoreEnabledProvider);
          },
          isBack: true,
        ),

        if (serviceTitle == ServiceTitle.oil)
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OilTabButton(
                  label: "موتور",
                  isSelected: selectedTab == OilTypeTab.engine,
                  onTap: isLoading
                      ? () {}
                      : () => ref.read(oilTypeTabProvider.notifier).state =
                            OilTypeTab.engine,
                ),
                OilTabButton(
                  label: "گیربکس",
                  isSelected: selectedTab == OilTypeTab.gearbox,
                  onTap: isLoading
                      ? () {}
                      : () => ref.read(oilTypeTabProvider.notifier).state =
                            OilTypeTab.gearbox,
                  /* onTap: () async {
                    final secureStorage =
                        const FlutterSecureStorage();
                    await secureStorage.write(
                      key: "accessToken",
                      value: "totally_invalid_token",
                    );
                    final refreshToken = await secureStorage
                        .read(key: "refreshToken");
                    debugPrint(
                      "debug the refersh token is $refreshToken",
                    );
                    ref
                            .read(oilTypeTabProvider.notifier)
                            .state =
                        OilTypeTab.gearbox;
                  }, */
                ),
                OilTabButton(
                  label: "ترمز",
                  isSelected: selectedTab == OilTypeTab.brake,
                  onTap: isLoading
                      ? () {}
                      : () => ref.read(oilTypeTabProvider.notifier).state =
                            OilTypeTab.brake,
                ),
                OilTabButton(
                  label: "فرمان",
                  isSelected: selectedTab == OilTypeTab.steering,
                  onTap: isLoading
                      ? () {}
                      : () => ref.read(oilTypeTabProvider.notifier).state =
                            OilTypeTab.steering,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyStateUI() {
    final title = getServiceTitle(serviceTitle);
    final index = serviceTitle.index;
    final imageBasedIndex = [
      {"icon": AppImages.fuel, "width": 315.4.w, "height": 177.h},
      {
        "icon": AppImages.seconfOnboardingImage,
        "width": 281.w,
        "height": 281.h,
      },
      {"icon": AppImages.purchases, "width": 107.w, "height": 163.h},
      {
        "icon": AppImages.seconfOnboardingImage,
        "width": 281.w,
        "height": 281.h,
      },
    ];

    return Column(
      children: [
        Image.asset(
          imageBasedIndex[index]['icon'] as String,
          width: imageBasedIndex[index]['width'] as double,
          height: imageBasedIndex[index]['height'] as double,
        ),
        SizedBox(height: 19.h),
        Text(
          "هنوز $titleی رو ثبت نکردی!",
          style: TextStyle(
            color: AppColors.blue600,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 160.h),
      ],
    );
  }

  Widget _buildFilledStateUI(
    WidgetRef ref,
    List<ServiceModel> serviceItems,
    bool isLoading,
  ) {
    final currentSort = ref.watch(serviceSortProvider);
    final newestSortColor = currentSort == ServiceSortType.newest
        ? Color(0xFFC60B0B)
        : AppColors.blue500;
    final oldestSortColor = currentSort == ServiceSortType.oldest
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
              onTap: isLoading
                  ? () {}
                  : () => ref.read(serviceSortProvider.notifier).state =
                        ServiceSortType.newest,
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
              onTap: isLoading
                  ? () {}
                  : () => ref.read(serviceSortProvider.notifier).state =
                        ServiceSortType.oldest,
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
            itemCount: serviceItems.length,
            itemBuilder: (context, index) {
              final serviceItem = serviceItems[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 25.h, right: 20.w, left: 20.w),
                child: ServiceItem(
                  serviceItem: serviceItem,
                  serviceTitle: serviceTitle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
