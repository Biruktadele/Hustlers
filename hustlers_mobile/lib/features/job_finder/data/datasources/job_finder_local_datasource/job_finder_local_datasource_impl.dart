import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/database/app_database.dart';
import '../../models/job_model.dart';
import 'job_finder_local_datasource.dart';

class JobFinderLocalDataSourceImpl implements JobFinderLocalDataSource {
  final AppDatabase appDatabase;
  final SharedPreferences sharedPreferences;

  JobFinderLocalDataSourceImpl({
    required this.appDatabase,
    required this.sharedPreferences,
  });

  static const String CACHED_JOB_TIME = 'CACHED_JOB_TIME';

  @override
  Future<void> cacheJobs(List<JobModel> jobs) async {
    await appDatabase.cacheJobs(jobs);
  }

  @override
  Future<List<JobModel>> getLastJobs() async {
    return await appDatabase.getCachedJobs();
  }

  @override
  Future<void> cacheLastFetchTime(DateTime time) async {
    await sharedPreferences.setString(CACHED_JOB_TIME, time.toIso8601String());
  }

  @override
  Future<DateTime?> getLastFetchTime() async {
    final jsonString = sharedPreferences.getString(CACHED_JOB_TIME);
    if (jsonString != null) {
      return DateTime.parse(jsonString);
    }
    return null;
  }
}
