import 'package:get_it/get_it.dart';

class ServiceLocator {
  static final GetIt _instance = GetIt.instance;

  static Future<void> init() async {
    // Enregistrer les services et repositories ici
  }
}
