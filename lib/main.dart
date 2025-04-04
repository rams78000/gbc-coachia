import 'package:flutter/material.dart';
import 'package:gbc_coachia/app.dart';
import 'package:gbc_coachia/config/di/service_locator.dart';

void main() async {
  // Initialiser le framework Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser le localisateur de services
  setupServiceLocator();
  
  // Lancer l'application
  runApp(const App());
}
