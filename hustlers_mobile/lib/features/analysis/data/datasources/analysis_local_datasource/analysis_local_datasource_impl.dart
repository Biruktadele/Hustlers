import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hustlers_mobile/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'analysis_local_datasource.dart';

final analysisLocalDataSourceProvider = Provider<AnalysisLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AnalysisLocalDataSourceImpl(prefs);
});

class AnalysisLocalDataSourceImpl implements AnalysisLocalDataSource {
  final SharedPreferences sharedPreferences;

  AnalysisLocalDataSourceImpl(this.sharedPreferences);

  static const String _cachedTotalAppliedKey = 'CACHED_TOTAL_APPLIED';
  static const String _cachedTotalAppliedThisWeekKey = 'CACHED_TOTAL_APPLIED_THIS_WEEK';
  static const String _cachedTotalAppliedLastWeekKey = 'CACHED_TOTAL_APPLIED_LAST_WEEK';
  static const String _cachedTotalScheduledKey = 'CACHED_TOTAL_SCHEDULED';
  static const String _cachedTotalScheduledThisWeekKey = 'CACHED_TOTAL_SCHEDULED_THIS_WEEK';
  static const String _cachedTotalScheduledLastWeekKey = 'CACHED_TOTAL_SCHEDULED_LAST_WEEK';

  @override
  Future<void> cacheTotalApplied(int count) {
    return sharedPreferences.setInt(_cachedTotalAppliedKey, count);
  }

  @override
  Future<int> getTotalApplied() {
    return Future.value(sharedPreferences.getInt(_cachedTotalAppliedKey) ?? 0);
  }

  @override
  Future<void> cacheTotalAppliedThisWeek(int count) {
    return sharedPreferences.setInt(_cachedTotalAppliedThisWeekKey, count);
  }

  @override
  Future<int> getTotalAppliedThisWeek() {
    return Future.value(sharedPreferences.getInt(_cachedTotalAppliedThisWeekKey) ?? 0);
  }

  @override
  Future<void> cacheTotalAppliedLastWeek(int count) {
    return sharedPreferences.setInt(_cachedTotalAppliedLastWeekKey, count);
  }

  @override
  Future<int> getTotalAppliedLastWeek() {
    return Future.value(sharedPreferences.getInt(_cachedTotalAppliedLastWeekKey) ?? 0);
  }

  @override
  Future<void> cacheTotalScheduled(int count) {
    return sharedPreferences.setInt(_cachedTotalScheduledKey, count);
  }

  @override
  Future<int> getTotalScheduled() {
    return Future.value(sharedPreferences.getInt(_cachedTotalScheduledKey) ?? 0);
  }

  @override
  Future<void> cacheTotalScheduledThisWeek(int count) {
    return sharedPreferences.setInt(_cachedTotalScheduledThisWeekKey, count);
  }

  @override
  Future<int> getTotalScheduledThisWeek() {
    return Future.value(sharedPreferences.getInt(_cachedTotalScheduledThisWeekKey) ?? 0);
  }

  @override
  Future<void> cacheTotalScheduledLastWeek(int count) {
    return sharedPreferences.setInt(_cachedTotalScheduledLastWeekKey, count);
  }

  @override
  Future<int> getTotalScheduledLastWeek() {
    return Future.value(sharedPreferences.getInt(_cachedTotalScheduledLastWeekKey) ?? 0);
  }
}
