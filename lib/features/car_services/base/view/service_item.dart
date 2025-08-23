import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';
import 'package:motogen/features/car_services/oil/view/oil_form_screen.dart';
import 'package:motogen/features/car_services/purchases/model/purhcase_state_item.dart';
import 'package:motogen/features/car_services/purchases/view/purchase_form_screen.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/view/refuel_form_screen.dart';
import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';
import 'package:motogen/features/car_services/repair/view/repair_from_screen.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';

class ServiceItem extends ConsumerWidget {
  final ServiceModel serviceItem;
  final ServiceTitle serviceTitle;
  const ServiceItem({
    super.key,
    required this.serviceItem,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceMoreEnabledForCurrent = ref.watch(
      serviceMoreEnabledProvider(serviceItem.id),
    );
    final titles = serviceItem.getTitleByIndex();
    final values = serviceItem.getValueByIndex();
    final moreTitles = serviceItem.getTitleByIndexForMoreItems();
    final moreValues = serviceItem.getValueByIndexForMoreItems();
    Widget getServiceFormScreen(
      ServiceModel serviceItem,
      ServiceTitle serviceTitle,
    ) {
      switch (serviceTitle) {
        case ServiceTitle.refuel:
          return RefuelFormScreen(initialItem: serviceItem as RefuelStateItem);
        case ServiceTitle.oil:
          return OilFormScreen(initialItem: serviceItem as OilStateItem);
        case ServiceTitle.purchases:
          return PurchaseFromScreen(
            initialItem: serviceItem as PurhcaseStateItem,
          );
        case ServiceTitle.repair:
          return RepairFromScreen(initialItem: serviceItem as RepairStateItem);
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        for (final otherId in _openItemIds(ref)) {
          if (otherId != serviceItem.id) {
            ref.read(serviceMoreEnabledProvider(otherId).notifier).state =
                false;
          }
        }
      },
      child: InnerShadow(
        shadows: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0, 0),
            color: Color(0xFF14213D).withAlpha(51),
          ),
        ],
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 180.h),
          padding: EdgeInsets.only(
            right: 15.w,
            left: 15.w,
            top: 25.h,
            bottom: 18.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.blue75,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < titles.length; index++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titles[index],
                      style: TextStyle(
                        color: AppColors.blue500,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      
                      ),
                    ),

                    Text(
                      values[index],
                      style: TextStyle(
                        color: AppColors.blue500,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 9.h),
              ],
              if (serviceMoreEnabledForCurrent && moreTitles.isNotEmpty)
                for (int index = 0; index < moreTitles.length; index++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        moreTitles[index],
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                     
                        ),
                      ),

                      Text(
                        moreValues[index],
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                  
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 9.h),
                ],
              if (serviceMoreEnabledForCurrent &&
                  serviceItem.serviceNotes != null) ...[
                Text(
                  "توضیحات:",
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  serviceItem.serviceNotes!,
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                 
                  ),
                ),
              ],
              SizedBox(height: 18.h),

              Row(
                mainAxisAlignment:
                    serviceMoreEnabledForCurrent ||
                        (serviceItem.serviceNotes == null && moreTitles.isEmpty)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!serviceMoreEnabledForCurrent &&
                      (serviceItem.serviceNotes != null ||
                          moreTitles.isNotEmpty))
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ref
                                .read(
                                  serviceMoreEnabledProvider(
                                    serviceItem.id,
                                  ).notifier,
                                )
                                .state =
                            true;
                      },
                      child: Row(
                        children: [
                          Text(
                            "بیشتر",
                            style: TextStyle(
                              color: Color(0xFF4A79D8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                   
                            ),
                          ),
                          SvgPicture.asset(
                            AppIcons.arrowDown,
                            width: 14.w,
                            height: 14.16.h,
                            colorFilter: ColorFilter.mode(
                              Color(0xFF4A79D8),
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      FadeRoute(
                        page: getServiceFormScreen(serviceItem, serviceTitle),
                      ),
                    ),

                    child: Container(
                      width: 84.w,
                      height: 21.h,
                      decoration: BoxDecoration(
                        color: AppColors.blue400,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.edit,
                            width: 10.w,
                            height: 10.h,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "ویرایش",
                            style: TextStyle(
                              color: AppColors.blue50,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w500,
                        
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to get all current item IDs without passing list in constructor
  List<String> _openItemIds(WidgetRef ref) {
    final carId = ref.watch(carStateNotifierProvider).currentCarId;
    final serviceListProvider = getServiceListProvider(serviceTitle);
    final asyncItems = ref.read(serviceListProvider(carId!));

    return asyncItems.maybeWhen(
      data: (list) => list
          .where(
            (r) => ref.read(serviceMoreEnabledProvider(r.id)),
          ) // Only open ones
          .map((r) => r.id)
          .toList(),
      orElse: () => [],
    );
  }
}
