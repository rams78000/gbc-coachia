import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_step_content.dart';
import '../widgets/onboarding_step_indicator.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<OnboardingBloc>()
        ..add(const InitializeOnboarding()),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            context.go('/dashboard');
          }
          
          if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is OnboardingLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB87333)),
                ),
              ),
            );
          }

          if (state is OnboardingInProgress) {
            return _OnboardingView(currentStep: state.currentStep);
          }

          return const Scaffold(
            body: Center(
              child: Text('Chargement...'),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  final int currentStep;
  static const int totalSteps = 5; // 0-4

  const _OnboardingView({
    Key? key,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(SkipOnboarding());
                },
                child: const Text(
                  'Passer',
                  style: TextStyle(
                    color: Color(0xFFB87333),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: PageController(initialPage: currentStep),
                children: [
                  OnboardingStepContent(
                    title: 'Bienvenue sur GBC CoachIA',
                    description: 'Votre assistant IA de gestion d\'entreprise pour entrepreneurs et freelances.',
                    imagePath: 'assets/images/onboarding/welcome.png',
                  ),
                  OnboardingStepContent(
                    title: 'Assistant IA Intelligent',
                    description: 'Posez vos questions, obtenez des conseils personnalisés et des réponses précises.',
                    imagePath: 'assets/images/onboarding/chatbot.png',
                  ),
                  OnboardingStepContent(
                    title: 'Planification Simplifiée',
                    description: 'Gérez votre agenda, vos tâches et vos projets de manière intuitive.',
                    imagePath: 'assets/images/onboarding/planner.png',
                  ),
                  OnboardingStepContent(
                    title: 'Suivi Financier',
                    description: 'Suivez vos finances, factures et paiements en un coup d\'œil.',
                    imagePath: 'assets/images/onboarding/finance.png',
                  ),
                  OnboardingStepContent(
                    title: 'Tout est prêt !',
                    description: 'Vous êtes maintenant prêt à utiliser toutes les fonctionnalités de GBC CoachIA.',
                    imagePath: 'assets/images/onboarding/complete.png',
                    additionalContent: ElevatedButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(CompleteOnboarding());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB87333),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Commencer',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: OnboardingStepIndicator(
                currentStep: currentStep,
                totalSteps: totalSteps,
              ),
            ),
            if (currentStep < totalSteps - 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentStep > 0)
                      OutlinedButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(PreviousStep());
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFB87333)),
                          foregroundColor: const Color(0xFFB87333),
                        ),
                        child: const Text('Précédent'),
                      )
                    else
                      const SizedBox(width: 80), // Espace pour équilibrer
                    ElevatedButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(NextStep());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB87333),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Suivant'),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 80), // Espace pour la dernière page
          ],
        ),
      ),
    );
  }
}
