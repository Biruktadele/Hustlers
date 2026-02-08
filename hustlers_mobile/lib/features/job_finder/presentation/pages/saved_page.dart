// import 'package:flutter/material.dart';
// import '../../../../core/presentation/widgets/custom_app_bar.dart';
// import '../widgets/job_card.dart';
// import '../widgets/company_card.dart';
// import 'job_detail_page.dart';

// class SavedPage extends StatefulWidget {
//   const SavedPage({super.key});

//   @override
//   State<SavedPage> createState() => _SavedPageState();
// }

// class _SavedPageState extends State<SavedPage> {
//   // Mock Data for Saved Jobs
//   final List<Map<String, String>> _savedJobs = [
//     {
//       "title": "Senior Flutter Developer",
//       "company": "Tech Corp",
//       "location": "Addis Ababa",
//       "salary": "\$120k - \$150k/yr",
//       "date": "2 days ago"
//     },
//     {
//       "title": "Backend Engineer",
//       "company": "Data Systems",
//       "location": "Hawassa",
//       "salary": "\$130k - \$160k/yr",
//       "date": "1 week ago"
//     },
//   ];

//   // Mock Data for Saved Companies
//   final List<Map<String, String>> _savedCompanies = [
//     {
//       "name": "Ethio Telecom",
//       "location": "Addis Ababa",
//       "type": "Telecommunications",
//       "phone": "+251 115 500 000"
//     },
//     {
//       "name": "Kuriftu Resort",
//       "location": "Adama",
//       "type": "Hospitality",
//       "phone": "+251 221 119 090"
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: const BeautifulAppBar(
//           title: "Saved Items",
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.deepPurple.shade500.withOpacity(0.3),
//                       blurRadius: 15,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: TabBar(
//                   indicator: BoxDecoration(
//                     color: Colors.deepPurple,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.grey,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   dividerColor: Colors.transparent,
//                   overlayColor: WidgetStateProperty.all(Colors.transparent),
//                   tabs: const [
//                     Tab(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text(
//                           "Jobs",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                     Tab(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text(
//                           "Company",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   _buildJobsList(context),
//                   _buildCompanyList(context),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildJobsList(BuildContext context) {
//     if (_savedJobs.isEmpty) {
//       return Center(
//         child: Text("No saved jobs", style: TextStyle(color: Colors.grey.shade600)),
//       );
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.only(top: 8, bottom: 80),
//       itemCount: _savedJobs.length,
//       itemBuilder: (context, index) {
//         final job = _savedJobs[index];
//         return JobCard(
//           jobTitle: job['title']!,
//           companyName: job['company']!,
//           location: job['location']!,
//           salary: job['salary']!,
//           date: job['date']!,
//           actionIcon: Icons.delete_outline,
//           onViewDetail: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     JobDetailPage(title: job['title']!, job: job),
//               ),
//             );
//           },
//           onAction: () {
//             setState(() {
//               _savedJobs.removeAt(index);
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Job Removed!")),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildCompanyList(BuildContext context) {
//     if (_savedCompanies.isEmpty) {
//       return Center(
//         child: Text("No saved companies", style: TextStyle(color: Colors.grey.shade600)),
//       );
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.only(top: 8, bottom: 80),
//       itemCount: _savedCompanies.length,
//       itemBuilder: (context, index) {
//         final company = _savedCompanies[index];
//         return CompanyCard(
//           companyName: company['name']!,
//           location: company['location']!,
//           companyType: company['type']!,
//           phoneNumber: company['phone']!,
//           actionIcon: Icons.delete_outline,
//           onViewDetail: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => JobDetailPage(
//                   title: company['name']!,
//                   job: {
//                     "title": company['name']!,
//                     "company": company['type']!,
//                     "location": company['location']!,
//                     "salary": "N/A",
//                     "date": "N/A",
//                   },
//                 ),
//               ),
//             );
//           },
//           onAction: () {
//             setState(() {
//               _savedCompanies.removeAt(index);
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Company Removed!")),
//             );
//           },
//         );
//       },
//     );
//   }
// }
