import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../widgets/job_card.dart';
import '../widgets/company_card.dart';
import 'job_detail_page.dart';

class JobFinderPage extends StatelessWidget {
  const JobFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const BeautifulAppBar(
          title: "Job Finder",
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade500.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  // Remove the default overlay color if desired
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Jobs",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Company",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildJobsList(context),
                  _buildCompanyList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsList(BuildContext context) {
    // Mock Data for Jobs
    final jobs = [
      {
        "title": "Senior Flutter Developer",
        "company": "Tech Corp",
        "location": "New York, USA",
        "date": "2 days ago"
      },
      {
        "title": "UI/UX Designer",
        "company": "Creative Studio",
        "location": "Remote",
        "date": "5 hours ago"
      },
      {
        "title": "Backend Engineer",
        "company": "Data Systems",
        "location": "San Francisco, CA",
        "date": "1 week ago"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80), // Bottom padding for navbar
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return JobCard(
          jobTitle: job['title']!,
          companyName: job['company']!,
          location: job['location']!,
          date: job['date']!,
          onViewDetail: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailPage(title: job['title']!),
              ),
            );
          },
          onSave: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Job Saved!")),
            );
          },
          onDelete: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Job Remove action clicked")),
            );
          },
        );
      },
    );
  }

  Widget _buildCompanyList(BuildContext context) {
    // Mock Data for Companies
    final companies = [
      {"name": "Google", "location": "Mountain View, CA"},
      {"name": "Spotify", "location": "Stockholm, Sweden"},
      {"name": "Microsoft", "location": "Redmond, WA"},
      {"name": "Airbnb", "location": "San Francisco, CA"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return CompanyCard(
          companyName: company['name']!,
          location: company['location']!,
          onViewDetail: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailPage(title: company['name']!),
              ),
            );
          },
        );
      },
    );
  }
}
