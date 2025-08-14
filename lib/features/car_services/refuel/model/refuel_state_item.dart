import 'package:motogen/features/bottom_sheet/config/picker_item.dart';

class RefuelStateItem {
  final String? refuelId;
  final DateTime? date;
  final double? liters;
  final String? rawLitersInput;
  final PickerItem? paymentMethod;
  final double? cost;
  final String? rawCostInput;
  final String? notes;
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

  RefuelStateItem copyWith({
    String? refuelId,
    DateTime? date,
    double? liters,
    String? rawLitersInput,
    PickerItem? paymentMethod,
    double? cost,
    String? rawCostInput,
    String? notes,
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
        liters: json['liters'] != null
            ? (json['liters'] as num).toDouble()
            : null,
        paymentMethod: json['paymentMethod'] != null
            ? PickerItem.fromJson(json['paymentMethod'])
            : null,
        cost: json['cost'] != null ? (json['cost'] as num).toDouble() : null,
        notes: json['notes'],
      );

  String? get refuelDateError =>
      isDateInteractedOnce && date == null ? 'الزامی!' : null;

  String? get refuelPaymentMethodError =>
      ispaymentMethodInteractedOnce && paymentMethod == null ? 'الزامی!' : null;
}
