// features/car_info/viewmodels/car_use_case_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_info/data/car_respository.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';

final carUseCaseProvider = NotifierProvider<CarUseCaseNotifier, void>(
  () => CarUseCaseNotifier(),
);

class CarUseCaseNotifier extends Notifier<void> {
  final _carRepository = CarRespository();

  @override
  void build() {
    // No state needed
  }

  Future<Map<String, dynamic>> completeProfile({
    required bool isSetNickName,
    required String nickNametext,
    required Map<String, String> userInfo,
  }) async {
    try {
      final stateNotifier = ref.read(carStateNotifierProvider.notifier);
      stateNotifier.ensureCarExists();
      if (isSetNickName) {
        stateNotifier.setNickName(nickNametext.trim());
      }
      final currentCarState =
          ref.read(carStateNotifierProvider).currentCar ??
          const CarFormStateItem();
      final response = await _carRepository.completeProfile(
        currentCarState,
        userInfo,
      );
      final data = response['data'];
      final carId = data['carId'] as String?;

      if (carId != null) {
        stateNotifier.updateCarIdFromNull(carId);
      }
      return response;
    } catch (e) {
      Logger().e('Complete profile error : $e');
      rethrow;
    }
  }

  Future<void> fetchAllCars() async {
    final stateNotifier = ref.read(carStateNotifierProvider.notifier);
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
    stateNotifier.setCars(cars);
  }
}
