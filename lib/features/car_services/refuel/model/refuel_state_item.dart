import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_validation.dart';

class RefuelStateItem
    with DateValidationForService, CostValidation, NotesValidation
    implements
        CostSetters<RefuelStateItem>,
        NotesSetters<RefuelStateItem>,
        ServiceModel {
  final String? refuelId;
  @override
  final DateTime? date;
  final int? liters;
  final String? rawLitersInput;
  final PickerItem? paymentMethod;
  @override
  final int? cost;
  @override
  final String? rawCostInput;
  @override
  final String? notes;
  @override
  final bool isDateInteractedOnce;
  final bool ispaymentMethodInteractedOnce;

  RefuelStateItem({
    this.refuelId,
    this.date,
    this.liters,
    this.rawLitersInput,
    this.paymentMethod,
    this.cost,
    this.rawCostInput,
    this.notes,
    this.isDateInteractedOnce = false,
    this.ispaymentMethodInteractedOnce = false,
  });

  @override
  String get id => refuelId!;
  @override
  int get costMin => 1500;
  @override
  int get costMax => 10000000;
  @override
  String? get serviceNotes => notes;
  @override
  List<String> getTitleByIndex() => [
    "تاریخ:",
    "مقدار افزوده:",
    "روش پرداخت:",
    "هزینه:",
  ];
  @override
  List<String> getValueByIndex() => [
    formatJalaliDate(date!),
    "$liters لیتر",
    paymentMethod?.title ?? "",
    "${formatNumberByThreeDigit(cost!)} تومان",
  ];
  @override
  List<String> getTitleByIndexForMoreItems() => [];
  @override
  List<String> getValueByIndexForMoreItems() => [];

  @override
  RefuelStateItem copyWith({
    String? part, //unused
    int? kilometer, //unused
    String? rawKilometerInput, //unused
    int? cost,
    String? rawCostInput,
    String? location,
    String? notes,
    String? refuelId,
    DateTime? date,
    int? liters,
    String? rawLitersInput,
    PickerItem? paymentMethod,
    bool? isDateInteractedOnce,
    bool? ispaymentMethodInteractedOnce,
  }) {
    return RefuelStateItem(
      refuelId: refuelId ?? this.refuelId,
      date: date ?? this.date,
      liters: liters ?? this.liters,
      rawLitersInput: rawLitersInput ?? this.rawLitersInput,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cost: cost ?? this.cost,
      rawCostInput: rawCostInput ?? this.rawCostInput,
      notes: notes ?? this.notes,
      isDateInteractedOnce: isDateInteractedOnce ?? this.isDateInteractedOnce,
      ispaymentMethodInteractedOnce:
          ispaymentMethodInteractedOnce ?? this.ispaymentMethodInteractedOnce,
    );
  }

  Map<String, dynamic> toJson() => {
    'refuelId': refuelId,
    'date': date?.toIso8601String(),
    'liters': liters,
    'paymentMethod': paymentMethod?.toJson(),
    'cost': cost,
    'notes': notes,
  };

  factory RefuelStateItem.fromJson(Map<String, dynamic> json) =>
      RefuelStateItem(
        refuelId: json['refuelId'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        liters: json['liters'],
        paymentMethod: json['paymentMethod'] != null
            ? PickerItem.fromJson(json['paymentMethod'])
            : null,
        cost: json['cost'],
        notes: json['notes'],
      );

  Map<String, dynamic> toApiJson() {
    final data = <String, dynamic>{
      'liters': liters,
      'cost': cost,
      'paymentMethod': paymentMethod?.id,
      'date': date?.toIso8601String(),
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes,
    };
    return data;
  }

  factory RefuelStateItem.fromApiJson(
    Map<String, dynamic> json,
    List<PickerItem> paymentMethods,
  ) {
    return RefuelStateItem(
      refuelId: json['id'] as String,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      liters: json['liters'],
      cost: json['cost'],
      paymentMethod: paymentMethods.firstWhere(
        (payment) => payment.id == (json['paymentMethod'] ?? ''),
        orElse: () => PickerItem(
          id: json['paymentMethod'] ?? '',
          title: json['paymentMethod'] ?? '',
        ),
      ),
      notes: json['notes'],
    );
  }

  String? get refuelPaymentMethodError =>
      ispaymentMethodInteractedOnce && paymentMethod == null ? 'الزامی!' : null;
}
