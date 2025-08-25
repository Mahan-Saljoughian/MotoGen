import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_info/data/car_info_providers.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';

PickerFieldConfig<CarFormStateItem> brandPickConfig =
    PickerFieldConfig<CarFormStateItem>(
      labelText: "برند خودرو",
      providerBuilder: (state) => carBrandsProvider,
      getter: (state) => state.brand,
      setter: (WidgetRef ref, value) =>
          ref.setBrand(value),
    );

PickerFieldConfig<CarFormStateItem> modelPickConfig =
    PickerFieldConfig<CarFormStateItem>(
      labelText: "مدل خودرو",
      providerBuilder: (state) => carModelsProvider(state.brand?.id ?? ''),
      getter: (state) => state.model,
      setter: (WidgetRef ref, value) =>
          ref.setModel(value),
    );

PickerFieldConfig<CarFormStateItem> typePickConfig =
    PickerFieldConfig<CarFormStateItem>(
      labelText: "تیپ خودرو",
      providerBuilder: (state) => carTypesProvider(state.model?.id ?? ''),
      getter: (state) => state.type,
      setter: (WidgetRef ref, value) =>
          ref.setType(value),
    );
PickerFieldConfig<CarFormStateItem> yearMadePickConfig =
    PickerFieldConfig<CarFormStateItem>(
      labelText: "سال ساخت",
      providerBuilder: (state) => yearMadeProvider((
        modelId: state.model?.id ?? '',
        typeId: state.type?.id ?? '',
      )),
      getter: (state) => state.yearMade != null
          ? PickerItem(
              id: state.yearMade.toString(),
              title: state.yearMade.toString(),
            )
          : null,
      setter: (ref, value) {
        final year = value != null ? int.tryParse(value.id!) : null;
        ref.setYearMade(year);
      },
    );

PickerFieldConfig<CarFormStateItem> colorPickConfig =
    PickerFieldConfig<CarFormStateItem>(
      labelText: "رنگ خودرو",
      providerBuilder: (state) => colorProvider,
      getter: (state) => state.color,
      setter: (WidgetRef ref, value) =>
          ref.setColor(value),
    );

PickerFieldConfig<CarFormStateItem> fuelTypePickConfig =
    PickerFieldConfig<CarFormStateItem>(
      labelText: "نوع سوخت",
      providerBuilder: fuelTypesAsyncProviderBuilder,
      getter: (state) => state.fuelType,
      setter: (WidgetRef ref, value) =>
          ref.setFuelType(value),
    );
