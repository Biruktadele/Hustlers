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
    final uri = Uri.parse('https://hustlers-production.up.railway.app/api/v1/resume/suggestions/pdf');

    var request = http.MultipartRequest('POST', uri);
    request.headers['accept'] = 'application/json';

    request.fields['github_username'] = githubUsername;
    request.fields['role'] = role;
    request.fields['limit'] = limit.toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
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
        throw Exception('Server Error (${response.statusCode}): ${response.body}');
      }
    } on SocketException catch (e) {
      throw Exception('Connection failed. Please check your internet: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
