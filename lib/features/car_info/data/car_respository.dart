
import 'package:logger/web.dart';
import 'package:motogen/core/services/api_service.dart';

import 'package:motogen/core/storage/token_flutter_secure_storage.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';

class CarRespository {
  final ApiService _api = ApiService();
  var logger = Logger();


  Future<Map<String, dynamic>> completeProfile(
    CarFormStateItem carState,
    Map<String, dynamic> userInfo,
  ) async {
    final accessToken = await getAccessToken();
    final data = {
      'userInformation': userInfo,
      'carInformation': {
        'productYear': carState.yearMade,
        'color': carState.color?.id,
        'kilometer': carState.kilometerDriven,
        'fuel': carState.fuelType?.id,
        'thirdPartyInsuranceExpiry': carState.thirdPartyInsuranceExpiry
            ?.toIso8601String(),
        if (carState.bodyInsuranceExpiry != null)
          'bodyInsuranceExpiry': carState.bodyInsuranceExpiry
              ?.toIso8601String(),
        'nextTechnicalInspectionDate': carState.nextTechnicalCheck
            ?.toIso8601String(),
        'carTrimId': carState.type?.id,
        if (carState.nickName != null && carState.nickName!.trim().isNotEmpty)
          'nickName': carState.nickName,
      },
    };

    final response = await _api.post(
      "users/me/complete-profile",
      data,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to complete profile');
    }

    return response;
  }

  Future<List<Map<String, dynamic>>> getAllCars() async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.get(
        "users/me/cars",
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to get car info');
      }
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      logger.e("debug Error getting car info");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCarInfoById(String carId) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.get(
        "users/me/cars/$carId",
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to get car info by carId : $carId',
        );
      }
      return response;
    } catch (e) {
      logger.e("debug Error getting car info by carId : $carId");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _patchField(
    String carId,
    Map<String, dynamic> data,
  ) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.patch(
        "users/me/cars/$carId",
        data,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to patch car field for ID: $carId',
        );
      }
      return response;
    } catch (e) {
      logger.e("Error patching car field for ID $carId: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchProductYear(
    String carId,
    int productYear,
  ) async {
    return await _patchField(carId, {'productYear': productYear});
  }

  Future<Map<String, dynamic>> patchColor(String carId, String colorId) async {
    return await _patchField(carId, {'color': colorId});
  }

  Future<Map<String, dynamic>> patchKilometer(
    String carId,
    int kilometer,
  ) async {
    return await _patchField(carId, {'kilometer': kilometer});
  }

  Future<Map<String, dynamic>> patchFuel(String carId, String fuelId) async {
    return await _patchField(carId, {'fuel': fuelId});
  }

  Future<Map<String, dynamic>> patchThirdPartyInsuranceExpiry(
    String carId,
    DateTime expiry,
  ) async {
    return await _patchField(carId, {
      'thirdPartyInsuranceExpiry': expiry.toIso8601String(),
    });
  }

  Future<Map<String, dynamic>> patchBodyInsuranceExpiry(
    String carId,
    DateTime expiry,
  ) async {
    return await _patchField(carId, {
      'bodyInsuranceExpiry': expiry.toIso8601String(),
    });
  }

  Future<Map<String, dynamic>> patchNextTechnicalInspectionDate(
    String carId,
    DateTime date,
  ) async {
    return await _patchField(carId, {
      'nextTechnicalInspectionDate': date.toIso8601String(),
    });
  }

  Future<Map<String, dynamic>> patchCarTrimId(
    String carId,
    String trimId,
  ) async {
    return await _patchField(carId, {'carTrimId': trimId});
  }

  Future<Map<String, dynamic>> patchNickName(
    String carId,
    String nickName,
  ) async {
    if (nickName.trim().isEmpty) throw Exception('Nickname cannot be empty');
    return await _patchField(carId, {'nickName': nickName.trim()});
  }

  Future<Map<String, dynamic>> postCarInfo(CarFormStateItem carState) async {
    try {
      final accessToken = await getAccessToken();

      final data = {
        "productYear": carState.yearMade,
        "color": carState.color?.id,
        "kilometer": carState.kilometerDriven,
        "fuel": carState.fuelType?.id,

        'thirdPartyInsuranceExpiry': carState.thirdPartyInsuranceExpiry
            ?.toIso8601String(),
        if (carState.bodyInsuranceExpiry != null)
          "bodyInsuranceExpiry": carState.bodyInsuranceExpiry
              ?.toIso8601String(),
        "nextTechnicalInspectionDate": carState.nextTechnicalCheck
            ?.toIso8601String(),
        "carTrimId": carState.type?.id,
        if (carState.nickName != null && carState.nickName!.trim().isNotEmpty)
          'nickName': carState.nickName,
      };
      final response = await _api.post(
        "users/me/cars",
        data,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to post user profile');
      }

      return response;
    } catch (e) {
      logger.e("debug Error posting user profile");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteCarInfoById(String carId) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.delete(
        "users/me/cars/$carId",
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to delete car info with carId: $carId',
        );
      }

      return response;
    } catch (e) {
      logger.e("debug Error deleting car info with carId: $carId");
      rethrow;
    }
  }
}
