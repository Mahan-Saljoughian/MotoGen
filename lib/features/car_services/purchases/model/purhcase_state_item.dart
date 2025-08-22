import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_validation.dart';

class PurhcaseStateItem
    with
        DateValidationForService,
        CostValidation,
        NotesValidation,
        LocationValidation,
        PartValidation
    implements
        CostSetters<PurhcaseStateItem>,
        NotesSetters<PurhcaseStateItem>,
        LocationSetters<PurhcaseStateItem>,
        PartSetters<PurhcaseStateItem>,
        ServiceModel {
  final String? purchaseId;

  @override
  final DateTime? date;
  @override
  final String? part;
  final PickerItem? purchaseCategory;

  @override
  final String? location;
  @override
  final int? cost;
  @override
  final String? rawCostInput;
  @override
  final String? notes;
  @override
  final bool isDateInteractedOnce;
  final bool isPurchaseCategoryInteractedOnce;

  PurhcaseStateItem({
    this.purchaseId,
    this.date,
    this.part,
    this.purchaseCategory,

    this.location,
    this.cost,
    this.rawCostInput,
    this.notes,
    this.isDateInteractedOnce = false,
    this.isPurchaseCategoryInteractedOnce = false,
  });

  @override
  String get id => purchaseId!;
  @override
  int get costMin => 1;
  @override
  int get costMax => 1000000000;
  @override
  String? get serviceNotes => notes;
  @override
  List<String> getTitleByIndex() => ["تاریخ:", "قطعه:", "دسته‌بندی:", "هزینه:"];
  @override
  List<String> getValueByIndex() => [
    formatJalaliDate(date!),
    "$part",
    purchaseCategory?.title ?? "",
    "${formatNumberByThreeDigit(cost!)} تومان",
  ];
  @override
  List<String> getTitleByIndexForMoreItems() => ["موقعیت:"];
  @override
  List<String> getValueByIndexForMoreItems() => [location!];

  @override
  PurhcaseStateItem copyWith({
    String? part,
    int? cost,
    String? rawCostInput,
    String? location,
    String? notes,
    String? purchaseId,
    DateTime? date,
    PickerItem? purchaseCategory,
    bool? isDateInteractedOnce,
    bool? isPurchaseCategoryInteractedOnce,
  }) {
    return PurhcaseStateItem(
      purchaseId: purchaseId ?? this.purchaseId,
      date: date ?? this.date,
      part: part ?? this.part,
      purchaseCategory: purchaseCategory ?? this.purchaseCategory,
      location: location ?? this.location,
      cost: cost ?? this.cost,
      rawCostInput: rawCostInput ?? this.rawCostInput,
      notes: notes ?? this.notes,
      isDateInteractedOnce: isDateInteractedOnce ?? this.isDateInteractedOnce,
      isPurchaseCategoryInteractedOnce:
          isPurchaseCategoryInteractedOnce ??
          this.isPurchaseCategoryInteractedOnce,
    );
  }

  Map<String, dynamic> toJson() => {
    'refuelId': purchaseId,
    'date': date?.toIso8601String(),
    'part': part,
    'purchaseCategory': purchaseCategory?.toJson(),
    'location': location,
    'cost': cost,
    'notes': notes,
  };

  factory PurhcaseStateItem.fromJson(Map<String, dynamic> json) =>
      PurhcaseStateItem(
        purchaseId: json['purchaseId'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        part: json['part'],
        purchaseCategory: json['purchaseCategory'] != null
            ? PickerItem.fromJson(json['purchaseCategory'])
            : null,
        location: json['location'],
        cost: json['cost'],
        notes: json['notes'],
      );

  Map<String, dynamic> toApiJson() {
    final data = <String, dynamic>{
      'date': date?.toIso8601String(),
      'part': part,
      'purchaseCategory': purchaseCategory?.id,
      'location': location,
      'cost': cost,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes,
    };
    return data;
  }

  factory PurhcaseStateItem.fromApiJson(
    Map<String, dynamic> json,
    List<PickerItem> purchaseCategories,
  ) {
    return PurhcaseStateItem(
      purchaseId: json['id'] as String,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      part: json['part'],

      purchaseCategory: purchaseCategories.firstWhere(
        (purchaseCategory) =>
            purchaseCategory.id == (json['purchaseCategory'] ?? ''),
        orElse: () => PickerItem(
          id: json['purchaseCategory'] ?? '',
          title: json['purchaseCategory'] ?? '',
        ),
      ),
      location: json['location'],
      cost: json['cost'],
      notes: json['notes'],
    );
  }

  String? get purchaseCategoryError =>
      isPurchaseCategoryInteractedOnce && purchaseCategory == null
      ? 'الزامی!'
      : null;
}
