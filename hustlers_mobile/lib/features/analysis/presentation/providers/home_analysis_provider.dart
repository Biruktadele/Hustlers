import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/database/app_database.dart';

class HomeAnalysisState {
  final double successRate;
  final List<FlSpot> weeklyData;
  final int jobsAppliedToday;
  final double comparisonPercentage;

  const HomeAnalysisState({
    required this.successRate,
    required this.weeklyData,
    required this.jobsAppliedToday,
    required this.comparisonPercentage,
  });
}

final homeAnalysisProvider = AsyncNotifierProvider<HomeAnalysisController, HomeAnalysisState>(
  HomeAnalysisController.new,
);

class HomeAnalysisController extends AsyncNotifier<HomeAnalysisState> {
  @override
  Future<HomeAnalysisState> build() async {
    final successRate = await _calculateSuccessRate();
    final weeklyData = await _calculateWeeklyData();
    final jobsAppliedToday = await _calculateJobsAppliedToday();
    final comparisonPercentage = await _calculateComparisonPercentage();
    
    return HomeAnalysisState(
      successRate: successRate,
      weeklyData: weeklyData,
      jobsAppliedToday: jobsAppliedToday,
      comparisonPercentage: comparisonPercentage,
    );
  }

  Future<double> _calculateComparisonPercentage() async {
    final db = ref.watch(appDatabaseProvider);
    final now = DateTime.now();
    final dayOfMonth = now.day;
    
    if (dayOfMonth == 0) return 0.0;
    
    final dailyGoal = 10;

    // This Month Stats
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startId = _getDayOfYear(startOfMonth);
    final endId = _getDayOfYear(now);
    final sumThisMonth = await db.getAppliedJobsSum(startId, endId);
    final targetThis = dayOfMonth * dailyGoal;
    final rateThis = targetThis > 0 ? sumThisMonth / targetThis : 0.0;

    // Last Month Stats (Same period: first N days)
    // Handle year wrap for previous month
    final lastMonthDate = DateTime(now.month == 1 ? now.year - 1 : now.year, now.month == 1 ? 12 : now.month - 1, 1);
    
    // Cap comparison days to length of last month (e.g. comparing Jan 30 to Feb -> Feb only has 28)
    final daysInLastMonth = DateTime(lastMonthDate.year, lastMonthDate.month + 1, 0).day;
    final compareDays = dayOfMonth > daysInLastMonth ? daysInLastMonth : dayOfMonth;
    
    final startIdLast = _getDayOfYear(lastMonthDate);
    final endIdLast = startIdLast + compareDays - 1;
    final sumLastMonth = await db.getAppliedJobsSum(startIdLast, endIdLast);
    final targetLast = compareDays * dailyGoal;
    final rateLast = targetLast > 0 ? sumLastMonth / targetLast : 0.0;

    // Difference in percentage points * 100 as per request ??
    // User said: (this month - last month) * 100.
    // Assuming this means difference in Success Rate Percentage Points.
    return (rateThis - rateLast) * 100;
  }

  Future<int> _calculateJobsAppliedToday() async {
    final db = ref.watch(appDatabaseProvider);
    final now = DateTime.now();
    final dayId = _getDayOfYear(now);
    return await db.getAppliedJobsSum(dayId, dayId);
  }

  Future<double> _calculateSuccessRate() async {
    final db = ref.watch(appDatabaseProvider);
    final now = DateTime.now();
    
    // Calculate range: Start of month to Today
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startId = _getDayOfYear(startOfMonth);
    final endId = _getDayOfYear(now);
    
    final sumApplied = await db.getAppliedJobsSum(startId, endId);
    
    final dayOfMonth = now.day;
    const dailyGoal = 10;
    
    if (dayOfMonth == 0) return 0.0;
    
    final target = dayOfMonth * dailyGoal;
    if (target == 0) return 0.0;

    double rate = sumApplied / target;
    if (rate > 1.0) rate = 1.0;
    
    return rate;
  }

  Future<List<FlSpot>> _calculateWeeklyData() async {
    final db = ref.watch(appDatabaseProvider);
    final now = DateTime.now();
    // Monday = 1, Sunday = 7
    final currentWeekday = now.weekday; 
    
    // Calculate Monday of the current week
    final startOfWeek = now.subtract(Duration(days: currentWeekday - 1));
    // Calculate Sunday of the current week
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final startId = _getDayOfYear(startOfWeek);
    final endId = _getDayOfYear(endOfWeek);

    final Map<int, int> appliedMap;
    // Handle year wrap-around logic roughly, though simple app might not need perfect year handling immediately.
    // However, robust code is better. 
    if (startOfWeek.year == endOfWeek.year) {
      appliedMap = await db.getAppliedJobsForRange(startId, endId);
    } else {
      // Split query
      final map1 = await db.getAppliedJobsForRange(startId, 365); // End of first year
      final map2 = await db.getAppliedJobsForRange(1, endId); // Start of next year
      appliedMap = {...map1, ...map2};
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < 7; i++) {
      final dayDate = startOfWeek.add(Duration(days: i));
      final dayId = _getDayOfYear(dayDate);
      final count = appliedMap[dayId] ?? 0;
      // x: 0 (Mon) -> 6 (Sun)
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }
    
    return spots;
  }

  int _getDayOfYear(DateTime date) {
    final diff = date.difference(DateTime(date.year, 1, 1, 0, 0));
    final diffInDays = diff.inDays;
    return diffInDays + 1;
  }
}
