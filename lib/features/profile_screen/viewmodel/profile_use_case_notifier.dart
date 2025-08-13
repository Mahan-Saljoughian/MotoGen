// features/car_info/viewmodels/car_use_case_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:motogen/features/car_info/data/car_respository.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';

final profileUseCaseProvider = NotifierProvider<ProfileUseCaseNotifier, void>(
  () => ProfileUseCaseNotifier(),
);

class ProfileUseCaseNotifier extends Notifier<void> {
  final _carRepository = CarRespository();

  @override
  void build() {
    // No state needed
  }

  Future<void> deleteSelectedCar(String carId) async {
    try {
      final cars = ref.read(carStateNotifierProvider).cars;

      final indexToRemove = cars.indexWhere((car) => car.carId == carId);
      if (indexToRemove == -1) {
        throw Exception("Car with ID $carId not found in state.");
      }

      final response = await _carRepository.deleteCarInfoById(carId);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? "Failed to delete car");
      }

      final updatedCars = List<CarFormStateItem>.from(cars);
      updatedCars.removeAt(indexToRemove);
      ref.read(carStateNotifierProvider.notifier).setCars(updatedCars);
    } catch (e) {
      Logger().e("Error deleting car (id: $carId): $e");
      rethrow;
    }
  }
}
