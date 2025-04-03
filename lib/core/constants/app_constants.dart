/// Application-wide constants
class AppConstants {
  // API URLs
  static const String baseApiUrl = 'https://api.example.com';
  static const String aiEndpoint = '$baseApiUrl/ai';
  
  // App Info
  static const String appName = 'GBC CoachIA';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your AI business coach for entrepreneurs and freelancers';
  
  // Feature Constants
  static const int maxConversations = 10; // Max number of conversations for free tier
  static const int maxTasksPerDay = 10; // Max tasks per day for free tier
  static const int maxDocumentsPerMonth = 5; // Max documents for free tier
  
  // Error Messages
  static const String generalErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String authErrorMessage = 'Authentication error. Please log in again.';
  
  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeModeKey = 'theme_mode';
  static const String onboardingCompletedKey = 'onboarding_completed';
  
  // Animations
  static const int animationDurationShort = 200; // milliseconds
  static const int animationDurationMedium = 350; // milliseconds
  static const int animationDurationLong = 500; // milliseconds
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableAIFeatures = true;
  static const bool enableAnalytics = true;
  static const bool enableFinanceFeatures = true;
  static const bool enableNotifications = true;
  
  // Default configuration
  static const List<String> defaultCategories = [
    'Business',
    'Marketing',
    'Finance',
    'Legal',
    'Operations',
    'Strategy',
    'Sales',
    'Other',
  ];
  
  static const Map<String, String> documentTypes = {
    'business_plan': 'Business Plan',
    'marketing_plan': 'Marketing Plan',
    'financial_projection': 'Financial Projection',
    'pitch_deck': 'Pitch Deck',
    'sales_proposal': 'Sales Proposal',
    'invoice': 'Invoice',
    'contract': 'Contract',
  };
}
