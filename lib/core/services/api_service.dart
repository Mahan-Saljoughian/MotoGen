import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl =
      'http://10.0.2.2:3000'; // Use 10.0.2.2 for Android emulator

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to GET data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API GET error: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to POST data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API POST error: $e');
    }
  }
}
