import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';

/// Widget pour afficher un modèle de document sous forme de carte
class DocumentTemplateCard extends StatelessWidget {
  final DocumentTemplate template;
  final VoidCallback onTap;
  
  const DocumentTemplateCard({
    Key? key,
    required this.template,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec la couleur du type de document
            Container(
              height: 8.0,
              decoration: BoxDecoration(
                color: template.type.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icône et type
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: template.type.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          template.type.icon,
                          color: template.type.color,
                          size: 24.0,
                        ),
                      ),
                      
                      const SizedBox(width: 12.0),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              template.type.displayName,
                              style: TextStyle(
                                color: template.type.color,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (template.isDefault)
                        Tooltip(
                          message: 'Modèle par défaut',
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14.0,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  'Défaut',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Description
                  Text(
                    template.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Informations sur les sections et champs
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.category,
                        '${template.sections.length} section${template.sections.length > 1 ? 's' : ''}',
                      ),
                      
                      const SizedBox(width: 8.0),
                      
                      _buildInfoChip(
                        context,
                        Icons.input,
                        '${_countFields(template)} champ${_countFields(template) > 1 ? 's' : ''}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bouton d'action
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: template.type.color,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text('Utiliser ce modèle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Compte le nombre total de champs dans toutes les sections
  int _countFields(DocumentTemplate template) {
    int count = 0;
    for (final section in template.sections) {
      count += section.fields.length;
    }
    return count;
  }
  
  // Construit une puce d'information
  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.0,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
