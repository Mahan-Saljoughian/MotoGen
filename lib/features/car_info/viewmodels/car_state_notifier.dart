import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';

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

  void _ensureCarExists() {
    if (state.cars.isEmpty) {
      final newCar = CarFormStateItem();
      state = state.copyWith(cars: [newCar], currentCarId: newCar.carId);
    } else if (state.currentCarId == null) {
      state = state.copyWith(currentCarId: state.cars.first.carId);
    }
  }

  void _updateCurrentCar(CarFormStateItem Function(CarFormStateItem) updater) {
    _ensureCarExists();
    final carId = state.currentCarId ?? state.cars.first.carId;
    final updatedCars = state.cars.map((car) {
      if (car.carId == carId) {
        return updater(car);
      }
      return car;
    }).toList();
    state = state.copyWith(cars: updatedCars);
  }

  void ensureCarExists() => _ensureCarExists();

  // ---- Setters for form fields

  void setBrand(PickerItem? brand) {
    _updateCurrentCar(
      (car) => car.copyWith(
        brand: brand,
        isBrandInteractedOnce: true,
        model: PickerItem.noValueString,
        type: PickerItem.noValueString,
        yearMade: PickerItem.yearNoValue,
      ),
    );
  }

  void setModel(PickerItem? model) {
    _updateCurrentCar(
      (car) => car.copyWith(
        model: model,
        isModelInteractedOnce: true,
        type: PickerItem.noValueString,
        yearMade: PickerItem.yearNoValue,
      ),
    );
  }

  void setType(PickerItem? type) {
    _updateCurrentCar(
      (car) => car.copyWith(
        type: type,
        isTypeInteractedOnce: true,
        yearMade: PickerItem.yearNoValue,
      ),
    );
  }

  void setYearMade(int? year) {
    _updateCurrentCar(
      (car) => car.copyWith(yearMade: year, isYearMadeInteractedOnce: true),
    );
  }

  void setColor(PickerItem? color) {
    _updateCurrentCar(
      (car) => car.copyWith(color: color, isColorInteractedOnce: true),
    );
  }

  void setKilometerDriven(int? km) {
    _updateCurrentCar((car) => car.copyWith(kilometerDriven: km));
  }

  void setFuelType(PickerItem? fuel) {
    _updateCurrentCar(
      (car) => car.copyWith(fuelType: fuel, isFuelTypeInteractedOnce: true),
    );
  }

  void setBodyInsuranceExpiry(DateTime? date) {
    _updateCurrentCar(
      (car) => car.copyWith(
        bodyInsuranceExpiry: date,
        isBodyInsuranceExpiryInteractedOnce: true,
      ),
    );
  }

  void setNextTechnicalCheck(DateTime? date) {
    _updateCurrentCar(
      (car) => car.copyWith(
        nextTechnicalCheck: date,
        isNextTechnicalCheckInteractedOnce: true,
      ),
    );
  }

  void setThirdPersonInsuranceExpiry(DateTime? date) {
    _updateCurrentCar(
      (car) => car.copyWith(
        thirdPartyInsuranceExpiry: date,
        isThirdPartyInsuranceExpiryInteractedOnce: true,
      ),
    );
  }

  void setNickName(String? nickNameText) {
    _updateCurrentCar((car) => car.copyWith(nickName: nickNameText));
  }

  // ----kilometer validation------
  void setRawKilometerInput(String input) {
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(input);
    _updateCurrentCar((car) {
      final parsed = int.tryParse(normalized);
      return car.copyWith(
        rawKilometersInput: normalized,
        kilometerDriven: (parsed != null && parsed >= 0 && parsed <= 10000000)
            ? parsed
            : null,
      );
    });
  }

  // New: For multi-car, add a new car to the list
  void addNewCar(CarFormStateItem newCarFormStateItem) {
    state = state.copyWith(
      cars: [...state.cars, newCarFormStateItem],
      currentCarId: newCarFormStateItem.carId,
    );
  }

  void updateCarIdFromNull(String newId) {
    final updatedCars = state.cars.map((car) {
      if (car.carId == null) {
        return car.copyWith(carId: newId);
      }
      return car;
    }).toList();

    state = state.copyWith(cars: updatedCars, currentCarId: newId);
  }

  // New: Switch selected car
  void selectCar(String currentCarId) {
    if (state.cars.any((car) => car.carId == currentCarId)) {
      state = state.copyWith(currentCarId: currentCarId);
    }
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
