import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';

class CompleteProfileApi {
  final _api = ApiService();
  final _secureStorage = FlutterSecureStorage();

  Future<Map<String, dynamic>> completeProfile(
    CarFormState carState,
    Map<String, dynamic> userInfo,
  ) async {
    final accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception("no access token found");
    }
    final data = {
      'userInformation': userInfo,
      'carInformation': {
        'productYear': carState.yearMade,
        'color': carState.color?.id,
        'kilometer': carState.kilometerDriven,
        'fuel': carState.fuelType?.id,
        'thirdPartyInsuranceExpiry': carState.thirdPartyInsuranceExpiry
            ?.toIso8601String(),
        'bodyInsuranceExpiry': carState.bodyInsuranceExpiry?.toIso8601String(),
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
}
