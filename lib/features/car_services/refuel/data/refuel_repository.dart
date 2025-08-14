import 'package:logger/web.dart';
import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/core/storage/token_flutter_secure_storage.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';

class RefuelRepository {
  final ApiService _api = ApiService();
  var logger = Logger();

  Future<List<Map<String, dynamic>>> getALLRefuels(String carId) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.get(
        "users/me/cars/$carId/refuels",
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to get refuel info for carId : $carId',
        );
      }
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      logger.e("debug Error getting  refuel info for carId : $carId");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postRefuelInfo(
    RefuelStateItem refuelState,
    String carId,
  ) async {
    try {
      final accessToken = await getAccessToken();

      final data = {
        "liters": refuelState.liters,
        "cost": refuelState.cost,
        "paymentMethod": refuelState.paymentMethod?.id,
        "date": refuelState.date?.toIso8601String(),
        if (refuelState.notes != null && refuelState.notes!.trim().isNotEmpty)
          'notes': refuelState.notes,
      };
      final response = await _api.post(
        "users/me/cars/$carId/refuels",
        data,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to post refuel info for carId : $carId',
        );
      }

      return response;
    } catch (e, st) {
      logger.e("debug Error posting refuel info for carId : $carId , $st ,$e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteRefuelItemById(
    String carId,
    String refuelId,
  ) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.delete(
        "users/me/cars/$carId/refuels/$refuelId",
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to delete refuel item with carId: $carId refuelId : $refuelId',
        );
      }
      return response;
    } catch (e) {
      logger.e(
        "debug Error deleting refuel item with carId: $carId refuelId : $refuelId",
      );
      rethrow;
    }
  }
}
