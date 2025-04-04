import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingStep> _steps = [
    OnboardingStep(
      title: 'Bienvenue sur GBC CoachIA',
      description: 'Votre assistant intelligent pour optimiser la gestion de votre entreprise',
      icon: Icons.rocket_launch,
    ),
    OnboardingStep(
      title: 'Assistant IA Personnel',
      description: 'Obtenez des réponses à toutes vos questions business et des conseils personnalisés',
      icon: Icons.chat,
    ),
    OnboardingStep(
      title: 'Gestion Financière',
      description: 'Suivez vos revenus, dépenses et analysez vos performances financières',
      icon: Icons.bar_chart,
    ),
    OnboardingStep(
      title: 'Planification Intelligente',
      description: 'Organisez votre agenda et maximisez votre productivité',
      icon: Icons.calendar_today,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Dernière page, marquer l'onboarding comme terminé
      context.read<OnboardingBloc>().add(const OnboardingCompleted());
      
      // Rediriger vers la page de connexion
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Indicateur de progression
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _steps.length,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB87333)),
                borderRadius: BorderRadius.circular(8),
                minHeight: 8,
              ),
            ),
            
            // Contenu des pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return _buildOnboardingPage(context, step);
                },
              ),
            ),
            
            // Boutons de navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton Passer
                  TextButton(
                    onPressed: () {
                      // Marquer l'onboarding comme terminé et aller à la page de connexion
                      context.read<OnboardingBloc>().add(const OnboardingCompleted());
                      context.go('/login');
                    },
                    child: const Text('Passer'),
                  ),
                  
                  // Bouton Suivant ou Commencer
                  ElevatedButton(
                    onPressed: _onNextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentPage == _steps.length - 1 ? 'Commencer' : 'Suivant',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(BuildContext context, OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFB87333).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              size: 60,
              color: const Color(0xFFB87333),
            ),
          ),
          const SizedBox(height: 32),
          
          // Titre
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingStep {
  final String title;
  final String description;
  final IconData icon;

  OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
