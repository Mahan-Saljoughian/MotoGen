import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:motogen/core/global_error_handling/app_with_container.dart';
import 'package:motogen/core/global_error_handling/viewmodel/global_error_provider.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/core/services/custom_exceptions.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApiService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  late final String _baseUrl;
  ApiService() {
    _baseUrl = dotenv.env['BASE_URL'] ?? '';
    if (_baseUrl.isEmpty) {
      appLogger.e("BASE_URL is not set in .env");
    }
  }

  bool isDebugMode = false;

  Map<String, String>? _cachedVersionHeaders;
  Future<Map<String, String>> _getVersionHeaders() async {
    if (_cachedVersionHeaders != null) return _cachedVersionHeaders!;
    final info = await PackageInfo.fromPlatform();
    _cachedVersionHeaders = {'x-app-version': "0.1.1"};
    return _cachedVersionHeaders!;
  }

  Future<String> _getAccessToken() async {
    final token = await _secureStorage.read(key: 'accessToken');
    if (token == null || token.isEmpty) {
      throw Exception("No access token found");
    }
    appLogger.d("AccessToken: $token");
    return token;
  }

  Future<dynamic> _refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) throw Exception("No refresh token found");

    final versionHeaders = await _getVersionHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
        if (!isDebugMode) ...versionHeaders,
      },
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
    Future<http.Response> Function(String? token, Map<String, String> headers)
    requestFunc, {
    bool skipAuth = false,
  }) async {
    String? token;

    if (!skipAuth) {
      token = await _getAccessToken();
    }

    final versionHeaders = await _getVersionHeaders();

    http.Response response;
    try {
      response = await requestFunc(token, versionHeaders);

      if (!skipAuth && response.statusCode == 401) {
        // token expired → refresh
        token = await _refreshToken();
        response = await requestFunc(token, versionHeaders);
      }
    } catch (e, st) {
      appLogger.e('API request failed: $e . $st');
      if (e is SocketException) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GlobalErrorHandler.handle(
            CustomGlobalError(message: 'socket_exception'),
          );
        });
        // stop the local widget from rendering any fallback UI
        throw const CustomGlobalError(message: 'socket_exception');
      }
      rethrow;
    }

    final body = json.decode(response.body);

    if (response.statusCode == 426) {
      final updateUrl = body['updateUrl'];
      final message = body['message'] ?? 'Update required';
      // Update global state for UI
      GlobalErrorHandler.handle(ForceUpdateException(message, updateUrl));

      throw ForceUpdateException(message, updateUrl);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      appLogger.e(body['message'] ?? 'Request failed: ${response.statusCode}');
      return <String, dynamic>{...body, "success": false};
    }
  }

  // --- GET ---
  Future<dynamic> get(String endpoint, {bool skipAuth = false}) async {
    return _requestWithRetry((token, versionHeaders) {
      return http.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
          if (!isDebugMode) ...versionHeaders,
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
    return _requestWithRetry((token, versionHeaders) {
      return http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
          if (!isDebugMode) ...versionHeaders,
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
    return _requestWithRetry((token, versionHeaders) {
      return http.patch(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
          if (!isDebugMode) ...versionHeaders,
        },
        body: json.encode(data),
      );
    }, skipAuth: skipAuth);
  }

  // --- DELETE ---
  Future<dynamic> delete(String endpoint, {bool skipAuth = false}) async {
    return _requestWithRetry((token, versionHeaders) {
      return http.delete(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (!skipAuth && token != null) 'Authorization': 'Bearer $token',
          if (!isDebugMode) ...versionHeaders,
        },
      );
    }, skipAuth: skipAuth);
  }
}
