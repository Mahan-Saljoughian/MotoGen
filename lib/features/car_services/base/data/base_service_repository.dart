import 'dart:io';

import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/core/services/custom_exceptions.dart';
import 'package:motogen/core/services/logger.dart';

abstract class BaseServiceRepository<T> {
  final ApiService _api = ApiService();

  /// Subclasses must override
  String get endpoint; // e.g. "refuels", "repairs"

  Map<String, dynamic> toApiJson(T item); // serialize
  
  Future<List<Map<String, dynamic>>> getAllItems(
    String carId,
    String? sortType,
    String? oilType,
  ) async {
    try {
      final queryParams = [
        if (oilType != null) 'oilType=$oilType',
        if (sortType != null) 'order=$sortType',
      ].join('&');
      if (simulateNoInternet) {
        throw const SocketException('Deliberate test of offline handling');
      }
      final response = await _api.get(
        "users/me/cars/$carId/$endpoint${queryParams.isNotEmpty ? '?$queryParams' : ''}",
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to get $endpoint for carId: $carId with sort type : $sortType and oilType $oilType',
        );
      }
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e, st) {
      appLogger.e(
        "Error getting $endpoint for carId: $carId with sort type : $sortType and oilType $oilType: $e,$st",
      );

      rethrow;
    }
  }

  Future<Map<String, dynamic>> postItem(T item, String carId) async {
    try {
      final response = await _api.post(
        "users/me/cars/$carId/$endpoint",
        toApiJson(item),
      );
      appLogger.d("debug Repair post response: $response");
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to post $endpoint for carId: $carId',
        );
      }
      return response;
    } catch (e, st) {
      appLogger.e("Error posting $endpoint for carId: $carId: $e , $st");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteItemById(
    String carId,
    String itemId,
  ) async {
    try {
      final response = await _api.delete(
        "users/me/cars/$carId/$endpoint/$itemId",
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to delete $endpoint $itemId for carId: $carId',
        );
      }
      return response;
    } catch (e) {
      appLogger.e("Error deleting $endpoint $itemId for carId: $carId: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchItemById(
    Map<String, dynamic> changes,
    String carId,
    String itemId,
  ) async {
    try {
      final response = await _api.patch(
        "users/me/cars/$carId/$endpoint/$itemId",
        changes,
      );
      if (response['success'] != true) {
        throw Exception(
          response['message'] ??
              'Failed to patch $endpoint $itemId for carId: $carId',
        );
      }
      return response;
    } catch (e, st) {
      appLogger.e(
        "Error patching $endpoint $itemId for carId: $carId: $e , $st",
      );
      rethrow;
    }
  }
}
