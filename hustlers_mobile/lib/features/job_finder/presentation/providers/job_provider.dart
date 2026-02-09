import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/app_database.dart';
import '../../data/datasources/job_finder_local_datasource/job_finder_local_datasource.dart';
import '../../data/datasources/job_finder_local_datasource/job_finder_local_datasource_impl.dart';
import '../../data/datasources/job_remote_datasource.dart';
import '../../data/models/job_model.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';

final jobRemoteDataSourceProvider = Provider<JobRemoteDataSource>((ref) {
  return JobRemoteDataSourceImpl(client: http.Client());
});

final jobLocalDataSourceProvider = Provider<JobFinderLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return JobFinderLocalDataSourceImpl(appDatabase: db, sharedPreferences: prefs);
});

final jobRepositoryProvider = Provider<JobRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(jobRemoteDataSourceProvider);
  final localDataSource = ref.watch(jobLocalDataSourceProvider);
  return JobRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final jobListProvider = FutureProvider<List<JobModel>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getJobs();
});
