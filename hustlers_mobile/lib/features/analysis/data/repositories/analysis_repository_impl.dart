import 'dart:io';
import '../../domain/repositories/analysis_repository.dart';
import '../../data/datasources/analysis_remote_datasource.dart';
import '../../data/models/analysis_response_model.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDataSource remoteDataSource;

  AnalysisRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AnalysisResponseModel> analyzeResume({
    required File file,
    required String githubUsername,
    required String role,
    int limit = 5,
  }) async {
    return await remoteDataSource.analyzeResume(
      file: file,
      githubUsername: githubUsername,
      role: role,
      limit: limit,
    );
  }
}
