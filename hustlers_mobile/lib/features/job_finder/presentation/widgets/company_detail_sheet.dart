import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hustlers_mobile/features/job_finder/data/models/company_model.dart';
import 'package:hustlers_mobile/features/job_finder/presentation/providers/company_insights_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetailSheet extends ConsumerWidget {
  final CompanyModel company;

  const CompanyDetailSheet({super.key, required this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(companyInsightsProvider(company));
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                _buildSliverAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCompanyHeader(theme),
                        const SizedBox(height: 24),
                        _buildContactInfo(theme),
                        if (company.description.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildDescription(theme),
                        ],
                        const SizedBox(height: 32),
                        _buildSectionHeader("AI Insights", Icons.auto_awesome),
                        const SizedBox(height: 16),
                        _buildInsights(insightsAsync, theme),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.deepPurple,
      expandedHeight: 120,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple, Colors.indigo],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.business,
                  size: 150,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      company.name.isNotEmpty ? company.name[0].toUpperCase() : 'C',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCompanyHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          company.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.deepPurple.shade100),
          ),
          child: Text(
            company.type.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.deepPurple.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildContactRow(Icons.phone_rounded, company.phone, "Phone"),
          const Divider(height: 24),
          _buildContactRow(Icons.email_rounded, company.email, "Email"),
          const Divider(height: 24),
          _buildContactRow(Icons.language_rounded, company.website, "Website", isLink: true),
          const Divider(height: 24),
          _buildContactRow(Icons.location_on_rounded, "${company.latitude}, ${company.longitude}", "Location"),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String value, String label, {bool isLink = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.deepPurple, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              InkWell(
                onTap: isLink && value.isNotEmpty ? () async {
                   final Uri url = Uri.parse(value.startsWith('http') ? value : 'https://$value');
                   if (await canLaunchUrl(url)) await launchUrl(url);
                } : null,
                child: Text(
                  value.isNotEmpty ? value : "Not Available",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: isLink && value.isNotEmpty ? Colors.blue[700] : Colors.black87,
                    fontWeight: FontWeight.w600,
                    decoration: isLink && value.isNotEmpty ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("About", Icons.info_outline),
        const SizedBox(height: 12),
        Text(
          company.description,
          style: GoogleFonts.inter(
            fontSize: 15,
            height: 1.6,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInsights(AsyncValue insightsAsync, ThemeData theme) {
    return insightsAsync.when(
      data: (insights) => Column(
        children: [
          if (insights.currentState != null)
             _buildInsightCard(
               title: "Current State Analysis",
               color: Colors.blue.shade50,
               borderColor: Colors.blue.shade200,
               icon: Icons.analytics_outlined,
               iconColor: Colors.blue.shade700,
               children: [
                 _buildInsightRow("Digital Presence", insights.currentState?.digitalPresence),
                 _buildInsightRow("Online Visibility", insights.currentState?.onlineVisibility),
               ]
             ),

          if (insights.keyProblems?.isNotEmpty ?? false)
            _buildInsightCard(
              title: "Key Paint Points",
              color: Colors.red.shade50,
              borderColor: Colors.red.shade200,
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.red.shade700,
              children: insights.keyProblems!.map<Widget>((e) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.remove_circle_outline, size: 16, color: Colors.red.shade400),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e, style: GoogleFonts.inter(fontSize: 14))),
                    ],
                  ),
                )
              ).toList(),
            ),

          if (insights.businessImpact != null)
             _buildInsightCard(
               title: "Business Impact",
               color: Colors.orange.shade50,
               borderColor: Colors.orange.shade200,
               icon: Icons.trending_down,
               iconColor: Colors.orange.shade800,
               children: [
                 _buildInsightRow("Lost Leads", insights.businessImpact?.lostLeads),
                 _buildInsightRow("Revenue Leakage", insights.businessImpact?.revenueLeakage),
               ]
             ),

          if (insights.recommendedSolutions != null)
             _buildInsightCard(
               title: "Recommended Solutions",
               color: Colors.green.shade50,
               borderColor: Colors.green.shade200,
               icon: Icons.lightbulb_outline,
               iconColor: Colors.green.shade700,
               children: [
                 _buildInsightRow("Website", insights.recommendedSolutions?.website),
                 _buildInsightRow("SEO", insights.recommendedSolutions?.seo),
                 _buildInsightRow("Marketing", insights.recommendedSolutions?.marketing),
               ]
             ),

          if (insights.outreachSummary != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.rocket_launch, color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Outreach Pitch",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    insights.outreachSummary?.primaryPitch ?? "",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CALL TO ACTION",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insights.outreachSummary?.callToAction ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                "Failed to load insights",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(e.toString(), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required Color color,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _buildInsightRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            width: 6,
            margin: const EdgeInsets.only(top: 7, right: 12),
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
