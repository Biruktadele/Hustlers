import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hustlers_mobile/features/analysis/presentation/providers/analysis_provider.dart';
import 'dart:io';

import 'package:hustlers_mobile/features/analysis/data/models/analysis_response_model.dart';
import 'package:hustlers_mobile/features/analysis/presentation/pages/analysis_result_page.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';

class ResumeRaterPage extends ConsumerStatefulWidget {
  const ResumeRaterPage({super.key});

  @override
  ConsumerState<ResumeRaterPage> createState() => _ResumeRaterPageState();
}

class _ResumeRaterPageState extends ConsumerState<ResumeRaterPage> {
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
    if (_roleController.text.isEmpty ||
        _githubController.text.isEmpty ||
        _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and upload a PDF')),
      );
      return;
    }

    ref.read(analysisControllerProvider.notifier).analyze(
          file: File(_pickedFile!.path!),
          githubUsername: _githubController.text,
          role: _roleController.text,
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
    ref.listen(analysisControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AnalysisResultPage(analysisResponse: data),
              ),
            );
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
        loading: () {
          // Optionally, show a loading indicator
        },
      );
    });
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
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(analysisControllerProvider);
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      shadowColor: Colors.deepPurple.withOpacity(0.4),
                      disabledBackgroundColor: Colors.deepPurple.shade200,
                    ),
                    child: state.isLoading 
                      ? const SizedBox(
                          height: 24, 
                          width: 24, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                        )
                      : Text(
                          "Analyze Resume", 
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
