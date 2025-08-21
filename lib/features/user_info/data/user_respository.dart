

import 'package:logger/web.dart';
import 'package:motogen/core/services/api_service.dart';



class UserRespository {
  final ApiService _api = ApiService();
  var logger = Logger();
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
    
      final response = await _api.get(
        "users/me"
      );
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to get user profile');
      }
      final data = response['data'];
      return data;
    } catch (e) {
      logger.e("debug Error getting user profile");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchUserProfile(
    Map<String, String> body,
  ) async {
    try {
 
      final response = await _api.patch(
        "users/me",
        body
      );
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to patch user profile');
      }
      final data = response['data'];
      return data;
    } catch (e) {
      logger.e("debug Error patching user profile");
      rethrow;
    }
  }
}
