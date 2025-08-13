import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_sevices/refuel/config/refuel_info_list.dart';
import 'package:motogen/features/car_sevices/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_sevices/refuel/viewmodel/refuel_list_notifier.dart';
import 'package:motogen/features/car_sevices/refuel/viewmodel/refuel_validation.dart';
import 'package:motogen/features/bottom_sheet/widgets/build_form_fields.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';

class AddRefuelScreen extends ConsumerWidget {
  const AddRefuelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(refuelDraftProvider);
    debugPrint(
      'debug DRAFT: id=${draft.refuelId}, '
      'date=${draft.date}, '
      'paymentMethod=${draft.paymentMethod}, '
      'liter=${draft.liters}'
      'cost=${draft.cost}'
      'note=${draft.notes}',
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h, right: 20.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref.invalidate(refuelDraftProvider);
                          litersController.clear();
                          costController.clear();
                          notesController.clear();
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(
                          AppIcons.arrowRight,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      SizedBox(width: 100.w),
                      Text(
                        "ثبت سوخت جدید",
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 24.w,
                      left: 38.w,
                      top: 88.h,
                    ),
                    child: BuildFormFields<RefuelStateItem>(
                      provider: refuelDraftProvider,
                      fieldsBuilder: (state, ref) =>
                          buildRefuelInfoFields(state, ref),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 90,
              right: 40,
              child: OnboardingButton(
                enabled: ref.watch(isRepairInfoButtonEnabled),
                text: "ثبت",
                onPressed: () {
                  final draft = ref.read(refuelDraftProvider);
                  final carId = ref.read(carStateNotifierProvider).currentCarId;

                  final newRefuel = RefuelStateItem(
                    refuelId: "created_temp_id",
                    date: draft.date,
                    paymentMethod: draft.paymentMethod,
                    liters: draft.liters,
                    cost: draft.cost,
                    notes: draft.notes,
                  );
                  ref
                      .read(refuelListProvider(carId!).notifier)
                      .addRefuel(newRefuel);
                  ref.read(refuelDraftProvider.notifier).state =
                      RefuelStateItem(refuelId: "temp_id");

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Local provider still scoped to this screen
final refuelDraftProvider = StateProvider<RefuelStateItem>(
  (ref) => RefuelStateItem(refuelId: "temp_id"),
);

// Local provider inside build so it uses the same ProviderScope override
final isRepairInfoButtonEnabled = Provider<bool>((ref) {
  final refuelState = ref.watch(refuelDraftProvider);
  return refuelState.isLitersValid &&
      refuelState.isCostValid &&
      refuelState.isNoteValid &&
      refuelState.date != null &&
      refuelState.liters != null &&
      refuelState.paymentMethod != null &&
      refuelState.cost != null;
});
