import '../datasources/job_remote_datasource.dart';
import '../models/job_model.dart';

abstract class JobRepository {
  Future<List<JobModel>> getJobs();
}

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<JobModel>> getJobs() async {
    return await remoteDataSource.getJobs();
  }
}
