import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/user_profile.dart';
import 'package:gbc_coachia/features/settings/presentation/bloc/settings_bloc.dart';

/// Widget pour éditer le profil utilisateur
class ProfileForm extends StatefulWidget {
  final UserProfile initialProfile;
  
  const ProfileForm({
    Key? key,
    required this.initialProfile,
  }) : super(key: key);
  
  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _addressController;
  
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.name);
    _emailController = TextEditingController(text: widget.initialProfile.email);
    _phoneController = TextEditingController(text: widget.initialProfile.phoneNumber ?? '');
    _companyController = TextEditingController(text: widget.initialProfile.company ?? '');
    _positionController = TextEditingController(text: widget.initialProfile.position ?? '');
    _addressController = TextEditingController(text: widget.initialProfile.address ?? '');
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _positionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is UserProfileUpdated) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil mis à jour avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.of(context).pop();
        } else if (state is SettingsError) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modifier votre profil',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Veuillez entrer un email valide';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Entreprise',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(
                labelText: 'Poste',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            
                            // Mettre à jour le profil utilisateur
                            final updatedProfile = widget.initialProfile.copyWith(
                              name: _nameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneController.text.isEmpty ? null : _phoneController.text,
                              company: _companyController.text.isEmpty ? null : _companyController.text,
                              position: _positionController.text.isEmpty ? null : _positionController.text,
                              address: _addressController.text.isEmpty ? null : _addressController.text,
                            );
                            
                            context.read<SettingsBloc>().add(UpdateUserProfile(updatedProfile));
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
