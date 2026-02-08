import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../providers/saved_jobs_provider.dart';
import '../../../job_finder/presentation/widgets/job_card.dart';
import '../../../job_finder/presentation/pages/job_detail_page.dart';
import '../../../job_finder/data/models/job_model.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedJobsAsync = ref.watch(savedJobsProvider);

    return Scaffold(
      appBar: const BeautifulAppBar(title: "Saved Jobs"),
      body: savedJobsAsync.when(
        data: (savedJobs) {
          if (savedJobs.isEmpty) {
            return const Center(child: Text("No saved jobs yet"));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final savedJob = savedJobs[index];
              return JobCard(
                jobTitle: savedJob.jobName,
                companyName: "Hustlers", // Fallback
                location: "Addis Ababa", // Fallback
                salary: _formatPrice(savedJob.price),
                date: savedJob.postedAt != null 
                    ? savedJob.postedAt!.split('T')[0] 
                    : "Recently",
                actionIcon: Icons.delete_outline,
                onViewDetail: () {
                   // Convert SavedJobModel back to JobModel for detail page
                   final job = JobModel(
                      id: savedJob.id,
                      jobName: savedJob.jobName,
                      jobType: savedJob.jobType,
                      price: savedJob.price,
                      deepLink: savedJob.deepLink,
                      jobDescription: savedJob.jobDescription,
                      expireDate: savedJob.expireDate,
                      postedAt: savedJob.postedAt,
                   );
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailPage(job: job),
                    ),
                  );
                },
                onAction: () async {
                  await ref.read(savedJobsProvider.notifier).deleteJob(savedJob.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${savedJob.jobName} removed.")),
                    );
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }

  String _formatPrice(String price) {
    final numeric = price.replaceAll(RegExp(r'[^0-9.,-]'), '');
    return numeric.isEmpty ? price : numeric;
  }
}
