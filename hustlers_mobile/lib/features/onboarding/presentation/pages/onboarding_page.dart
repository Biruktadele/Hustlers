import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../providers/onboarding_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  final List<OnboardingSlide> slides = [
    OnboardingSlide(
      title: "Welcome to Hustlers",
      description: "Find your dream job and build your career with us.",
      imagePath: "assets/images/log_hustler.jpg", // Ensure you add this file!
      isLogo: true,
    ),
    OnboardingSlide(
      title: "Track Your Application",
      description: "Stay updated with real-time notifications on your job applications.",
      icon: Icons.track_changes,
    ),
    OnboardingSlide(
      title: "Get Hired",
      description: "Connect with top recruiters and land your next opportunity.",
      icon: Icons.work,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => isLastPage = index == slides.length - 1);
            },
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(slides[index]);
            }),
      ),
      bottomSheet: isLastPage
          ? Container(
              height: 80,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () async {
                  await ref
                      .read(onboardingControllerProvider.notifier)
                      .completeOnboarding();
                  
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                    );
                  }
                },
                child: const Text('Get Started', style: TextStyle(fontSize: 18)),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _pageController.jumpToPage(slides.length - 1),
                    child: const Text('SKIP'),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: slides.length,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Theme.of(context).primaryColor,
                      ),
                      onDotClicked: (index) => _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text('NEXT'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (slide.isLogo)
            // Display Image if logo, otherwise Icon
            Image.asset(
              slide.imagePath!,
              height: 200,
              errorBuilder: (context, error, stackTrace) =>
                   const Icon(Icons.business_center, size: 150, color: Colors.deepPurple),
            )
          else
            Icon(slide.icon, size: 150, color: Colors.deepPurple),
          const SizedBox(height: 40),
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final String? imagePath;
  final IconData? icon;
  final bool isLogo;

  OnboardingSlide({
    required this.title,
    required this.description,
    this.imagePath,
    this.icon,
    this.isLogo = false,
  });
}
