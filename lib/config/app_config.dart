import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Global application configuration with environment variables and constants
class AppConfig {
  AppConfig._(); // Private constructor to prevent instantiation

  // App information
  static const String appName = 'AI Assistant';
  static const String appVersion = '1.0.0';

  // Default model provider configuration
  static const String defaultModelName = 'GPT-3.5-Turbo';
  static const String defaultModelProvider = 'OpenAI';
  static const bool defaultMultimodalSupport = false;

  // Storage keys for settings
  static const String settingsKey = 'app_settings';
  static const String modelsKey = 'ai_models';
  static const String conversationsKey = 'conversations';
  static const String userProfileKey = 'user_profile';

  // API request defaults
  static const int defaultTimeout = 30; // seconds
  static const int maxRetries = 3;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Content limits
  static const int maxMessageLength = 4000;
  static const int maxConversationLength = 100; // messages

  // File storage paths
  static const String imageSavePath = 'images';
  static const String audioSavePath = 'audio';
  static const String videoSavePath = 'video';
}