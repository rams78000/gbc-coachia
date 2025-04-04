import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Initialise les paramètres de localisation pour l'application
Future<void> initializeLocale() async {
  // Initialiser les données de localisation pour le français
  await initializeDateFormatting('fr_FR', null);
}
