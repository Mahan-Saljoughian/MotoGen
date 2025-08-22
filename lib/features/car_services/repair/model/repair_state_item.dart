import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_validation.dart';

class RepairStateItem
    with
        DateValidationForService,
        CostValidation,
        NotesValidation,
        KilometerValidation,
        LocationValidation,
        PartValidation
    implements
        CostSetters<RepairStateItem>,
        NotesSetters<RepairStateItem>,
        KilometerSetters<RepairStateItem>,
        LocationSetters<RepairStateItem>,
        PartSetters<RepairStateItem>,
        ServiceModel {
  final String? repairId;

  @override
  final DateTime? date;
  @override
  final String? part;
  final PickerItem? repairAction;
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
  @override
  final String? notes;
  @override
  final bool isDateInteractedOnce;
  final bool isRepairActionInteractedOnce;

  RepairStateItem({
    this.repairId,
    this.date,
    this.part,
    this.repairAction,
    this.kilometer,
    this.rawKilometerInput,
    this.location,
    this.cost,
    this.rawCostInput,
    this.notes,
    this.isDateInteractedOnce = false,
    this.isRepairActionInteractedOnce = false,
  });

  @override
  String get id => repairId!;
  @override
  int get costMin => 1;
  @override
  int get costMax => 1000000000;
  @override
  String? get serviceNotes => notes;
  @override
  List<String> getTitleByIndex() => ["تاریخ:", "قطعه:", "اقدامات:", "هزینه:"];
  @override
  List<String> getValueByIndex() => [
    formatJalaliDate(date!),
    "$part",
    repairAction?.title ?? "",
    "${formatNumberByThreeDigit(cost!)} تومان",
  ];
  @override
  List<String> getTitleByIndexForMoreItems() => ["کیلومتر:", "موقعیت:"];
  @override
  List<String> getValueByIndexForMoreItems() => [
    formatNumberByThreeDigit(kilometer!),
    location!,
  ];

  @override
  RepairStateItem copyWith({
    String? part,
    int? kilometer,
    String? rawKilometerInput,
    int? cost,
    String? rawCostInput,
    String? location,
    String? notes,
    String? repairId,
    DateTime? date,
    PickerItem? repairAction,
    bool? isDateInteractedOnce,
    bool? isRepairActionInteractedOnce,
  }) {
    return RepairStateItem(
      repairId: repairId ?? this.repairId,
      date: date ?? this.date,
      part: part ?? this.part,
      repairAction: repairAction ?? this.repairAction,
      kilometer: kilometer ?? this.kilometer,
      rawKilometerInput: rawKilometerInput ?? this.rawKilometerInput,
      location: location ?? this.location,
      cost: cost ?? this.cost,
      rawCostInput: rawCostInput ?? this.rawCostInput,
      notes: notes ?? this.notes,
      isDateInteractedOnce: isDateInteractedOnce ?? this.isDateInteractedOnce,
      isRepairActionInteractedOnce:
          isRepairActionInteractedOnce ?? this.isRepairActionInteractedOnce,
    );
  }

  Map<String, dynamic> toJson() => {
    'repairId': repairId,
    'date': date?.toIso8601String(),
    'part': part,
    'repairAction': repairAction?.toJson(),
    'kilometer': kilometer,
    'location': location,
    'cost': cost,
    'notes': notes,
  };

  factory RepairStateItem.fromJson(Map<String, dynamic> json) =>
      RepairStateItem(
        repairId: json['repairId'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        part: json['part'],
        repairAction: json['repairAction'] != null
            ? PickerItem.fromJson(json['repairAction'])
            : null,
        kilometer: json['kilometer'],
        location: json['location'],
        cost: json['cost'],
        notes: json['notes'],
      );

  Map<String, dynamic> toApiJson() {
    final data = <String, dynamic>{
      'date': date?.toIso8601String(),
      'part': part,
      'repairAction': repairAction?.id,
      'kilometer': kilometer,
      'location': location,
      'cost': cost,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes,
    };
    return data;
  }

  factory RepairStateItem.fromApiJson(
    Map<String, dynamic> json,
    List<PickerItem> repairActions,
  ) {
    return RepairStateItem(
      repairId: json['id'] as String,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      part: json['part'],

      repairAction: repairActions.firstWhere(
        (repairAction) => repairAction.id == (json['repairAction'] ?? ''),
        orElse: () => PickerItem(
          id: json['repairAction'] ?? '',
          title: json['repairAction'] ?? '',
        ),
      ),
      kilometer: json['kilometer'],
      location: json['location'],
      cost: json['cost'],
      notes: json['notes'],
    );
  }

  String? get repairActionError =>
      isRepairActionInteractedOnce && repairAction == null ? 'الزامی!' : null;
}
