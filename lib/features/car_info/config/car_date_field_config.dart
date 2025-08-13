import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';



DateFieldConfig<CarFormStateItem> bodyInsuranceExpiryDateConfig =
    DateFieldConfig<CarFormStateItem>(
      labelText: "تاریخ انقضای بیمه (اختیاری)",
      getter: (state) => state.bodyInsuranceExpiry,
      setter: (WidgetRef ref, value) => ref
          .read(carStateNotifierProvider.notifier)
          .setBodyInsuranceExpiry(value),
    );

DateFieldConfig<CarFormStateItem> thirdPersonInsuranceExpiryDateConfig =
    DateFieldConfig<CarFormStateItem>(
      labelText: "تاریخ انقضای بیمه شخص ثالث",
      getter: (state) => state.thirdPartyInsuranceExpiry,
      setter: (WidgetRef ref, value) => ref
          .read(carStateNotifierProvider.notifier)
          .setThirdPersonInsuranceExpiry(value),
    );

DateFieldConfig<CarFormStateItem> nextTechnicalCheckDateonfig =
    DateFieldConfig<CarFormStateItem>(
      labelText: "تاریخ معاینه فنی بعدی",
      getter: (state) => state.nextTechnicalCheck,
      setter: (WidgetRef ref, value) => ref
          .read(carStateNotifierProvider.notifier)
          .setNextTechnicalCheck(value),
    );
