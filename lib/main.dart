import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  // Capture les erreurs non gérées
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const App());
  }, (error, stack) {
    // Capture les erreurs non gérées
    debugPrint('Erreur non gérée: $error');
    debugPrint('Stack trace: $stack');
  });
}
