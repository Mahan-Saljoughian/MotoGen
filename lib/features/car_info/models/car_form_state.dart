import 'package:motogen/features/car_info/models/car_form_state_item.dart';

class CarFormState {
  final List<CarFormStateItem> cars;
  final String? currentCarId;

  const CarFormState({this.cars = const [], this.currentCarId});

  CarFormState copyWith({List<CarFormStateItem>? cars, String? currentCarId}) {
    return CarFormState(
      cars: cars ?? this.cars,
      currentCarId: currentCarId ?? this.currentCarId,
    );
  }

  String? getCurrentCarId() => currentCarId;

  bool get hasCars => cars.isNotEmpty;

  CarFormStateItem? get currentCar {
    if (cars.isEmpty) return CarFormStateItem();
    return cars.firstWhere(
      (car) => car.carId == currentCarId,
      orElse: () => cars.first,
    );
  }
}
