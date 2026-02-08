import 'dart:io';
import '../../data/models/analysis_response_model.dart';

abstract class AnalysisRepository {
  Future<AnalysisResponseModel> analyzeResume({
    required File file,
    required String githubUsername,
    required String role,
    int limit = 5,
  });
}
