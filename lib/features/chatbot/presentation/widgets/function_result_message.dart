import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message.dart';

/// Widget pour afficher des résultats de fonction dans les messages
/// Par exemple, afficher des synthèses financières, des événements, etc.
class FunctionResultMessage extends StatelessWidget {
  final Message message;

  const FunctionResultMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estimation du type de contenu pour la mise en forme
          _buildFormattedContent(context, theme),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.smart_toy,
                size: 12,
                color: Color(0xFFB87333),
              ),
              const SizedBox(width: 4),
              Text(
                'GBC CoachIA',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFB87333),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormattedContent(BuildContext context, ThemeData theme) {
    // Vérifier si le contenu est formaté comme un résultat de fonction
    if (_containsTableFormat(message.content)) {
      return _buildTableContent(context, theme);
    } else if (_containsListFormat(message.content)) {
      return _buildListContent(context, theme);
    } else if (_containsFinancialData(message.content)) {
      return _buildFinancialContent(context, theme);
    } else {
      return Text(
        message.content,
        style: theme.textTheme.bodyMedium,
      );
    }
  }
  
  bool _containsTableFormat(String content) {
    // Recherche de formats de table (lignes avec plusieurs | )
    return content.contains('|') && 
           content.split('\n').where((line) => line.contains('|') && line.split('|').length > 2).length > 1;
  }
  
  bool _containsListFormat(String content) {
    // Recherche de listes avec tirets ou numéros
    final lines = content.split('\n');
    int listItems = 0;
    
    for (var line in lines) {
      if (line.trim().startsWith('- ') || line.trim().startsWith('* ') || 
          RegExp(r'^\d+\.\s').hasMatch(line.trim())) {
        listItems++;
      }
    }
    
    return listItems >= 3; // Au moins 3 éléments de liste pour considérer comme une liste formatée
  }
  
  bool _containsFinancialData(String content) {
    // Recherche d'indicateurs financiers (montants, pourcentages)
    return RegExp(r'(\d+[,.]\d+\s*€)|(\d+\s*€)|(€\s*\d+)|(Solde)|(Revenus?)|(Dépenses?)').hasMatch(content);
  }
  
  Widget _buildTableContent(BuildContext context, ThemeData theme) {
    final lines = message.content.split('\n');
    final tableLines = lines.where((line) => line.contains('|')).toList();
    
    // Extraction de l'en-tête et des lignes du tableau
    final headers = tableLines.isNotEmpty 
        ? tableLines[0].split('|').map((h) => h.trim()).where((h) => h.isNotEmpty).toList()
        : [];
    
    // Ignorer la ligne de séparation (------|------|-----)
    final dataRows = tableLines.length > 2 
        ? tableLines.sublist(2)
        : tableLines.length > 1 ? tableLines.sublist(1) : [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre ou description avant le tableau
        if (lines.isNotEmpty && !lines[0].contains('|'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              lines[0],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB87333),
              ),
            ),
          ),
        
        // Tableau
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // En-tête
              if (headers.isNotEmpty)
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: headers.map((header) => 
                      Expanded(
                        child: Text(
                          header,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ).toList(),
                  ),
                ),
              
              // Lignes de données
              ...dataRows.map((row) {
                final cells = row.split('|')
                    .map((c) => c.trim())
                    .where((c) => c.isNotEmpty)
                    .toList();
                
                return Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: cells.map((cell) => 
                      Expanded(child: Text(cell))
                    ).toList(),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        
        // Texte après le tableau
        if (lines.length > tableLines.length)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              lines.sublist(tableLines.length + 1).join('\n'),
              style: theme.textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
  
  Widget _buildListContent(BuildContext context, ThemeData theme) {
    final lines = message.content.split('\n');
    
    // Trouver le titre (première ligne non-liste)
    String title = '';
    int contentStartIndex = 0;
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty && 
          !line.startsWith('- ') && 
          !line.startsWith('* ') && 
          !RegExp(r'^\d+\.\s').hasMatch(line)) {
        title = line;
        contentStartIndex = i + 1;
        break;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB87333),
              ),
            ),
          ),
        
        ...lines.sublist(contentStartIndex).map((line) {
          final trimmedLine = line.trim();
          if (trimmedLine.startsWith('- ') || trimmedLine.startsWith('* ')) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      trimmedLine.substring(2),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          } else if (RegExp(r'^\d+\.\s').hasMatch(trimmedLine)) {
            final match = RegExp(r'(\d+\.\s)(.*)').firstMatch(trimmedLine);
            if (match != null) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.group(1)!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        match.group(2)!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }
          } 
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(line, style: theme.textTheme.bodyMedium),
          );
        }).toList(),
      ],
    );
  }
  
  Widget _buildFinancialContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.green[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Résumé Financier',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _formatFinancialData(context, theme),
      ],
    );
  }
  
  Widget _formatFinancialData(BuildContext context, ThemeData theme) {
    final lines = message.content.split('\n');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        // Formater les lignes contenant des montants
        if (RegExp(r'(Revenus|Dépenses|Solde|Balance|Total)').hasMatch(line)) {
          final parts = line.split(':');
          if (parts.length > 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    parts[0].trim() + ':',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    parts[1].trim(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getAmountColor(parts[0].trim(), parts[1].trim()),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(line, style: theme.textTheme.bodyMedium),
        );
      }).toList(),
    );
  }
  
  Color _getAmountColor(String label, String amount) {
    if (label.contains('Revenus') || label.contains('Solde positif')) {
      return Colors.green[700]!;
    } else if (label.contains('Dépenses') || label.contains('Solde négatif')) {
      return Colors.red[700]!;
    } else {
      return Colors.blueGrey[700]!;
    }
  }
}