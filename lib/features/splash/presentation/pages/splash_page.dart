import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../onboarding/presentation/bloc/onboarding_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Vérifier si l'onboarding a été complété
    final onboardingState = context.read<OnboardingBloc>().state;
    if (onboardingState is OnboardingNotCompleted) {
      context.go('/onboarding');
      return;
    }
    
    // Vérifier si l'utilisateur est authentifié
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      if (authState.status.isAuthenticated) {
        context.go('/dashboard');
      } else {
        context.go('/login');
      }
    } else {
      // En cas d'erreur ou d'état inconnu, rediriger vers la page de connexion
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFB87333),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.assistant,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Titre de l'application
            Text(
              'GBC CoachIA',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB87333),
              ),
            ),
            const SizedBox(height: 8),
            
            // Slogan
            Text(
              'Votre Coach Business Intelligent',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 48),
            
            // Indicateur de chargement
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB87333)),
            ),
          ],
        ),
      ),
    );
  }
}
