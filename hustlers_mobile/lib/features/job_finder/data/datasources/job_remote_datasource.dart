import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

abstract class JobRemoteDataSource {
  Future<List<JobModel>> getJobs();
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final http.Client client;

  JobRemoteDataSourceImpl({required this.client});

  @override
  Future<List<JobModel>> getJobs() async {
    final response = await client.get(
      Uri.parse('https://hustlers-production.up.railway.app/api/tg/jobs'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> jobsJson = jsonResponse['data'];
        return jobsJson.map((json) => JobModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load jobs: API status not success');
      }
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
