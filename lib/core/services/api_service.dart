import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl =
      //'http://10.0.2.2:3000'; // Use 10.0.2.2 for Android emulator
      'http://192.168.219.6:3000';

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to GET data: ${response.statusCode}');
      }
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
    final response = await http.post(
      url,
      headers: mergedHeaders,
      body: json.encode(data),
    );
    final body = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body;
    } else {
      throw Exception(
        body['message'] ?? 'Failed to POST data: ${response.statusCode}',
      );
    }
  }
}
