// lib/features/auth/viewmodels/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:motogen/features/user_info/data/auth_repository.dart';
import 'package:motogen/features/user_info/model/auth_state.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = AuthRepository();
    return const AuthState();
  }

  Future<void> requestOtp(String phone) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      final response = await _repository.requestOtp(phone);
      state = state.copyWith(
        status: AuthStatus.codeSent,
        message: response['message'] as String?,
        codeSent: response['data'],
        phoneNumber: phone,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> confirmOtp(String phone, String code) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      final response = await _repository.confirmOtp(phone, code);
      final data = response['data'] ?? {};
      final user = data['user'] ?? {};
      final isProfileCompleted = user['isProfileCompleted'] == true;

      state = state.copyWith(
        status: AuthStatus.confirmed,
        message: response['message'] as String?,
        accessToken: data['accessToken'] as String?,
        refreshToken: data['refreshToken'] as String?,
        isProfileCompleted: isProfileCompleted,
      );

    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  
}
