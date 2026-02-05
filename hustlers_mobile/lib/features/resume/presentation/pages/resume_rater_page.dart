import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';

class ResumeRaterPage extends StatelessWidget {
  const ResumeRaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BeautifulAppBar(title: "Resume Rater"),
      body: Center(child: Text("Resume Rater Page")),
    );
  }
}
