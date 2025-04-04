import 'package:flutter/material.dart';

import 'app.dart';
import 'config/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser le service locator
  await setupServiceLocator();
  
  runApp(const App());
}
