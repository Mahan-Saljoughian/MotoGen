// lib/features/auth/models/auth_state.dart
enum AuthStatus { idle, loading, codeSent, confirmed, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final String? codeSent;
  final bool isProfileCompleted;
  final String? phoneNumber;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.status = AuthStatus.idle,
    this.message,
    this.codeSent,
    this.isProfileCompleted = false,
    this.phoneNumber,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    String? codeSent,
    bool? isProfileCompleted,
    String? phoneNumber,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      codeSent: codeSent ?? this.codeSent,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
