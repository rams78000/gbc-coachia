import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'config/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verrouiller l'orientation en mode portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurer le service locator
  await setupServiceLocator();

  runApp(const App());
}
