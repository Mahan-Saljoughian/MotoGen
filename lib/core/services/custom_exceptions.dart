class RefreshTokenExpiredException implements Exception {
  final String message;
  RefreshTokenExpiredException([this.message = 'Refresh token expired']);
  @override
  String toString() => message;
}

class ForceUpdateException implements Exception {
  final String message;
  final String updateUrl;
  ForceUpdateException(this.message, this.updateUrl);

  @override
  String toString() => 'ForceUpdateException: $message ($updateUrl)';
}

bool simulateNoInternet = true;

class CustomGlobalError implements Exception {
  final String message;
  final bool? isForceUpdate;
  final String? updateUrl;

  const CustomGlobalError({
    required this.message,
    this.isForceUpdate,
    this.updateUrl,
  });
}
