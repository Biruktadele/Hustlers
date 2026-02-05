import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BeautifulAppBar(title: "About Us"),
      body: Center(child: Text("About Us Page")),
    );
  }
}
