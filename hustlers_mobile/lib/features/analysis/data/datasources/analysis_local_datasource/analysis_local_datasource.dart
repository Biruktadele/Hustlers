abstract class AnalysisLocalDataSource {
  Future<void> cacheTotalApplied(int count);
  Future<int> getTotalApplied();

  Future<void> cacheTotalAppliedThisWeek(int count);
  Future<int> getTotalAppliedThisWeek();

  Future<void> cacheTotalAppliedLastWeek(int count);
  Future<int> getTotalAppliedLastWeek();

  Future<void> cacheTotalScheduled(int count);
  Future<int> getTotalScheduled();

  Future<void> cacheTotalScheduledThisWeek(int count);
  Future<int> getTotalScheduledThisWeek();

  Future<void> cacheTotalScheduledLastWeek(int count);
  Future<int> getTotalScheduledLastWeek();
}
