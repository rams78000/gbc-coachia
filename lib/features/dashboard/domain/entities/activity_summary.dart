/// Résumé des activités de l'utilisateur
class ActivitySummary {
  final int totalEvents;
  final int completedEvents;
  final int totalDocuments;
  final int totalTransactions;
  final double completionRate;

  const ActivitySummary({
    required this.totalEvents,
    required this.completedEvents,
    required this.totalDocuments,
    required this.totalTransactions,
    required this.completionRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalEvents': totalEvents,
      'completedEvents': completedEvents,
      'totalDocuments': totalDocuments,
      'totalTransactions': totalTransactions,
      'completionRate': completionRate,
    };
  }

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      totalEvents: json['totalEvents'],
      completedEvents: json['completedEvents'],
      totalDocuments: json['totalDocuments'],
      totalTransactions: json['totalTransactions'],
      completionRate: json['completionRate'],
    );
  }
}
