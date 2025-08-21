// lib/features/auth/data/auth_repository.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motogen/core/services/api_service.dart';

class AuthRepository {
  final ApiService _api = ApiService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<Map<String, dynamic>> requestOtp(String phone) async {
    final response = await _api.post('auth/request-otp', {
      'phoneNumber': phone,
    }, skipAuth: true);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to request OTP');
    }
    return response;
  }

  Future<Map<String, dynamic>> confirmOtp(String phone, String code) async {
    final response = await _api.post('auth/confirm-otp', {
      'phoneNumber': phone,
      'otpCode': code,
    }, skipAuth: true);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to confirm OTP');
    }

    final data = response['data'] ?? {};
    final refreshToken = data['refreshToken'] as String?;
    final accessToken = data['accessToken'] as String?;
    if (accessToken != null)
      {await _secureStorage.write(key: 'accessToken', value: accessToken);}
    if (refreshToken != null)
      {await _secureStorage.write(key: 'refreshToken', value: refreshToken);}

    return response;
  }
}
