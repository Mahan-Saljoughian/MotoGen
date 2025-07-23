import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/models/car_form_state.dart';
import 'package:motogen/viewmodels/car_info/bottomsheet_search_viewmodel.dart';
import 'package:motogen/viewmodels/car_info/bottomsheet_selection_viewmodel.dart';
import 'package:motogen/views/onboarding/car_info/picker_and_field_config.dart';

class BottomsheetListShow {
  static Future<void> showSelectionBottomSheet({
    required BuildContext context,
    required PickerFieldConfig config,
    required WidgetRef ref,
    required CarFormState state,
  }) async {
    final labelText = config.labelText;
    final items = config.items;
    final selectedItem = config.getter(state);
    String? latestSelectedItem = selectedItem;

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      builder: (ctx) => _BottomSheetContent(
        labelText: labelText,
        items: items,
        initalSelectedItem: selectedItem,
        onLatestSelectionChanged: (val) => latestSelectedItem = val,
      ),
    );

    config.setter(ref, result ?? latestSelectedItem);
  }
}

class _BottomSheetContent extends StatelessWidget {
  final String labelText;
  final List<String> items;
  final String? initalSelectedItem;
  final ValueChanged<String?> onLatestSelectionChanged;

  const _BottomSheetContent({
    required this.labelText,
    required this.items,
    required this.initalSelectedItem,
    required this.onLatestSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        bottomsheetSelectionProvider.overrideWith(
          (ref) => BottomsheetSelectionViewmodel.initial(initalSelectedItem),
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
          onLatestSelectionChanged(selectionVM.selectedItem);

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            padding: const EdgeInsets.symmetric(vertical: 34),
            child: Column(
              children: [
                // Title
                Text(
                  labelText,
                  style: TextStyle(
                    color: AppColors.blue600,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 29.h),

                // Search field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
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
                        padding: const EdgeInsets.only(left: 18),
                        child: SvgPicture.asset(
                          "assets/icons/search-status.svg",
                        ),
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

                // List
                Expanded(
                  child: RawScrollbar(
                    thumbVisibility: true,
                    thickness: 8.w,
                    radius: const Radius.circular(20),
                    thumbColor: AppColors.black50,
                    padding: const EdgeInsets.only(left: 10),
                    interactive: true,
                    child: ListView.builder(
                      itemCount: searchVM.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = searchVM.filteredItems[index];
                        final isSelected = selectionVM.isSelected(item);

                        return ListTile(
                          onTap: () {
                            ref.read(bottomsheetSelectionProvider).select(item);
                            Navigator.pop(context, item);
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 44,
                          ),
                          title: Text(
                            item,
                            style: TextStyle(
                              color: AppColors.blue600,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: SvgPicture.asset(
                            isSelected
                                ? "assets/icons/tick-circle-filled.svg"
                                : "assets/icons/tick-circle-empty.svg",
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
    );
  }
}
