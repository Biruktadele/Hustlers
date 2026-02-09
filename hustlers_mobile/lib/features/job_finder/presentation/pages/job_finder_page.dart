import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hustlers_mobile/features/saved/data/models/saved_job_model.dart';
import 'package:hustlers_mobile/features/saved/presentation/providers/saved_jobs_provider.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../widgets/job_card.dart';
import '../widgets/company_card.dart';
import '../providers/job_provider.dart';
import 'job_detail_page.dart';

class JobFinderPage extends ConsumerStatefulWidget {
  const JobFinderPage({super.key});

  @override
  ConsumerState<JobFinderPage> createState() => _JobFinderPageState();
}

class _JobFinderPageState extends ConsumerState<JobFinderPage> {
  String selectedCity = "Addis Ababa";
  Timer? _refreshTimer;
  final List<String> cities = [
    "Addis Ababa",
    "Adama",
    "Hawassa",
    "Bahir Dar",
    "Dire Dawa",
    "Asosa"
  ];

  @override
  void initState() {
    super.initState();
    // Automatically reload jobs every 8 hours while the app is open
    _refreshTimer = Timer.periodic(const Duration(hours: 8), (timer) {
      if (mounted) {
        ref.refresh(jobListProvider);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

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
                   _buildJobsList(context, ref),
                   _buildCompanyList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsList(BuildContext context, WidgetRef ref) {
    final jobsAsyncValue = ref.watch(jobListProvider);
    final savedJobsAsync = ref.watch(savedJobsProvider);

    return jobsAsyncValue.when(
      data: (jobs) {
        if (jobs.isEmpty) {
          return const Center(child: Text("No jobs found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            final jobId = job.deeplink.hashCode;
            final isSaved = savedJobsAsync.asData?.value.any((s) => s.id == jobId) ?? false;
            
            return JobCard(
              jobTitle: job.jobTitle,
              companyName: job.moreInfo.isNotEmpty ? "See Details" : "Hustlers", 
              location: job.location,
              salary: job.salary,
              date: job.deadline,
              actionIcon: isSaved ? Icons.bookmark : Icons.bookmark_border,
              actionIconColor: isSaved ? Colors.deepPurple : Colors.grey,
              onViewDetail: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetailPage(job: job),
                  ),
                );
              },
              onAction: () async {
                if (isSaved) {
                  await ref.read(savedJobsProvider.notifier).deleteJob(jobId);
                   if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${job.jobTitle} removed from favorites!")),
                    );
                  }
                } else {
                  final savedJob = SavedJobModel(
                    id: jobId,
                    jobName: job.jobTitle,
                    jobType: job.jobType,
                    price: job.salary,
                    deepLink: job.deeplink,
                    jobDescription: job.description,
                    expireDate: job.deadline,
                    postedAt: null,
                    status: "Saved",
                    location: job.location,
                    sex: job.sex,
                    moreInfo: job.moreInfo,
                  );
                  await ref.read(savedJobsProvider.notifier).saveJob(savedJob);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${job.jobTitle} saved to favorites!")),
                    );
                  }
                }
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Error: $error")),
    );
  }

  String _formatPrice(String price) {
    // Keep only digits, dots, commas, and dashes
    final numeric = price.replaceAll(RegExp(r'[^0-9.,-]'), '');
    return numeric.isEmpty ? price : numeric;
  }

  Widget _buildCompanyList(BuildContext context) {
    // Mock Data for Companies with Ethiopian Context
    final allCompanies = [
      {
        "name": "Ethio Telecom",
        "location": "Addis Ababa",
        "type": "Telecommunications",
        "phone": "+251 115 500 000"
      },
      {
        "name": "Commercial Bank of Ethiopia",
        "location": "Addis Ababa",
        "type": "Finance",
        "phone": "+251 115 515 004"
      },
      {
        "name": "Kuriftu Resort",
        "location": "Adama",
        "type": "Hospitality",
        "phone": "+251 221 119 090"
      },
      {
        "name": "Haile Resort",
        "location": "Hawassa",
        "type": "Hospitality",
        "phone": "+251 462 201 228"
      },
      {
        "name": "Avanti Blue Nile",
        "location": "Bahir Dar",
        "type": "Hospitality",
        "phone": "+251 582 204 200"
      },
       {
        "name": "Dire Dawa Textile",
        "location": "Dire Dawa",
        "type": "Manufacturing",
        "phone": "+251 251 112 345"
      },
       {
        "name": "Grand Asosa Hotel",
        "location": "Asosa",
        "type": "Hospitality",
        "phone": "+251 577 750 001"
      },
    ];

    // Filter based on selected city
    // In a real app, you might strict filter. Here we ensure at least one matches or show all if city is "All" (if we had an All option)
    // For now, let's just filter by the exact string. Use 'Addis Ababa' as default.
    final companies = allCompanies.where((c) => c['location'] == selectedCity).toList();
    // If empty for demo purposes fallback to all or empty list
    final displayCompanies = companies.isEmpty ? allCompanies : companies;

    return Column(
      children: [
        // City Selector
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedCity,
              icon: const Icon(Icons.location_on, color: Colors.deepPurple),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Poppins', 
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCity = newValue;
                  });
                }
              },
              items: cities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        
        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: displayCompanies.length,
            itemBuilder: (context, index) {
              final company = displayCompanies[index];
              return CompanyCard(
                companyName: company['name']!,
                location: company['location']!,
                companyType: company['type']!,
                phoneNumber: company['phone']!,
                 onViewDetail: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Details for ${company['name']} coming soon!")),
                  );
                },
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Company Saved!")),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
