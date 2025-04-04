import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/config/router/app_router.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import 'package:gbc_coachia/core/widgets/app_button.dart';
import 'package:gbc_coachia/core/widgets/app_text_field.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';

/// Page de connexion
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginUser(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          } else if (state is Authenticated) {
            setState(() {
              _isLoading = false;
              _errorMessage = null;
            });
            context.go(AppRoutes.dashboard);
          } else if (state is AuthError) {
            setState(() {
              _isLoading = false;
              _errorMessage = state.message;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacing * 2),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo ou titre
                      const Icon(
                        Icons.psychology_alt,
                        size: 80,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: AppTheme.spacing),
                      Text(
                        'GBC CoachIA',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.smallSpacing),
                      Text(
                        'Connectez-vous pour continuer',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacing * 2),

                      // Affichage des erreurs s'il y en a
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                AppTheme.smallBorderRadius),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing),
                      ],

                      // Champs de formulaire
                      AppTextField(
                        label: 'Email',
                        hintText: 'Entrez votre adresse email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppTheme.spacing),
                      AppTextField(
                        label: 'Mot de passe',
                        hintText: 'Entrez votre mot de passe',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          if (value.length < 6) {
                            return 'Le mot de passe doit contenir au moins 6 caractères';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: AppTheme.smallSpacing),

                      // Lien pour mot de passe oublié
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  // TODO: Implémenter la réinitialisation du mot de passe
                                },
                          child: const Text('Mot de passe oublié ?'),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing),

                      // Bouton de connexion
                      AppButton(
                        label: 'Se connecter',
                        isLoading: _isLoading,
                        isFullWidth: true,
                        onPressed: _isLoading ? null : _handleLogin,
                      ),
                      const SizedBox(height: AppTheme.largeSpacing),

                      // Lien pour s'inscrire
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Vous n\'avez pas de compte ?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    context.push(AppRoutes.register);
                                  },
                            child: const Text('S\'inscrire'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
