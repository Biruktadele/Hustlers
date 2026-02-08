import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/analysis_remote_datasource.dart';
import '../../data/repositories/analysis_repository_impl.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../../data/models/analysis_response_model.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final analysisRemoteDataSourceProvider = Provider<AnalysisRemoteDataSource>((ref) {
  return AnalysisRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

final analysisRepositoryProvider = Provider<AnalysisRepository>((ref) {
  return AnalysisRepositoryImpl(remoteDataSource: ref.read(analysisRemoteDataSourceProvider));
});

final analysisControllerProvider = StateNotifierProvider<AnalysisController, AsyncValue<AnalysisResponseModel?>>((ref) {
  return AnalysisController(ref.read(analysisRepositoryProvider));
});

class AnalysisController extends StateNotifier<AsyncValue<AnalysisResponseModel?>> {
  final AnalysisRepository _repository;

  AnalysisController(this._repository) : super(const AsyncValue.data(null));

  Future<void> analyze({
    required File file,
    required String githubUsername,
    required String role,
    int limit = 5,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.analyzeResume(
        file: file,
        githubUsername: githubUsername,
        role: role,
        limit: limit,
      );
    });
  }
}
