
import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/core/services/logger.dart';

class ReminderRepository  {
  final ApiService _api = ApiService();
  Future<List<Map<String, dynamic>>> getAllReminders(String carId) async {
    try {
      final response = await _api.get("users/me/cars/$carId/reminders");
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to get reminder for car with carId : $carId',
        );
      }
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      appLogger.e("debug Error getting reminder for car with carId : $carId");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchReminderById(
    Map<String, dynamic> changes,
    String carId,
    String reminderId,
  ) async {
    try {
      final response = await _api.patch(
        "users/me/cars/$carId/reminders/$reminderId",
        changes,
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to patch reminder with reminderId : $reminderId for car with carId: $carId',
        );
      }
      return response;
    } catch (e, st) {
      appLogger.e(
        "Error patching reminder with reminderId : $reminderId for car with carId: $carId: $e , $st",
      );
      rethrow;
    }
  }
}
