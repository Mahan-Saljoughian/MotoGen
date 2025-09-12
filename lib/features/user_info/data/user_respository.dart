import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/core/services/logger.dart';

class UserRespository {
  final ApiService _api = ApiService();
  
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _api.get("users/me");
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to get user profile');
      }
      final data = response['data'];
      return data;
    } catch (e) {
      appLogger.e("debug Error getting user profile");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchUserProfile(
    Map<String, String> changes,
  ) async {
    try {
      final response = await _api.patch("users/me", changes);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to patch user profile');
      }
      return Map<String, dynamic>.from(response['data'] as Map);
    } catch (e) {
      appLogger.e("debug Error patching user profile");
      rethrow;
    }
  }
}
