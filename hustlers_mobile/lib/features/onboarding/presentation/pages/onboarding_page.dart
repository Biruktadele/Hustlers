import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
      title: "Elevate Your Career",
      description: "Hustlers uses advanced AI to analyze your resume and match you with your dream job.",
      imagePath: "assets/images/log_husler.jpg",
      isLogo: true,
    ),
    OnboardingSlide(
      title: "Smart Resume Insights",
      description: "Get instant, detailed feedback on your resume to stand out to recruiters.",
      icon: Icons.analytics_outlined,
    ),
    OnboardingSlide(
      title: "Track Your Success",
      description: "Organize applications and opportunities in one unified dashboard.",
      icon: Icons.dashboard_customize_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.05),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: !isLastPage
                        ? TextButton(
                            onPressed: () => _pageController.jumpToPage(slides.length - 1),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : const SizedBox(height: 48),
                  ),
                ),
                
                // Page Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => isLastPage = index == slides.length - 1);
                    },
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      return _buildSlide(slides[index]);
                    },
                  ),
                ),
                
                // Bottom Indicator and Navigation
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: slides.length,
                        effect: ExpandingDotsEffect(
                          spacing: 6,
                          dotWidth: 8,
                          dotHeight: 8,
                          dotColor: Colors.deepPurple.shade100,
                          activeDotColor: Colors.deepPurple.shade400,
                          expansionFactor: 4,
                        ),
                      ),
                      
                      // Next/Get Started Button
                      InkWell(
                        onTap: () async {
                          if (isLastPage) {
                            await ref
                                .read(onboardingControllerProvider.notifier)
                                .completeOnboarding();
                            
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const DashboardPage()),
                              );
                            }
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(isLastPage ? 32 : 50),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: isLastPage ? 32 : 16, 
                            vertical: 16
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(isLastPage ? 32 : 50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isLastPage)
                                Text(
                                  'Get Started',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              if (isLastPage) const SizedBox(width: 12),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                            ],
                          ),
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
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: slide.isLogo
                  ? Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          slide.imagePath!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.rocket_launch, size: 100, color: Colors.deepPurple),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        slide.icon,
                        size: 100,
                        color: Colors.deepPurple,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
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
