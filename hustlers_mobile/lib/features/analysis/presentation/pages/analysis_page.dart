import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hustlers_mobile/core/presentation/widgets/custom_app_bar.dart'; 
import 'analysis_result_page.dart';
import '../providers/analysis_provider.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  File? _selectedResume;
  int _limit = 5;

  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      if (result.files.single.path != null) {
        setState(() {
          _selectedResume = File(result.files.single.path!);
        });
      }
    }
  }

  Future<void> _analyzeResume() async {
    if (_formKey.currentState!.validate() && _selectedResume != null) {
      await ref.read(analysisControllerProvider.notifier).analyze(
        file: _selectedResume!,
        githubUsername: _githubController.text,
        role: _roleController.text,
        limit: _limit,
      );
      
      // The listener in build() will handle navigation
    } else {
       if (_selectedResume == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a resume file (PDF/DOC).')),
          );
       }
    }
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
                builder: (context) => AnalysisResultPage(analysisResponse: data),
              ),
            );
          }
        },
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
        loading: () {},
      );
    });

    final state = ref.watch(analysisControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BeautifulAppBar(title: 'Resume Rater', transparent: false), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Get AI-powered insights on your resume',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _roleController,
                  decoration: InputDecoration(
                    labelText: 'Target Role',
                    hintText: 'e.g., Backend Developer',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the target role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _githubController,
                  decoration: InputDecoration(
                    labelText: 'GitHub Username',
                    hintText: 'e.g., Biruktadele',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.code),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your GitHub username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Limit Input
                Row(
                  children: [
                    const Text("Analysis Limit: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Slider(
                        value: _limit.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: _limit.toString(),
                        onChanged: (value) {
                          setState(() {
                            _limit = value.toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: _pickResume,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _selectedResume == null ? Icons.upload_file : Icons.check_circle,
                          size: 48,
                          color: _selectedResume == null ? Colors.grey : Colors.green,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedResume == null
                              ? 'Tap to upload Resume (PDF/DOCX)'
                              : 'Selected: ${_selectedResume!.path.split('/').last}',
                          style: TextStyle(
                             color: _selectedResume == null ? Colors.grey.shade700 : Colors.green.shade700,
                             fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : _analyzeResume,
                  icon: isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                      : const Icon(Icons.analytics_outlined),
                  label: Text(isLoading ? 'Analyzing...' : 'Analyze Resume'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    )
    );
  }
}
