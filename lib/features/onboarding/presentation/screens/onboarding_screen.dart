import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

/// Onboarding screen
class OnboardingScreen extends StatefulWidget {
  /// Constructor
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Bienvenue sur GBC CoachIA',
      description: 'Votre assistant personnel pour optimiser votre entreprise et booster votre productivité.',
      image: 'assets/images/onboarding1.png',
      icon: Icons.lightbulb_outline,
    ),
    const OnboardingPage(
      title: 'Planification Intelligente',
      description: 'Organisez vos tâches, planifiez vos rendez-vous et atteignez vos objectifs professionnels avec notre assistant IA.',
      image: 'assets/images/onboarding2.png',
      icon: Icons.calendar_today,
    ),
    const OnboardingPage(
      title: 'Gestion Financière',
      description: 'Suivez vos finances, analysez vos revenus et dépenses, et prenez des décisions éclairées pour votre entreprise.',
      image: 'assets/images/onboarding3.png',
      icon: Icons.account_balance_wallet,
    ),
    const OnboardingPage(
      title: 'Coach IA Personnalisé',
      description: 'Obtenez des conseils personnalisés, des réponses à vos questions et un accompagnement sur mesure pour votre activité.',
      image: 'assets/images/onboarding4.png',
      icon: Icons.psychology,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    // Navigate to login screen
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Passer',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildDotIndicator(index),
                ),
              ),
            ),

            // Next/Finish button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AppButton(
                label: _currentPage == _pages.length - 1 ? 'Commencer' : 'Suivant',
                onPressed: _nextPage,
                icon: _currentPage == _pages.length - 1
                    ? Icons.check_circle_outline
                    : Icons.arrow_forward,
                iconPosition: IconPosition.right,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? AppColors.primary
            : AppColors.primaryLight,
      ),
    );
  }
}

/// Onboarding page model
class OnboardingPage extends StatelessWidget {
  /// Constructor
  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  }) : super(key: key);

  /// Page title
  final String title;

  /// Page description
  final String description;

  /// Page image asset path
  final String image;

  /// Page icon
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon
          Icon(
            icon,
            size: 120,
            color: AppColors.primary,
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
