import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../../../onboarding/presentation/bloc/onboarding_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configurer les animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    
    // Démarrer l'animation
    _controller.forward();

    // Déclencher les événements pour vérifier l'authentification et le statut d'onboarding
    context.read<AuthBloc>().add(const AuthCheckRequested());
    context.read<OnboardingBloc>().add(const OnboardingCheckStatus());
    
    // Attendre un peu avant la navigation
    Future.delayed(const Duration(milliseconds: 2000), () {
      _navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    // Vérifier l'état d'authentification
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      if (authState.status.isAuthenticated) {
        // Utilisateur authentifié, vérifier le statut d'onboarding
        final onboardingState = context.read<OnboardingBloc>().state;
        
        if (onboardingState is OnboardingRequired || authState.status.isFirstLogin) {
          // Onboarding requis ou première connexion
          context.go('/onboarding');
        } else {
          // Onboarding déjà effectué, aller au tableau de bord
          context.go('/');
        }
      } else {
        // Utilisateur non authentifié, aller à la page de connexion
        context.go('/login');
      }
    } else {
      // En cas d'erreur ou d'état initial, aller à la page de connexion par défaut
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final goldColor = const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.business_center,
                          size: 70,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Nom de l'application
                    Text(
                      'GBC CoachIA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Slogan
                    Text(
                      'Votre assistant d\'entreprise intelligent',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Indicateur de chargement
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: goldColor,
                        strokeWidth: 4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
