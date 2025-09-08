import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/web.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/bottom_sheet/config/picker_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/bottom_sheet/viewmodels/bottomsheet_multi_selection_viewmodel.dart';
import 'package:motogen/features/bottom_sheet/viewmodels/bottomsheet_search_viewmodel.dart';
import 'package:motogen/features/bottom_sheet/viewmodels/bottomsheet_selection_viewmodel.dart';
import 'package:motogen/widgets/loading_animation.dart';

class BottomsheetListShow {
  static Future<void> showSelectionBottomSheet<T>({
    required BuildContext context,
    required PickerFieldConfig<T> config,
    required WidgetRef ref,
    required T state,
  }) async {
    final labelText = config.labelText;
    if (config.isMultiSelect) {
      final initialSelected = config.multiGetter!(state);
      List<PickerItem> latestSelected = List.from(initialSelected);

      final result = await showModalBottomSheet<List<PickerItem>>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        ),
        builder: (ctx) => _BottomSheetMultiContent(
          labelText: config.labelText,
          itemsProvider: config.providerBuilder(state),
          initialSelectedItems: initialSelected,
          onSelectionChanged: (vals) => latestSelected = vals,
        ),
      );

      config.multiSetter!(ref, result ?? latestSelected);
    } else {
      final PickerItem? selectedItem = config.getter!(state);
     //PickerItem? latestSelectedItem = selectedItem;

      final result = await showModalBottomSheet<PickerItem>(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        ),
        builder: (ctx) => _BottomSheetContent(
          labelText: labelText,
          itemsProvider: config.providerBuilder(state),
          initialSelectedItem: selectedItem,
          //onLatestSelectionChanged: (val) => latestSelectedItem = val,
        ),
      );

      if (result != null) config.setter!(ref, result);
    }
  }
}

class _BottomSheetContent extends ConsumerWidget {
  final String labelText;
  final ProviderListenable<AsyncValue<List<PickerItem>>> itemsProvider;
  final PickerItem? initialSelectedItem;
//  final ValueChanged<PickerItem?> onLatestSelectionChanged;

  const _BottomSheetContent({
    required this.labelText,
  //  required this.onLatestSelectionChanged,
    this.initialSelectedItem,
    required this.itemsProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    return itemsAsync.when(
      data: (items) => ProviderScope(
        overrides: [
          bottomsheetSelectionProvider.overrideWith(
            (ref) => BottomsheetSelectionViewmodel.initial(initialSelectedItem),
          ),
          bottomsheetSearchProvider.overrideWith(
            (ref) => BottomsheetSearchViewmodel(items: items),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final searchVM = ref.watch(bottomsheetSearchProvider);
            final selectionVM = ref.watch(bottomsheetSelectionProvider);

            // Update latest selection
        //    onLatestSelectionChanged(selectionVM.selectedItem);

            return Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              padding: EdgeInsets.symmetric(vertical: 34.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labelText,
                    style: TextStyle(
                      color: AppColors.blue600,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 29.h),

                  if (items.length >= 5) ...[
                    // Search field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 33.w),
                      child: TextField(
                        onChanged: (val) => searchVM.query = val,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: AppColors.white700,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: AppColors.white700,
                              width: 1,
                            ),
                          ),
                          hintText: "جستجو...",
                          hintStyle: TextStyle(
                            color: AppColors.black300,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(left: 18.w),
                            child: SvgPicture.asset(AppIcons.searchStatus),
                          ),
                          suffixIconConstraints: BoxConstraints(
                            minHeight: 24.h,
                            minWidth: 24.w,
                          ),
                          contentPadding: EdgeInsets.only(right: 26.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // List
                  Flexible(
                    child: RawScrollbar(
                      thumbVisibility: true,
                      thickness: 8.w,
                      radius: const Radius.circular(20),
                      thumbColor: AppColors.black50,
                      padding: EdgeInsets.only(left: 10.w),
                      interactive: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchVM.filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = searchVM.filteredItems[index];
                          final isSelected = selectionVM.isSelected(item);

                          return ListTile(
                            onTap: () {
                              ref
                                  .read(bottomsheetSelectionProvider)
                                  .select(item);
                              Navigator.pop(context, item);
                            },
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 44.w,
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                color: AppColors.blue600,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              isSelected
                                  ? AppIcons.tickCircleFilled
                                  : AppIcons.tickCircleEmpty,
                              width: 24.w,
                              height: 24.h,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      loading: () => SizedBox(
        height: 250,
        child: Center(child: LoadingAnimation()),
      ),
      error: (err, stack) {
        Logger().i('provider error: $err');
        Logger().i('stack error  $stack');
        return SizedBox(
          height: 250,
          child: Center(child: Text('خطا در گرفتن لیست')),
        );
      },
    );
  }
}

class _BottomSheetMultiContent extends ConsumerWidget {
  final String labelText;
  final ProviderListenable<AsyncValue<List<PickerItem>>> itemsProvider;
  final List<PickerItem> initialSelectedItems;
  final ValueChanged<List<PickerItem>> onSelectionChanged;

  const _BottomSheetMultiContent({
    required this.labelText,
    required this.onSelectionChanged,
    required this.itemsProvider,
    required this.initialSelectedItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);

    return itemsAsync.when(
      data: (items) => ProviderScope(
        overrides: [
          bottomsheetMultiSelectionProvider.overrideWith(
            (ref) => BottomsheetMultiSelectionViewmodel.initial(
              initialSelectedItems,
            ),
          ),
          bottomsheetSearchProvider.overrideWith(
            (ref) => BottomsheetSearchViewmodel(items: items),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final searchVM = ref.watch(bottomsheetSearchProvider);
            final selectionVM = ref.watch(bottomsheetMultiSelectionProvider);

            // Update latest selections upward
            onSelectionChanged(selectionVM.selectedItems);

            return Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              padding: EdgeInsets.symmetric(vertical: 34.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labelText,
                    style: TextStyle(
                      color: AppColors.blue600,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 29.h),

                  if (items.length >= 5) ...[
                    // Search field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 33.w),
                      child: TextField(
                        onChanged: (val) => searchVM.query = val,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: AppColors.white700,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: AppColors.white700,
                              width: 1,
                            ),
                          ),
                          hintText: "جستجو...",
                          hintStyle: TextStyle(
                            color: AppColors.black300,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(left: 18.w),
                            child: SvgPicture.asset(AppIcons.searchStatus),
                          ),
                          suffixIconConstraints: BoxConstraints(
                            minHeight: 24.h,
                            minWidth: 24.w,
                          ),
                          contentPadding: EdgeInsets.only(right: 26.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // List
                  Flexible(
                    child: RawScrollbar(
                      thumbVisibility: true,
                      thickness: 8.w,
                      radius: const Radius.circular(20),
                      thumbColor: AppColors.black50,
                      padding: EdgeInsets.only(left: 10.w),
                      interactive: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchVM.filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = searchVM.filteredItems[index];
                          final isSelected = selectionVM.isSelected(item);

                          return ListTile(
                            onTap: () {
                              ref
                                  .read(bottomsheetMultiSelectionProvider)
                                  .toggle(item);
                              // No pop — stays open
                            },
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 44.w,
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                color: AppColors.blue600,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              isSelected
                                  ? AppIcons.tickCircleFilled
                                  : AppIcons.tickCircleEmpty,
                              width: 24.w,
                              height: 24.h,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      loading: () => SizedBox(
        height: 250,
        child: Center(child: LoadingAnimation()),
      ),
      error: (err, stack) => SizedBox(
        height: 250,
        child: Center(child: Text('خطا در گرفتن لیست')),
      ),
    );
  }
}
