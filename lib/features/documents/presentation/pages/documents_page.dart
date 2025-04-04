import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/documents_list_page.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/document_templates_page.dart';
import 'package:gbc_coachia/features/shared/presentation/widgets/main_scaffold.dart';

/// Page principale pour le module Documents
class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Charger les données initiales
    _loadData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Charge les données initiales (documents et modèles)
  void _loadData() {
    final bloc = context.read<DocumentBloc>();
    bloc.add(LoadDocuments());
    bloc.add(LoadTemplates());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MainScaffold(
      title: 'Documents',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Ici, on pourrait ouvrir une page de recherche
            showSearch(
              context: context,
              delegate: _DocumentSearchDelegate(),
            );
          },
          tooltip: 'Rechercher',
        ),
      ],
      body: Column(
        children: [
          // Tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Mes documents'),
              Tab(text: 'Modèles'),
            ],
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: theme.colorScheme.primary,
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // Liste des documents
                DocumentsListPage(),
                
                // Liste des modèles
                DocumentTemplatesPage(),
              ],
            ),
          ),
        ],
      ),
      // FAB pour créer un nouveau document à partir d'un modèle
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Si on est sur l'onglet des modèles, passer à l'onglet des documents
          if (_tabController.index == 1) {
            _tabController.animateTo(0);
          }
          
          // Naviguer vers la page pour créer un document
          Navigator.pushNamed(context, '/documents/create');
        },
        child: const Icon(Icons.add),
        tooltip: 'Nouveau document',
      ),
    );
  }
}

/// Délégué pour la recherche de documents
class _DocumentSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Veuillez saisir un terme de recherche'),
      );
    }
    
    // Déclencher la recherche
    context.read<DocumentBloc>().add(SearchDocuments(query));
    
    // Afficher les résultats
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        if (state is DocumentsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DocumentsLoaded) {
          final documents = state.documents;
          
          if (documents.isEmpty) {
            return const Center(
              child: Text('Aucun document trouvé'),
            );
          }
          
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return ListTile(
                title: Text(document.title),
                subtitle: Text(document.type.displayName),
                leading: CircleAvatar(
                  backgroundColor: Color(document.type.color),
                  child: Text(
                    document.title.isNotEmpty ? document.title[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Color(document.status.color),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    document.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                onTap: () {
                  // Fermer la recherche et naviguer vers le détail du document
                  close(context, document.id);
                  Navigator.pushNamed(
                    context,
                    '/documents/detail',
                    arguments: document.id,
                  );
                },
              );
            },
          );
        } else if (state is DocumentsError) {
          return Center(
            child: Text('Erreur: ${state.message}'),
          );
        }
        
        return const Center(
          child: Text('Rechercher des documents...'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions simples pour l'instant
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Factures'),
          onTap: () {
            query = 'Facture';
            showResults(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Contrats'),
          onTap: () {
            query = 'Contrat';
            showResults(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Rapports'),
          onTap: () {
            query = 'Rapport';
            showResults(context);
          },
        ),
      ],
    );
  }
}
