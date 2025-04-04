import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_state.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/login_page.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gbc_coachia/features/onboarding/presentation/pages/onboarding_page.dart';

/// Page de démarrage
class SplashPage extends StatefulWidget {
  /// Nom de la route
  static const routeName = '/';
  
  /// Constructeur
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    
    // Attendre un peu avant de rediriger
    Future.delayed(const Duration(seconds: 3), () {
      _redirectBasedOnAuthState();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  /// Rediriger en fonction de l'état d'authentification
  void _redirectBasedOnAuthState() {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is AuthAuthenticatedState) {
      if (!authState.hasSeenOnboarding) {
        context.go(OnboardingPage.routeName);
      } else {
        context.go(DashboardPage.routeName);
      }
    } else if (authState is AuthUnauthenticatedState) {
      if (!authState.hasSeenOnboarding) {
        context.go(OnboardingPage.routeName);
      } else {
        context.go(LoginPage.routeName);
      }
    } else {
      // Par défaut, aller à la page de connexion
      context.go(LoginPage.routeName);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.tips_and_updates, // Remplacer par le logo réel
                      size: 70,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Titre de l'application
                  Text(
                    'GBC CoachIA',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Slogan
                  Text(
                    'Votre coach entrepreneurial intelligent',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),
            
            // Indicateur de chargement
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
