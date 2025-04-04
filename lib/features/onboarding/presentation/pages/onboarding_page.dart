import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/config/router/app_router.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import 'package:gbc_coachia/core/widgets/app_button.dart';
import 'package:gbc_coachia/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page d'onboarding
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;
  static const String _onboardingCompletedKey = 'onboarding_completed';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    // Marquer l'onboarding comme terminé
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  _OnboardingPageContent(
                    title: 'Bienvenue sur GBC CoachIA',
                    description:
                        'Votre assistant personnel pour vous accompagner dans le développement de votre entreprise ou activité freelance.',
                    icon: Icons.psychology_alt,
                    color: AppTheme.primaryColor,
                  ),
                  _OnboardingPageContent(
                    title: 'Planifiez et Organisez',
                    description:
                        'Gérez efficacement votre temps, vos projets et vos rendez-vous grâce à notre planificateur intelligent.',
                    icon: Icons.calendar_today,
                    color: AppTheme.accentColor,
                  ),
                  _OnboardingPageContent(
                    title: 'Gérez vos Finances',
                    description:
                        'Suivez vos revenus, dépenses et créez facilement des factures et devis professionnels.',
                    icon: Icons.account_balance_wallet,
                    color: AppTheme.secondaryColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing * 2),
              child: Column(
                children: [
                  PageIndicator(
                    count: _numPages,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: AppTheme.spacing * 2),
                  Row(
                    children: [
                      if (_currentPage < _numPages - 1) ...[
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: const Text('Passer'),
                        ),
                        const Spacer(),
                        AppButton(
                          label: 'Suivant',
                          onPressed: _nextPage,
                          icon: Icons.arrow_forward,
                        ),
                      ] else ...[
                        const Spacer(),
                        AppButton(
                          label: 'Commencer',
                          onPressed: _completeOnboarding,
                          isFullWidth: true,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Contenu d'une page d'onboarding
class _OnboardingPageContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _OnboardingPageContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          const SizedBox(height: AppTheme.spacing * 2),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
