import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_validation.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';

class CarFormStateItem
    with KilometerValidation
    implements KilometerSetters<CarFormStateItem> {
  final String? carId;
  final PickerItem? brand;
  final PickerItem? type;
  final PickerItem? model;
  final int? yearMade;
  final PickerItem? color;
  @override
  final int? kilometer;
  @override
  final String? rawKilometerInput;
  final PickerItem? fuelType;
  final DateTime? bodyInsuranceExpiry;
  final DateTime? nextTechnicalCheck;
  final String? nickName;
  final DateTime? thirdPartyInsuranceExpiry;

  final List<RefuelStateItem> refuels;
  final List<RepairStateItem> repairs;
  final bool isBrandInteractedOnce;
  final bool isModelInteractedOnce;
  final bool isTypeInteractedOnce;
  final bool isYearMadeInteractedOnce;
  final bool isFuelTypeInteractedOnce;
  final bool isBodyInsuranceExpiryInteractedOnce;
  final bool isColorInteractedOnce;
  final bool isNextTechnicalCheckInteractedOnce;
  final bool isThirdPartyInsuranceExpiryInteractedOnce;

  const CarFormStateItem({
    this.carId,
    this.brand,
    this.model,
    this.type,
    this.yearMade,
    this.color,
    this.kilometer,
    this.rawKilometerInput,
    this.fuelType,
    this.bodyInsuranceExpiry,
    this.thirdPartyInsuranceExpiry,
    this.nextTechnicalCheck,
    this.nickName,
    this.refuels = const [],
    this.repairs = const [],
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
  @override
  CarFormStateItem copyWith({
    int? kilometer,
    String? rawKilometerInput,
    String? carId,
    PickerItem? brand,
    PickerItem? model,
    PickerItem? type,
    int? yearMade,
    PickerItem? color,
    PickerItem? fuelType,
    DateTime? bodyInsuranceExpiry,
    DateTime? nextTechnicalCheck,
    DateTime? thirdPartyInsuranceExpiry,
    String? nickName,
    List<RefuelStateItem>? refuels,
    List<RepairStateItem>? repairs,
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
    return CarFormStateItem(
      carId: carId ?? this.carId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      yearMade: yearMade ?? this.yearMade,
      color: color ?? this.color,
      kilometer: kilometer ?? this.kilometer,
      rawKilometerInput: rawKilometerInput ?? this.rawKilometerInput,
      fuelType: fuelType ?? this.fuelType,
      bodyInsuranceExpiry: bodyInsuranceExpiry ?? this.bodyInsuranceExpiry,
      nextTechnicalCheck: nextTechnicalCheck ?? this.nextTechnicalCheck,

      thirdPartyInsuranceExpiry:
          thirdPartyInsuranceExpiry ?? this.thirdPartyInsuranceExpiry,
      nickName: nickName ?? this.nickName,
      refuels: refuels ?? this.refuels,
      repairs: repairs ?? this.repairs,
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
    "carId": carId,
    "brand": brand?.toJson(),
    "model": model?.toJson(),
    "type": type?.toJson(),
    "yearMade": yearMade,
    "color": color?.toJson(),
    "kilometer": kilometer,
    "fuelType": fuelType?.toJson(),
    "bodyInsuranceExpiry": bodyInsuranceExpiry?.toIso8601String(),
    "nextTechnicalCheck": nextTechnicalCheck?.toIso8601String(),
    "thirdPartyInsuranceExpiry": thirdPartyInsuranceExpiry?.toIso8601String(),
    "nickName": nickName,
    "refuels": refuels.map((r) => r.toJson()).toList(),
    "repairs": repairs.map((r) => r.toJson()).toList(),
  };

  factory CarFormStateItem.fromJson(
    Map<String, dynamic> json,
  ) => CarFormStateItem(
    carId: json['carId'],
    brand: json['brand'] != null ? PickerItem.fromJson(json['brand']) : null,
    model: json['model'] != null ? PickerItem.fromJson(json['model']) : null,
    type: json['type'] != null ? PickerItem.fromJson(json['type']) : null,
    yearMade: json['yearMade'],
    color: json['color'] != null ? PickerItem.fromJson(json['color']) : null,
    kilometer: json['kilometer'],
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
    refuels:
        (json['refuels'] as List<dynamic>?)
            ?.map((e) => RefuelStateItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    repairs:
        (json['repairs'] as List<dynamic>?)
            ?.map((e) => RepairStateItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );

Map<String, dynamic> toApiJson({Map<String, dynamic>? userInfo}) {
  final carInfo = {
    'productYear': yearMade,
    'color': color?.id,
    'kilometer': kilometer,
    'fuel': fuelType?.id,
    'thirdPartyInsuranceExpiry': thirdPartyInsuranceExpiry?.toIso8601String(),
    if (bodyInsuranceExpiry != null)
      'bodyInsuranceExpiry': bodyInsuranceExpiry?.toIso8601String(),
    'nextTechnicalInspectionDate': nextTechnicalCheck?.toIso8601String(),
    'carTrimId': type?.id,
    if (nickName != null && nickName!.trim().isNotEmpty)
      'nickName': nickName,
  };

  if (userInfo != null) {
    return {
      'userInformation': userInfo,
      'carInformation': carInfo,
    };
  } else {
    return carInfo;
  }
}

}
