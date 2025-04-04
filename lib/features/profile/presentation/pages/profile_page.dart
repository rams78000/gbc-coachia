import 'package:flutter/material.dart';

/// Page de profil utilisateur
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: const Center(
        child: Text('Contenu du profil à venir'),
      ),
    );
  }
}