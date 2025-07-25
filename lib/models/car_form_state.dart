import 'package:motogen/views/onboarding/car_info/picker_item.dart';

class CarFormState {
  final PickerItem? brand;
  final PickerItem? model;
  final PickerItem? type;
  final int? yearMade;
  final PickerItem? color;
  final int? kilometerDriven;
  final PickerItem? fuelType;
  final DateTime? insuranceExpiry;
  final DateTime? nextTechnicalCheck;
  final String? rawKilometersInput;

  const CarFormState({
    this.brand,
    this.model,
    this.type,
    this.yearMade,
    this.color,
    this.kilometerDriven,
    this.fuelType,
    this.insuranceExpiry,
    this.nextTechnicalCheck,
    this.rawKilometersInput,
  });

  CarFormState copyWith({
    PickerItem? brand,
    PickerItem? model,
    PickerItem? type,
    int? yearMade,
    PickerItem? color,
    int? kilometerDriven,
    PickerItem? fuelType,
    DateTime? insuranceExpiry,
    DateTime? nextTechnicalCheck,
    String? rawKilometersInput,
  }) {
    return CarFormState(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      yearMade: yearMade ?? this.yearMade,
      color: color ?? this.color,
      kilometerDriven: kilometerDriven ?? this.kilometerDriven,
      fuelType: fuelType ?? this.fuelType,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      nextTechnicalCheck: nextTechnicalCheck ?? this.nextTechnicalCheck,
      rawKilometersInput: rawKilometersInput ?? this.rawKilometersInput,
    );
  }

  Map<String, dynamic> toJson() => {
    "brand": brand?.toJson(),
    "model": model?.toJson(),
    "type": type?.toJson(),
    "yearMade": yearMade,
    "color": color?.toJson(),
    "kilometerDriven": kilometerDriven,
    "fuelType": fuelType?.toJson(),
    "insuranceExpiry": insuranceExpiry?.toIso8601String(),
    "nextTechnicalCheck": nextTechnicalCheck?.toIso8601String(),
  };

  factory CarFormState.fromJson(Map<String, dynamic> json) => CarFormState(
    brand: json['brand'] != null ? PickerItem.fromJson(json['brand']) : null,
    model: json['model'] != null ? PickerItem.fromJson(json['model']) : null,
    type: json['type'] != null ? PickerItem.fromJson(json['type']) : null,
    yearMade: json['yearMade'],
    color: json['color'] != null ? PickerItem.fromJson(json['color']) : null,
    kilometerDriven: json['kilometerDriven'],
    fuelType: json['fuelType'] != null
        ? PickerItem.fromJson(json['fuelType'])
        : null,
    insuranceExpiry: json['insuranceExpiry'] != null
        ? DateTime.parse(json['insuranceExpiry'])
        : null,
    nextTechnicalCheck: json['nextTechnicalCheck'] != null
        ? DateTime.parse(json['nextTechnicalCheck'])
        : null,
  );
}
