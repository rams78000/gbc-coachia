import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';

/// Carte représentant un modèle de document
class TemplateCard extends StatelessWidget {
  final DocumentTemplate template;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TemplateCard({
    Key? key,
    required this.template,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            // En-tête avec couleur selon le type
            Container(
              color: Color(template.type.color).withOpacity(0.2),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.description,
                    color: Color(template.type.color),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      template.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildPopupMenu(context),
                ],
              ),
            ),
            
            // Contenu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (template.description.isNotEmpty) ...[
                    Text(
                      template.description,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  
                  // Nombre de champs
                  Row(
                    children: [
                      const Icon(
                        Icons.list_alt,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${template.fields.length} champ${template.fields.length > 1 ? 's' : ''}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8.0),
                  
                  // Type de document
                  Row(
                    children: [
                      Icon(
                        Icons.label,
                        size: 16.0,
                        color: Color(template.type.color),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        template.type.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Color(template.type.color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bouton d'action
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(template.type.color),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Utiliser ce modèle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construit le menu popup
  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8.0),
              Text('Modifier'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              const SizedBox(width: 8.0),
              const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
