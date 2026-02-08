import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/models/saved_job_model.dart';

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
}
