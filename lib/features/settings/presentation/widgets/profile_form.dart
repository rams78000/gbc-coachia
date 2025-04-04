import 'package:flutter/material.dart';

import '../../domain/entities/user_profile.dart';

class ProfileForm extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onSubmit;
  final VoidCallback? onCancel;

  const ProfileForm({
    super.key,
    required this.userProfile,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(text: widget.userProfile.phoneNumber ?? '');
    _companyController = TextEditingController(text: widget.userProfile.companyName ?? '');
    _positionController = TextEditingController(text: widget.userProfile.position ?? '');
    _addressController = TextEditingController(text: widget.userProfile.address ?? '');
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  backgroundImage: widget.userProfile.profileImageUrl != null
                      ? NetworkImage(widget.userProfile.profileImageUrl!)
                      : null,
                  child: widget.userProfile.profileImageUrl == null
                      ? Text(
                          _getInitials(widget.userProfile.name),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : null,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: () {
                      // À implémenter : sélection d'image
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                    constraints: const BoxConstraints.tightFor(
                      width: 36,
                      height: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Nom
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom complet',
              hintText: 'Entrez votre nom complet',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre nom';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Adresse email',
              hintText: 'Entrez votre adresse email',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Veuillez entrer une adresse email valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Téléphone
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Numéro de téléphone',
              hintText: 'Entrez votre numéro de téléphone',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          // Entreprise
          TextFormField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Entreprise',
              hintText: 'Entrez le nom de votre entreprise',
              prefixIcon: Icon(Icons.business),
            ),
          ),
          const SizedBox(height: 16),
          // Poste
          TextFormField(
            controller: _positionController,
            decoration: const InputDecoration(
              labelText: 'Poste / Fonction',
              hintText: 'Entrez votre poste ou fonction',
              prefixIcon: Icon(Icons.work),
            ),
          ),
          const SizedBox(height: 16),
          // Adresse
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Adresse',
              hintText: 'Entrez votre adresse professionnelle',
              prefixIcon: Icon(Icons.location_on),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          // Boutons
          Row(
            children: [
              if (widget.onCancel != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('Annuler'),
                  ),
                ),
              if (widget.onCancel != null)
                const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedProfile = widget.userProfile.copyWith(
                        name: _nameController.text,
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                        companyName: _companyController.text,
                        position: _positionController.text,
                        address: _addressController.text,
                      );
                      widget.onSubmit(updatedProfile);
                    }
                  },
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.length > 1) {
      return name.substring(0, 2).toUpperCase();
    } else {
      return name.toUpperCase();
    }
  }
}
