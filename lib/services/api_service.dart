import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // REGISTER NEW ACCOUNT
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        return Map<String, dynamic>.from(data);
      }

      throw Exception(
        data['message'] ?? 'Registration failed.',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Unable to connect to the server.');
    }
  }

  // LOGIN EXISTING ACCOUNT
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        return Map<String, dynamic>.from(data);
      }

      throw Exception(
        data['message'] ?? 'Login failed.',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Unable to connect to the server.');
    }
  }
}