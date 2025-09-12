import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';

class CarRespository {
  final ApiService _api = ApiService();


  Future<Map<String, dynamic>> completeProfile(
    CarFormStateItem carState,
    Map<String, dynamic> userInfo,
  ) async {
    final data = carState.toApiJson(userInfo: userInfo);
    final response = await _api.post("users/me/complete-profile", data);

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to complete profile');
    }

    return response;
  }

  Future<List<Map<String, dynamic>>> getAllCars() async {
    try {
      final response = await _api.get("users/me/cars");
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to get car info');
      }
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      appLogger.e("debug Error getting car info");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCarInfoById(String carId) async {
    try {
      final response = await _api.get("users/me/cars/$carId");
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to get car info by carId : $carId',
        );
      }
      return response['data'];
    } catch (e) {
      appLogger.e("debug Error getting car info by carId : $carId");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchCarById(
    Map<String, dynamic> changes,
    String carId,
  ) async {
    try {
      final response = await _api.patch("users/me/cars/$carId", changes);
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to patch car with carId: $carId',
        );
      }
      return response;
    } catch (e, st) {
      appLogger.e("Error patching car with carId: $carId: $e , $st");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postCarInfo(CarFormStateItem carState) async {
    try {
      final data = carState.toApiJson();
      final response = await _api.post("users/me/cars", data);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to post user profile');
      }
      return response;
    } catch (e) {
      appLogger.e("debug Error posting car ");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteCarInfoById(String carId) async {
    try {
      final response = await _api.delete("users/me/cars/$carId");
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to delete car info with carId: $carId',
        );
      }

      return response;
    } catch (e) {
      appLogger.e("debug Error deleting car info with carId: $carId");
      rethrow;
    }
  }
}
