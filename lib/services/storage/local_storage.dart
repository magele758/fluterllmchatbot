import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../models/user.dart';

/// Handles local storage operations using SharedPreferences and FlutterSecureStorage
class LocalStorage {
  static SharedPreferences? _preferences;
  static const _secureStorage = FlutterSecureStorage();

  /// Initialize the local storage
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save auth token to secure storage
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  /// Get auth token from secure storage
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  /// Clear the auth token
  static Future<void> clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  /// Save user data to shared preferences
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _preferences?.setString(AppConfig.userProfileKey, jsonEncode(userData));
  }

  /// Get user data from shared preferences
  static Future<Map<String, dynamic>?> getUserData() async {
    final userData = _preferences?.getString(AppConfig.userProfileKey);
    if (userData == null) return null;
    return jsonDecode(userData) as Map<String, dynamic>;
  }

  /// Clear user data from shared preferences
  static Future<void> clearUserData() async {
    await _preferences?.remove(AppConfig.userProfileKey);
    await clearToken();
  }

  /// Save conversation to shared preferences
  static Future<void> saveConversation(String id, String conversationJson) async {
    await _preferences?.setString('${AppConfig.conversationsKey}_$id', conversationJson);
  }

  /// Get conversation from shared preferences
  static Future<String?> getConversation(String id) async {
    return _preferences?.getString('${AppConfig.conversationsKey}_$id');
  }

  /// Save list of AI models to shared preferences
  static Future<void> saveModels(String modelsJson) async {
    await _preferences?.setString(AppConfig.modelsKey, modelsJson);
  }

  /// Get list of AI models from shared preferences
  static Future<String?> getModels() async {
    return _preferences?.getString(AppConfig.modelsKey);
  }

  /// Save selected model ID to shared preferences
  static Future<void> saveSelectedModelId(String modelId) async {
    await _preferences?.setString('selected_model_id', modelId);
  }

  /// Get selected model ID from shared preferences
  static Future<String?> getSelectedModelId() async {
    return _preferences?.getString('selected_model_id');
  }

  /// Save deep thinking enabled setting to shared preferences
  static Future<void> saveDeepThinkingEnabled(bool enabled) async {
    await _preferences?.setBool('deep_thinking_enabled', enabled);
  }

  /// Get deep thinking enabled setting from shared preferences
  static Future<bool?> getDeepThinkingEnabled() async {
    return _preferences?.getBool('deep_thinking_enabled');
  }

  /// Save use cloud storage setting to shared preferences
  static Future<void> saveUseCloudStorage(bool enabled) async {
    await _preferences?.setBool('use_cloud_storage', enabled);
  }

  /// Get use cloud storage setting from shared preferences
  static Future<bool?> getUseCloudStorage() async {
    return _preferences?.getBool('use_cloud_storage');
  }

  /// Save theme mode to shared preferences
  static Future<void> saveThemeMode(String mode) async {
    await _preferences?.setString('theme_mode', mode);
  }

  /// Get theme mode from shared preferences
  static Future<String?> getThemeMode() async {
    return _preferences?.getString('theme_mode');
  }
}
