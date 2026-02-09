import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hustlers_mobile/features/saved/presentation/providers/saved_jobs_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure url_launcher is added
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../data/models/job_model.dart';
import 'package:google_fonts/google_fonts.dart';

class JobDetailPage extends ConsumerWidget {
  final JobModel job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedJobsAsync = ref.watch(savedJobsProvider);
    final jobId = job.deeplink.hashCode;
    final savedJob = savedJobsAsync.asData?.value.where((s) => s.id == jobId).firstOrNull;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BeautifulAppBar(title: job.jobTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.jobTitle,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.jobType,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
             const SizedBox(height: 8),
            Text(
              job.salary,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            
            // Status Management Button for Saved Jobs
            if (savedJob != null) ...[
               _buildStatusButton(context, ref, savedJob),
               const SizedBox(height: 20),
            ],

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.location_on, "Location", job.location),
                  const SizedBox(height: 12),
                  if (job.sex.isNotEmpty) ...[
                     _buildDetailRow(Icons.person, "Sex", job.sex),
                     const SizedBox(height: 12),
                  ],
                  _buildDetailRow(Icons.calendar_today, "Deadline", job.deadline),
                   if (job.moreInfo.isNotEmpty)
                   ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.info_outline, "More Info", job.moreInfo),
                   ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Description",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
             const SizedBox(height: 12),
            Text(
              job.description,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
             const SizedBox(height: 40),
             SizedBox(
               width: double.infinity,
               height: 55,
               child: ElevatedButton(
                 onPressed: () => _launchURL(job.deeplink),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.deepPurple,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(16),
                   ),
                   elevation: 5,
                   shadowColor: Colors.deepPurple.withOpacity(0.4),
                 ),
                 child: Text(
                   "Apply Now",
                   style: GoogleFonts.poppins(
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                   ),
                 ),
               ),
             ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, WidgetRef ref, dynamic savedJob) {
    String buttonText;
    Color buttonColor;
    IconData icon;
    String nextStatus;
    VoidCallback? onPressed;

    switch (savedJob.status) {
      case "Saved":
        buttonText = "Mark as Applied";
        buttonColor = Colors.blue;
        icon = Icons.send;
        nextStatus = "Applied";
        onPressed = () =>  ref.read(savedJobsProvider.notifier).markAsApplied(savedJob.id);
        break;
      case "Applied":
        buttonText = "Mark as Pending";
        buttonColor = Colors.orange;
        icon = Icons.hourglass_empty;
         nextStatus = "Pending";
        onPressed = () => ref.read(savedJobsProvider.notifier).updateStatus(savedJob.id, nextStatus);
        break;
      case "Pending":
        buttonText = "Mark as Scheduled";
        buttonColor = Colors.teal;
        icon = Icons.calendar_today;
        nextStatus = "Scheduled";
        onPressed = () => _showScheduleDialog(context, ref, savedJob.id);
        break;
      case "Scheduled":
        buttonText = "Scheduled";
        buttonColor = Colors.green;
        icon = Icons.check_circle;
        nextStatus = "Scheduled";
         onPressed = () => _showScheduleDialog(context, ref, savedJob.id); // Allow editing
        break;
      default:
        buttonText = "Update Status";
        buttonColor = Colors.grey;
        icon = Icons.edit;
        nextStatus = "Saved";
         onPressed = () {};
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          buttonText,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showScheduleDialog(BuildContext context, WidgetRef ref, int jobId) {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add to Schedule", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Interview Title", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
             TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)", border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)),
               onTap: () async {
                 DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), 
                    lastDate: DateTime(2101)
                );
                if(pickedDate != null ){
                   dateController.text = pickedDate.toIso8601String().split('T')[0];
                }
              },
            ),
             const SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: "Time (HH:MM)", border: OutlineInputBorder(), icon: Icon(Icons.access_time)),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now()
                );
                 if(pickedTime != null && context.mounted ){
                   timeController.text = pickedTime.format(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              // In the future we can save specific schedule details
              ref.read(savedJobsProvider.notifier).updateStatus(jobId, "Scheduled");
              Navigator.pop(context);
              if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job scheduled successfully!")));
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);

    // 1. Check if it is a Telegram link and try to use the tg:// scheme first
    if (url.host == 't.me' || url.host == 'telegram.me') {
      try {
        Uri? tgUrl;
        final String path = url.path;
        
        if (path.startsWith('/joinchat/')) {
          final invite = path.substring('/joinchat/'.length);
          tgUrl = Uri.parse("tg://join?invite=$invite");
        } else if (path.startsWith('/+')) {
           final invite = path.substring('/+'.length);
           tgUrl = Uri.parse("tg://join?invite=$invite");
        } else if (path.length > 1) {
          final parts = path.substring(1).split('/');
          if (parts.length == 1) {
            // e.g. t.me/username
            final query = url.hasQuery ? "&${url.query}" : "";
             tgUrl = Uri.parse("tg://resolve?domain=${parts[0]}$query");
          } else if (parts.length == 2) {
            if (int.tryParse(parts[1]) != null) {
              // e.g. t.me/channel/123
              tgUrl = Uri.parse("tg://resolve?domain=${parts[0]}&post=${parts[1]}");
            } else {
              // Handle Mini App: /botname/appname
              // e.g. t.me/bot/app?startapp=...
              final query = url.hasQuery ? "&${url.query}" : "";
              tgUrl = Uri.parse("tg://resolve?domain=${parts[0]}&appname=${parts[1]}$query");
            }
          }
        }
        
        if (tgUrl != null) {
          // Try launching the tg:// link. This is the most reliable way to open the app directly.
          if (await launchUrl(tgUrl, mode: LaunchMode.externalNonBrowserApplication)) {
            return;
          }
        }
      } catch (e) {
        debugPrint("Error constructing/launching tg:// URI: $e");
      }

      // 2. If tg:// failed, try launching the original HTTPS link with externalNonBrowserApplication
      // This might work if the system recognizes the https link association.
      try {
        if (await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)) {
          return;
        }
      } catch (_) {}
    }

    // 3. Fallback to generic external application (Browser)
    // This will open Chrome/Safari, which usually handles the redirect to Telegram if installed.
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
