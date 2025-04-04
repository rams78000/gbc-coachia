import 'package:flutter/material.dart';
import 'app.dart';
import 'config/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les services et dépendances
  await initServiceLocator();
  
  runApp(const GBCCoachIAApp());
}
