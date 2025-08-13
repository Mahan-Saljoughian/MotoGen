class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException([this.message = "Token expired"]);

  @override
  String toString() => message;
}
