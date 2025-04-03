import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/router/app_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: 'Welcome to ${AppConstants.appName}',
      description: 'Your personal AI-powered business assistant designed for entrepreneurs and freelancers.',
      imagePath: 'briefcase',
    ),
    OnboardingSlideData(
      title: 'AI-Powered Assistance',
      description: 'Get smart answers to your business questions, schedule management, and financial insights.',
      imagePath: 'message-circle',
    ),
    OnboardingSlideData(
      title: 'Document Management',
      description: 'Create professional invoices, contracts, and reports with our easy-to-use tools.',
      imagePath: 'file-text',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Save that onboarding is completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompletedKey, true);
    
    // Navigate to login screen
    if (mounted) {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go(AppRouter.home);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _numPages,
                  itemBuilder: (context, index) {
                    return OnboardingSlide(
                      title: _slides[index].title,
                      description: _slides[index].description,
                      icon: _slides[index].imagePath,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppTheme.spacing(4)),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _numPages,
                      effect: WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: AppColors.primary,
                        dotColor: AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _currentPage < _numPages - 1
                            ? TextButton(
                                onPressed: _skipOnboarding,
                                child: const Text('Skip'),
                              )
                            : const SizedBox.shrink(),
                        AppButton(
                          text: _currentPage < _numPages - 1 ? 'Next' : 'Get Started',
                          onPressed: _nextPage,
                          fullWidth: false,
                          icon: _currentPage < _numPages - 1
                              ? Icons.arrow_forward
                              : Icons.check,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.spacing(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSlideData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingSlideData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
