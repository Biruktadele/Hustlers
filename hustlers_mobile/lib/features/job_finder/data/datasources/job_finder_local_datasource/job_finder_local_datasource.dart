import '../../models/job_model.dart';

abstract class JobFinderLocalDataSource {
  Future<void> cacheJobs(List<JobModel> jobs);
  Future<List<JobModel>> getLastJobs();
  Future<void> cacheLastFetchTime(DateTime time);
  Future<DateTime?> getLastFetchTime();
}
