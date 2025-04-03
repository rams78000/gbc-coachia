import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'config/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize dependencies
  await initDependencies();
  
  runApp(const App());
}
