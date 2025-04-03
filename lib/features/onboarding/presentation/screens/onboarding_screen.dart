import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Onboarding screen
class OnboardingScreen extends StatefulWidget {
  /// Creates an OnboardingScreen
  const OnboardingScreen({super.key});

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
          'Votre assistant intelligent pour la gestion de votre activité',
      icon: Icons.analytics_outlined,
    ),
    const OnboardingPage(
      title: 'Assistant IA',
      description:
          'Obtenez des conseils personnalisés et des réponses à vos questions',
      icon: Icons.chat_bubble_outline,
    ),
    const OnboardingPage(
      title: 'Planificateur',
      description:
          'Organisez votre temps et vos projets de manière efficace',
      icon: Icons.calendar_today_outlined,
    ),
    const OnboardingPage(
      title: 'Finances',
      description:
          'Suivez vos revenus, dépenses et optimisez votre rentabilité',
      icon: Icons.monetization_on_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
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
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  // Next button
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Commencer'
                          : 'Suivant',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Passer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Onboarding page
class OnboardingPage extends StatelessWidget {
  /// Creates an OnboardingPage
  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Title
  final String title;

  /// Description
  final String description;

  /// Icon
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
