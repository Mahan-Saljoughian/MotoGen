class CarFormState {
  final String? brand;
  final String? model;
  final String? type;
  final int? yearMade;
  final String? color;
  final int? kilometerDriven;
  final String? fuelType;
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
    this.fuelType ,
    this.insuranceExpiry,
    this.nextTechnicalCheck,
    this.rawKilometersInput
  });

  CarFormState copyWith({
    String? brand,
    String? model,
    String? type,
    int? yearMade,
    String? color,
    int? kilometerDriven,
    String? fuelType,
    DateTime? insuranceExpiry,
    DateTime? nextTechnicalCheck,
    String? rawKilometersInput
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
      rawKilometersInput : rawKilometersInput ?? this.rawKilometersInput
    );
  }

  Map<String, dynamic> toJson() => {
    "brand": brand,
    "model": model,
    "type": type,
    "yearMade": yearMade,
    "color": color,
    "kilometerDriven": kilometerDriven,
    "fuelType": fuelType,
    "insuranceExpiry": insuranceExpiry?.toIso8601String(),
    "nextTechnicalCheck": nextTechnicalCheck?.toIso8601String(),
  };

  factory CarFormState.fromJson(Map<String, dynamic> json) => CarFormState(
    brand: json['brand'],
    model: json['model'],
    type: json['type'],
    yearMade: json['yearMade'],
    color: json['color'],
    kilometerDriven: json['kilometerDriven'],
    fuelType: json['fuelType'],
    insuranceExpiry: json['insuranceExpiry'] != null
        ? DateTime.parse(json['insuranceExpiry'])
        : null,
    nextTechnicalCheck: json['nextTechnicalCheck'] != null
        ? DateTime.parse(json['nextTechnicalCheck'])
        : null,
  );
}
