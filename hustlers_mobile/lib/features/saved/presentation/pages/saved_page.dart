import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BeautifulAppBar(title: "Saved Jobs"),
      body: Center(child: Text("Saved Jobs Page")),
    );
  }
}
