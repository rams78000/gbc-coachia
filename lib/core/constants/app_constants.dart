import 'package:flutter/material.dart';

/// App constants
class AppConstants {
  /// App name
  static const String appName = 'GBC CoachIA';
  
  /// App version
  static const String appVersion = '1.0.0';
  
  /// API URL
  static const String apiUrl = 'https://api.gbccoachia.com';
  
  /// Shared preferences keys
  static const String prefThemeMode = 'theme_mode';
  static const String prefAuthToken = 'auth_token';
  static const String prefUserId = 'user_id';
  static const String prefUserName = 'user_name';
  static const String prefUserEmail = 'user_email';
  static const String prefUserAvatar = 'user_avatar';
  static const String prefOnboardingCompleted = 'onboarding_completed';
  
  /// Hive box names
  static const String boxSettings = 'settings';
  static const String boxUser = 'user';
  static const String boxConversations = 'conversations';
  static const String boxTasks = 'tasks';
  static const String boxTransactions = 'transactions';
  static const String boxAccounts = 'accounts';
  static const String boxCategories = 'categories';
  
  /// Default spacing
  static const double spacingXXS = 4.0;
  static const double spacingXS = 8.0;
  static const double spacingS = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  /// Default radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  
  /// Default elevation
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;
  
  /// Default duration
  static const Duration durationXS = Duration(milliseconds: 100);
  static const Duration durationS = Duration(milliseconds: 200);
  static const Duration durationM = Duration(milliseconds: 300);
  static const Duration durationL = Duration(milliseconds: 500);
  static const Duration durationXL = Duration(milliseconds: 800);
  
  /// Default animation curve
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveFast = Curves.fastOutSlowIn;
  static const Curve curveElastic = Curves.elasticInOut;
  static const Curve curveBounce = Curves.bounceInOut;
}
