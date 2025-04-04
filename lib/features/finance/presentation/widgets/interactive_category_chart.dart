import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';

/// Widget affichant un graphique en anneau interactif pour la répartition des transactions par catégorie
class InteractiveCategoryChart extends StatefulWidget {
  final Map<TransactionCategory, double> categoriesAmount;
  final TransactionType type;
  final double totalAmount;
  final Function(TransactionCategory)? onCategorySelected;
  final Widget Function(TransactionCategory, double, double)? categoryItemBuilder;
  
  const InteractiveCategoryChart({
    Key? key,
    required this.categoriesAmount,
    required this.type,
    required this.totalAmount,
    this.onCategorySelected,
    this.categoryItemBuilder,
  }) : super(key: key);
  
  @override
  State<InteractiveCategoryChart> createState() => _InteractiveCategoryChartState();
}

class _InteractiveCategoryChartState extends State<InteractiveCategoryChart> with SingleTickerProviderStateMixin {
  int? touchedIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showDetails = false;
  TransactionCategory? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final chartTitle = widget.type == TransactionType.income 
        ? 'Répartition des revenus' 
        : 'Répartition des dépenses';
    
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre avec icône d'information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chartTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 20),
                    onPressed: () {
                      _showChartInfo(context);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ],
              ),
              
              // Légende du total
              if (widget.totalAmount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Total: ${NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(widget.totalAmount)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              
              const SizedBox(height: 16.0),
              
              // Contenu principal (graphique ou détails)
              Expanded(
                child: widget.categoriesAmount.isEmpty
                    ? _buildEmptyState()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _showDetails && _selectedCategory != null
                            ? _buildCategoryDetails(_selectedCategory!)
                            : _buildMainChart(),
                      ),
              ),
              
              // Bouton pour revenir au graphique principal si nécessaire
              if (_showDetails && _selectedCategory != null)
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Retour au graphique'),
                  onPressed: () {
                    setState(() {
                      _showDetails = false;
                      _selectedCategory = null;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    minimumSize: const Size(0, 32),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit le graphique en anneau principal
  Widget _buildMainChart() {
    return Row(
      key: const ValueKey('mainChart'),
      children: [
        // Graphique en anneau
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    
                    if (touchedIndex != null && touchedIndex! >= 0 && event is FlTapUpEvent) {
                      final categories = widget.categoriesAmount.keys.toList();
                      if (touchedIndex! < categories.length) {
                        final selectedCategory = categories[touchedIndex!];
                        
                        if (widget.onCategorySelected != null) {
                          widget.onCategorySelected!(selectedCategory);
                        }
                        
                        setState(() {
                          _selectedCategory = selectedCategory;
                          _showDetails = true;
                        });
                      }
                    }
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _buildPieSections(),
            ),
          ),
        ),
        
        // Légende
        Expanded(
          flex: 2,
          child: _buildLegend(),
        ),
      ],
    );
  }
  
  /// Construit les sections du graphique en anneau
  List<PieChartSectionData> _buildPieSections() {
    final categories = widget.categoriesAmount.keys.toList();
    
    // Trier par montant (décroissant)
    categories.sort((a, b) => 
        widget.categoriesAmount[b]!.compareTo(widget.categoriesAmount[a]!));
    
    return List.generate(categories.length, (i) {
      final category = categories[i];
      final value = widget.categoriesAmount[category]!;
      final percentage = (value / widget.totalAmount) * 100;
      final isTouched = touchedIndex == i;
      final radius = isTouched ? 60.0 : 50.0;
      
      // Couleur basée sur le type de transaction et la catégorie
      final Color sectionColor = widget.type == TransactionType.income
          ? _getIncomeColor(category)
          : _getExpenseColor(category);
      
      return PieChartSectionData(
        color: sectionColor,
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? _buildCategoryIcon(category, sectionColor)
            : null,
        badgePositionPercentageOffset: 1.1,
      );
    });
  }
  
  /// Construit l'icône de catégorie pour l'affichage sur le graphique
  Widget _buildCategoryIcon(TransactionCategory category, Color color) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 16,
      child: Icon(
        _getCategoryIcon(category),
        color: color,
        size: 18,
      ),
    );
  }
  
  /// Construit la légende du graphique
  Widget _buildLegend() {
    final categories = widget.categoriesAmount.keys.toList();
    
    // Trier par montant (décroissant)
    categories.sort((a, b) => 
        widget.categoriesAmount[b]!.compareTo(widget.categoriesAmount[a]!));
    
    // Limiter à 6 catégories + "Autres" si nécessaire
    List<TransactionCategory> displayCategories;
    if (categories.length > 6) {
      displayCategories = categories.sublist(0, 5);
      
      // Calculer le reste
      final otherAmount = categories.sublist(5).fold(
        0.0,
        (sum, category) => sum + widget.categoriesAmount[category]!,
      );
      
      if (otherAmount > 0) {
        displayCategories.add(TransactionCategory.other_expense);
      }
    } else {
      displayCategories = categories;
    }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: displayCategories.map((category) {
          final isOther = categories.length > 6 && category == displayCategories.last;
          final amount = isOther 
              ? categories.sublist(5).fold(
                  0.0, 
                  (sum, cat) => sum + widget.categoriesAmount[cat]!
                )
              : widget.categoriesAmount[category]!;
          
          final percentage = (amount / widget.totalAmount) * 100;
          
          return _buildLegendItem(
            context,
            category: category,
            amount: amount,
            percentage: percentage,
            isOther: isOther,
          );
        }).toList(),
      ),
    );
  }
  
  /// Construit un élément de légende
  Widget _buildLegendItem(
    BuildContext context, {
    required TransactionCategory category,
    required double amount,
    required double percentage,
    bool isOther = false,
  }) {
    final Color itemColor = widget.type == TransactionType.income
        ? _getIncomeColor(category)
        : _getExpenseColor(category);
    
    return InkWell(
      onTap: () {
        if (widget.onCategorySelected != null) {
          widget.onCategorySelected!(category);
        }
        
        if (!isOther) {
          setState(() {
            _selectedCategory = category;
            _showDetails = true;
          });
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: itemColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOther ? 'Autres' : _getCategoryName(category),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        NumberFormat.compactCurrency(
                          locale: 'fr_FR',
                          symbol: '€',
                        ).format(amount),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: itemColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construit les détails d'une catégorie sélectionnée
  Widget _buildCategoryDetails(TransactionCategory category) {
    final amount = widget.categoriesAmount[category] ?? 0.0;
    final percentage = widget.totalAmount > 0 
        ? (amount / widget.totalAmount) * 100 
        : 0.0;
    
    // Utiliser le builder personnalisé si fourni
    if (widget.categoryItemBuilder != null) {
      return widget.categoryItemBuilder!(category, amount, percentage);
    }
    
    // Sinon, utiliser l'affichage par défaut
    return Center(
      key: const ValueKey('categoryDetails'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône et titre
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.type == TransactionType.income
                  ? _getIncomeColor(category).withOpacity(0.1)
                  : _getExpenseColor(category).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: widget.type == TransactionType.income
                  ? _getIncomeColor(category)
                  : _getExpenseColor(category),
              size: 36,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Nom de la catégorie
          Text(
            _getCategoryName(category),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Montant et pourcentage
          Text(
            NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(amount),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: widget.type == TransactionType.income
                  ? _getIncomeColor(category)
                  : _getExpenseColor(category),
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            '${percentage.toStringAsFixed(1)}% du total',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tips (à personnaliser selon la catégorie)
          _buildCategoryTip(category),
        ],
      ),
    );
  }
  
  /// Construit un conseil personnalisé selon la catégorie
  Widget _buildCategoryTip(TransactionCategory category) {
    String tipText;
    
    if (widget.type == TransactionType.income) {
      switch (category) {
        case TransactionCategory.salary:
          tipText = "Conseil: Envisagez d'automatiser un transfert vers votre épargne chaque mois à la réception de votre salaire.";
          break;
        case TransactionCategory.clientPayment:
          tipText = "Conseil: Suivez le délai de paiement moyen de vos clients pour mieux anticiper votre trésorerie.";
          break;
        case TransactionCategory.investment:
          tipText = "Conseil: Diversifiez vos sources de revenus d'investissement pour réduire les risques.";
          break;
        default:
          tipText = "Conseil: Analysez régulièrement vos différentes sources de revenus pour identifier des opportunités de croissance.";
      }
    } else {
      switch (category) {
        case TransactionCategory.rent:
        case TransactionCategory.utilities:
          tipText = "Conseil: Les charges fixes représentent une part importante de votre budget. Renégociez-les annuellement.";
          break;
        case TransactionCategory.marketing:
          tipText = "Conseil: Mesurez le ROI de vos dépenses marketing pour optimiser votre budget.";
          break;
        case TransactionCategory.tax:
          tipText = "Conseil: Consultez un comptable pour identifier les déductions fiscales possibles.";
          break;
        case TransactionCategory.subscription:
          tipText = "Conseil: Révisez régulièrement vos abonnements pour éliminer ceux que vous n'utilisez pas pleinement.";
          break;
        default:
          tipText = "Conseil: Comparez cette catégorie de dépenses d'un mois à l'autre pour identifier des tendances et opportunités d'économies.";
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.blue.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tipText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Affiche un état vide lorsqu'il n'y a pas de données
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            widget.type == TransactionType.income
                ? 'Aucun revenu à afficher'
                : 'Aucune dépense à afficher',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Affiche une boîte de dialogue d'information sur le graphique
  void _showChartInfo(BuildContext context) {
    final String title = widget.type == TransactionType.income
        ? 'Répartition des revenus'
        : 'Répartition des dépenses';
    
    final String description = widget.type == TransactionType.income
        ? 'Ce graphique montre la répartition de vos revenus par catégorie. Touchez une section pour voir plus de détails.'
        : 'Ce graphique montre la répartition de vos dépenses par catégorie. Touchez une section pour voir plus de détails.';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 16),
            const Text(
              'Interaction:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Touchez une section du graphique ou un élément de la légende pour voir les détails'),
            const SizedBox(height: 8),
            const Text('• Le pourcentage indique la part de chaque catégorie dans le total'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
  
  /// Renvoie la couleur pour une catégorie de revenus
  Color _getIncomeColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.salary:
        return Colors.green.shade600;
      case TransactionCategory.clientPayment:
        return Colors.teal.shade500;
      case TransactionCategory.investment:
        return Colors.blue.shade600;
      case TransactionCategory.sale:
        return Colors.purple.shade400;
      default:
        return Colors.amber.shade600;
    }
  }
  
  /// Renvoie la couleur pour une catégorie de dépenses
  Color _getExpenseColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.rent:
      case TransactionCategory.utilities:
        return Colors.red.shade500;
      case TransactionCategory.equipment:
        return Colors.orange.shade600;
      case TransactionCategory.marketing:
        return Colors.purple.shade400;
      case TransactionCategory.software:
        return Colors.blue.shade500;
      case TransactionCategory.travel:
        return Colors.teal.shade500;
      case TransactionCategory.food:
        return Colors.amber.shade600;
      case TransactionCategory.tax:
        return Colors.brown.shade500;
      case TransactionCategory.insurance:
        return Colors.indigo.shade400;
      case TransactionCategory.subscription:
        return Colors.pink.shade400;
      default:
        return Colors.grey.shade500;
    }
  }
  
  /// Renvoie l'icône pour une catégorie
  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.salary:
        return Icons.account_balance_wallet;
      case TransactionCategory.clientPayment:
        return Icons.payments;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.sale:
        return Icons.shopping_cart;
      case TransactionCategory.rent:
        return Icons.home;
      case TransactionCategory.utilities:
        return Icons.power;
      case TransactionCategory.equipment:
        return Icons.computer;
      case TransactionCategory.software:
        return Icons.code;
      case TransactionCategory.marketing:
        return Icons.campaign;
      case TransactionCategory.travel:
        return Icons.flight;
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.tax:
        return Icons.account_balance;
      case TransactionCategory.insurance:
        return Icons.health_and_safety;
      case TransactionCategory.subscription:
        return Icons.subscriptions;
      default:
        return Icons.category;
    }
  }
  
  /// Renvoie le nom localisé d'une catégorie
  String _getCategoryName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.salary:
        return 'Salaire';
      case TransactionCategory.clientPayment:
        return 'Paiement client';
      case TransactionCategory.investment:
        return 'Investissement';
      case TransactionCategory.sale:
        return 'Vente';
      case TransactionCategory.rent:
        return 'Loyer';
      case TransactionCategory.utilities:
        return 'Services';
      case TransactionCategory.equipment:
        return 'Équipement';
      case TransactionCategory.software:
        return 'Logiciels';
      case TransactionCategory.marketing:
        return 'Marketing';
      case TransactionCategory.travel:
        return 'Voyages';
      case TransactionCategory.food:
        return 'Alimentation';
      case TransactionCategory.tax:
        return 'Impôts';
      case TransactionCategory.insurance:
        return 'Assurance';
      case TransactionCategory.subscription:
        return 'Abonnements';
      case TransactionCategory.miscellaneous:
        return 'Divers';
      case TransactionCategory.other:
        return 'Autres revenus';
      default:
        return 'Autres dépenses';
    }
  }
}