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
                companyName: savedJob.moreInfo.isNotEmpty ? "See Details" : "Hustlers",
                location: savedJob.location,
                salary: savedJob.price,
                date: savedJob.expireDate ?? "Recently",
                actionIcon: Icons.delete_outline,
                onViewDetail: () {
                   // Convert SavedJobModel back to JobModel for detail page
                   final job = JobModel(
                      jobTitle: savedJob.jobName,
                      jobType: savedJob.jobType,
                      salary: savedJob.price,
                      deeplink: savedJob.deepLink,
                      description: savedJob.jobDescription,
                      deadline: savedJob.expireDate ?? "",
                      location: savedJob.location,
                      sex: savedJob.sex,
                      moreInfo: savedJob.moreInfo,
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

  // Helper removed as formatting is handled by API or Model
}
