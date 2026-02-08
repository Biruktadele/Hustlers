import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/analysis_response_model.dart';

abstract class AnalysisRemoteDataSource {
  Future<AnalysisResponseModel> analyzeResume({
    required File file,
    required String githubUsername,
    required String role,
    int limit = 5,
  });
}

class AnalysisRemoteDataSourceImpl implements AnalysisRemoteDataSource {
  final http.Client client;

  AnalysisRemoteDataSourceImpl({required this.client});

  @override
  Future<AnalysisResponseModel> analyzeResume({
    required File file,
    required String githubUsername,
    required String role,
    int limit = 5,
  }) async {
    final uri = Uri.parse('https://hustlers-production.up.railway.app/hustler/ai/analyze');

    var request = http.MultipartRequest('POST', uri);

    request.fields['github_username'] = githubUsername;
    request.fields['role'] = role;
    request.fields['limit'] = limit.toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        'resume',
        file.path,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return AnalysisResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to analyze resume: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
