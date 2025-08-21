class RefreshTokenExpiredException implements Exception {
  final String message;
  RefreshTokenExpiredException([this.message = 'Refresh token expired']);
  @override
  String toString() => message;
}
