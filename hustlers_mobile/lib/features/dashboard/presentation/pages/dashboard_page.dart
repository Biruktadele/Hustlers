import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hustlers_mobile/features/saved/presentation/pages/saved_page.dart';
import '../../../analysis/presentation/pages/home_analysis_page.dart';
import '../../../job_finder/presentation/pages/job_finder_page.dart';
import '../../../job_finder/presentation/pages/saved_page.dart';
import '../../../resume/presentation/pages/resume_rater_page.dart';
import '../../../about/presentation/pages/about_us_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    const HomeAnalysisPage(),
    const JobFinderPage(),
    const SavedPage(),
    const ResumeRaterPage(),
    const AboutUsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for curved navbar to float over content if needed, or just look good
      body: _pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.analytics_outlined, size: 30, color: Colors.white),
          Icon(Icons.work_outline, size: 30, color: Colors.white),
          Icon(Icons.bookmark_border, size: 30, color: Colors.white),
          Icon(Icons.rate_review_outlined, size: 30, color: Colors.white),
          Icon(Icons.info_outline, size: 30, color: Colors.white),
        ],
        color: Colors.deepPurple.shade400,
        buttonBackgroundColor: Colors.deepPurple.shade500,
        backgroundColor: Colors.transparent, // Background of the curve
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
