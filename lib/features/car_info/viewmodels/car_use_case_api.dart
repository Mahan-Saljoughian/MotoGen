import 'package:logger/logger.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_info/data/car_respository.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';

extension CarUseCaseApi on CarStateNotifier {
  CarRespository get _carRepository => CarRespository();

  Future<Map<String, dynamic>> completeProfile({
    required bool isSetNickName,
    required String nickNametext,
    required Map<String, String> userInfo,
  }) async {
    try {
      ensureCarExists();
      if (isSetNickName) {
        setNickName(nickNametext.trim());
      }

      final response = await _carRepository.completeProfile(
        currentCar,
        userInfo,
      );
      final data = response['data'];
      final carId = data['carId'] as String?;

      if (carId != null) {
        updateCarIdFromNull(carId);
      }
      return response;
    } catch (e) {
      Logger().e('Complete profile error : $e');
      rethrow;
    }
  }

  Future<void> fetchAllCars() async {
    final carsData = await _carRepository.getAllCars();

    final cars = carsData.map((car) {
      return CarFormStateItem(
        carId: car['id'],
        brand: PickerItem(id: null, title: car['CarBrandTitle'] ?? ''),
        model: PickerItem(id: null, title: car['carModelTitle'] ?? ''),
        type: PickerItem(id: null, title: car['carTrimTitle'] ?? ''),
        nickName: car['nickName'] ?? '',
      );
    }).toList();
    setCars(cars);
  }

  Future<void> deleteSelectedCar(String carId) async {
    try {
      final indexToRemove = currentState.cars.indexWhere(
        (car) => car.carId == carId,
      );
      if (indexToRemove == -1) {
        throw Exception("Car with ID $carId not found in state.");
      }

      final response = await _carRepository.deleteCarInfoById(carId);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? "Failed to delete car");
      }

      final updatedCars = List<CarFormStateItem>.from(currentState.cars);
      updatedCars.removeAt(indexToRemove);
      setCars(updatedCars);
    } catch (e) {
      Logger().e("Error deleting car (id: $carId): $e");
      rethrow;
    }
  }
}
