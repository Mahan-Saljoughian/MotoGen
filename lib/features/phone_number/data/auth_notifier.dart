import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/features/phone_number/model/auth_state.dart';

final _secureStorage = FlutterSecureStorage();

class AuthNotifier extends Notifier<AuthState> {
  late final ApiService api;
  @override
  AuthState build() {
    api = ApiService();
    return const AuthState();
  }

  Future<void> requestOtp(String phone) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      final response = await api.post('auth/request-otp', {
        'phoneNumber': phone,
      });
      final success = response['success'] == true;
      final message = response['messaeg'] as String?;
      final codeSent = response['data'];

      if (success) {
        state = state.copyWith(
          status: AuthStatus.codeSent,
          message: message,
          codeSent: codeSent,
          phoneNumber: phone,
        );
      } else {
        state = state.copyWith(status: AuthStatus.error, message: message);
      }
    } catch (e) {
      final errorString = e.toString();
      final pureMsg = errorString.replaceFirst('Exception: ', '');
      state = state.copyWith(status: AuthStatus.error, message: pureMsg);
    }
  }

  Future<void> confirmOtp(String phone, String code) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      final response = await api.post('auth/confirm-otp', {
        'phoneNumber': phone,
        'otpCode': code,
      });
      final success = response['success'] == true;
      final message = response['message'] as String?;

      if (!success) {
        state = state.copyWith(status: AuthStatus.error, message: message);
      }
      final data = response['data'] ?? {};
      final user = data['user'] ?? {};
      final refreshToken = data['refreshToken'] as String?;
      final accessToken = data['accessToken'] as String?;
      final isProfileCompleted = user['isProfileCompleted'] == true;

      if (accessToken != null) {
        await _secureStorage.write(key: 'accessToken', value: accessToken);
      }
      if (refreshToken != null) {
        await _secureStorage.write(key: 'refreshToken', value: refreshToken);
      }

      state = state.copyWith(
        status: AuthStatus.confirmed,
        message: message,
        accessToken: accessToken,
        refreshToken: refreshToken,
        isProfileCompleted: isProfileCompleted,
      );
    } catch (e) {
      final errorString = e.toString();
      final pureMsg = errorString.replaceFirst('Exception: ', '');
      state = state.copyWith(status: AuthStatus.error, message: pureMsg);
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
