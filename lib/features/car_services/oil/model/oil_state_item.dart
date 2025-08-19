import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_validation.dart';

class OilStateItem
    with
        DateValidationForService,
        CostValidation,
        NotesValidation,
        KilometerValidation,
        LocationValidation
    implements
        CostSetters<OilStateItem>,
        NotesSetters<OilStateItem>,
        KilometerSetters<OilStateItem>,
        LocationSetters<OilStateItem>,
        ServiceModel {
  final String? oilId;

  @override
  final DateTime? date;

  final PickerItem? oilType;
  final String? oilBrandAndModel;
  @override
  final int? kilometer;
  @override
  final String? rawKilometerInput;
  @override
  final String? location;
  @override
  final int? cost;
  @override
  final String? rawCostInput;
  final bool oilFilterChanged;
  final bool airFilterChanged;
  final bool cabinFilterChanged;
  final bool fuelFilterChanged;
  @override
  final String? notes;
  @override
  final bool isDateInteractedOnce;
  final bool isOilTypeInteractedOnce;

  OilStateItem({
    this.oilId,
    this.date,
    this.oilType,
    this.oilBrandAndModel,
    this.kilometer,
    this.rawKilometerInput,
    this.location,
    this.cost,
    this.rawCostInput,
    this.oilFilterChanged = false,
    this.airFilterChanged = false,
    this.cabinFilterChanged = false,
    this.fuelFilterChanged = false,
    this.notes,
    this.isDateInteractedOnce = false,
    this.isOilTypeInteractedOnce = false,
  });

  @override
  String get id => oilId!;
  @override
  List<String> getTitleByIndex() => [
    "تاریخ:",
    "برند و مدل:",
    "کیلومتر:",
    "هزینه:",
  ];
  @override
  List<String> getValueByIndex() => [
    formatJalaliDate(date!),
    oilBrandAndModel!,
    formatNumberByThreeDigit(kilometer!),
    "${formatNumberByThreeDigit(cost!)} تومان",
  ];
  @override
  List<String> getTitleByIndexForMoreItems() {
    final hasAnyFilterChanged = [
      oilFilterChanged,
      airFilterChanged,
      cabinFilterChanged,
      fuelFilterChanged,
    ].any((f) => f == true);
    final titles = <String>[];
    if (hasAnyFilterChanged) {
      titles.add("تعویض فیلتر:");
    }
    titles.add("موقعیت:");
    return titles;
  }

  @override
  List<String> getValueByIndexForMoreItems() {
    final filters = <String>[];
    if (oilFilterChanged == true) filters.add("فیلتر روغن");
    if (airFilterChanged == true) filters.add("فیلتر هوا");
    if (cabinFilterChanged == true) filters.add("فیلتر کابین");
    if (fuelFilterChanged == true) filters.add("فیلتر سوخت");

    final values = <String>[];
    if (filters.isNotEmpty) {
      values.add(filters.join("، "));
    }
    values.add(location ?? "");
    return values;
  }

  @override
  String? get serviceNotes => notes;

  @override
  OilStateItem copyWith({
    int? kilometer,
    String? rawKilometerInput,
    int? cost,
    String? rawCostInput,
    String? location,
    String? notes,
    String? oilId,
    DateTime? date,
    PickerItem? oilType,
    String? oilBrandAndModel,
    bool? oilFilterChanged,
    bool? airFilterChanged,
    bool? cabinFilterChanged,
    bool? fuelFilterChanged,
    bool? isDateInteractedOnce,
    bool? isOilTypeInteractedOnce,
  }) {
    return OilStateItem(
      oilId: oilId ?? this.oilId,
      date: date ?? this.date,
      oilType: oilType ?? this.oilType,
      oilBrandAndModel: oilBrandAndModel ?? this.oilBrandAndModel,
      kilometer: kilometer ?? this.kilometer,
      rawKilometerInput: rawKilometerInput ?? this.rawKilometerInput,
      location: location ?? this.location,
      cost: cost ?? this.cost,
      rawCostInput: rawCostInput ?? this.rawCostInput,
      notes: notes ?? this.notes,
      oilFilterChanged: oilFilterChanged ?? this.oilFilterChanged,
      airFilterChanged: airFilterChanged ?? this.airFilterChanged,
      cabinFilterChanged: cabinFilterChanged ?? this.cabinFilterChanged,
      fuelFilterChanged: fuelFilterChanged ?? this.fuelFilterChanged,
      isDateInteractedOnce: isDateInteractedOnce ?? this.isDateInteractedOnce,
      isOilTypeInteractedOnce:
          isOilTypeInteractedOnce ?? this.isOilTypeInteractedOnce,
    );
  }

  Map<String, dynamic> toJson() => {
    'oilId': oilId,
    'date': date?.toIso8601String(),
    'oilType': oilType?.toJson(),
    'oilBrandAndModel': oilBrandAndModel,
    'kilometer': kilometer,
    'location': location,
    'cost': cost,
    'oilFilterChanged': oilFilterChanged,
    'airFilterChanged': airFilterChanged,
    'cabinFilterChanged': cabinFilterChanged,
    'fuelFilterChanged': fuelFilterChanged,
    'notes': notes,
  };

  factory OilStateItem.fromJson(Map<String, dynamic> json) => OilStateItem(
    oilId: json['oilId'],
    date: json['date'] != null ? DateTime.parse(json['date']) : null,
    oilType: json['oilType'] != null
        ? PickerItem.fromJson(json['oilType'])
        : null,
    oilBrandAndModel: json['oilBrandAndModel'],
    kilometer: json['kilometer'],
    location: json['location'],
    cost: json['cost'],
    oilFilterChanged: json['oilFilterChanged'],
    airFilterChanged: json['airFilterChanged'],
    cabinFilterChanged: json['cabinFilterChanged'],
    fuelFilterChanged: json['fuelFilterChanged'],
    notes: json['notes'],
  );

  Map<String, dynamic> toApiJson() {
    final data = <String, dynamic>{
      'date': date?.toIso8601String(),
      'oilType': oilType?.id,
      'oilBrandAndModel': oilBrandAndModel,
      'kilometer': kilometer,
      'location': location,
      'cost': cost,
      if (oilType?.id == "ENGINE") ...{
        'oilFilterChanged': oilFilterChanged,
        'airFilterChanged': airFilterChanged,
        'cabinFilterChanged': cabinFilterChanged,
        'fuelFilterChanged': fuelFilterChanged,
      },
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes,
    };
    return data;
  }

  factory OilStateItem.fromApiJson(
    Map<String, dynamic> json,
    List<PickerItem> oilTypes,
  ) {
    final type = oilTypes.firstWhere(
      (oilType) => oilType.id == (json['oilType'] ?? ''),
      orElse: () =>
          PickerItem(id: json['oilType'] ?? '', title: json['oilType'] ?? ''),
    );
    return OilStateItem(
      oilId: json['id'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      oilType: type,
      oilBrandAndModel: json['oilBrandAndModel'],
      kilometer: json['kilometer'],
      location: json['location'],
      cost: json['cost'],
      oilFilterChanged: type.id == "ENGINE"
          ? (json['oilFilterChanged'])
          : false,
      airFilterChanged: type.id == "ENGINE"
          ? (json['airFilterChanged'])
          : false,
      cabinFilterChanged: type.id == "ENGINE"
          ? (json['cabinFilterChanged'])
          : false,
      fuelFilterChanged: type.id == "ENGINE"
          ? (json['fuelFilterChanged'])
          : false,
      notes: json['notes'],
    );
  }

  String? get oilTypeError =>
      isOilTypeInteractedOnce && oilType == null ? 'الزامی!' : null;
}
