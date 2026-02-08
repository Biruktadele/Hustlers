import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/job_remote_datasource.dart';
import '../../data/models/job_model.dart';
import '../../data/repositories/job_repository_impl.dart';

final jobRemoteDataSourceProvider = Provider<JobRemoteDataSource>((ref) {
  return JobRemoteDataSourceImpl(client: http.Client());
});

final jobRepositoryProvider = Provider<JobRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(jobRemoteDataSourceProvider);
  return JobRepositoryImpl(remoteDataSource: remoteDataSource);
});

final jobListProvider = FutureProvider<List<JobModel>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getJobs();
});
