import 'package:flutter/rendering.dart';

// ignore: constant_identifier_names
enum IntervalType { DAYS, KILOMETERS, FIXED_DATE, orElse }

enum DoneType { tick, add }

class ReminderStateItem {
  final String reminderId;
  final String type;
  final IntervalType intervalType;
  final int intervalValue;
  final bool enabled;
  final int? lastKilometer;
  final DateTime? lastDate;
  final bool haveBaseValue;
  final int? remainingValue;

  ReminderStateItem({
    required this.reminderId,
    required this.type,
    required this.intervalType,
    required this.intervalValue,
    required this.enabled,
    this.lastKilometer,
    this.lastDate,
    required this.haveBaseValue,
    this.remainingValue,
  });

  ReminderStateItem copyWith({
    String? reminderId,
    String? type,
    IntervalType? intervalType,
    int? intervalValue,
    bool? enabled,
    int? lastKilometer,
    DateTime? lastDate,
    bool? hasBaseValue,
    int? remainingValue,
  }) {
    return ReminderStateItem(
      reminderId: reminderId ?? this.reminderId,
      type: type ?? this.type,
      intervalType: intervalType ?? this.intervalType,
      intervalValue: intervalValue ?? this.intervalValue,
      enabled: enabled ?? this.enabled,
      lastKilometer: lastKilometer ?? this.lastKilometer,
      lastDate: lastDate ?? this.lastDate,
      haveBaseValue: hasBaseValue ?? this.haveBaseValue,
      remainingValue: remainingValue ?? this.remainingValue,
    );
  }

  factory ReminderStateItem.fromAPIJson(Map<String, dynamic> json) {
    final safeInterval = IntervalType.values.firstWhere(
      (e) => e.name == json['intervalType'],
      orElse: () => IntervalType.orElse,
    );

    // Optional: log when fallback is used
    if (safeInterval == IntervalType.orElse) {
      debugPrint('⚠ Unknown intervalType from API: ${json['intervalType']}');
      debugPrint('Full JSON: $json');
    }

    return ReminderStateItem(
      reminderId: json['id'] as String,
      type: json['type'] as String,

      intervalType: safeInterval,
      intervalValue: json['intervalValue'] as int,
      enabled: json['enabled'] as bool,
      lastKilometer: safeInterval == IntervalType.KILOMETERS
          ? json['lastKilometer'] as int?
          : null,
      lastDate:
          (safeInterval == IntervalType.DAYS ||
              safeInterval == IntervalType.FIXED_DATE)
          ? (json['lastDate'] != null
                ? DateTime.parse(json['lastDate'] as String)
                : null)
          : null,
      haveBaseValue: json['haveBaseValue'] as bool,
      remainingValue: json['remainingValue'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminderId': reminderId,
      'type': type,
      'intervalType': intervalType.toString().split('.').last,
      'intervalValue': intervalValue,
      'enabled': enabled,
      if (intervalType == IntervalType.KILOMETERS)
        'lastKilometer': lastKilometer,
      if (intervalType == IntervalType.DAYS ||
          intervalType == IntervalType.FIXED_DATE)
        'lastDate': lastDate?.toIso8601String(),
      'haveBaseValue': haveBaseValue,
    };
  }

  static const Map<String, String> faTypeJSON = {
    "ENGINE_OIL_CHECK": "بررسی روغن موتور",
    "RADIATOR_WATER_CHECK": "بررسی آب رادیاتور",
    "TIRE_PRESSURE_ADJUSTMENT": "تنظیم باد لاستیک",
    "SPARE_TIRE_PRESSURE_ADJUSTMENT": "تنظیم باد لاستیک زاپاس",
    "TURN_ON_AC": "روشن کردن کولر (فقط زمستان)",
    "BRAKE_OIL_CHANGE": "تعویض روغن ترمز",
    "ENGINE_OIL_CHANGE": "تعویض روغن موتور",
    "STEERING_OIL_CHANGE": "تعویض روغن فرمان",
    "GEARBOX_OIL_CHANGE": "تعویض روغن گیربکس",
    "TIMING_BELT_CHANGE": "تعویض تسمه تایم",
    "BODY_INSURANCE_VALIDITY": "اعتبار بیمه بدنه",
    "THIRD_PARTY_INSURANCE_VALIDITY": "اعتبار بیمه شخص ثالث",
    "VEHICLE_INSPECTION_VALIDITY": "اعتبار معاینه فنی",
  };

  static const Map<String, DoneType> doneType = {
    "ENGINE_OIL_CHECK": DoneType.tick,
    "RADIATOR_WATER_CHECK": DoneType.tick,
    "TIRE_PRESSURE_ADJUSTMENT": DoneType.tick,
    "SPARE_TIRE_PRESSURE_ADJUSTMENT": DoneType.tick,
    "TURN_ON_AC": DoneType.tick,
    "BRAKE_OIL_CHANGE": DoneType.add,
    "ENGINE_OIL_CHANGE": DoneType.add,
    "STEERING_OIL_CHANGE": DoneType.add,
    "GEARBOX_OIL_CHANGE": DoneType.add,
    "TIMING_BELT_CHANGE": DoneType.add,
    "BODY_INSURANCE_VALIDITY": DoneType.add,
    "THIRD_PARTY_INSURANCE_VALIDITY": DoneType.add,
    "VEHICLE_INSPECTION_VALIDITY": DoneType.add,
  };

  static String translate(String type) {
    return faTypeJSON[type] ?? type; // fallback
  }

  static DoneType getDoneType(String type) {
    return doneType[type] ?? DoneType.add; // fallback
  }
}
