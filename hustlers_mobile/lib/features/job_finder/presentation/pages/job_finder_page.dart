import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hustlers_mobile/features/saved/data/models/saved_job_model.dart';
import 'package:hustlers_mobile/features/saved/presentation/providers/saved_jobs_provider.dart';
import '../../data/models/company_model.dart';
import '../providers/company_provider.dart';
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
    final companyState = ref.watch(companySearchProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showFilterDialog(context, companyState),
              icon: const Icon(Icons.tune),
              label: const Text("Filter / Refresh Search"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: companyState.companies.when(
            data: (companies) {
              if (companies.isEmpty) {
                return const Center(
                  child: Text("No companies found nearby."),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return CompanyCard(
                    companyName: company.name,
                    location: company.address.isNotEmpty
                        ? company.address
                        : "${company.latitude.toStringAsFixed(4)}, ${company.longitude.toStringAsFixed(4)}",
                    companyType: company.type,
                    phoneNumber: company.phone,
                    onViewDetail: () {
                      _showCompanyDetail(context, company);
                    },
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${company.name} Saved!")),
                      );
                    },
                  );
                },
              );
            },
            error: (e, s) => Center(child: Text("Error: $e")),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  void _showCompanyDetail(BuildContext context, CompanyModel company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    company.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      company.type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.deepPurple.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (company.description.isNotEmpty) ...[
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company.description,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildDetailRow(Icons.phone, "Phone", company.phone),
                  _buildDetailRow(Icons.email, "Email", company.email),
                  _buildDetailRow(Icons.web, "Website", company.website),
                  _buildDetailRow(Icons.location_on, "Coordinates",
                      "${company.latitude}, ${company.longitude}"),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, CompanySearchState currentState) {
    String location = currentState.location;
    String companyType = currentState.companyType;
    String searchType = currentState.searchType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Search Parameters", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),
                  _buildDropdown("Location", location, [
                    "Addis Ababa", "Adama", "Bahir Dar", "Hawassa", "Mekelle", "Dire Dawa", "Gondar", "Jimma"
                  ], (val) => setState(() => location = val!)),
                  const SizedBox(height: 16),
                  _buildDropdown("Company Type", companyType, [
                    "Hotel", "Hospital", "Pharmacy", "Restaurant", "Cafe", "Gym", "School"
                  ], (val) => setState(() => companyType = val!)),
                  const SizedBox(height: 16),
                  _buildDropdown("Find Type", searchType, [
                    "Fast Find", "Normal Find", "Deep Large Scale Find"
                  ], (val) => setState(() => searchType = val!)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(companySearchProvider.notifier).updateParams(
                          location: location,
                          companyType: companyType,
                          searchType: searchType,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Search"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                         foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

}
