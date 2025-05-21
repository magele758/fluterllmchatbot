import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_config.dart';
import '../config/routes.dart';
import '../config/theme.dart';
import '../models/ai_model.dart';
import '../providers/settings_provider.dart';
import '../widgets/common/section_header.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // App theme section
              _buildSectionHeader(context, 'Appearance'),
              _buildThemeSelector(context, settings),
              const SizedBox(height: 24),

              // Content generation settings
              _buildSectionHeader(context, 'Content Generation'),
              _buildSwitchTile(
                context: context,
                title: 'Deep Thinking Mode',
                subtitle: 'Enable deeper, more thorough AI responses',
                value: settings.deepThinkingEnabled,
                onChanged: (value) => settings.setDeepThinking(value),
              ),
              const SizedBox(height: 12),

              // Storage settings
              _buildSwitchTile(
                context: context,
                title: 'Cloud Storage',
                subtitle: 'Store conversations in cloud storage',
                value: settings.useCloudStorage,
                onChanged: (value) => settings.setUseCloudStorage(value),
              ),
              const SizedBox(height: 24),

              // AI models section
              _buildSectionHeader(context, 'AI Models'),
              ...settings.models.map((model) => _buildModelItem(context, model, settings)),

              // Add model button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.modelConfig);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('添加新模型'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              // 导入/导出设置
              _buildSectionHeader(context, '导入/导出'),

              // 导出当前配置
              ListTile(
                leading: const Icon(Icons.upload),
                title: const Text('导出配置'),
                subtitle: const Text('将当前配置导出为文本'),
                onTap: () => _exportConfig(context, settings),
              ),

              // 从文本导入配置
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('导入配置'),
                subtitle: const Text('从文本导入模型配置'),
                onTap: () => _showImportDialog(context, settings),
              ),

              const SizedBox(height: 24),

              // About section
              _buildSectionHeader(context, 'About'),
              ListTile(
                title: const Text('App Version'),
                subtitle: Text(AppConfig.appVersion),
                trailing: const Icon(Icons.info_outline),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build a section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  /// Build theme mode selector
  Widget _buildThemeSelector(BuildContext context, SettingsProvider settings) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Mode',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            // Theme options
            Wrap(
              spacing: 12,
              children: [
                _buildThemeOption(
                  context,
                  title: 'Light',
                  icon: Icons.light_mode,
                  mode: ThemeMode.light,
                  currentMode: settings.themeMode,
                  onTap: () => settings.setThemeMode(ThemeMode.light),
                ),
                _buildThemeOption(
                  context,
                  title: 'Dark',
                  icon: Icons.dark_mode,
                  mode: ThemeMode.dark,
                  currentMode: settings.themeMode,
                  onTap: () => settings.setThemeMode(ThemeMode.dark),
                ),
                _buildThemeOption(
                  context,
                  title: 'System',
                  icon: Icons.settings_suggest,
                  mode: ThemeMode.system,
                  currentMode: settings.themeMode,
                  onTap: () => settings.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build a theme option chip
  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onTap,
  }) {
    final isSelected = mode == currentMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a switch tile with title and subtitle
  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: SwitchListTile.adaptive(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  /// Build an AI model item
  Widget _buildModelItem(BuildContext context, AIModel model, SettingsProvider settings) {
    final isSelected = model.id == settings.selectedModel?.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => settings.selectModel(model.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Model selection indicator
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (_) => settings.selectModel(model.id),
                activeColor: AppTheme.primaryColor,
              ),

              // Model info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      model.provider,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),

                    // Model capabilities
                    Wrap(
                      spacing: 8,
                      children: model.capabilities.map((capability) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _capabilityToString(capability),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Edit button
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Navigate to edit model screen
                  Navigator.pushNamed(
                    context,
                    Routes.modelConfig,
                    arguments: model,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Convert capability enum to display string
  String _capabilityToString(AICapability capability) {
    switch (capability) {
      case AICapability.text:
        return 'Text';
      case AICapability.image:
        return 'Image';
      case AICapability.video:
        return 'Video';
      case AICapability.audio:
        return 'Audio';
      case AICapability.deepThinking:
        return 'Deep Thinking';
    }
  }

  /// 导出当前配置为文本
  void _exportConfig(BuildContext context, SettingsProvider settings) {
    final modelsJson = jsonEncode(settings.models.map((m) => m.toJson()).toList());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导出配置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('复制下面的配置文本到安全的地方：'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                modelsJson,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 显示导入配置对话框
  void _showImportDialog(BuildContext context, SettingsProvider settings) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导入配置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('粘贴之前导出的配置文本：'),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '粘贴配置JSON',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              _importConfig(context, settings, textController.text);
              Navigator.pop(context);
            },
            child: const Text('导入'),
          ),
        ],
      ),
    );
  }

  /// 导入配置
  void _importConfig(BuildContext context, SettingsProvider settings, String configText) {
    try {
      final List<dynamic> modelsJson = jsonDecode(configText);
      final models = modelsJson.map((json) => AIModel.fromJson(json)).toList();

      if (models.isEmpty) {
        _showErrorSnackBar(context, '配置无效：未找到任何模型');
        return;
      }

      // 导入所有模型
      settings.importModels(models);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('成功导入配置'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar(context, '导入失败：$e');
    }
  }

  /// 显示错误提示
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}