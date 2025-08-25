import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_info/data/car_info_providers.dart';
import 'package:motogen/features/car_info/data/car_respository.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';

extension CarUseCaseApi on CarStateNotifier {
  CarRespository get _carRepository => CarRespository();

  Future<Map<String, dynamic>> completeProfileFromDraft({
    required bool isSetNickName,
    required Map<String, String> userInfo,
    required CarFormStateItem draft,
  }) async {
    try {
      final draftToSend = isSetNickName
          ? draft.copyWith(nickName: draft.nickName?.trim())
          : draft;

      final response = await _carRepository.completeProfile(
        draftToSend,
        userInfo,
      );
      final data = response['data'];
      final carId = data['carId'] as String?;
      commitDraft(draftToSend, carId!);
      ref.invalidate(carDraftProvider);

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

  Future<void> fetchCarWithId(String carId) async {
    final carInfoResponse = await _carRepository.getCarInfoById(carId);
    final fuelTypes = ref.read(fuelTypesProvider);
    updateCarById(carId, (currentCar) {
      return currentCar.copyWith(
        model: PickerItem(
          id: carInfoResponse['carModelId'],
          title: carInfoResponse['modelTitle'],
        ),
        type: PickerItem(
          id: carInfoResponse['carTrimId'],
          title: carInfoResponse['trimTitle'],
        ),
        yearMade: carInfoResponse['productYear'],
        color: PickerItem(id: null, title: carInfoResponse['color']),
        kilometer: carInfoResponse['kilometer'],
        fuelType: fuelTypes.firstWhere(
          (payment) => payment.id == (carInfoResponse['fuel'] ?? ''),
          orElse: () => PickerItem(
            id: carInfoResponse['fuel'] ?? '',
            title: carInfoResponse['fuel'] ?? '',
          ),
        ),
        thirdPartyInsuranceExpiry:
            carInfoResponse['thirdPartyInsuranceExpiry'] != null
            ? DateTime.parse(
                carInfoResponse['thirdPartyInsuranceExpiry'] as String,
              )
            : null,
        bodyInsuranceExpiry: carInfoResponse['bodyInsuranceExpiry'] != null
            ? DateTime.parse(carInfoResponse['bodyInsuranceExpiry'] as String)
            : null,
        nextTechnicalCheck:
            carInfoResponse['nextTechnicalInspectionDate'] != null
            ? DateTime.parse(
                carInfoResponse['nextTechnicalInspectionDate'] as String,
              )
            : null,
      );
    });
  }

  Future<void> addCarFromDraft(CarFormStateItem draft) async {
    try {
      final response = await _carRepository.postCarInfo(draft);
      final data = response['data'];
      final carId = data['id'] as String?;
      commitDraft(draft, carId!);
    } catch (e) {
      debugPrint("debug Error adding car");
      rethrow;
    }
  }

  Future<void> updateCarFromDraft(
    CarFormStateItem draft,
    CarFormStateItem original,
  ) async {
    final Map<String, dynamic> changes = {};

    if (draft.type != original.type) {
      changes['carTrimID'] = draft.type?.id;
    }
    if (draft.yearMade != original.yearMade) {
      changes['productYear'] = draft.yearMade;
    }
    if (draft.color?.title != original.color?.title) {
      changes['color'] = draft.color?.id;
    }
    if (draft.kilometer != original.kilometer) {
      changes['kilometer'] = draft.kilometer;
    }
    if (draft.fuelType?.title != original.fuelType?.title) {
      changes['fuel'] = draft.fuelType?.id;
    }
    if (draft.bodyInsuranceExpiry != original.bodyInsuranceExpiry) {
      changes['bodyInsuranceExpiry'] = draft.bodyInsuranceExpiry
          ?.toIso8601String();
    }
    if (draft.thirdPartyInsuranceExpiry != original.thirdPartyInsuranceExpiry) {
      changes['thirdPartyInsuranceExpiry'] = draft.thirdPartyInsuranceExpiry
          ?.toIso8601String();
    }
    if (draft.nextTechnicalCheck != original.nextTechnicalCheck) {
      changes['nextTechnicalInspectionDate'] = draft.nextTechnicalCheck
          ?.toIso8601String();
    }
    if (draft.nickName != original.nickName) {
      changes['nickName'] = draft.nickName;
    }

    if (changes.isEmpty) {
      // Nothing changed, skip request
      return;
    }

    try {
      await _carRepository.patchCarById(changes, original.carId!);
      updateCarById(original.carId!, (currentCar) {
        return currentCar.copyWith(
          type: changes.containsKey('carTrimID') ? draft.type : currentCar.type,
          yearMade: changes.containsKey('productYear')
              ? draft.yearMade
              : currentCar.yearMade,
          color: changes.containsKey('color') ? draft.color : currentCar.color,
          kilometer: changes.containsKey('kilometer')
              ? draft.kilometer
              : currentCar.kilometer,
          fuelType: changes.containsKey('fuel')
              ? draft.fuelType
              : currentCar.fuelType,
          bodyInsuranceExpiry: changes.containsKey('bodyInsuranceExpiry')
              ? draft.bodyInsuranceExpiry
              : currentCar.bodyInsuranceExpiry,
          thirdPartyInsuranceExpiry:
              changes.containsKey('thirdPartyInsuranceExpiry')
              ? draft.thirdPartyInsuranceExpiry
              : currentCar.thirdPartyInsuranceExpiry,
          nextTechnicalCheck: changes.containsKey('nextTechnicalInspectionDate')
              ? draft.nextTechnicalCheck
              : currentCar.nextTechnicalCheck,
          nickName: changes.containsKey('nickName')
              ? draft.nickName
              : currentCar.nickName,
        );
      });
    } catch (e, st) {
      Logger().e(
        "Error patching car with ${original.carId} with ${changes.toString()}, error : $e , stacktrace: $st",
      );
      rethrow;
    }
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
