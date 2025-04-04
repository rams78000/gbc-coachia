import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../onboarding/presentation/bloc/onboarding_bloc.dart';

class OnboardingSettingsPage extends StatelessWidget {
  const OnboardingSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<OnboardingBloc>()
        ..add(const InitializeOnboarding(fromSettings: true)),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tutoriel'),
              backgroundColor: const Color(0xFFB87333),
              foregroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.school_outlined,
                      size: 80,
                      color: Color(0xFFB87333),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tutoriel de l\'application',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Découvrez les fonctionnalités et comment utiliser efficacement l\'application pour gérer votre entreprise.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    if (state is OnboardingLoading)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB87333)),
                      )
                    else ...[
                      ElevatedButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(ResetOnboarding());
                          context.go('/onboarding');
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
                          'Démarrer le tutoriel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text(
                          'Retour aux paramètres',
                          style: TextStyle(
                            color: Color(0xFFB87333),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
