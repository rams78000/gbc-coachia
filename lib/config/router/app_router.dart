import 'package:flutter/material.dart';

/// App routes
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String chatbot = '/chatbot';
  static const String planner = '/planner';
  static const String finance = '/finance';
  static const String documents = '/documents';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
}

/// App router configuration
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Splash Screen Placeholder')),
          ),
        );
        
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Onboarding Screen Placeholder')),
          ),
        );
        
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Login Screen Placeholder')),
          ),
        );
        
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Register Screen Placeholder')),
          ),
        );
        
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Forgot Password Screen Placeholder')),
          ),
        );
        
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Home Screen Placeholder')),
          ),
        );
        
      case AppRoutes.chatbot:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Chatbot Screen Placeholder')),
          ),
        );
        
      case AppRoutes.planner:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Planner Screen Placeholder')),
          ),
        );
        
      case AppRoutes.finance:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Finance Screen Placeholder')),
          ),
        );
        
      case AppRoutes.documents:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Documents Screen Placeholder')),
          ),
        );
        
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Profile Screen Placeholder')),
          ),
        );
        
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Settings Screen Placeholder')),
          ),
        );
        
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Notifications Screen Placeholder')),
          ),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
