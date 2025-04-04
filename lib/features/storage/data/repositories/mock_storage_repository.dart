import 'dart:typed_data';
import 'dart:math' as math;

import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_folder.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_item.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_statistics.dart';
import 'package:gbc_coachia/features/storage/domain/repositories/storage_repository.dart';

/// Implémentation simulée du repository de stockage
class MockStorageRepository implements StorageRepository {
  // Données simulées
  final List<StorageFile> _files = [];
  final List<StorageFolder> _folders = [];
  
  // Statistiques simulées
  final StorageStatistics _statistics = StorageStatistics(
    totalSize: 10 * 1024 * 1024 * 1024, // 10 Go
    usedSize: 3 * 1024 * 1024 * 1024, // 3 Go
    availableSize: 7 * 1024 * 1024 * 1024, // 7 Go
    totalFiles: 100,
    totalFolders: 20,
    fileTypeCount: {
      FileType.document: 25,
      FileType.image: 30,
      FileType.pdf: 15,
      FileType.video: 10,
      FileType.audio: 8,
      FileType.spreadsheet: 7,
      FileType.presentation: 5,
      FileType.archive: 3,
      FileType.other: 2,
    },
    fileTypeSize: {
      FileType.document: 200 * 1024 * 1024, // 200 Mo
      FileType.image: 500 * 1024 * 1024, // 500 Mo
      FileType.pdf: 300 * 1024 * 1024, // 300 Mo
      FileType.video: 1500 * 1024 * 1024, // 1.5 Go
      FileType.audio: 200 * 1024 * 1024, // 200 Mo
      FileType.spreadsheet: 100 * 1024 * 1024, // 100 Mo
      FileType.presentation: 150 * 1024 * 1024, // 150 Mo
      FileType.archive: 50 * 1024 * 1024, // 50 Mo
      FileType.other: 100 * 1024 * 1024, // 100 Mo
    },
  );
  
  // Constructeur
  MockStorageRepository() {
    _initMockData();
  }
  
  // Initialisation des données simulées
  void _initMockData() {
    // Dossier racine
    final rootFolder = StorageFolder(
      id: 'root',
      name: 'Mon stockage',
      path: '/',
      itemCount: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      isFavorite: false,
      isShared: false,
    );
    _folders.add(rootFolder);
    
    // Dossier Documents
    final documentsFolder = StorageFolder(
      id: 'documents',
      name: 'Documents',
      path: '/Documents',
      itemCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      parentId: 'root',
      isFavorite: true,
      isShared: false,
    );
    _folders.add(documentsFolder);
    
    // Dossier Images
    final imagesFolder = StorageFolder(
      id: 'images',
      name: 'Images',
      path: '/Images',
      itemCount: 30,
      createdAt: DateTime.now().subtract(const Duration(days: 250)),
      parentId: 'root',
      isFavorite: false,
      isShared: true,
    );
    _folders.add(imagesFolder);
    
    // Dossier Vidéos
    final videosFolder = StorageFolder(
      id: 'videos',
      name: 'Vidéos',
      path: '/Vidéos',
      itemCount: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      parentId: 'root',
      isFavorite: false,
      isShared: false,
    );
    _folders.add(videosFolder);
    
    // Dossier Projets
    final projectsFolder = StorageFolder(
      id: 'projects',
      name: 'Projets',
      path: '/Projets',
      itemCount: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
      parentId: 'root',
      isFavorite: true,
      isShared: false,
    );
    _folders.add(projectsFolder);
    
    // Sous-dossiers Documents
    final invoicesFolder = StorageFolder(
      id: 'invoices',
      name: 'Factures',
      path: '/Documents/Factures',
      itemCount: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 280)),
      parentId: 'documents',
      isFavorite: false,
      isShared: false,
    );
    _folders.add(invoicesFolder);
    
    final contractsFolder = StorageFolder(
      id: 'contracts',
      name: 'Contrats',
      path: '/Documents/Contrats',
      itemCount: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 260)),
      parentId: 'documents',
      isFavorite: false,
      isShared: false,
    );
    _folders.add(contractsFolder);
    
    // Sous-dossiers Images
    final clientsFolder = StorageFolder(
      id: 'clients',
      name: 'Clients',
      path: '/Images/Clients',
      itemCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 230)),
      parentId: 'images',
      isFavorite: false,
      isShared: false,
    );
    _folders.add(clientsFolder);
    
    final productsFolder = StorageFolder(
      id: 'products',
      name: 'Produits',
      path: '/Images/Produits',
      itemCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 220)),
      parentId: 'images',
      isFavorite: false,
      isShared: false,
    );
    _folders.add(productsFolder);
    
    // Fichiers dans le dossier Documents
    _files.add(
      StorageFile(
        id: 'doc1',
        name: 'Business Plan 2024.docx',
        path: '/Documents/Business Plan 2024.docx',
        extension: 'docx',
        size: 2 * 1024 * 1024, // 2 Mo
        type: FileType.document,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
        isFavorite: true,
        isShared: false,
      ),
    );
    
    _files.add(
      StorageFile(
        id: 'doc2',
        name: 'Finances Q1 2024.xlsx',
        path: '/Documents/Finances Q1 2024.xlsx',
        extension: 'xlsx',
        size: 1.5 * 1024 * 1024, // 1.5 Mo
        type: FileType.spreadsheet,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        isFavorite: false,
        isShared: true,
      ),
    );
    
    _files.add(
      StorageFile(
        id: 'doc3',
        name: 'Rapport Annuel 2023.pdf',
        path: '/Documents/Rapport Annuel 2023.pdf',
        extension: 'pdf',
        size: 5 * 1024 * 1024, // 5 Mo
        type: FileType.pdf,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        isFavorite: false,
        isShared: false,
      ),
    );
    
    // Fichiers dans le dossier Factures
    _files.add(
      StorageFile(
        id: 'invoice1',
        name: 'Facture - Client A - #123.pdf',
        path: '/Documents/Factures/Facture - Client A - #123.pdf',
        extension: 'pdf',
        size: 0.8 * 1024 * 1024, // 800 Ko
        type: FileType.pdf,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        isFavorite: false,
        isShared: false,
      ),
    );
    
    _files.add(
      StorageFile(
        id: 'invoice2',
        name: 'Facture - Client B - #124.pdf',
        path: '/Documents/Factures/Facture - Client B - #124.pdf',
        extension: 'pdf',
        size: 0.7 * 1024 * 1024, // 700 Ko
        type: FileType.pdf,
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
        isFavorite: false,
        isShared: true,
      ),
    );
    
    // Fichiers dans le dossier Contrats
    _files.add(
      StorageFile(
        id: 'contract1',
        name: 'Contrat - Prestation XYZ.docx',
        path: '/Documents/Contrats/Contrat - Prestation XYZ.docx',
        extension: 'docx',
        size: 1.2 * 1024 * 1024, // 1.2 Mo
        type: FileType.document,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        isFavorite: true,
        isShared: false,
      ),
    );
    
    // Fichiers dans le dossier Images
    _files.add(
      StorageFile(
        id: 'img1',
        name: 'Logo Entreprise.png',
        path: '/Images/Logo Entreprise.png',
        extension: 'png',
        size: 0.5 * 1024 * 1024, // 500 Ko
        type: FileType.image,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now().subtract(const Duration(days: 150)),
        isFavorite: true,
        isShared: true,
        thumbnail: 'https://via.placeholder.com/100',
      ),
    );
    
    _files.add(
      StorageFile(
        id: 'img2',
        name: 'Banner Site Web.jpg',
        path: '/Images/Banner Site Web.jpg',
        extension: 'jpg',
        size: 2.5 * 1024 * 1024, // 2.5 Mo
        type: FileType.image,
        createdAt: DateTime.now().subtract(const Duration(days: 160)),
        isFavorite: false,
        isShared: true,
        thumbnail: 'https://via.placeholder.com/100',
      ),
    );
    
    // Fichiers dans le dossier Clients
    for (int i = 1; i <= 5; i++) {
      _files.add(
        StorageFile(
          id: 'client$i',
          name: 'Client $i.jpg',
          path: '/Images/Clients/Client $i.jpg',
          extension: 'jpg',
          size: (0.3 + i * 0.1) * 1024 * 1024, // 300-800 Ko
          type: FileType.image,
          createdAt: DateTime.now().subtract(Duration(days: 100 + i * 2)),
          isFavorite: i == 1,
          isShared: i % 2 == 0,
          thumbnail: 'https://via.placeholder.com/100',
        ),
      );
    }
    
    // Fichiers dans le dossier Produits
    for (int i = 1; i <= 5; i++) {
      _files.add(
        StorageFile(
          id: 'product$i',
          name: 'Produit $i.jpg',
          path: '/Images/Produits/Produit $i.jpg',
          extension: 'jpg',
          size: (0.4 + i * 0.1) * 1024 * 1024, // 400-900 Ko
          type: FileType.image,
          createdAt: DateTime.now().subtract(Duration(days: 80 + i * 2)),
          isFavorite: i == 3,
          isShared: i % 3 == 0,
          thumbnail: 'https://via.placeholder.com/100',
        ),
      );
    }
    
    // Fichiers dans le dossier Vidéos
    _files.add(
      StorageFile(
        id: 'video1',
        name: 'Présentation Produit.mp4',
        path: '/Vidéos/Présentation Produit.mp4',
        extension: 'mp4',
        size: 50 * 1024 * 1024, // 50 Mo
        type: FileType.video,
        createdAt: DateTime.now().subtract(const Duration(days: 130)),
        isFavorite: false,
        isShared: true,
        thumbnail: 'https://via.placeholder.com/100',
      ),
    );
    
    _files.add(
      StorageFile(
        id: 'video2',
        name: 'Interview Client.mp4',
        path: '/Vidéos/Interview Client.mp4',
        extension: 'mp4',
        size: 75 * 1024 * 1024, // 75 Mo
        type: FileType.video,
        createdAt: DateTime.now().subtract(const Duration(days: 110)),
        isFavorite: true,
        isShared: false,
        thumbnail: 'https://via.placeholder.com/100',
      ),
    );
    
    // Fichiers dans le dossier Projets
    _files.add(
      StorageFile(
        id: 'project1',
        name: 'Projet Alpha - Planning.xlsx',
        path: '/Projets/Projet Alpha - Planning.xlsx',
        extension: 'xlsx',
        size: 0.9 * 1024 * 1024, // 900 Ko
        type: FileType.spreadsheet,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isFavorite: false,
        isShared: true,
      ),
    );
    
    _files.add(
      StorageFile(
        id: 'project2',
        name: 'Projet Beta - Présentation.pptx',
        path: '/Projets/Projet Beta - Présentation.pptx',
        extension: 'pptx',
        size: 3.5 * 1024 * 1024, // 3.5 Mo
        type: FileType.presentation,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isFavorite: false,
        isShared: false,
      ),
    );
    
    _files.add(
      StorageFile(
        id: 'project3',
        name: 'Projet Gamma - Documents.zip',
        path: '/Projets/Projet Gamma - Documents.zip',
        extension: 'zip',
        size: 15 * 1024 * 1024, // 15 Mo
        type: FileType.archive,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        isFavorite: false,
        isShared: false,
      ),
    );
  }
  
  @override
  Future<List<StorageItem>> getItemsInFolder(String folderId) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Trouver tous les dossiers dont le parent est le dossier spécifié
    final childFolders = _folders
        .where((folder) => folder.parentId == folderId)
        .map((folder) => folder.toItem())
        .toList();
    
    // Trouver tous les fichiers dont le chemin correspond au dossier spécifié
    String folderPath = folderId == 'root' 
        ? '/' 
        : _folders.firstWhere((folder) => folder.id == folderId).path;
    
    final childFiles = _files
        .where((file) {
          // Compte le nombre de / dans le chemin du fichier pour déterminer la profondeur
          int depth = file.path.split('/').where((s) => s.isNotEmpty).length;
          
          // Pour les fichiers à la racine (dossier 'root'), on vérifie s'ils ont une profondeur de 1
          if (folderId == 'root') {
            return depth == 1;
          }
          
          // Pour les autres dossiers, on vérifie si le chemin du fichier commence par le chemin du dossier
          // et si la profondeur relative est de 1 (fichier directement dans ce dossier)
          return file.path.startsWith(folderPath) && 
                 file.path.substring(folderPath.length).split('/').where((s) => s.isNotEmpty).length == 1;
        })
        .map((file) => file.toItem())
        .toList();
    
    // Combiner les dossiers et les fichiers
    final items = [...childFolders, ...childFiles];
    items.sort((a, b) => a.name.compareTo(b.name));
    
    return items;
  }
  
  @override
  Future<List<StorageFile>> getRecentFiles({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Trier les fichiers par date de création ou de mise à jour (la plus récente)
    final sortedFiles = [..._files]..sort((a, b) {
      final aDate = a.updatedAt ?? a.createdAt;
      final bDate = b.updatedAt ?? b.createdAt;
      return bDate.compareTo(aDate);
    });
    
    return sortedFiles.take(limit).toList();
  }
  
  @override
  Future<List<StorageFile>> getFavoriteFiles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _files.where((file) => file.isFavorite).toList();
  }
  
  @override
  Future<List<StorageFile>> getSharedFiles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _files.where((file) => file.isShared).toList();
  }
  
  @override
  Future<StorageFile> getFileById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final file = _files.firstWhere(
      (file) => file.id == id,
      orElse: () => throw Exception('Fichier non trouvé avec ID: $id'),
    );
    
    return file;
  }
  
  @override
  Future<StorageFolder> getFolderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final folder = _folders.firstWhere(
      (folder) => folder.id == id,
      orElse: () => throw Exception('Dossier non trouvé avec ID: $id'),
    );
    
    return folder;
  }
  
  @override
  Future<StorageFolder> createFolder({
    required String name,
    required String parentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trouver le dossier parent
    final parent = _folders.firstWhere(
      (folder) => folder.id == parentId,
      orElse: () => throw Exception('Dossier parent non trouvé avec ID: $parentId'),
    );
    
    // Créer le chemin du nouveau dossier
    final path = parent.path == '/' ? '/$name' : '${parent.path}/$name';
    
    // Créer le nouveau dossier
    final newFolder = StorageFolder(
      id: 'folder_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      path: path,
      itemCount: 0,
      createdAt: DateTime.now(),
      parentId: parentId,
      isFavorite: false,
      isShared: false,
    );
    
    // Ajouter le dossier à la liste
    _folders.add(newFolder);
    
    return newFolder;
  }
  
  @override
  Future<StorageFile> renameFile({
    required String id,
    required String newName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Trouver le fichier
    final fileIndex = _files.indexWhere((file) => file.id == id);
    if (fileIndex == -1) {
      throw Exception('Fichier non trouvé avec ID: $id');
    }
    
    final file = _files[fileIndex];
    
    // Obtenir l'extension du fichier
    final extension = file.extension;
    
    // Vérifier si le nouveau nom contient déjà l'extension
    final nameWithoutExtension = newName.endsWith('.$extension')
        ? newName.substring(0, newName.length - extension.length - 1)
        : newName;
    
    // Construire le nouveau nom avec l'extension
    final fullNewName = '$nameWithoutExtension.$extension';
    
    // Construire le nouveau chemin
    final pathParts = file.path.split('/');
    pathParts[pathParts.length - 1] = fullNewName;
    final newPath = pathParts.join('/');
    
    // Créer le fichier mis à jour
    final updatedFile = file.copyWith(
      name: fullNewName,
      path: newPath,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour le fichier dans la liste
    _files[fileIndex] = updatedFile;
    
    return updatedFile;
  }
  
  @override
  Future<StorageFolder> renameFolder({
    required String id,
    required String newName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Trouver le dossier
    final folderIndex = _folders.indexWhere((folder) => folder.id == id);
    if (folderIndex == -1) {
      throw Exception('Dossier non trouvé avec ID: $id');
    }
    
    final folder = _folders[folderIndex];
    
    // Construire le nouveau chemin
    final oldPath = folder.path;
    final pathParts = oldPath.split('/');
    pathParts[pathParts.length - 1] = newName;
    final newPath = pathParts.join('/');
    
    // Créer le dossier mis à jour
    final updatedFolder = folder.copyWith(
      name: newName,
      path: newPath,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour les chemins des sous-dossiers et fichiers
    for (int i = 0; i < _folders.length; i++) {
      if (_folders[i].path.startsWith(oldPath) && _folders[i].id != id) {
        _folders[i] = _folders[i].copyWith(
          path: _folders[i].path.replaceFirst(oldPath, newPath),
          updatedAt: DateTime.now(),
        );
      }
    }
    
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].path.startsWith(oldPath)) {
        _files[i] = _files[i].copyWith(
          path: _files[i].path.replaceFirst(oldPath, newPath),
          updatedAt: DateTime.now(),
        );
      }
    }
    
    // Mettre à jour le dossier dans la liste
    _folders[folderIndex] = updatedFolder;
    
    return updatedFolder;
  }
  
  @override
  Future<StorageFile> moveFile({
    required String id,
    required String destinationFolderId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trouver le fichier
    final fileIndex = _files.indexWhere((file) => file.id == id);
    if (fileIndex == -1) {
      throw Exception('Fichier non trouvé avec ID: $id');
    }
    
    // Trouver le dossier de destination
    final destinationFolder = _folders.firstWhere(
      (folder) => folder.id == destinationFolderId,
      orElse: () => throw Exception('Dossier de destination non trouvé avec ID: $destinationFolderId'),
    );
    
    final file = _files[fileIndex];
    final fileName = file.name;
    
    // Construire le nouveau chemin
    final newPath = destinationFolder.path == '/'
        ? '/$fileName'
        : '${destinationFolder.path}/$fileName';
    
    // Créer le fichier mis à jour
    final updatedFile = file.copyWith(
      path: newPath,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour le fichier dans la liste
    _files[fileIndex] = updatedFile;
    
    return updatedFile;
  }
  
  @override
  Future<StorageFolder> moveFolder({
    required String id,
    required String destinationFolderId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Vérifier que le dossier n'est pas déplacé dans un de ses sous-dossiers
    if (id == destinationFolderId) {
      throw Exception('Impossible de déplacer un dossier dans lui-même');
    }
    
    // Trouver le dossier
    final folderIndex = _folders.indexWhere((folder) => folder.id == id);
    if (folderIndex == -1) {
      throw Exception('Dossier non trouvé avec ID: $id');
    }
    
    // Trouver le dossier de destination
    final destinationFolder = _folders.firstWhere(
      (folder) => folder.id == destinationFolderId,
      orElse: () => throw Exception('Dossier de destination non trouvé avec ID: $destinationFolderId'),
    );
    
    // Vérifier que le dossier de destination n'est pas un sous-dossier du dossier à déplacer
    if (destinationFolder.path.startsWith(_folders[folderIndex].path)) {
      throw Exception('Impossible de déplacer un dossier dans un de ses sous-dossiers');
    }
    
    final folder = _folders[folderIndex];
    final folderName = folder.name;
    final oldPath = folder.path;
    
    // Construire le nouveau chemin
    final newPath = destinationFolder.path == '/'
        ? '/$folderName'
        : '${destinationFolder.path}/$folderName';
    
    // Créer le dossier mis à jour
    final updatedFolder = folder.copyWith(
      path: newPath,
      parentId: destinationFolderId,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour les chemins des sous-dossiers et fichiers
    for (int i = 0; i < _folders.length; i++) {
      if (_folders[i].path.startsWith(oldPath) && _folders[i].id != id) {
        _folders[i] = _folders[i].copyWith(
          path: _folders[i].path.replaceFirst(oldPath, newPath),
          updatedAt: DateTime.now(),
        );
      }
    }
    
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].path.startsWith(oldPath)) {
        _files[i] = _files[i].copyWith(
          path: _files[i].path.replaceFirst(oldPath, newPath),
          updatedAt: DateTime.now(),
        );
      }
    }
    
    // Mettre à jour le dossier dans la liste
    _folders[folderIndex] = updatedFolder;
    
    return updatedFolder;
  }
  
  @override
  Future<StorageFile> toggleFileFavorite({
    required String id,
    required bool isFavorite,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Trouver le fichier
    final fileIndex = _files.indexWhere((file) => file.id == id);
    if (fileIndex == -1) {
      throw Exception('Fichier non trouvé avec ID: $id');
    }
    
    // Créer le fichier mis à jour
    final updatedFile = _files[fileIndex].copyWith(
      isFavorite: isFavorite,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour le fichier dans la liste
    _files[fileIndex] = updatedFile;
    
    return updatedFile;
  }
  
  @override
  Future<StorageFolder> toggleFolderFavorite({
    required String id,
    required bool isFavorite,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Trouver le dossier
    final folderIndex = _folders.indexWhere((folder) => folder.id == id);
    if (folderIndex == -1) {
      throw Exception('Dossier non trouvé avec ID: $id');
    }
    
    // Créer le dossier mis à jour
    final updatedFolder = _folders[folderIndex].copyWith(
      isFavorite: isFavorite,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour le dossier dans la liste
    _folders[folderIndex] = updatedFolder;
    
    return updatedFolder;
  }
  
  @override
  Future<StorageFile> toggleFileSharing({
    required String id,
    required bool isShared,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Trouver le fichier
    final fileIndex = _files.indexWhere((file) => file.id == id);
    if (fileIndex == -1) {
      throw Exception('Fichier non trouvé avec ID: $id');
    }
    
    // Créer le fichier mis à jour
    final updatedFile = _files[fileIndex].copyWith(
      isShared: isShared,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour le fichier dans la liste
    _files[fileIndex] = updatedFile;
    
    return updatedFile;
  }
  
  @override
  Future<StorageFolder> toggleFolderSharing({
    required String id,
    required bool isShared,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Trouver le dossier
    final folderIndex = _folders.indexWhere((folder) => folder.id == id);
    if (folderIndex == -1) {
      throw Exception('Dossier non trouvé avec ID: $id');
    }
    
    // Créer le dossier mis à jour
    final updatedFolder = _folders[folderIndex].copyWith(
      isShared: isShared,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour le dossier dans la liste
    _folders[folderIndex] = updatedFolder;
    
    return updatedFolder;
  }
  
  @override
  Future<void> deleteFile(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Trouver le fichier
    final fileIndex = _files.indexWhere((file) => file.id == id);
    if (fileIndex == -1) {
      throw Exception('Fichier non trouvé avec ID: $id');
    }
    
    // Supprimer le fichier
    _files.removeAt(fileIndex);
  }
  
  @override
  Future<void> deleteFolder(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Vérifier que le dossier n'est pas le dossier racine
    if (id == 'root') {
      throw Exception('Impossible de supprimer le dossier racine');
    }
    
    // Trouver le dossier
    final folderIndex = _folders.indexWhere((folder) => folder.id == id);
    if (folderIndex == -1) {
      throw Exception('Dossier non trouvé avec ID: $id');
    }
    
    final folderPath = _folders[folderIndex].path;
    
    // Supprimer tous les fichiers dans ce dossier et ses sous-dossiers
    _files.removeWhere((file) => file.path.startsWith(folderPath));
    
    // Supprimer tous les sous-dossiers
    _folders.removeWhere((folder) => folder.path.startsWith(folderPath) && folder.id != id);
    
    // Supprimer le dossier lui-même
    _folders.removeAt(folderIndex);
  }
  
  @override
  Future<Uint8List> downloadFile(String id) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Trouver le fichier
    final file = _files.firstWhere(
      (file) => file.id == id,
      orElse: () => throw Exception('Fichier non trouvé avec ID: $id'),
    );
    
    // Simuler des données de fichier (octets aléatoires)
    final random = math.Random();
    return Uint8List.fromList(List.generate(file.size > 1024 ? 1024 : file.size, (_) => random.nextInt(256)));
  }
  
  @override
  Future<StorageFile> uploadFile({
    required String name,
    required String folderId,
    required Uint8List data,
    String? contentType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Trouver le dossier
    final folder = _folders.firstWhere(
      (folder) => folder.id == folderId,
      orElse: () => throw Exception('Dossier non trouvé avec ID: $folderId'),
    );
    
    // Extraire l'extension du nom de fichier
    final extension = name.contains('.')
        ? name.split('.').last.toLowerCase()
        : '';
    
    // Construire le chemin du fichier
    final path = folder.path == '/'
        ? '/$name'
        : '${folder.path}/$name';
    
    // Créer le nouveau fichier
    final newFile = StorageFile(
      id: 'file_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      path: path,
      extension: extension,
      size: data.length,
      type: FileType.fromExtension(extension),
      createdAt: DateTime.now(),
      isFavorite: false,
      isShared: false,
    );
    
    // Ajouter le fichier à la liste
    _files.add(newFile);
    
    return newFile;
  }
  
  @override
  Future<List<StorageItem>> searchItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final lowercaseQuery = query.toLowerCase();
    
    // Rechercher les dossiers
    final matchingFolders = _folders
        .where((folder) => folder.name.toLowerCase().contains(lowercaseQuery))
        .map((folder) => folder.toItem())
        .toList();
    
    // Rechercher les fichiers
    final matchingFiles = _files
        .where((file) => file.name.toLowerCase().contains(lowercaseQuery))
        .map((file) => file.toItem())
        .toList();
    
    // Combiner les résultats
    final results = [...matchingFolders, ...matchingFiles];
    results.sort((a, b) => a.name.compareTo(b.name));
    
    return results;
  }
  
  @override
  Future<List<StorageFile>> filterFilesByType(FileType type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _files.where((file) => file.type == type).toList();
  }
  
  @override
  Future<StorageStatistics> getStorageStatistics() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _statistics;
  }
  
  @override
  Future<Uint8List?> getFilePreview(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trouver le fichier
    final file = _files.firstWhere(
      (file) => file.id == id,
      orElse: () => throw Exception('Fichier non trouvé avec ID: $id'),
    );
    
    // Vérifier si le fichier peut être prévisualisé
    if (!file.isPreviewable) {
      return null;
    }
    
    // Simuler des données de prévisualisation (octets aléatoires)
    final random = math.Random();
    return Uint8List.fromList(List.generate(1024, (_) => random.nextInt(256)));
  }
  
  @override
  Future<List<StorageFolder>> getPathInfo(String folderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (folderId == 'root') {
      // Si c'est le dossier racine, renvoyer juste ce dossier
      return [_folders.firstWhere((folder) => folder.id == 'root')];
    }
    
    // Trouver le dossier
    final folder = _folders.firstWhere(
      (folder) => folder.id == folderId,
      orElse: () => throw Exception('Dossier non trouvé avec ID: $folderId'),
    );
    
    // Construire le chemin complet
    final List<StorageFolder> path = [];
    
    // Ajouter le dossier racine
    path.add(_folders.firstWhere((f) => f.id == 'root'));
    
    // Diviser le chemin en segments
    final pathSegments = folder.path.split('/').where((s) => s.isNotEmpty).toList();
    
    // Construire le chemin complet
    String currentPath = '';
    for (int i = 0; i < pathSegments.length; i++) {
      currentPath += '/${pathSegments[i]}';
      
      // Trouver le dossier correspondant à ce segment de chemin
      final matchingFolder = _folders.firstWhere(
        (f) => f.path == currentPath,
        orElse: () => throw Exception('Dossier non trouvé pour le chemin: $currentPath'),
      );
      
      path.add(matchingFolder);
    }
    
    return path;
  }
  
  @override
  Future<StorageFile> copyFile({
    required String id,
    required String destinationFolderId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trouver le fichier
    final file = _files.firstWhere(
      (file) => file.id == id,
      orElse: () => throw Exception('Fichier non trouvé avec ID: $id'),
    );
    
    // Trouver le dossier de destination
    final destinationFolder = _folders.firstWhere(
      (folder) => folder.id == destinationFolderId,
      orElse: () => throw Exception('Dossier de destination non trouvé avec ID: $destinationFolderId'),
    );
    
    final fileName = file.name;
    
    // Vérifier si un fichier avec le même nom existe déjà dans le dossier de destination
    final existingFiles = _files.where(
      (f) => f.path == (destinationFolder.path == '/' ? '/$fileName' : '${destinationFolder.path}/$fileName')
    ).toList();
    
    // Si un fichier avec le même nom existe, ajouter un suffixe
    String newFileName = fileName;
    if (existingFiles.isNotEmpty) {
      final nameWithoutExtension = fileName.contains('.')
          ? fileName.substring(0, fileName.lastIndexOf('.'))
          : fileName;
      final extension = fileName.contains('.')
          ? fileName.substring(fileName.lastIndexOf('.'))
          : '';
      
      newFileName = '$nameWithoutExtension - Copie$extension';
      
      // Vérifier si la copie existe déjà
      int copyNumber = 1;
      while (_files.any((f) => 
        f.path == (destinationFolder.path == '/' ? '/$newFileName' : '${destinationFolder.path}/$newFileName')
      )) {
        copyNumber++;
        newFileName = '$nameWithoutExtension - Copie $copyNumber$extension';
      }
    }
    
    // Construire le nouveau chemin
    final newPath = destinationFolder.path == '/'
        ? '/$newFileName'
        : '${destinationFolder.path}/$newFileName';
    
    // Créer la copie du fichier
    final newFile = StorageFile(
      id: 'file_${DateTime.now().millisecondsSinceEpoch}',
      name: newFileName,
      path: newPath,
      url: file.url,
      extension: file.extension,
      size: file.size,
      type: file.type,
      createdAt: DateTime.now(),
      thumbnail: file.thumbnail,
      isFavorite: false,
      isShared: false,
    );
    
    // Ajouter le fichier à la liste
    _files.add(newFile);
    
    return newFile;
  }
}
