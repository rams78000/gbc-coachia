import 'package:flutter/material.dart';

/// Page de gestion des documents
class DocumentsPage extends StatelessWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      body: const Center(
        child: Text('Contenu de gestion des documents à venir'),
      ),
    );
  }
}