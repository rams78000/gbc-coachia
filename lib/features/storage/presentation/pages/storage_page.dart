import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  String _currentPath = '/';
  final List<String> _breadcrumbs = ['/'];
  String? _selectedFile;
  final List<StorageItem> _recentFiles = [
    StorageItem(
      name: 'Présentation client.pptx',
      path: '/Présentations/Présentation client.pptx',
      type: StorageItemType.file,
      size: '2.5 Mo',
      lastModified: DateTime.now().subtract(const Duration(hours: 3)),
      icon: Icons.slideshow,
      color: Colors.orange,
    ),
    StorageItem(
      name: 'Budget 2023.xlsx',
      path: '/Documents/Finances/Budget 2023.xlsx',
      type: StorageItemType.file,
      size: '1.8 Mo',
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.table_chart,
      color: Colors.green,
    ),
    StorageItem(
      name: 'Contrat Dupont.pdf',
      path: '/Documents/Contrats/Contrat Dupont.pdf',
      type: StorageItemType.file,
      size: '350 Ko',
      lastModified: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.picture_as_pdf,
      color: Colors.red,
    ),
    StorageItem(
      name: 'Logo entreprise.png',
      path: '/Images/Logo entreprise.png',
      type: StorageItemType.file,
      size: '580 Ko',
      lastModified: DateTime.now().subtract(const Duration(days: 5)),
      icon: Icons.image,
      color: Colors.blue,
    ),
  ];

  Map<String, List<StorageItem>> _fileStructure = {};

  @override
  void initState() {
    super.initState();
    _initFileStructure();
  }

  void _initFileStructure() {
    // Initialisation d'une structure de fichiers simulée
    _fileStructure = {
      '/': [
        StorageItem(
          name: 'Documents',
          path: '/Documents',
          type: StorageItemType.folder,
          size: '--',
          lastModified: DateTime.now().subtract(const Duration(days: 10)),
          icon: Icons.folder,
          color: const Color(0xFFB87333),
        ),
        StorageItem(
          name: 'Images',
          path: '/Images',
          type: StorageItemType.folder,
          size: '--',
          lastModified: DateTime.now().subtract(const Duration(days: 15)),
          icon: Icons.folder,
          color: const Color(0xFFB87333),
        ),
        StorageItem(
          name: 'Présentations',
          path: '/Présentations',
          type: StorageItemType.folder,
          size: '--',
          lastModified: DateTime.now().subtract(const Duration(days: 20)),
          icon: Icons.folder,
          color: const Color(0xFFB87333),
        ),
        StorageItem(
          name: 'Notes.txt',
          path: '/Notes.txt',
          type: StorageItemType.file,
          size: '12 Ko',
          lastModified: DateTime.now().subtract(const Duration(days: 1)),
          icon: Icons.text_snippet,
          color: Colors.grey,
        ),
      ],
      '/Documents': [
        StorageItem(
          name: 'Contrats',
          path: '/Documents/Contrats',
          type: StorageItemType.folder,
          size: '--',
          lastModified: DateTime.now().subtract(const Duration(days: 12)),
          icon: Icons.folder,
          color: const Color(0xFFB87333),
        ),
        StorageItem(
          name: 'Finances',
          path: '/Documents/Finances',
          type: StorageItemType.folder,
          size: '--',
          lastModified: DateTime.now().subtract(const Duration(days: 8)),
          icon: Icons.folder,
          color: const Color(0xFFB87333),
        ),
        StorageItem(
          name: 'Rapport annuel.docx',
          path: '/Documents/Rapport annuel.docx',
          type: StorageItemType.file,
          size: '1.2 Mo',
          lastModified: DateTime.now().subtract(const Duration(days: 3)),
          icon: Icons.description,
          color: Colors.blue,
        ),
      ],
      '/Documents/Contrats': [
        StorageItem(
          name: 'Contrat Dupont.pdf',
          path: '/Documents/Contrats/Contrat Dupont.pdf',
          type: StorageItemType.file,
          size: '350 Ko',
          lastModified: DateTime.now().subtract(const Duration(days: 2)),
          icon: Icons.picture_as_pdf,
          color: Colors.red,
        ),
        StorageItem(
          name: 'Contrat Martin.pdf',
          path: '/Documents/Contrats/Contrat Martin.pdf',
          type: StorageItemType.file,
          size: '320 Ko',
          lastModified: DateTime.now().subtract(const Duration(days: 5)),
          icon: Icons.picture_as_pdf,
          color: Colors.red,
        ),
      ],
      '/Documents/Finances': [
        StorageItem(
          name: 'Budget 2023.xlsx',
          path: '/Documents/Finances/Budget 2023.xlsx',
          type: StorageItemType.file,
          size: '1.8 Mo',
          lastModified: DateTime.now().subtract(const Duration(days: 1)),
          icon: Icons.table_chart,
          color: Colors.green,
        ),
        StorageItem(
          name: 'Factures Q1.xlsx',
          path: '/Documents/Finances/Factures Q1.xlsx',
          type: StorageItemType.file,
          size: '950 Ko',
          lastModified: DateTime.now().subtract(const Duration(days: 7)),
          icon: Icons.table_chart,
          color: Colors.green,
        ),
      ],
      '/Images': [
        StorageItem(
          name: 'Logo entreprise.png',
          path: '/Images/Logo entreprise.png',
          type: StorageItemType.file,
          size: '580 Ko',
          lastModified: DateTime.now().subtract(const Duration(days: 5)),
          icon: Icons.image,
          color: Colors.blue,
        ),
        StorageItem(
          name: 'Photo équipe.jpg',
          path: '/Images/Photo équipe.jpg',
          type: StorageItemType.file,
          size: '1.5 Mo',
          lastModified: DateTime.now().subtract(const Duration(days: 30)),
          icon: Icons.image,
          color: Colors.blue,
        ),
      ],
      '/Présentations': [
        StorageItem(
          name: 'Présentation client.pptx',
          path: '/Présentations/Présentation client.pptx',
          type: StorageItemType.file,
          size: '2.5 Mo',
          lastModified: DateTime.now().subtract(const Duration(hours: 3)),
          icon: Icons.slideshow,
          color: Colors.orange,
        ),
        StorageItem(
          name: 'Formation interne.pptx',
          path: '/Présentations/Formation interne.pptx',
          type: StorageItemType.file,
          size: '3.2 Mo',
          lastModified: DateTime.now().subtract(const Duration(days: 15)),
          icon: Icons.slideshow,
          color: Colors.orange,
        ),
      ],
    };
  }

  void _navigateToFolder(String path) {
    setState(() {
      _currentPath = path;
      _updateBreadcrumbs();
      _selectedFile = null;
    });
  }

  void _updateBreadcrumbs() {
    _breadcrumbs.clear();
    
    List<String> parts = _currentPath.split('/');
    String currentBuild = '';
    
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) {
        currentBuild = '/';
      } else {
        currentBuild += parts[i] + '/';
      }
      
      if (i == 0 && parts[i].isEmpty) {
        _breadcrumbs.add('/');
      } else if (parts[i].isNotEmpty) {
        _breadcrumbs.add(currentBuild);
      }
    }
    
    // Remove trailing slash for paths other than root
    if (_breadcrumbs.last != '/' && _breadcrumbs.last.endsWith('/')) {
      _breadcrumbs[_breadcrumbs.length - 1] = 
          _breadcrumbs.last.substring(0, _breadcrumbs.last.length - 1);
    }
  }

  String _getBreadcrumbLabel(String path) {
    if (path == '/') return 'Accueil';
    List<String> parts = path.split('/');
    return parts.last;
  }

  void _selectFile(StorageItem file) {
    setState(() {
      _selectedFile = file.path;
    });
  }

  List<StorageItem> _getCurrentFolderItems() {
    return _fileStructure[_currentPath] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stockage'),
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
              Tab(text: 'Mes fichiers'),
              Tab(text: 'Récents'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFilesTab(),
            _buildRecentFilesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddFileDialog();
          },
          backgroundColor: const Color(0xFFB87333),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildFilesTab() {
    return Column(
      children: [
        _buildBreadcrumbsBar(),
        Expanded(
          child: _getCurrentFolderItems().isEmpty
              ? const Center(
                  child: Text(
                    'Ce dossier est vide',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _getCurrentFolderItems().length,
                  itemBuilder: (context, index) {
                    final item = _getCurrentFolderItems()[index];
                    return _buildFileListItem(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBreadcrumbsBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            _breadcrumbs.length,
            (index) {
              final isLast = index == _breadcrumbs.length - 1;
              return Row(
                children: [
                  TextButton(
                    onPressed: isLast
                        ? null
                        : () => _navigateToFolder(_breadcrumbs[index]),
                    style: TextButton.styleFrom(
                      foregroundColor: isLast ? Colors.grey : const Color(0xFFB87333),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(_getBreadcrumbLabel(_breadcrumbs[index])),
                  ),
                  if (!isLast)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFileListItem(StorageItem item) {
    final isSelected = item.path == _selectedFile;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: Color(0xFFB87333), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          if (item.type == StorageItemType.folder) {
            _navigateToFolder(item.path);
          } else {
            _selectFile(item);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.size,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          DateFormat('dd/MM/yyyy').format(item.lastModified),
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
              if (item.type == StorageItemType.folder)
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                )
              else
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'preview') {
                      _showFilePreviewDialog(item);
                    } else if (value == 'download') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Téléchargement simulé'),
                        ),
                      );
                    } else if (value == 'delete') {
                      _showDeleteFileDialog(item);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'preview',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 20),
                          SizedBox(width: 8),
                          Text('Aperçu'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download, size: 20),
                          SizedBox(width: 8),
                          Text('Télécharger'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentFilesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentFiles.length,
      itemBuilder: (context, index) {
        final file = _recentFiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              _showFilePreviewDialog(file);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: file.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      file.icon,
                      color: file.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Modifié ${_getTimeAgo(file.lastModified)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          file.path,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) => _buildFileActionsSheet(file),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return 'il y a ${difference.inDays} ${difference.inDays == 1 ? 'jour' : 'jours'}';
    } else if (difference.inHours > 0) {
      return 'il y a ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}';
    } else if (difference.inMinutes > 0) {
      return 'il y a ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return 'à l\'instant';
    }
  }

  Widget _buildFileActionsSheet(StorageItem file) {
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
                _showFilePreviewDialog(file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Ouvrir l\'emplacement'),
              onTap: () {
                Navigator.pop(context);
                // Extraire le chemin du dossier parent
                final pathParts = file.path.split('/');
                pathParts.removeLast();
                final parentPath = pathParts.join('/');
                _navigateToFolder(parentPath.isEmpty ? '/' : parentPath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Télécharger'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Téléchargement simulé'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Supprimer', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteFileDialog(file);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilePreviewDialog(StorageItem file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(file.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: file.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    file.icon,
                    size: 64,
                    color: file.color,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Chemin: ${file.path}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Taille: ${file.size}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dernière modification: ${DateFormat('dd/MM/yyyy HH:mm').format(file.lastModified)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Téléchargement simulé'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87333),
                foregroundColor: Colors.white,
              ),
              child: const Text('Télécharger'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFileDialog(StorageItem file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le fichier'),
          content: Text('Êtes-vous sûr de vouloir supprimer "${file.name}" ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Supprimer le fichier de la structure
                final parentPath = file.path.substring(0, file.path.lastIndexOf('/'));
                final parent = parentPath.isEmpty ? '/' : parentPath;
                
                setState(() {
                  _fileStructure[parent]?.removeWhere((item) => item.path == file.path);
                  _recentFiles.removeWhere((item) => item.path == file.path);
                  
                  if (_selectedFile == file.path) {
                    _selectedFile = null;
                  }
                });
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${file.name} supprimé'),
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

  void _showAddFileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.create_new_folder,
                  color: const Color(0xFFB87333),
                ),
                title: const Text('Nouveau dossier'),
                onTap: () {
                  Navigator.pop(context);
                  _showCreateFolderDialog();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.upload_file,
                  color: const Color(0xFFB87333),
                ),
                title: const Text('Importer un fichier'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonctionnalité d\'import à implémenter'),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateFolderDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouveau dossier'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nom du dossier',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final folderName = controller.text.trim();
                if (folderName.isNotEmpty) {
                  final newPath = _currentPath == '/'
                      ? '/$folderName'
                      : '$_currentPath/$folderName';
                  
                  setState(() {
                    // Ajouter le dossier à la structure
                    if (_fileStructure[_currentPath] == null) {
                      _fileStructure[_currentPath] = [];
                    }
                    
                    _fileStructure[_currentPath]!.add(
                      StorageItem(
                        name: folderName,
                        path: newPath,
                        type: StorageItemType.folder,
                        size: '--',
                        lastModified: DateTime.now(),
                        icon: Icons.folder,
                        color: const Color(0xFFB87333),
                      ),
                    );
                    
                    // Initialiser le contenu du nouveau dossier
                    _fileStructure[newPath] = [];
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dossier "$folderName" créé'),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87333),
                foregroundColor: Colors.white,
              ),
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }
}

enum StorageItemType {
  folder,
  file,
}

class StorageItem {
  final String name;
  final String path;
  final StorageItemType type;
  final String size;
  final DateTime lastModified;
  final IconData icon;
  final Color color;

  StorageItem({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.lastModified,
    required this.icon,
    required this.color,
  });
}
