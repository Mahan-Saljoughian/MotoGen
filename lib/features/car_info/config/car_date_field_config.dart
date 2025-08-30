import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';

DateFieldConfig<CarFormStateItem> bodyInsuranceExpiryDateConfig =
    DateFieldConfig<CarFormStateItem>(
      labelText: "تاریخ انقضای بیمه (اختیاری)",
      getter: (state) => state.bodyInsuranceExpiry,
      setter: (WidgetRef ref, value) => ref.setBodyInsuranceExpiry(value),
      usageType: DateUsageType.insurance,
    );

DateFieldConfig<CarFormStateItem> thirdPersonInsuranceExpiryDateConfig =
    DateFieldConfig<CarFormStateItem>(
      labelText: "تاریخ انقضای بیمه شخص ثالث",
      getter: (state) => state.thirdPartyInsuranceExpiry,
      setter: (WidgetRef ref, value) =>
          ref.setThirdPersonInsuranceExpiry(value),
      usageType: DateUsageType.insurance,
    );

DateFieldConfig<CarFormStateItem> nextTechnicalCheckDateConfig =
    DateFieldConfig<CarFormStateItem>(
      labelText: "تاریخ معاینه فنی بعدی",
      getter: (state) => state.nextTechnicalCheck,
      setter: (WidgetRef ref, value) => ref.setNextTechnicalCheck(value),
      usageType: DateUsageType.insurance,
    );
