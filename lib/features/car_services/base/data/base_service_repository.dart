import 'package:logger/logger.dart';
import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/core/storage/token_flutter_secure_storage.dart';

abstract class BaseServiceRepository<T> {
  final ApiService _api = ApiService();
  final logger = Logger();

  /// Subclasses must override
  String get endpoint; // e.g. "refuels", "repairs"

  Map<String, dynamic> toApiJson(T item); // serialize

  Future<List<Map<String, dynamic>>> getAllItems(
    String carId,
    String? sortType,
    String? oilType,
  ) async {
    try {
      final accessToken = await getAccessToken();
      final queryParams = [
        if (oilType != null) 'oilType=$oilType',
        if (sortType != null) 'order=$sortType',
      ].join('&');
      final response = await _api.get(
        "users/me/$carId/$endpoint${queryParams.isNotEmpty ? '?$queryParams' : ''}",
        /* cars/ */
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to get $endpoint for carId: $carId with sort type : $sortType and oilType $oilType',
        );
      }
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e, st) {
      logger.e(
        "Error getting $endpoint for carId: $carId with sort type : $sortType and oilType $oilType: $e,$st",
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postItem(T item, String carId) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.post(
        "users/me/$carId/$endpoint",
        toApiJson(item),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      logger.d("debug Repair post response: $response");
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to post $endpoint for carId: $carId',
        );
      }
      return response;
    } catch (e, st) {
      logger.e("Error posting $endpoint for carId: $carId: $e , $st");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteItemById(
    String carId,
    String itemId,
  ) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.delete(
        "users/me/$carId/$endpoint/$itemId",
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to delete $endpoint $itemId for carId: $carId',
        );
      }
      return response;
    } catch (e) {
      logger.e("Error deleting $endpoint $itemId for carId: $carId: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchItemById(
    Map<String, dynamic> changes,
    String carId,
    String itemId,
  ) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _api.patch(
        "users/me/$carId/$endpoint/$itemId",
        changes,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to patch $endpoint $itemId for carId: $carId',
        );
      }
      return response;
    } catch (e, st) {
      logger.e("Error patching $endpoint $itemId for carId: $carId: $e , $st");
      rethrow;
    }
  }
}
