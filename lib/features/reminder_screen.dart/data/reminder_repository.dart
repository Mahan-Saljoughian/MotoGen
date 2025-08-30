import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';
import 'package:motogen/core/services/api_service.dart';

class ReminderRepository  {
  final ApiService _api = ApiService();
  var logger = Logger();

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
      logger.e("debug Error getting reminder for car with carId : $carId");
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
      logger.e(
        "Error patching reminder with reminderId : $reminderId for car with carId: $carId: $e , $st",
      );
      rethrow;
    }
  }
}
