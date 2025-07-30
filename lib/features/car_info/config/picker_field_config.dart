import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_info/config/picker_item.dart';
import 'package:motogen/features/car_info/data/car_info_providers.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';
import 'package:motogen/features/car_info/viewmodels/car_info_form_viewmodel.dart';

class PickerFieldConfig {
  final String labelText;
  final ProviderListenable<AsyncValue<List<PickerItem>>> Function(
    CarFormState state,
  )
  providerBuilder;

  final PickerItem? Function(CarFormState state) getter;
  final void Function(WidgetRef ref, PickerItem? val) setter;
  PickerFieldConfig({
    required this.labelText,
    required this.providerBuilder,
    required this.getter,
    required this.setter,
  });
}

PickerFieldConfig brandPickConfig = PickerFieldConfig(
  labelText: "برند خودرو",
  providerBuilder: (state) => carBrandsProvider,
  getter: (CarFormState state) => state.brand,
  setter: (WidgetRef ref, value) =>
      ref.read(carInfoFormProvider.notifier).setBrand(value),
);

PickerFieldConfig modelPickConfig = PickerFieldConfig(
  labelText: "مدل خودرو",
  providerBuilder: (state) => carModelsProvider(state.brand?.id ?? ''),
  getter: (CarFormState state) => state.model,
  setter: (WidgetRef ref, value) =>
      ref.read(carInfoFormProvider.notifier).setModel(value),
);

PickerFieldConfig typePickConfig = PickerFieldConfig(
  labelText: "تیپ خودرو",
  providerBuilder: (state) => carTypesProvider(state.model?.id ?? ''),
  getter: (CarFormState state) => state.type,
  setter: (WidgetRef ref, value) =>
      ref.read(carInfoFormProvider.notifier).setType(value),
);

final yearMadePickConfig = PickerFieldConfig(
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
    final year = value != null ? int.tryParse(value.id) : null;
    ref.read(carInfoFormProvider.notifier).setYearMade(year);
  },
);

PickerFieldConfig colorPickConfig = PickerFieldConfig(
  labelText: "رنگ خودرو",
  providerBuilder: carColorsAsyncProviderBuilder,
  getter: (CarFormState state) => state.color,
  setter: (WidgetRef ref, value) =>
      ref.read(carInfoFormProvider.notifier).setColor(value),
);

PickerFieldConfig fuelTypePickConfig = PickerFieldConfig(
  labelText: "نوع سوخت",
  providerBuilder: fuelTypesAsyncProviderBuilder,
  getter: (CarFormState state) => state.fuelType,
  setter: (WidgetRef ref, value) =>
      ref.read(carInfoFormProvider.notifier).setFuelType(value),
);
