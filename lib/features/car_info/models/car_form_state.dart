import 'package:motogen/features/car_info/config/picker_item.dart';

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
  final String? nickName;
  final bool isBrandInteractedOnce;
  final bool isModelInteractedOnce;
  final bool isTypeInteractedOnce;
  final bool isYearMadeInteractedOnce;
  final bool isFuelTypeInteractedOnce;
  final bool isInsuranceExpiryInteractedOnce;
  final bool isColorInteractedOnce;
  final bool isNextTechnicalCheckInteractedOnce;

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
    this.nickName,
    this.isBrandInteractedOnce = false,
    this.isModelInteractedOnce = false,
    this.isTypeInteractedOnce = false,
    this.isYearMadeInteractedOnce = false,
    this.isFuelTypeInteractedOnce = false,
    this.isInsuranceExpiryInteractedOnce = false,
    this.isColorInteractedOnce = false,
    this.isNextTechnicalCheckInteractedOnce = false,
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
    String? nickName,
    bool? isBrandInteractedOnce,
    bool? isModelInteractedOnce,
    bool? isTypeInteractedOnce,
    bool? isYearMadeInteractedOnce,
    bool? isFuelTypeInteractedOnce,
    bool? isInsuranceExpiryInteractedOnce,
    bool? isColorInteractedOnce,
    bool? isNextTechnicalCheckInteractedOnce,
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
      nickName: nickName ?? this.nickName,
      isBrandInteractedOnce:
          isBrandInteractedOnce ?? this.isBrandInteractedOnce,
      isModelInteractedOnce:
          isModelInteractedOnce ?? this.isModelInteractedOnce,
      isTypeInteractedOnce: isTypeInteractedOnce ?? this.isTypeInteractedOnce,
      isYearMadeInteractedOnce:
          isYearMadeInteractedOnce ?? this.isYearMadeInteractedOnce,
      isFuelTypeInteractedOnce:
          isFuelTypeInteractedOnce ?? this.isFuelTypeInteractedOnce,
      isInsuranceExpiryInteractedOnce:
          isInsuranceExpiryInteractedOnce ??
          this.isInsuranceExpiryInteractedOnce,
      isColorInteractedOnce:
          isColorInteractedOnce ?? this.isColorInteractedOnce,
      isNextTechnicalCheckInteractedOnce:
          isNextTechnicalCheckInteractedOnce ??
          this.isNextTechnicalCheckInteractedOnce,
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
    "nickName": nickName,
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
    nickName: json['nickName'],
  );

  String? get kilometerError {
    final text = rawKilometersInput;
    if (text == null || text.trim().isEmpty) {
      return 'الزامی!';
    }
    final parsed = int.tryParse(text);
    if (parsed == null || parsed >= 0 && parsed <= 10000000) {
      return 'کیلومتر باید بین 0 تا 10,000,000 باشد';
    }
    return null;
  }

  bool get isKilometerValid => kilometerError == null;

  String? get brandError =>
      isBrandInteractedOnce && brand == null ? 'الزامی!' : null;

  String? get modelError =>
      isModelInteractedOnce &&
          (model == null || model == PickerItem.noValueString)
      ? 'الزامی!'
      : null;

  String? get typeError =>
      isTypeInteractedOnce && (type == null || type == PickerItem.noValueString)
      ? 'الزامی!'
      : null;

  String? get yearMadeError =>
      isYearMadeInteractedOnce &&
          (yearMade == null || yearMade == PickerItem.yearNoValue)
      ? 'الزامی!'
      : null;

  String? get fuelTypeError =>
      isFuelTypeInteractedOnce && fuelType == null ? 'الزامی!' : null;

  String? get insuranceExpiryError =>
      isInsuranceExpiryInteractedOnce && insuranceExpiry == null
      ? 'الزامی!'
      : null;

  String? get nextTechnicalCheckError =>
      isNextTechnicalCheckInteractedOnce && nextTechnicalCheck == null
      ? 'الزامی!'
      : null;

  String? get colorError =>
      isColorInteractedOnce && color == null ? 'الزامی!' : null;
}
