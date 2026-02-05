import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';

class JobDetailPage extends StatelessWidget {
  final String title;

  const JobDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BeautifulAppBar(title: title),
      body: Center(
        child: Text("Detail for $title"),
      ),
    );
  }
}
