import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbc_coachia/app.dart';
import 'package:gbc_coachia/config/di/service_locator.dart';

void main() async {
  // Assurer que les widgets sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Configurer l'orientation de l'application (portrait uniquement pour mobile)
  // Vérifier si nous sommes sur le web pour éviter les erreurs avec l'orientation
  bool isMobile = !(const bool.fromEnvironment('dart.library.js'));
  if (isMobile) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Initialiser les dépendances
  await initDependencies();

  // Démarrer l'application
  runApp(const App());
}
