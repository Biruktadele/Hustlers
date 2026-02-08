import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hustlers_mobile/features/analysis/data/models/analysis_response_model.dart';
import 'package:hustlers_mobile/features/analysis/presentation/pages/analysis_result_page.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';

class ResumeRaterPage extends StatefulWidget {
  const ResumeRaterPage({super.key});

  @override
  State<ResumeRaterPage> createState() => _ResumeRaterPageState();
}

class _ResumeRaterPageState extends State<ResumeRaterPage> {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  PlatformFile? _pickedFile;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final file = result.files.first;
        if (file.extension != 'pdf') {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Only PDF files are allowed')),
          );
          return;
        }
        setState(() {
          _pickedFile = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  void _submit() {
    if (_roleController.text.isEmpty || _githubController.text.isEmpty || _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and upload a PDF')),
      );
      return;
    }

    // Demo JSON data
    const demoJson = {
      "status": "success",
      "data": {
        "resume": {
          "name": "Biruk Tadel",
          "email": "dagibura33@gmail.com",
          "phone": "+2519 6100",
          "skills": [
            "Technical skills — Python",
            "Dart",
            "C++",
            "Java",
            "Flutter",
            "Django",
            "Flask",
            "Javascript",
            "Git",
            "MySQL",
            "PostgreSQL",
            "Firebase",
            "Soft Skills — Team Work",
            "Agile Development"
          ],
          "experience": [
            "Competitive Programming Contest Manager Sep 2024 – Jan 2025 | Adama , Ethiopia",
            "CSEC ASTU Club",
            "Orchestrated weekly programming competitions featuring 15+ curated problems and 500+ test cases",
            "•",
            "curated 12 challenging problem sets (each with 3-5 problems), specifically covering advanced Data Structures",
            "•",
            "and Algorithms for 120+ club members.",
            "Mentored 50+ club members, directly contributing to 75% of participants achieving higher competitive",
            "•",
            "programming ranks on platforms like Codeforces and LeetCode.",
            "Software Engineer Intern Jul 2025 – Sep 2025 | Adama , Ethiopia",
            "A2SV - backed by Google",
            "Collaborated to develop an AI-integrated mobile application leveraging the AliExpress API, enabling 10,000+",
            "•",
            "users to find optimal products.",
            "Applied Clean Architecture and industry best practices, boosting code maintainability by 25% and accelerating",
            "•",
            "future feature development by 15%, ensuring scalability for 20+ planned additions."
          ],
          "education": [
            "Bsc in Computer Science and Engineering Mar 2023 – Present | Adama, Ethiopia",
            "Adama Science and Technology University",
            "One of Ethiopia's two leading universities, established to help the country's industrialization efforts.",
            "•",
            "Relevant Coursework: Data Structures & Algorithms, Database Management Systems, Computer Networking,",
            "•",
            "Object-Oriented Programming (OOP), Operating Systems, Advanced Programming",
            "Data Structures and Algorithms, Jan 2025 – Present | Adama , Ethiopia",
            "A2SV - Africa to Silicon Valley Coding Academy: Backed by Google",
            "Completed a 30+ hours/week curriculum focused on advanced Data Structures and Algorithms, solving 1000+",
            "•",
            "problems on Codeforces and LeetCode"
          ],
          "projects": [
            "E-commerce with Chatting Feature Project Jun 2025 – Jul 2025",
            "Flutter Mobile Developer",
            "Engineered real-time chat with Socket.IO and stateless REST API supporting 100s of concurrent users.",
            "•",
            "Implemented BLoC for scalable state management, achieving 90% unit and widget test coverage for reliability.",
            "•",
            "Translated 10+ complex Figma designs into pixel-perfect Flutter UI for a polished user experience.",
            "•",
            "Intelligent AliExpress Assistant Aug 2025 – Sep 2025",
            "Shopally",
            "Developed an AI-integrated platform (using Affiliate Market API) to enable intelligent product search and",
            "•",
            "comparison.",
            "Implemented AI-powered search and comparison features, accelerating product discovery by 30% and",
            "•",
            "improving personalized recommendation accuracy by 20%.",
            "Enhanced user shopping efficiency by an estimated 25% through deal tracking and optimized decision-making",
            "•",
            "tools for millions of products.",
            "Achievements or Awards",
            "Ranked Top 3 at Adama Science and Technology University in the EtCPC National Contest, and placed among",
            "•",
            "the Top 10 teams in Ethiopia.",
            "Achieved 1st Place in the A2SV Cohort 6 Team Project Competition, outperforming 14 project teams.",
            "•"
          ]
        },
        "github": {
          "username": "Biruktadele",
          "role": "backend",
          "repos": [
            {
              "name": "Biruktadele",
              "url": "https://github.com/Biruktadele/Biruktadele",
              "description": "Config files for my GitHub profile.",
              "scores": {
                "relevance": 5,
                "impact": 2,
                "complexity": 1,
                "quality_docs_tests": 2,
                "recency": 5,
                "ownership": 5,
                "results_metrics": 5
              },
              "total": 25,
              "evidence": {
                "relevance": "matched: backend, api, postgres, mysql, fastapi, django",
                "impact": "stars: 3, forks: 0",
                "complexity": "size_kb: 65, languages: none",
                "quality_docs_tests": "install:False, usage:False, tests:True, ci:True",
                "recency": "updated 1 months ago",
                "ownership": "original repo",
                "results_metrics": "metrics:True, outcomes:True"
              }
            }
          ]
        },
        "suggestions": {
          "resume_summary": "Biruk is a highly motivated Computer Science student with a strong foundation in Data Structures & Algorithms, Python (Django, Flask), and database management (MySQL, PostgreSQL). He demonstrates experience in API integration, backend architecture, and developing scalable solutions, evidenced by projects that improved maintainability by 25% and accelerated feature development by 15%. Biruk is an award-winning competitive programmer and an effective mentor, ready to transition his analytical and problem-solving skills to a dedicated backend engineering role.",
          "strengths": [
            "Strong technical foundation in Python (Django, Flask), MySQL, PostgreSQL, and Data Structures & Algorithms, backed by A2SV and competitive programming achievements.",
            "Demonstrated ability in API development and integration (AliExpress, Affiliate Market API) and engineering real-time REST APIs (Socket.IO).",
            "Applied Clean Architecture and industry best practices, boosting code maintainability by 25% and accelerating future feature development by 15%.",
            "Proven impact with quantifiable results, including 30% faster product discovery and 20% improved recommendation accuracy.",
            "Leadership and mentorship experience as a Competitive Programming Contest Manager, contributing to 75% of participants achieving higher ranks."
          ],
          "gaps": [
            "Inconsistent and future-dated experience/project timelines (e.g., 'Sep 2024 – Jan 2025', 'Jul 2025 – Sep 2025') create confusion and should be corrected or marked as 'expected'.",
            "The primary GitHub repository provided ('Biruktadele/Biruktadele') is a profile configuration, not a substantial project demonstrating backend code quality, architecture, or skills.",
            "While backend skills are present, most listed experience and projects lean towards mobile application development (Flutter), requiring more explicit emphasis on specific backend contributions.",
            "Limited explicit experience with modern backend deployment practices like containerization (Docker) or cloud platforms (AWS, GCP)."
          ],
          "skills_to_add": [
            "Containerization: Docker, Kubernetes",
            "Cloud Platforms: AWS (EC2, S3, RDS, Lambda), GCP, or Azure",
            "CI/CD: Practical experience with GitHub Actions, GitLab CI, or Jenkins for automated deployments.",
            "Advanced Database Concepts: NoSQL databases (e.g., MongoDB, Redis), advanced SQL optimization.",
            "Message Brokers: Kafka or RabbitMQ for asynchronous processing."
          ],
          "project_improvements": [
            "E-commerce with Chatting Feature Project: Expand on the backend architecture, database schema design, API security implementation, and any deployment details (e.g., infrastructure, scaling solutions). Clearly distinguish backend contributions from Flutter UI.",
            "Intelligent AliExpress Assistant: Detail the backend logic for AI integration, data processing pipelines, and API management. Explain how the 'intelligent product search and comparison' was engineered and optimized on the backend.",
            "New Backend Project: Develop a new, complex backend project (e.g., a microservices-based API, a data processing pipeline) using Python/Django/Flask, Docker, and a cloud provider. Ensure it is open-source, well-documented, thoroughly tested, and showcases CI/CD implementation."
          ],
          "bullet_rewrites": [
            "Competitive Programming Contest Manager: 'Orchestrated 12 weekly programming competitions, curating 15+ advanced Data Structures and Algorithms problems and 500+ test cases for 120+ club members.'",
            "Software Engineer Intern (A2SV): 'Engineered an AI-integrated mobile application backend, leveraging the AliExpress API to enable optimal product discovery for 10,000+ users.'",
            "Software Engineer Intern (A2SV): 'Implemented Clean Architecture and industry best practices, boosting backend code maintainability by 25% and accelerating future feature development by 15% for 20+ planned additions.'",
            "E-commerce with Chatting Feature Project: 'Engineered robust real-time chat with Socket.IO and a stateless REST API, supporting 100s of concurrent users and ensuring high availability.'",
            "Intelligent AliExpress Assistant: 'Engineered an AI-integrated backend platform, leveraging the Affiliate Market API to power intelligent product search and comparison, enhancing user efficiency by 25%.'",
            "Intelligent AliExpress Assistant: 'Implemented AI-powered search and comparison features in the backend, accelerating product discovery by 30% and improving personalized recommendation accuracy by 20%.'"
          ],
          "github_highlights": [
            "The current GitHub profile ('Biruktadele/Biruktadele') is a configuration repository and lacks a substantial project to demonstrate backend coding skills. The low impact and complexity scores reflect this.",
            "Actionable: Create a dedicated public GitHub repository for a significant backend project. This project should showcase:",
            "Clean, well-structured Python code (Django/Flask).",
            "Comprehensive unit and integration tests (e.g., using Pytest).",
            "A clear README.md with setup instructions, API endpoints, and usage examples.",
            "Demonstration of database interactions (PostgreSQL/MySQL) and schema design.",
            "Implementation of CI/CD (e.g., GitHub Actions) for automated testing and deployment.",
            "Deployment to a cloud platform (e.g., Heroku, AWS EC2/Lambda) to demonstrate practical application."
          ],
          "next_steps": [
            "Correct Dates: Review and rectify all experience and project dates on the resume to eliminate future or overlapping entries; use 'Expected' where appropriate.",
            "Backend Focus: Reframe your resume summary and bullet points to explicitly highlight your backend contributions, emphasizing Python, API design, database management, and architectural decisions in your projects.",
            "Develop Backend Portfolio: Create and prominently feature a robust, well-documented backend-focused project on GitHub to showcase your technical depth and coding standards.",
            "Expand Toolset: Actively learn and integrate containerization (Docker) and basic cloud services (e.g., AWS EC2, S3, RDS) into your personal projects.",
            "Quantify Impact: Ensure all bullet points use strong action verbs and quantify achievements with measurable results (e.g., 'reduced latency by X%', 'handled Y requests/second')."
          ]
        }
      }
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalysisResultPage(
          analysisResponse: AnalysisResponseModel.fromJson(demoJson),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roleController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BeautifulAppBar(title: "Resume Rater"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Get your resume rated!",
              style: GoogleFonts.poppins(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.deepPurple
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Upload your resume PDF and provide your details to get AI-powered feedback.",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: "Target Role",
                hintText: "e.g. Flutter Developer",
                prefixIcon: const Icon(Icons.work_outline, color: Colors.deepPurple),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
            ),
             const SizedBox(height: 16),
            TextField(
              controller: _githubController,
              decoration: InputDecoration(
                labelText: "GitHub Username",
                hintText: "e.g. biruk123",
                prefixIcon: const Icon(Icons.code, color: Colors.deepPurple),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
            ),
             const SizedBox(height: 20),
            
            // File Upload Area
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.deepPurple.shade200, 
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _pickedFile == null ? Icons.cloud_upload_outlined : Icons.description,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _pickedFile == null ? "Tap to upload Resume (PDF)" : _pickedFile!.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.deepPurple
                      ),
                      textAlign: TextAlign.center,
                    ),
                     if (_pickedFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${(_pickedFile!.size / 1024).toStringAsFixed(2)} KB",
                          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                shadowColor: Colors.deepPurple.withOpacity(0.4),
              ),
              child: Text(
                "Analyze Resume", 
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
