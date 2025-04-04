import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

/// Widget pour afficher l'aperçu du contenu d'un document
class DocumentPreview extends StatefulWidget {
  final Document document;
  final bool showJsonView;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  const DocumentPreview({
    Key? key,
    required this.document,
    this.showJsonView = false,
    this.onDownload,
    this.onShare,
  }) : super(key: key);

  @override
  State<DocumentPreview> createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview> {
  bool _showJson = false;
  
  @override
  void initState() {
    super.initState();
    _showJson = widget.showJsonView;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre d'outils
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              // Bouton pour basculer entre l'aperçu et le JSON
              ToggleButtons(
                isSelected: [!_showJson, _showJson],
                onPressed: (index) {
                  setState(() {
                    _showJson = index == 1;
                  });
                },
                borderRadius: BorderRadius.circular(8.0),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Aperçu'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('JSON'),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Bouton de téléchargement
              if (widget.onDownload != null)
                IconButton(
                  onPressed: widget.onDownload,
                  icon: const Icon(Icons.download),
                  tooltip: 'Télécharger',
                ),
              
              // Bouton de partage
              if (widget.onShare != null)
                IconButton(
                  onPressed: widget.onShare,
                  icon: const Icon(Icons.share),
                  tooltip: 'Partager',
                ),
            ],
          ),
        ),
        
        // Contenu du document
        Expanded(
          child: _showJson ? _buildJsonView() : _buildPreview(),
        ),
      ],
    );
  }

  // Construit l'aperçu formaté du document
  Widget _buildPreview() {
    // Si le contenu est vide, afficher un message
    if (widget.document.content.isEmpty) {
      return const Center(
        child: Text('Aucun contenu disponible'),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du document
          Text(
            widget.document.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24.0),
          
          // Contenu du document (formaté en HTML ou markdown)
          // Pour l'instant, on affiche simplement le texte brut
          Text(widget.document.content),
        ],
      ),
    );
  }

  // Construit la vue JSON du document
  Widget _buildJsonView() {
    try {
      // Convertir le contenu en objet JSON
      final dynamic jsonObject = widget.document.content.isNotEmpty
          ? json.decode(widget.document.content)
          : {};
      
      // Formater le JSON pour l'affichage
      final JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      final String prettyJson = encoder.convert(jsonObject);
      
      return Container(
        color: Colors.grey.shade900,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SelectableText(
            prettyJson,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.green,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    } catch (e) {
      // En cas d'erreur de parsing JSON
      return Center(
        child: Text(
          'Erreur de format JSON: ${e.toString()}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
