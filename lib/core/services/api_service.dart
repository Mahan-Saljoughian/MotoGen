import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:motogen/core/services/refresh_token_expired_exception.dart';

class ApiService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final _logger = Logger();
  final String _baseUrl = 'https://motogen-api-nest.onrender.com';
  //'http://10.0.2.2:3000'; // Use 10.0.2.2 for Android emulator
  //'http://192.168.219.6:3000';

  bool isDebugMode = false;

  Future<String> _getAccessToken() async {
    final token = await _secureStorage.read(key: 'accessToken');
    if (token == null || token.isEmpty) {
      throw Exception("No access token found");
    }
    _logger.d("AccessToken: $token");
    return token;
  }

  Future<dynamic> _refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) throw Exception("No refresh token found");

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 401) {
      // Refresh token is dead — clear tokens, trigger logout flow
      await _secureStorage.deleteAll();
      throw RefreshTokenExpiredException(); // no where i catch this yet and no providerlistnere on the main
    }
    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw Exception("Refresh token failed (${response.statusCode})");
    }

    final body = json.decode(response.body);
    final data = body['data'];
    //debugPrint("debug 🔍 _refreshToken response:$body");
    final newAccessToken = data['accessToken'];
    final newRefreshToken = data['refreshToken'];
    await _secureStorage.write(key: 'accessToken', value: newAccessToken);
    await _secureStorage.write(key: 'refreshToken', value: newRefreshToken);

    return newAccessToken;
  }

  Future<dynamic> _requestWithRetry(
    Future<http.Response> Function(String? token) requestFunc, {
    bool skipAuth = false,
  }) async {
    String? token;

    if (!skipAuth) {
      token = await _getAccessToken();
    }

    http.Response response;
    try {
      response = await requestFunc(token);

      if (!skipAuth && response.statusCode == 401) {
        // token expired → refresh
        token = await _refreshToken();
        response = await requestFunc(token);
      }
    } catch (e) {
      _logger.e('API request failed: $e');
      return {
        "success": false,
        "message": isDebugMode ? 'API request failed: $e' : "خطای شبکه",
      };
    }

    final body = json.decode(response.body);
    //debugPrint("🔍 debug _requestWithRetry response:$body");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      _logger.e(body['message'] ?? 'Request failed: ${response.statusCode}');
      return <String, dynamic>{...body, "success": false};
    }
  }

  // --- GET ---
  Future<dynamic> get(String endpoint, {bool skipAuth = false}) async {
    return _requestWithRetry((token) {
      return http.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
        },
      );
    }, skipAuth: skipAuth);
  }

  // --- POST ---
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool skipAuth = false,
  }) async {
    return _requestWithRetry((token) {
      return http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );
    }, skipAuth: skipAuth);
  }

  // --- PATCH ---
  Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> data, {
    bool skipAuth = false,
  }) async {
    return _requestWithRetry((token) {
      return http.patch(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );
    }, skipAuth: skipAuth);
  }

  // --- DELETE ---
  Future<dynamic> delete(String endpoint, {bool skipAuth = false}) async {
    return _requestWithRetry((token) {
      return http.delete(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
        },
      );
    }, skipAuth: skipAuth);
  }
}
