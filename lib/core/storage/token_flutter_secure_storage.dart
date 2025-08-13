import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
var _logger = Logger();

Future<String> getAccessToken() async {
  final accessToken = await _secureStorage.read(key: 'accessToken');
  if (accessToken == null || accessToken.isEmpty) {
    throw Exception("No access token found");
  }
  _logger.d(" debug AccessToken : $accessToken");
  return accessToken;
}
