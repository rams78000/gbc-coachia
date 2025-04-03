import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool isEditing = false;
  String? selectedImage;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (isEditing) {
      // Save changes
      final name = nameController.text.trim();
      if (name.isNotEmpty) {
        context.read<AuthBloc>().add(
          UpdateProfileRequested(displayName: name),
        );
      }
    } else {
      // Enter edit mode
      final user = (context.read<AuthBloc>().state as Authenticated).user;
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() {
          selectedImage = image.path;
        });
        
        // In a real app, you would upload this image to storage
        // and then update the user's profile with the URL
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selection successful. In a real app, this would be uploaded.'),
          ),
        );
        
        // For this demo, we'll just reset the selected image after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              selectedImage = null;
            });
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(SignOutRequested());
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _handleVerifyEmail() {
    context.read<AuthBloc>().add(SendEmailVerificationRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEditMode,
            tooltip: isEditing ? 'Save Changes' : 'Edit Profile',
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          } else if (state is EmailVerificationSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification email sent. Please check your inbox.')),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is! Authenticated) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = state.user;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.spacing(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                AppCard(
                  child: Padding(
                    padding: EdgeInsets.all(AppTheme.spacing(2)),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: isEditing ? _pickImage : null,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.primary,
                                foregroundImage: selectedImage != null
                                    ? FileImage(File(selectedImage!))
                                    : user.photoURL != null
                                        ? NetworkImage(user.photoURL!)
                                        : null,
                                child: user.photoURL == null && selectedImage == null
                                    ? Text(
                                        user.displayName?.isNotEmpty == true
                                            ? user.displayName![0].toUpperCase()
                                            : user.email![0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                              if (isEditing)
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing(2)),
                        if (isEditing) ...[
                          AppTextField(
                            controller: nameController,
                            label: 'Name',
                            hint: 'Enter your name',
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ] else ...[
                          Text(
                            user.displayName ?? 'No name provided',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        SizedBox(height: AppTheme.spacing(1)),
                        Text(
                          user.email ?? '',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (!user.emailVerified) ...[
                          SizedBox(height: AppTheme.spacing(2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 18,
                              ),
                              SizedBox(width: AppTheme.spacing(1)),
                              Text(
                                'Email not verified',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(width: AppTheme.spacing(1)),
                              TextButton(
                                onPressed: _handleVerifyEmail,
                                child: const Text('Verify Now'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppTheme.spacing(3)),

                // Account Settings
                Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppCard(
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        context,
                        'Notification Settings',
                        Icons.notifications,
                        () {
                          // Navigate to notification settings
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notification settings would open here')),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Privacy & Security',
                        Icons.security,
                        () {
                          // Navigate to privacy settings
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy settings would open here')),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Language',
                        Icons.language,
                        () {
                          // Open language selector
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Language settings would open here')),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Theme',
                        Icons.brightness_6,
                        () {
                          // Open theme selector
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Theme settings would open here')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppTheme.spacing(3)),

                // Payment & Subscription
                Text(
                  'Payment & Subscription',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppCard(
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        context,
                        'Subscription Plan',
                        Icons.card_membership,
                        () {
                          // View subscription details
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Subscription details would open here')),
                          );
                        },
                        trailing: const Chip(
                          label: Text('Free'),
                          backgroundColor: Colors.green,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Payment Methods',
                        Icons.payment,
                        () {
                          // Manage payment methods
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment methods would open here')),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Billing History',
                        Icons.receipt_long,
                        () {
                          // View billing history
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Billing history would open here')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppTheme.spacing(3)),

                // Help & Support
                Text(
                  'Help & Support',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppCard(
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        context,
                        'Help Center',
                        Icons.help_center,
                        () {
                          // Open help center
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Help center would open here')),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Contact Support',
                        Icons.support_agent,
                        () {
                          // Contact support
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Support contact would open here')),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Terms of Service',
                        Icons.description,
                        () {
                          // View terms
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Terms would open here')),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        context,
                        'Privacy Policy',
                        Icons.privacy_tip,
                        () {
                          // View privacy policy
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy policy would open here')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppTheme.spacing(4)),

                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Sign Out',
                    type: AppButtonType.secondary,
                    onPressed: _handleSignOut,
                    icon: Icons.logout,
                  ),
                ),

                SizedBox(height: AppTheme.spacing(4)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppTheme.spacing(2),
          horizontal: AppTheme.spacing(2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              radius: 20,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            SizedBox(width: AppTheme.spacing(2)),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 56,
    );
  }
}
