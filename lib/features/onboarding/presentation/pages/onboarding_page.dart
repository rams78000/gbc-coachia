import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/core/widgets/app_button.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_event.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_state.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/login_page.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';

/// Page d'onboarding
class OnboardingPage extends StatefulWidget {
  /// Nom de la route
  static const routeName = '/onboarding';
  
  /// Constructeur
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingItem> _items = [
    const OnboardingItem(
      title: 'Bienvenue sur GBC CoachIA',
      description: 'Votre assistant intelligent pour gérer et développer votre activité entrepreneuriale.',
      icon: Icons.auto_awesome,
    ),
    const OnboardingItem(
      title: 'Assistant IA Personnalisé',
      description: 'Posez vos questions business et obtenez des conseils pertinents et personnalisés.',
      icon: Icons.psychology,
    ),
    const OnboardingItem(
      title: 'Planifiez Efficacement',
      description: 'Organisez votre temps, vos tâches et vos projets avec nos outils de planification.',
      icon: Icons.calendar_today,
    ),
    const OnboardingItem(
      title: 'Gestion Financière Simplifiée',
      description: 'Suivez vos revenus, dépenses et prévisions pour une meilleure gestion financière.',
      icon: Icons.attach_money,
    ),
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  /// Marquer l'onboarding comme vu
  void _completeOnboarding() {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(AuthSetOnboardingSeenEvent());
    
    // Rediriger en fonction de l'état d'authentification
    if (authBloc.state is AuthAuthenticatedState) {
      context.go(DashboardPage.routeName);
    } else {
      context.go(LoginPage.routeName);
    }
  }
  
  /// Passer à la page suivante
  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }
  
  /// Passer à la page précédente
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bouton "Ignorer"
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Ignorer'),
                ),
              ),
            ),
            
            // Contenu principal
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_items[index]);
                },
              ),
            ),
            
            // Indicateurs de page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Boutons de navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton précédent
                  _currentPage > 0
                      ? AppButton(
                          text: 'Précédent',
                          type: AppButtonType.secondary,
                          icon: Icons.arrow_back,
                          onPressed: _previousPage,
                        )
                      : const SizedBox(width: 100),
                  
                  // Bouton suivant ou terminer
                  AppButton(
                    text: _currentPage < _items.length - 1 ? 'Suivant' : 'Commencer',
                    icon: _currentPage < _items.length - 1 ? Icons.arrow_forward : Icons.check,
                    iconOnRight: true,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construire une page d'onboarding
  Widget _buildPage(OnboardingItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 60,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          
          // Titre
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Item pour une page d'onboarding
class OnboardingItem {
  /// Titre de la page
  final String title;
  
  /// Description de la page
  final String description;
  
  /// Icône à afficher
  final IconData icon;
  
  /// Constructeur
  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
