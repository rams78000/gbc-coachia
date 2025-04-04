import 'package:flutter/material.dart';
import 'package:gbc_coachia/preview/app_previewer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Générer toutes les prévisualisations
  await AppPreviewer.generateAllPreviews();
}
