import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl =
      'http://10.0.2.2:3000'; // Use 10.0.2.2 for Android emulator
  //'http://192.168.219.6:3000';

  dynamic _handleResponse(http.Response response) {
    final body = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(
        body['message'] ?? 'Request failed: ${response.statusCode}',
      );
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('API GET error: $e');
    }
  }

  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final defaultHeaders = {'Content-Type': 'application/json'};
    final mergedHeaders = {...defaultHeaders, ...?headers};

    try {
      final response = await http.post(
        url,
        headers: mergedHeaders,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('API POST error: $e');
    }
  }


  Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final defaultHeaders = {'Content-Type': 'application/json'};
    final mergedHeaders = {...defaultHeaders, ...?headers};

    try {
      final response = await http.patch(
        url,
        headers: mergedHeaders,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('API PATCH error: $e');
    }
  }


  
  Future<dynamic> delete(
    String endpoint,
   {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final defaultHeaders = {'Content-Type': 'application/json'};
    final mergedHeaders = {...defaultHeaders, ...?headers};

    try {
      final response = await http.delete(
        url,
        headers: mergedHeaders,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('API DELETE error: $e');
    }
  }

  
}
