import 'package:flutter/material.dart';

/// Page de gestion de documents et signatures électroniques
class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoriesSection(context),
          Expanded(
            child: _buildDocumentsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {'name': 'Tous', 'icon': Icons.folder, 'count': 28},
      {'name': 'Contrats', 'icon': Icons.description, 'count': 12},
      {'name': 'Factures', 'icon': Icons.receipt, 'count': 8},
      {'name': 'Signatures', 'icon': Icons.draw, 'count': 4},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catégories',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories
                  .map((category) => _buildCategoryCard(
                        context,
                        category['name'] as String,
                        category['icon'] as IconData,
                        category['count'] as int,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String name, IconData icon, int count) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(name, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    final documentTypes = {
      'pdf': Icons.picture_as_pdf,
      'doc': Icons.description,
      'img': Icons.image,
      'xls': Icons.table_chart,
    };

    final documents = [
      {
        'name': 'Contrat de prestation',
        'date': '04 Avr 2025',
        'type': 'pdf',
        'size': '2.3 Mo'
      },
      {
        'name': 'Facture #2305',
        'date': '01 Avr 2025',
        'type': 'pdf',
        'size': '1.1 Mo'
      },
      {
        'name': 'Planning projet Alpha',
        'date': '29 Mar 2025',
        'type': 'xls',
        'size': '4.2 Mo'
      },
      {
        'name': 'Présentation client',
        'date': '28 Mar 2025',
        'type': 'doc',
        'size': '3.5 Mo'
      },
      {
        'name': 'Signature contrat',
        'date': '26 Mar 2025',
        'type': 'img',
        'size': '0.8 Mo'
      },
      {
        'name': 'Proposition commerciale',
        'date': '20 Mar 2025',
        'type': 'pdf',
        'size': '1.9 Mo'
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final document = documents[index];
        final docType = document['type'] as String;
        final icon = documentTypes[docType] ?? Icons.insert_drive_file;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getDocumentColor(docType).withOpacity(0.1),
            child: Icon(icon, color: _getDocumentColor(docType)),
          ),
          title: Text(document['name'] as String),
          subtitle: Text('${document['date']} • ${document['size']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }

  Color _getDocumentColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.red;
      case 'doc':
        return Colors.blue;
      case 'img':
        return Colors.green;
      case 'xls':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
