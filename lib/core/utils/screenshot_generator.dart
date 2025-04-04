import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

/// Classe utilitaire pour générer des captures d'écran des widgets Flutter
class ScreenshotGenerator {
  /// Capture un widget et le sauvegarde dans le dossier de prévisualisation
  static Future<String> captureWidget({
    required Widget widget,
    required String fileName,
    Size size = const Size(390, 844),  // Taille iPhone 13 comme référence
  }) async {
    // Créer un RenderRepaintBoundary
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();
    
    // Créer un pipeline de rendu
    final BuildContext? context = WidgetsBinding.instance.renderViewElement;
    if (context == null) {
      return 'Erreur: Aucun contexte disponible';
    }
    
    // Créer une vue qui permet de capturer un widget
    final RenderView renderView = RenderView(
      view: WidgetsBinding.instance.platformDispatcher.views.first,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: boundary,
      ),
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: 2.0,
      ),
    );
    
    try {
      // Configurer le pipeline de rendu et mettre à jour la disposition
      final PipelineOwner pipelineOwner = PipelineOwner();
      final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
      
      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();
      
      // Construire l'élément pour notre widget
      final RenderObjectToWidgetElement<RenderBox> rootElement = 
          RenderObjectToWidgetAdapter<RenderBox>(
        container: boundary,
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: Material(
            color: Colors.white,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: widget,
            ),
          ),
        ),
      ).attachToRenderTree(buildOwner);
      
      // Disposer la mise en page
      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();
      
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();
      
      // Capturer comme image
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        return 'Erreur: Impossible de convertir l\'image';
      }
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      // Sauvegarder l'image
      final String path = await _savePngFile(pngBytes, fileName);
      return path;
    } catch (e) {
      return 'Erreur de capture: $e';
    }
  }
  
  /// Sauvegarde une image PNG dans le dossier de prévisualisation
  static Future<String> _savePngFile(Uint8List bytes, String fileName) async {
    try {
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String previewDir = '$dir/../../preview/screenshots';
      
      // Créer le dossier s'il n'existe pas
      final Directory directory = Directory(previewDir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      final String path = '$previewDir/$fileName.png';
      final File file = File(path);
      await file.writeAsBytes(bytes);
      
      return path;
    } catch (e) {
      return 'Erreur de sauvegarde: $e';
    }
  }
}
