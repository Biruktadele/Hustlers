import '../datasources/job_remote_datasource.dart';
import '../datasources/job_finder_local_datasource/job_finder_local_datasource.dart';
import '../models/job_model.dart';

abstract class JobRepository {
  Future<List<JobModel>> getJobs({bool forceRefresh = false});
}

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;
  final JobFinderLocalDataSource localDataSource;

  JobRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<JobModel>> getJobs({bool forceRefresh = false}) async {
    final now = DateTime.now();
    final lastFetchTime = await localDataSource.getLastFetchTime();

    final shouldFetch = forceRefresh || 
                        lastFetchTime == null || 
                        now.difference(lastFetchTime).inHours >= 8;

    if (shouldFetch) {
      try {
        final remoteJobs = await remoteDataSource.getJobs();
        await localDataSource.cacheJobs(remoteJobs);
        await localDataSource.cacheLastFetchTime(now);
        return remoteJobs;
      } catch (e) {
        // Fetch failed. If we have local data, return it (unless it was a forced refresh, 
        // but even then, better to show something than nothing if network is down).
        final localJobs = await localDataSource.getLastJobs();
        if (localJobs.isNotEmpty) {
          return localJobs;
        }
        rethrow;
      }
    } else {
      return await localDataSource.getLastJobs();
    }
  }
}
