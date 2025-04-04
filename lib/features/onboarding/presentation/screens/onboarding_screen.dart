import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_button.dart';

/// Écran d'onboarding
class OnboardingScreen extends StatefulWidget {
  /// Constructeur
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
      description:
          'Votre assistant personnel pour la gestion de votre activité professionnelle',
      image: Icons.psychology,
    ),
    const OnboardingPage(
      title: 'Assistance IA Personnalisée',
      description:
          'Bénéficiez de conseils adaptés à votre activité et vos objectifs',
      image: Icons.smart_toy,
    ),
    const OnboardingPage(
      title: 'Planification Intelligente',
      description:
          'Organisez votre temps efficacement avec notre planificateur avancé',
      image: Icons.calendar_today,
    ),
    const OnboardingPage(
      title: 'Gestion Financière Simplifiée',
      description:
          'Suivez vos revenus, dépenses et atteignez vos objectifs financiers',
      image: Icons.account_balance_wallet,
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
      GoRouter.of(context).go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicateurs de page
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? theme.primaryColor
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  // Bouton suivant
                  CustomButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    onPressed: _nextPage,
                    icon: Icons.arrow_forward,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Bouton passer
            if (_currentPage < _pages.length - 1)
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go('/login');
                },
                child: const Text('Passer'),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Widget pour une page d'onboarding
class OnboardingPage extends StatelessWidget {
  /// Titre de la page
  final String title;

  /// Description de la page
  final String description;

  /// Icône ou image à afficher
  final IconData image;

  /// Constructeur
  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            image,
            size: 150,
            color: theme.primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
