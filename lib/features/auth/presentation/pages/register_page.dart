import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/router/app_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        RegisterWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleGoogleSignIn() {
    context.read<AuthBloc>().add(SignInWithGoogle());
  }

  void _handleAppleSignIn() {
    context.read<AuthBloc>().add(SignInWithApple());
  }

  void _navigateToLogin() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go(AppRouter.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppTheme.spacing(3)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppTheme.spacing(2)),
                    // App logo
                    SvgPicture.asset(
                      AppConstants.logoPath,
                      height: 60,
                    ),
                    SizedBox(height: AppTheme.spacing(1)),
                    Text(
                      'Join ${AppConstants.appName}',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppTheme.spacing(1)),
                    Text(
                      'Create your account to get started',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppTheme.spacing(4)),
                    // Registration form
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppTheme.spacing(3)),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Create a password',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppTheme.spacing(3)),
                    AppTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppTheme.spacing(4)),
                    AppButton(
                      text: 'Create Account',
                      onPressed: _handleRegister,
                      isLoading: state is AuthLoading,
                      icon: Icons.person_add,
                    ),
                    SizedBox(height: AppTheme.spacing(3)),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: AppTheme.spacing(3)),
                    AppButton(
                      text: 'Sign up with Google',
                      onPressed: _handleGoogleSignIn,
                      type: AppButtonType.secondary,
                      icon: Icons.g_mobiledata,
                    ),
                    SizedBox(height: AppTheme.spacing(2)),
                    AppButton(
                      text: 'Sign up with Apple',
                      onPressed: _handleAppleSignIn,
                      type: AppButtonType.secondary,
                      icon: Icons.apple,
                    ),
                    SizedBox(height: AppTheme.spacing(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: _navigateToLogin,
                          child: const Text('Log in'),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.spacing(2)),
                    Text(
                      'By signing up, you agree to our Terms of Service and Privacy Policy',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
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
