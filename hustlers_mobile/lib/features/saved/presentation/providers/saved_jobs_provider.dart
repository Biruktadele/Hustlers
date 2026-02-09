import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/models/saved_job_model.dart';
import '../../../analysis/presentation/providers/home_analysis_provider.dart';

final savedJobsProvider = AsyncNotifierProvider<SavedJobsNotifier, List<SavedJobModel>>(() {
  return SavedJobsNotifier();
});

class SavedJobsNotifier extends AsyncNotifier<List<SavedJobModel>> {
  @override
  Future<List<SavedJobModel>> build() async {
    return _fetchSavedJobs();
  }

  Future<List<SavedJobModel>> _fetchSavedJobs() async {
    final db = ref.read(appDatabaseProvider);
    return await db.getSavedJobs();
  }

  Future<void> saveJob(SavedJobModel job) async {
    final db = ref.read(appDatabaseProvider);
    await db.insertSavedJob(job);
    // Refresh the list
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSavedJobs());
  }

  Future<void> deleteJob(int id) async {
    final db = ref.read(appDatabaseProvider);
    await db.deleteSavedJob(id);
    // Refresh the list
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSavedJobs());
  }

  Future<void> updateStatus(int id, String status) async {
    final db = ref.read(appDatabaseProvider);
    await db.updateSavedJobStatus(id, status);
    // Refresh the list
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSavedJobs());
  }

  Future<void> markAsApplied(int id) async {
    final db = ref.read(appDatabaseProvider);
    final savedJobs = await db.getSavedJobs();
    final job = savedJobs.firstWhere((j) => j.id == id);
    
    if (!job.appliedCounted) {
      await db.incrementTodayAppliedJob();
      // Update with appliedCounted = true (1) and status = Applied
      // Since updateSavedJobStatus only updates status, needs a more specific update
      // or we can just use the insert (which replaces) with modify
      final updatedJob = SavedJobModel(
        id: job.id,
        jobName: job.jobName,
        jobType: job.jobType,
        price: job.price,
        deepLink: job.deepLink,
        jobDescription: job.jobDescription,
        expireDate: job.expireDate,
        postedAt: job.postedAt,
        status: "Applied",
        location: job.location,
        sex: job.sex,
        moreInfo: job.moreInfo,
        appliedCounted: true,
      );
      await db.insertSavedJob(updatedJob);
    } else {
       await db.updateSavedJobStatus(id, "Applied");
    }

    // Refresh the saved jobs list
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSavedJobs());
    
    // Refresh the dashboard analysis data
    ref.invalidate(homeAnalysisProvider);
  }
}
