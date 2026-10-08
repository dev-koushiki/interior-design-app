import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ProjectService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // CREATE PROJECT
  static Future<Map<String, dynamic>> createProject({
    required String projectName,
    required String roomType,
    String description = '',
    String originalImage = '',
    List<String> generatedDesigns = const [],
  }) async {
    final userId = await AuthService.getUserId();

    if (userId == null || userId.isEmpty) {
      throw Exception('Please log in to create a project.');
    }

    final response = await http
        .post(
      Uri.parse('$baseUrl/projects'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'projectName': projectName,
        'roomType': roomType,
        'description': description,
        'originalImage': originalImage,
        'generatedDesigns': generatedDesigns,
      }),
    )
        .timeout(const Duration(seconds: 20));

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['success'] == true) {
      return Map<String, dynamic>.from(data['project']);
    }

    throw Exception(data['message'] ?? 'Unable to create project.');
  }

  // GET ALL PROJECTS
  static Future<List<Map<String, dynamic>>> getProjects() async {
    final userId = await AuthService.getUserId();

    if (userId == null || userId.isEmpty) {
      throw Exception('Please log in to view your projects.');
    }

    final response = await http
        .get(
      Uri.parse('$baseUrl/projects/$userId'),
      headers: {'Content-Type': 'application/json'},
    )
        .timeout(const Duration(seconds: 20));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['projects']);
    }

    throw Exception(data['message'] ?? 'Unable to load projects.');
  }

  // DELETE PROJECT
  static Future<void> deleteProject(String projectId) async {
    final userId = await AuthService.getUserId();

    if (userId == null || userId.isEmpty) {
      throw Exception('Please log in to delete a project.');
    }

    final response = await http
        .delete(
      Uri.parse('$baseUrl/projects/$projectId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    )
        .timeout(const Duration(seconds: 20));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return;
    }

    throw Exception(data['message'] ?? 'Unable to delete project.');
  }
}