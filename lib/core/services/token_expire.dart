import 'dart:convert';

bool isTokenExpired(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final payloadMap = jsonDecode(payload);

    final exp = payloadMap['exp']; // seconds
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return now >= exp;
  } catch (_) {
    return true; // Treat invalid token as expired
  }
}
