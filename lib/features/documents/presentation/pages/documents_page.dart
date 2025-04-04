import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_grid_item.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/folder_grid_item.dart';
import 'package:path/path.dart' as path;

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _currentFolderId;
  String? _currentFolderName;
  final List<String> _navigationHistory = [];
  
  @override
  void initState() {
    super.initState();
    // Charger les dossiers racines et documents au démarrage
    context.read<DocumentBloc>().add(LoadRootFolders());
    context.read<DocumentBloc>().add(LoadDocuments());
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentFolderId == null
            ? const Text('Documents')
            : Text(_currentFolderName ?? 'Documents'),
        leading: _currentFolderId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _navigateBack,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              _currentFolderId = null;
              _currentFolderName = null;
              context.read<DocumentBloc>().add(LoadFavoriteDocuments());
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher des documents...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    if (_currentFolderId != null) {
                      context.read<DocumentBloc>().add(
                          LoadDocumentsInFolder(folderId: _currentFolderId!));
                    } else {
                      context.read<DocumentBloc>().add(LoadDocuments());
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<DocumentBloc>().add(SearchDocuments(value));
                }
              },
            ),
          ),
          
          // Contenu principal (dossiers et documents)
          Expanded(
            child: BlocConsumer<DocumentBloc, DocumentState>(
              listener: (context, state) {
                if (state is DocumentUploaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document ajouté avec succès'),
                    ),
                  );
                } else if (state is DocumentDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document supprimé avec succès'),
                    ),
                  );
                } else if (state is FolderCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dossier créé avec succès'),
                    ),
                  );
                } else if (state is FolderDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dossier supprimé avec succès'),
                    ),
                  );
                } else if (state is DocumentsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is DocumentsLoading || state is FoldersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DocumentsInFolderLoaded) {
                  _currentFolderId = state.folder.id;
                  _currentFolderName = state.folder.name;
                  return _buildDocumentsGrid(
                    folders: const [], // Les dossiers sont chargés séparément
                    documents: state.documents,
                    insideFolder: true,
                  );
                } else if (state is FoldersLoaded) {
                  if (state.parentFolderId != null) {
                    _currentFolderId = state.parentFolderId;
                    // Charger les documents de ce dossier
                    context.read<DocumentBloc>().add(
                          LoadDocumentsInFolder(folderId: state.parentFolderId!),
                        );
                  }
                  return _buildDocumentsGrid(
                    folders: state.folders,
                    documents: const [], // Les documents sont chargés séparément
                    insideFolder: state.parentFolderId != null,
                  );
                } else if (state is DocumentsLoaded) {
                  // Réinitialiser la navigation si on est à la racine
                  if (state.activeFilter == null || 
                      state.activeFilter == 'Favoris' ||
                      state.activeFilter!.startsWith('Recherche:') ||
                      state.activeFilter!.startsWith('Type:') ||
                      state.activeFilter!.startsWith('Tag:')) {
                    _currentFolderId = null;
                    _currentFolderName = null;
                  }
                  
                  return _buildDocumentsGrid(
                    folders: const [], // On n'affiche pas les dossiers dans ce cas
                    documents: state.documents,
                    activeFilter: state.activeFilter,
                  );
                } else if (state is DocumentLoaded) {
                  // Ouvrir le document
                  _openDocument(context, state.document, state.file);
                  // Retourner à l'état précédent
                  if (_currentFolderId != null) {
                    context.read<DocumentBloc>().add(
                          LoadDocumentsInFolder(folderId: _currentFolderId!),
                        );
                  } else {
                    context.read<DocumentBloc>().add(LoadDocuments());
                  }
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // État initial ou inconnu
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.folder_open,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucun document',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ajoutez des documents en utilisant le bouton +',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            _showAddDocumentDialog(context);
                          },
                          child: const Text('Ajouter un document'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildDocumentsGrid({
    required List<DocumentFolder> folders,
    required List<Document> documents,
    String? activeFilter,
    bool insideFolder = false,
  }) {
    if (folders.isEmpty && documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              insideFolder
                  ? 'Ce dossier est vide'
                  : activeFilter != null
                      ? 'Aucun document ne correspond à votre recherche'
                      : 'Aucun document',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ajoutez des documents en utilisant le bouton +',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        if (activeFilter != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Chip(
                label: Text(activeFilter),
                deleteIcon: const Icon(Icons.clear),
                onDeleted: () {
                  if (_currentFolderId != null) {
                    context.read<DocumentBloc>().add(
                          LoadDocumentsInFolder(folderId: _currentFolderId!),
                        );
                  } else {
                    context.read<DocumentBloc>().add(LoadDocuments());
                  }
                },
              ),
            ),
          ),
        if (folders.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.folder, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Dossiers (${folders.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (folders.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final folder = folders[index];
                  return FolderGridItem(
                    folder: folder,
                    onTap: () {
                      _navigateToFolder(folder);
                    },
                    onEdit: () {
                      _showEditFolderDialog(context, folder);
                    },
                    onDelete: () {
                      _showDeleteFolderDialog(context, folder);
                    },
                  );
                },
                childCount: folders.length,
              ),
            ),
          ),
        if (documents.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Documents (${documents.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (documents.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final document = documents[index];
                  return DocumentGridItem(
                    document: document,
                    onTap: () {
                      context
                          .read<DocumentBloc>()
                          .add(ViewDocument(document.id));
                    },
                    onDelete: () {
                      _showDeleteDocumentDialog(context, document);
                    },
                    onToggleFavorite: (isFavorite) {
                      context.read<DocumentBloc>().add(
                            ToggleFavorite(
                              id: document.id,
                              isFavorite: isFavorite,
                            ),
                          );
                    },
                  );
                },
                childCount: documents.length,
              ),
            ),
          ),
        // Ajouter un espace en bas pour éviter que le FAB ne cache du contenu
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showAddOptions(context);
      },
      icon: const Icon(Icons.add),
      label: const Text('Ajouter'),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Importer un document'),
              onTap: () {
                Navigator.of(context).pop();
                _showAddDocumentDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.create_new_folder),
              title: const Text('Créer un dossier'),
              onTap: () {
                Navigator.of(context).pop();
                _showAddFolderDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDocumentDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    DocumentType type = DocumentType.other;
    List<String> tags = [];
    String tagText = '';
    String? associatedEntityId;
    File? selectedFile;
    
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    
    selectedFile = File(result.files.single.path!);
    name = path.basename(selectedFile.path);
    
    // Déterminer le type de document en fonction de l'extension
    final extension = path.extension(name).toLowerCase();
    if (['.jpg', '.jpeg', '.png', '.gif', '.bmp'].contains(extension)) {
      type = DocumentType.image;
    } else if (extension == '.pdf') {
      type = DocumentType.pdf;
    } else if (['.doc', '.docx', '.txt', '.rtf', '.md'].contains(extension)) {
      type = DocumentType.text;
    } else if (['.xls', '.xlsx', '.csv'].contains(extension)) {
      type = DocumentType.spreadsheet;
    } else if (['.ppt', '.pptx'].contains(extension)) {
      type = DocumentType.presentation;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un document'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom du fichier sélectionné
                      Text(
                        'Fichier sélectionné: ${selectedFile?.path ?? "Aucun"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Nom
                      TextFormField(
                        initialValue: name,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          hintText: 'Entrez un nom pour le document',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      
                      // Description
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description (optionnel)',
                          hintText: 'Entrez une description',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      
                      // Type
                      DropdownButtonFormField<DocumentType>(
                        decoration: const InputDecoration(
                          labelText: 'Type de document',
                        ),
                        value: type,
                        items: DocumentType.values.map((docType) {
                          return DropdownMenuItem<DocumentType>(
                            value: docType,
                            child: Text(_getDocumentTypeName(docType)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              type = value;
                            });
                          }
                        },
                      ),
                      
                      // Tags
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: Text(
                          'Tags (optionnel)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      // Liste des tags ajoutés
                      if (tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          children: tags
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  deleteIcon: const Icon(Icons.clear, size: 16),
                                  onDeleted: () {
                                    setState(() {
                                      tags.remove(tag);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      
                      // Champ pour ajouter un tag
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Ajouter un tag',
                                hintText: 'Entrez un tag',
                              ),
                              onChanged: (value) {
                                tagText = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (tagText.isNotEmpty && !tags.contains(tagText)) {
                                setState(() {
                                  tags.add(tagText);
                                  tagText = '';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() && selectedFile != null) {
                      context.read<DocumentBloc>().add(
                            AddDocument(
                              name: name,
                              description: description,
                              file: selectedFile!,
                              type: type,
                              tags: tags,
                              associatedEntityId: associatedEntityId,
                              folderId: _currentFolderId,
                            ),
                          );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Créer un dossier'),
          content: Form(
            key: formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nom du dossier',
                hintText: 'Entrez un nom pour le dossier',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<DocumentBloc>().add(
                        CreateFolder(
                          name: name,
                          parentId: _currentFolderId,
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  void _showEditFolderDialog(BuildContext context, DocumentFolder folder) {
    final formKey = GlobalKey<FormState>();
    String name = folder.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Renommer le dossier'),
          content: Form(
            key: formKey,
            child: TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                labelText: 'Nom du dossier',
                hintText: 'Entrez un nouveau nom',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedFolder = folder.copyWith(name: name);
                  context.read<DocumentBloc>().add(UpdateFolder(updatedFolder));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Renommer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFolderDialog(BuildContext context, DocumentFolder folder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le dossier'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer le dossier "${folder.name}" ? '
            'Cette action ne peut pas être annulée.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                context.read<DocumentBloc>().add(DeleteFolder(folder.id));
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDocumentDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le document'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer le document "${document.name}" ? '
            'Cette action ne peut pas être annulée.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                context.read<DocumentBloc>().add(DeleteDocument(document.id));
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrer les documents'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filtrer par type de document'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(
                    context,
                    'Factures',
                    () {
                      Navigator.of(context).pop();
                      context
                          .read<DocumentBloc>()
                          .add(LoadDocumentsByType(DocumentType.invoice));
                    },
                  ),
                  _buildFilterChip(
                    context,
                    'Contrats',
                    () {
                      Navigator.of(context).pop();
                      context
                          .read<DocumentBloc>()
                          .add(LoadDocumentsByType(DocumentType.contract));
                    },
                  ),
                  _buildFilterChip(
                    context,
                    'Images',
                    () {
                      Navigator.of(context).pop();
                      context
                          .read<DocumentBloc>()
                          .add(LoadDocumentsByType(DocumentType.image));
                    },
                  ),
                  _buildFilterChip(
                    context,
                    'PDF',
                    () {
                      Navigator.of(context).pop();
                      context
                          .read<DocumentBloc>()
                          .add(LoadDocumentsByType(DocumentType.pdf));
                    },
                  ),
                  _buildFilterChip(
                    context,
                    'Textes',
                    () {
                      Navigator.of(context).pop();
                      context
                          .read<DocumentBloc>()
                          .add(LoadDocumentsByType(DocumentType.text));
                    },
                  ),
                  _buildFilterChip(
                    context,
                    'Tableurs',
                    () {
                      Navigator.of(context).pop();
                      context
                          .read<DocumentBloc>()
                          .add(LoadDocumentsByType(DocumentType.spreadsheet));
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_currentFolderId != null) {
                  context.read<DocumentBloc>().add(
                        LoadDocumentsInFolder(folderId: _currentFolderId!),
                      );
                } else {
                  context.read<DocumentBloc>().add(LoadDocuments());
                }
              },
              child: const Text('Tout voir'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }

  void _navigateToFolder(DocumentFolder folder) {
    if (_currentFolderId != null) {
      _navigationHistory.add(_currentFolderId!);
    }
    _currentFolderId = folder.id;
    _currentFolderName = folder.name;
    
    // Charger les sous-dossiers
    context.read<DocumentBloc>().add(LoadSubfolders(folderId: folder.id));
    
    // Charger les documents de ce dossier
    context.read<DocumentBloc>().add(LoadDocumentsInFolder(folderId: folder.id));
  }

  void _navigateBack() {
    if (_navigationHistory.isNotEmpty) {
      final previousFolderId = _navigationHistory.removeLast();
      _currentFolderId = previousFolderId;
      
      // Charger les sous-dossiers du dossier précédent
      context.read<DocumentBloc>().add(LoadSubfolders(folderId: previousFolderId));
      
      // Charger les documents du dossier précédent
      context.read<DocumentBloc>().add(LoadDocumentsInFolder(folderId: previousFolderId));
    } else {
      _currentFolderId = null;
      _currentFolderName = null;
      
      // Charger les dossiers racines
      context.read<DocumentBloc>().add(LoadRootFolders());
      
      // Charger tous les documents
      context.read<DocumentBloc>().add(LoadDocuments());
    }
  }

  void _openDocument(BuildContext context, Document document, File file) {
    // Ici, on pourrait implémenter l'ouverture du document selon son type
    // Pour l'instant, on affiche simplement un dialogue
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(document.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${_getDocumentTypeName(document.type)}'),
                const SizedBox(height: 8),
                Text('Taille: ${_formatFileSize(document.size)}'),
                const SizedBox(height: 8),
                Text('Créé le: ${document.createdAt.toString()}'),
                if (document.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(document.description),
                ],
                if (document.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Tags:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children: document.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Chemin du fichier:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(file.path),
                if (document.type == DocumentType.image) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Aperçu:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text('Impossible d\'afficher l\'image'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  String _getDocumentTypeName(DocumentType type) {
    switch (type) {
      case DocumentType.invoice:
        return 'Facture';
      case DocumentType.contract:
        return 'Contrat';
      case DocumentType.report:
        return 'Rapport';
      case DocumentType.receipt:
        return 'Reçu';
      case DocumentType.proposal:
        return 'Proposition';
      case DocumentType.legal:
        return 'Document légal';
      case DocumentType.tax:
        return 'Document fiscal';
      case DocumentType.image:
        return 'Image';
      case DocumentType.pdf:
        return 'PDF';
      case DocumentType.spreadsheet:
        return 'Tableur';
      case DocumentType.presentation:
        return 'Présentation';
      case DocumentType.text:
        return 'Texte';
      case DocumentType.other:
        return 'Autre';
    }
  }

  String _formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
}
