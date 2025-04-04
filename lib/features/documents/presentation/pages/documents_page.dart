import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'Factures',
    'Devis',
    'Rapports',
    'Contrats',
    'Autres',
  ];

  final List<Document> _documents = [
    Document(
      id: '1',
      title: 'Facture client Dupont',
      category: 'Factures',
      date: DateTime.now().subtract(const Duration(days: 2)),
      size: '245 Ko',
      thumbnailUrl: 'assets/images/invoice_thumbnail.png',
    ),
    Document(
      id: '2',
      title: 'Devis travaux bureaux',
      category: 'Devis',
      date: DateTime.now().subtract(const Duration(days: 5)),
      size: '180 Ko',
      thumbnailUrl: 'assets/images/quote_thumbnail.png',
    ),
    Document(
      id: '3',
      title: 'Contrat prestation Martin',
      category: 'Contrats',
      date: DateTime.now().subtract(const Duration(days: 10)),
      size: '320 Ko',
      thumbnailUrl: 'assets/images/contract_thumbnail.png',
    ),
    Document(
      id: '4',
      title: 'Rapport d\'activité T1 2023',
      category: 'Rapports',
      date: DateTime.now().subtract(const Duration(days: 15)),
      size: '1.2 Mo',
      thumbnailUrl: 'assets/images/report_thumbnail.png',
    ),
    Document(
      id: '5',
      title: 'Planning projet XYZ',
      category: 'Autres',
      date: DateTime.now().subtract(const Duration(days: 20)),
      size: '150 Ko',
      thumbnailUrl: 'assets/images/planning_thumbnail.png',
    ),
  ];

  final List<TemplateCategory> _templateCategories = [
    TemplateCategory(
      name: 'Factures',
      icon: Icons.receipt_outlined,
      templates: [
        Template(
          id: '1',
          title: 'Facture standard',
          description: 'Modèle de facture simple et professionnel',
          thumbnailUrl: 'assets/images/invoice_template_1.png',
        ),
        Template(
          id: '2',
          title: 'Facture détaillée',
          description: 'Facture avec ventilation détaillée des prestations',
          thumbnailUrl: 'assets/images/invoice_template_2.png',
        ),
      ],
    ),
    TemplateCategory(
      name: 'Devis',
      icon: Icons.description_outlined,
      templates: [
        Template(
          id: '3',
          title: 'Devis standard',
          description: 'Modèle de devis simple et efficace',
          thumbnailUrl: 'assets/images/quote_template_1.png',
        ),
        Template(
          id: '4',
          title: 'Devis détaillé',
          description: 'Devis avec options et conditions détaillées',
          thumbnailUrl: 'assets/images/quote_template_2.png',
        ),
      ],
    ),
    TemplateCategory(
      name: 'Contrats',
      icon: Icons.handshake_outlined,
      templates: [
        Template(
          id: '5',
          title: 'Contrat de prestation',
          description: 'Modèle de contrat pour prestations de services',
          thumbnailUrl: 'assets/images/contract_template_1.png',
        ),
        Template(
          id: '6',
          title: 'Contrat de confidentialité',
          description: 'NDA pour projets confidentiels',
          thumbnailUrl: 'assets/images/contract_template_2.png',
        ),
      ],
    ),
  ];

  List<Document> get _filteredDocuments {
    if (_selectedCategory == 'Tous') {
      return _documents;
    }
    return _documents
        .where((doc) => doc.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Documents'),
          backgroundColor: const Color(0xFFB87333),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Mes documents'),
              Tab(text: 'Modèles'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDocumentsTab(),
            _buildTemplatesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreateDocumentDialog();
          },
          backgroundColor: const Color(0xFFB87333),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: _filteredDocuments.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun document dans cette catégorie',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredDocuments.length,
                  itemBuilder: (context, index) {
                    return _buildDocumentCard(_filteredDocuments[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: const Color(0xFFB87333),
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDocumentCard(Document document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showDocumentActionsDialog(document);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.description,
                    size: 32,
                    color: Color(0xFFB87333),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(document.date),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          document.size,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  _showDocumentActionsDialog(document);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _templateCategories.length,
      itemBuilder: (context, index) {
        final category = _templateCategories[index];
        return _buildTemplateCategory(category);
      },
    );
  }

  Widget _buildTemplateCategory(TemplateCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                category.icon,
                color: const Color(0xFFB87333),
              ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: category.templates.length,
          itemBuilder: (context, index) {
            return _buildTemplateCard(category.templates[index]);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTemplateCard(Template template) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showTemplateDetailsDialog(template);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.description_outlined,
                    size: 48,
                    color: Color(0xFFB87333),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentActionsDialog(Document document) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.visibility),
                  title: const Text('Aperçu'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDocumentPreviewDialog(document);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Modifier'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité en développement'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Partager'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité en développement'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Télécharger'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité en développement'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteDocumentDialog(document);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDocumentPreviewDialog(Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(document.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('Aperçu du document'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Catégorie: ${document.category}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(document.date)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Taille: ${document.size}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDocumentDialog(Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le document'),
          content: Text('Êtes-vous sûr de vouloir supprimer "${document.title}" ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _documents.removeWhere((doc) => doc.id == document.id);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document supprimé'),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _showTemplateDetailsDialog(Template template) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(template.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Color(0xFFB87333),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(template.description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fermer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Création de document en développement'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87333),
                foregroundColor: Colors.white,
              ),
              child: const Text('Utiliser ce modèle'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateDocumentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Créer un document'),
          content: const Text('Choisissez une méthode pour créer un document'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                DefaultTabController.of(context).animateTo(1);
              },
              child: const Text('Utiliser un modèle'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Création manuelle en développement'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87333),
                foregroundColor: Colors.white,
              ),
              child: const Text('Créer manuellement'),
            ),
          ],
        );
      },
    );
  }
}

class Document {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String size;
  final String thumbnailUrl;

  Document({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.size,
    required this.thumbnailUrl,
  });
}

class Template {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;

  Template({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });
}

class TemplateCategory {
  final String name;
  final IconData icon;
  final List<Template> templates;

  TemplateCategory({
    required this.name,
    required this.icon,
    required this.templates,
  });
}
