import 'package:flutter/material.dart';
import 'dart:convert';

import '../../domain/entities/message.dart';

class FunctionResultMessage extends StatelessWidget {
  final Message message;
  
  const FunctionResultMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Tenter de déterminer si le message contient un résultat de fonction
    try {
      final Map<String, dynamic> functionResult = jsonDecode(message.content);
      if (functionResult.containsKey('function_name') && 
          functionResult.containsKey('arguments') &&
          functionResult.containsKey('explanation')) {
        
        // Afficher le résultat de l'appel de fonction
        return _buildFunctionResultCard(functionResult, theme);
      }
    } catch (e) {
      // Si le contenu n'est pas un JSON valide ou ne contient pas de résultat de fonction,
      // nous afficherons simplement le contenu du message normal
    }
    
    // Vérifier si le contenu contient un résultat formaté (du texte qui semble être un résultat de fonction)
    if (message.content.contains('ajouté avec succès:') || 
        message.content.contains('Résumé financier') ||
        message.content.contains('Événements à venir') ||
        message.content.contains('Résultats de la recherche') ||
        message.content.contains('Aperçu')) {
      
      return _buildFormattedResultCard(message.content, theme);
    }
    
    // Sinon, il s'agit d'un message texte normal
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message.content),
      ),
    );
  }

  Widget _buildFunctionResultCard(Map<String, dynamic> functionResult, ThemeData theme) {
    final functionName = functionResult['function_name'];
    final arguments = functionResult['arguments'];
    final explanation = functionResult['explanation'];
    
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec le nom de la fonction
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getFunctionIcon(functionName),
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getFunctionTitle(functionName),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Explication
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(explanation),
          ),
          
          // Détails de l'action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Détails de l\'action:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _buildArgumentsList(arguments),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFormattedResultCard(String content, ThemeData theme) {
    // Déterminer le type de résultat pour personnaliser l'affichage
    IconData icon;
    String title;
    Color bgColor;
    
    if (content.contains('ajouté avec succès')) {
      icon = Icons.check_circle;
      title = 'Succès';
      bgColor = Colors.green.withOpacity(0.1);
    } else if (content.contains('Résumé financier')) {
      icon = Icons.account_balance_wallet;
      title = 'Résumé Financier';
      bgColor = Colors.blue.withOpacity(0.1);
    } else if (content.contains('Événements à venir')) {
      icon = Icons.event;
      title = 'Calendrier';
      bgColor = Colors.orange.withOpacity(0.1);
    } else if (content.contains('Résultats de la recherche')) {
      icon = Icons.search;
      title = 'Recherche';
      bgColor = Colors.purple.withOpacity(0.1);
    } else if (content.contains('Aperçu')) {
      icon = Icons.analytics;
      title = 'Analyse';
      bgColor = Colors.teal.withOpacity(0.1);
    } else {
      icon = Icons.info;
      title = 'Information';
      bgColor = Colors.grey.withOpacity(0.1);
    }
    
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Contenu formaté
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: const TextStyle(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArgumentsList(dynamic arguments) {
    if (arguments is! Map<String, dynamic>) {
      return const Text('Arguments non disponibles');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: arguments.entries.map<Widget>((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${entry.key}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: entry.value.toString(),
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getFunctionIcon(String functionName) {
    switch (functionName) {
      case 'getFinancialSummary':
        return Icons.account_balance_wallet;
      case 'createTransaction':
        return Icons.add_card;
      case 'getUpcomingEvents':
        return Icons.event;
      case 'createEvent':
        return Icons.event_available;
      case 'searchDocuments':
        return Icons.search;
      case 'getBusinessInsights':
        return Icons.analytics;
      default:
        return Icons.code;
    }
  }

  String _getFunctionTitle(String functionName) {
    switch (functionName) {
      case 'getFinancialSummary':
        return 'Résumé Financier';
      case 'createTransaction':
        return 'Nouvelle Transaction';
      case 'getUpcomingEvents':
        return 'Événements à venir';
      case 'createEvent':
        return 'Nouvel Événement';
      case 'searchDocuments':
        return 'Recherche de Documents';
      case 'getBusinessInsights':
        return 'Analyse Business';
      default:
        return functionName;
    }
  }
}
