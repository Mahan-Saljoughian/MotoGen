enum AuthStatus { idle, loading, codeSent, confirmed, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final String? codeSent;
  final String? phoneNumber;
  final bool? isProfileCompleted;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.status = AuthStatus.idle,
    this.message,
    this.isProfileCompleted,
    this.accessToken,
    this.refreshToken,
    this.codeSent,
    this.phoneNumber,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    String? codeSent,
    bool? isProfileCompleted,
    String? accessToken,
    String? refreshToken,
    String? phoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      codeSent: codeSent ?? this.codeSent,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
