import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/ai_model.dart';
import '../config/app_config.dart';
import '../config/default_config.dart';
import '../services/storage/local_storage.dart';

/// Provider for managing application settings and AI model configurations
class SettingsProvider extends ChangeNotifier {
  /// List of configured AI models
  List<AIModel> _models = [];

  /// Currently selected AI model ID
  String? _selectedModelId;

  /// Whether deep thinking mode is enabled
  bool _deepThinkingEnabled = false;

  /// Whether to use cloud storage
  bool _useCloudStorage = false;

  /// Theme mode for the app
  ThemeMode _themeMode = ThemeMode.system;

  /// Get all configured models
  List<AIModel> get models => _models;

  /// Get the currently selected model
  AIModel? get selectedModel => _selectedModelId != null
      ? _models.firstWhere((m) => m.id == _selectedModelId, orElse: () => _models.first)
      : _models.isEmpty ? null : _models.first;

  /// Check if deep thinking is enabled
  bool get deepThinkingEnabled => _deepThinkingEnabled;

  /// Check if cloud storage is enabled
  bool get useCloudStorage => _useCloudStorage;

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Constructor initializes settings from storage
  SettingsProvider() {
    _loadSettings();
  }

  /// Load settings from local storage
  Future<void> _loadSettings() async {
    try {
      // Load models
      final modelsData = await LocalStorage.getModels();
      if (modelsData != null) {
        _models = (jsonDecode(modelsData) as List)
            .map((modelJson) => AIModel.fromJson(modelJson))
            .toList();
      }

      // Load selected model ID
      final selectedId = await LocalStorage.getSelectedModelId();
      _selectedModelId = selectedId;

      // Load deep thinking setting
      final deepThinking = await LocalStorage.getDeepThinkingEnabled();
      _deepThinkingEnabled = deepThinking ?? false;

      // Load cloud storage setting
      final cloudStorage = await LocalStorage.getUseCloudStorage();
      _useCloudStorage = cloudStorage ?? false;

      // Load theme mode
      final themeModeString = await LocalStorage.getThemeMode();
      if (themeModeString != null) {
        switch (themeModeString) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          default:
            _themeMode = ThemeMode.system;
        }
      }

      // Create default model if none exists
      if (_models.isEmpty) {
        await addDefaultModel();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  /// Add a default model for first-time users
  Future<void> addDefaultModel() async {
    // 默认添加DMXAPI的预设模型
    await addPredefinedModel('dmxapi-gpt4o-mini');

    // 也可以添加其他预设模型
    if (_models.isEmpty) {
      // 如果添加预设模型失败，使用硬编码的默认值
      final defaultModel = AIModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: AppConfig.defaultModelName,
        provider: AppConfig.defaultModelProvider,
        apiEndpoint: 'https://api.openai.com/v1/chat/completions',
        apiKey: 'YOUR_API_KEY_HERE',
        supportsMultimodal: AppConfig.defaultMultimodalSupport,
        capabilities: [AICapability.text, AICapability.image],
        isSelected: true,
      );

      _models.add(defaultModel);
      _selectedModelId = defaultModel.id;
    }

    await saveModels();
  }

  /// 添加预定义模型
  Future<bool> addPredefinedModel(String modelKey) async {
    try {
      if (DefaultConfig.predefinedModels.containsKey(modelKey)) {
        final modelConfig = DefaultConfig.predefinedModels[modelKey]!;

        // 创建能力列表
        final List<AICapability> capabilities = [];
        final capabilityStrings = modelConfig['capabilities'] as List<String>;
        for (final capability in capabilityStrings) {
          switch (capability) {
            case 'text':
              capabilities.add(AICapability.text);
              break;
            case 'image':
              capabilities.add(AICapability.image);
              break;
            case 'video':
              capabilities.add(AICapability.video);
              break;
            case 'audio':
              capabilities.add(AICapability.audio);
              break;
            case 'deepThinking':
              capabilities.add(AICapability.deepThinking);
              break;
          }
        }

        // 创建模型
        final model = AIModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: modelConfig['name'],
          provider: modelConfig['provider'],
          apiEndpoint: modelConfig['endpoint'],
          apiKey: '', // 用户需要配置API密钥
          supportsMultimodal: modelConfig['supportsMultimodal'],
          capabilities: capabilities,
          description: modelConfig['description'],
          isSelected: true,
        );

        _models.add(model);
        _selectedModelId = model.id;

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('添加预设模型错误: $e');
      return false;
    }
  }

  /// Add a new AI model
  Future<void> addModel(AIModel model) async {
    _models.add(model);
    await saveModels();
    notifyListeners();
  }

  /// Update an existing AI model
  Future<void> updateModel(AIModel updatedModel) async {
    final index = _models.indexWhere((m) => m.id == updatedModel.id);
    if (index >= 0) {
      _models[index] = updatedModel;
      await saveModels();
      notifyListeners();
    }
  }

  /// Delete an AI model
  Future<void> deleteModel(String modelId) async {
    _models.removeWhere((m) => m.id == modelId);

    // If the selected model was deleted, select the first available
    if (_selectedModelId == modelId && _models.isNotEmpty) {
      _selectedModelId = _models.first.id;
    }

    await saveModels();
    notifyListeners();
  }

  /// Set the selected model
  Future<void> selectModel(String modelId) async {
    _selectedModelId = modelId;
    await LocalStorage.saveSelectedModelId(modelId);
    notifyListeners();
  }

  /// Toggle deep thinking mode
  Future<void> setDeepThinking(bool enabled) async {
    _deepThinkingEnabled = enabled;
    await LocalStorage.saveDeepThinkingEnabled(enabled);
    notifyListeners();
  }

  /// Toggle cloud storage mode
  Future<void> setUseCloudStorage(bool enabled) async {
    _useCloudStorage = enabled;
    await LocalStorage.saveUseCloudStorage(enabled);
    notifyListeners();
  }

  /// Set the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      default:
        modeString = 'system';
    }
    await LocalStorage.saveThemeMode(modeString);
    notifyListeners();
  }

  /// Save models to local storage
  Future<void> saveModels() async {
    final modelsJson = jsonEncode(_models.map((m) => m.toJson()).toList());
    await LocalStorage.saveModels(modelsJson);
    if (_selectedModelId != null) {
      await LocalStorage.saveSelectedModelId(_selectedModelId!);
    }
  }

  /// 批量导入模型配置
  Future<void> importModels(List<AIModel> models) async {
    // 如果模型列表为空，不执行任何操作
    if (models.isEmpty) return;

    // 清除现有的模型
    _models.clear();

    // 添加导入的模型
    _models.addAll(models);

    // 选择第一个模型作为默认模型
    if (_models.isNotEmpty) {
      _selectedModelId = _models.first.id;
    }

    // 保存到本地存储
    await saveModels();

    // 通知更新
    notifyListeners();
  }
}