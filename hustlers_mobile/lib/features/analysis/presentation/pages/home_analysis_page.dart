import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hustlers_mobile/core/presentation/widgets/custom_app_bar.dart';
import '../providers/home_analysis_provider.dart';

import '../../../../core/daily_content/daily_quote_provider.dart';

class HomeAnalysisPage extends ConsumerWidget {
  const HomeAnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data
    final todayQuote = ref.watch(dailyQuoteProvider);
    final homeAnalysisAsync = ref.watch(homeAnalysisProvider);

    final double successRate = homeAnalysisAsync.value?.successRate ?? 0.0;
    final List<FlSpot> weeklyData = homeAnalysisAsync.value?.weeklyData ??
        List.generate(7, (index) => FlSpot(index.toDouble(), 0));
    final int jobsAppliedToday = homeAnalysisAsync.value?.jobsAppliedToday ?? 0;
    final double comparisonPercentage = homeAnalysisAsync.value?.comparisonPercentage ?? 0.0;
    
    const String userName = "Alex";
    const int dailyGoal = 10;
    final int remainingJobs = (dailyGoal - jobsAppliedToday).clamp(0, dailyGoal);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: const BeautifulAppBar(title: 'Home Analysis', transparent: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16.0,
            16.0,
            16.0,
            100.0,
          ), // Extra bottom padding for Navbar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildQuoteSection(todayQuote.text, todayQuote.author),
              const SizedBox(height: 20),
              _buildSuccessRateChart(successRate, comparisonPercentage),
              const SizedBox(height: 20),
              _buildWeeklyGraph(weeklyData),
              const SizedBox(height: 20),
              _buildDailyProgress(userName, jobsAppliedToday, remainingJobs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection(String quote, String author) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Icon(Icons.format_quote, color: Colors.white70, size: 32),
          const SizedBox(height: 12),
          Text(
            quote,
            style: GoogleFonts.lora(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "- $author",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessRateChart(double successRate, double comparisonPercentage) {
    // Determine status based on comparisonPercentage
    final bool isPositive = comparisonPercentage > 0;
    final double displayValue = comparisonPercentage.abs();
    final Color statusColor = isPositive ? Colors.green : Colors.red;
    final IconData statusIcon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Column(
      children: [
        Text(
          "Success Rate",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        CircularPercentIndicator(
          radius: 70.0,
          lineWidth: 18.0,
          animation: true,
          percent: successRate.clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(successRate * 100).toInt()}%",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              Text(
                "Success",
                style: GoogleFonts.poppins(fontSize: 12.0, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(statusIcon, color: statusColor, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    "${displayValue.toStringAsFixed(1)}%",
                    style: GoogleFonts.poppins(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple.shade100,
          footer: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "Scheduled / Applied",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyGraph(List<FlSpot> weeklyData) {
    // Generate BarGroups from the FlSpots
    List<BarChartGroupData> barGroups = weeklyData.asMap().entries.map((entry) {
      int index = entry.key;
      double value = entry.value.y;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: Colors.deepPurple,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 10, // Assuming max is around 10
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly Activity",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2, // Only show every 2 units to reduce clutter
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(
                                value < 5 ? 0.5 : 1.0,
                              ), // Opacity < 50%
                              fontSize: 12,
                              fontWeight: value < 5
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyProgress(
    String userName,
    int jobsAppliedToday,
    int remainingJobs,
  ) {
    final int totalJobs = jobsAppliedToday + remainingJobs;
    // Prevent division by zero if totalJobs is 0 (should correspond to goal=0? which we set to 10)
    final double progress = totalJobs > 0 ? jobsAppliedToday / totalJobs : 0.0;
    
    // Determine status text and color based on applied count
    String statusTitle;
    String statusEmoji;
    Color statusColor;

    if (jobsAppliedToday == 0) {
      statusTitle = "What is waiting for $userName...";
      statusEmoji = "🤔";
      statusColor = Colors.redAccent;
    } else if (jobsAppliedToday >= 1 && jobsAppliedToday <= 3) {
      statusTitle = "Keep going, you're doing great";
      statusEmoji = "👍";
      statusColor = Colors.orangeAccent;
    } else if (jobsAppliedToday >= 4 && jobsAppliedToday <= 6) {
      statusTitle = "You are on fire, $userName!";
      statusEmoji = "🔥";
      statusColor = Colors.amber.shade700;
    } else if (jobsAppliedToday >= 7 && jobsAppliedToday <= 10) {
      statusTitle = "You are Demon Man!";
      statusEmoji = "😈";
      statusColor = Colors.deepPurple;
    } else {
      statusTitle = "Unstoppable!";
      statusEmoji = "🚀";
      statusColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  statusTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(statusEmoji, style: const TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
              children: [
                const TextSpan(text: "You applied to "),
                TextSpan(
                  text: "$jobsAppliedToday jobs",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const TextSpan(text: " today."),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
              children: [
                TextSpan(
                  text: "$remainingJobs jobs",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: " remaining to reach your daily goal."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 12.0,
            percent: progress.clamp(0.0, 1.0),
            padding: EdgeInsets.zero,
            barRadius: const Radius.circular(10),
            backgroundColor: Colors.grey.shade200,
            progressColor: statusColor,
            animation: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(progress * 100).toInt()}% Done",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
