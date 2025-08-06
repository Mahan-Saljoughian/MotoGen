import 'package:hive_flutter/hive_flutter.dart';
import 'package:motogen/features/car_info/config/picker_item.dart';

part 'car_form_state.g.dart';

@HiveType(typeId: 0)
class CarFormState {
  @HiveField(0)
  final PickerItem? brand;
  @HiveField(1)
  final PickerItem? type;
  @HiveField(2)
  final PickerItem? model;
  @HiveField(3)
  final int? yearMade;
  @HiveField(4)
  final PickerItem? color;
  @HiveField(5)
  final int? kilometerDriven;
  @HiveField(6)
  final PickerItem? fuelType;
  @HiveField(7)
  final DateTime? bodyInsuranceExpiry;
  @HiveField(8)
  final DateTime? nextTechnicalCheck;
  @HiveField(9)
  final String? rawKilometersInput;
  @HiveField(10)
  final String? nickName;
  @HiveField(11)
  final DateTime? thirdPartyInsuranceExpiry;
  final bool isBrandInteractedOnce;
  final bool isModelInteractedOnce;
  final bool isTypeInteractedOnce;
  final bool isYearMadeInteractedOnce;
  final bool isFuelTypeInteractedOnce;
  final bool isBodyInsuranceExpiryInteractedOnce;
  final bool isColorInteractedOnce;
  final bool isNextTechnicalCheckInteractedOnce;
  final bool isThirdPartyInsuranceExpiryInteractedOnce;

  const CarFormState({
    this.brand,
    this.model,
    this.type,
    this.yearMade,
    this.color,
    this.kilometerDriven,
    this.fuelType,
    this.bodyInsuranceExpiry,
    this.thirdPartyInsuranceExpiry,
    this.nextTechnicalCheck,
    this.rawKilometersInput,
    this.nickName,
    this.isBrandInteractedOnce = false,
    this.isModelInteractedOnce = false,
    this.isTypeInteractedOnce = false,
    this.isYearMadeInteractedOnce = false,
    this.isFuelTypeInteractedOnce = false,
    this.isBodyInsuranceExpiryInteractedOnce = false,
    this.isColorInteractedOnce = false,
    this.isNextTechnicalCheckInteractedOnce = false,
    this.isThirdPartyInsuranceExpiryInteractedOnce = false,
  });

  CarFormState copyWith({
    PickerItem? brand,
    PickerItem? model,
    PickerItem? type,
    int? yearMade,
    PickerItem? color,
    int? kilometerDriven,
    PickerItem? fuelType,
    DateTime? bodyInsuranceExpiry,
    DateTime? nextTechnicalCheck,
    String? rawKilometersInput,
    DateTime? thirdPartyInsuranceExpiry,
    String? nickName,
    bool? isBrandInteractedOnce,
    bool? isModelInteractedOnce,
    bool? isTypeInteractedOnce,
    bool? isYearMadeInteractedOnce,
    bool? isFuelTypeInteractedOnce,
    bool? isBodyInsuranceExpiryInteractedOnce,
    bool? isColorInteractedOnce,
    bool? isNextTechnicalCheckInteractedOnce,
    bool? isThirdPartyInsuranceExpiryInteractedOnce,
  }) {
    return CarFormState(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      yearMade: yearMade ?? this.yearMade,
      color: color ?? this.color,
      kilometerDriven: kilometerDriven ?? this.kilometerDriven,
      fuelType: fuelType ?? this.fuelType,
      bodyInsuranceExpiry: bodyInsuranceExpiry ?? this.bodyInsuranceExpiry,
      nextTechnicalCheck: nextTechnicalCheck ?? this.nextTechnicalCheck,
      rawKilometersInput: rawKilometersInput ?? this.rawKilometersInput,
      thirdPartyInsuranceExpiry:
          thirdPartyInsuranceExpiry ?? this.thirdPartyInsuranceExpiry,
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
      isBodyInsuranceExpiryInteractedOnce:
          isBodyInsuranceExpiryInteractedOnce ??
          this.isBodyInsuranceExpiryInteractedOnce,
      isColorInteractedOnce:
          isColorInteractedOnce ?? this.isColorInteractedOnce,
      isNextTechnicalCheckInteractedOnce:
          isNextTechnicalCheckInteractedOnce ??
          this.isNextTechnicalCheckInteractedOnce,
      isThirdPartyInsuranceExpiryInteractedOnce:
          isThirdPartyInsuranceExpiryInteractedOnce ??
          this.isThirdPartyInsuranceExpiryInteractedOnce,
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
    "bodyInsuranceExpiry": bodyInsuranceExpiry?.toIso8601String(),
    "nextTechnicalCheck": nextTechnicalCheck?.toIso8601String(),
    "thirdPartyInsuranceExpiry": thirdPartyInsuranceExpiry?.toIso8601String(),
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
    bodyInsuranceExpiry: json['bodyInsuranceExpiry'] != null
        ? DateTime.parse(json['bodyInsuranceExpiry'])
        : null,
    nextTechnicalCheck: json['nextTechnicalCheck'] != null
        ? DateTime.parse(json['nextTechnicalCheck'])
        : null,
    thirdPartyInsuranceExpiry: json['thirdPartyInsuranceExpiry'] != null
        ? DateTime.parse(json['thirdPartyInsuranceExpiry'])
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

  String? get bodyInsuranceExpiryError =>
      isBodyInsuranceExpiryInteractedOnce && bodyInsuranceExpiry == null
      ? 'الزامی!'
      : null;

  String? get nextTechnicalCheckError =>
      isNextTechnicalCheckInteractedOnce && nextTechnicalCheck == null
      ? 'الزامی!'
      : null;

  String? get colorError =>
      isColorInteractedOnce && color == null ? 'الزامی!' : null;

  String? get thirdPartyInsuranceExpiryError =>
      isThirdPartyInsuranceExpiryInteractedOnce &&
          thirdPartyInsuranceExpiry == null
      ? 'الزامی!'
      : null;
}
