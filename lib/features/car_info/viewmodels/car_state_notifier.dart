import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';


final carStateNotifierProvider =
    NotifierProvider<CarStateNotifier, CarFormState>(() => CarStateNotifier());

class CarStateNotifier extends Notifier<CarFormState> {
  CarFormState get currentState => state;
  CarFormStateItem get currentCar =>
      state.currentCar ?? const CarFormStateItem();

  final kilometeDrivenController = TextEditingController();

  @override
  CarFormState build() {
    return const CarFormState();
  }

  // New: For multi-car, add a new car to the list
  void addNewCar(CarFormStateItem newCarFormStateItem) {
    state = state.copyWith(
      cars: [...state.cars, newCarFormStateItem],
      currentCarId: newCarFormStateItem.carId,
    );
  }

  void commitDraft(CarFormStateItem draft, String newId) {
    final committed = draft.copyWith(carId: newId);
    addNewCar(committed);
  }

  CarFormStateItem getCarById(String carId) {
    return state.cars.firstWhere((car) => car.carId == carId);
  }

  // New: Switch selected car
  void selectCar(String currentCarId) {
    if (state.cars.any((car) => car.carId == currentCarId)) {
      state = state.copyWith(currentCarId: currentCarId);
    }
  }

  void updateCarById(
    String carId,
    CarFormStateItem Function(CarFormStateItem) updater,
  ) {
    final updatedCars = [
      for (final car in state.cars) car.carId == carId ? updater(car) : car,
    ];

    setCars(updatedCars);
  }

  void setCars(List<CarFormStateItem> cars) {
    String? newCurrentCarId = state.currentCarId;

    if (cars.isEmpty) {
      newCurrentCarId = null;
    } else if (newCurrentCarId == null ||
        !cars.any((c) => c.carId == newCurrentCarId)) {
      newCurrentCarId = cars
          .firstWhere((c) => c.carId != null, orElse: () => cars.first)
          .carId;
    }

    state = state.copyWith(cars: cars, currentCarId: newCurrentCarId);
  }
}
