import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../config/theme.dart';
import '../config/default_config.dart';
import '../models/ai_model.dart';
import '../providers/settings_provider.dart';

/// Screen for adding or editing AI model configurations
class ModelConfigScreen extends StatefulWidget {
  const ModelConfigScreen({super.key});

  @override
  State<ModelConfigScreen> createState() => _ModelConfigScreenState();
}

class _ModelConfigScreenState extends State<ModelConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _providerController = TextEditingController();
  final _endpointController = TextEditingController();
  final _proxyUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _supportsMultimodal = false;
  final Set<AICapability> _selectedCapabilities = <AICapability>{};

  AIModel? _existingModel;
  bool get _isEditing => _existingModel != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Load existing model data if editing
    final model = ModalRoute.of(context)?.settings.arguments as AIModel?;
    if (model != null && _existingModel == null) {
      _existingModel = model;
      _nameController.text = model.name;
      _providerController.text = model.provider;
      _endpointController.text = model.apiEndpoint;
      _proxyUrlController.text = model.proxyUrl ?? '';
      _apiKeyController.text = model.apiKey;
      _descriptionController.text = model.description ?? '';
      _supportsMultimodal = model.supportsMultimodal;
      _selectedCapabilities.addAll(model.capabilities);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _providerController.dispose();
    _endpointController.dispose();
    _proxyUrlController.dispose();
    _apiKeyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit AI Model' : 'Add AI Model'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic information section
              const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Model Name',
                  hintText: 'E.g., GPT-4, Claude, etc.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a model name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Provider field
              TextFormField(
                controller: _providerController,
                decoration: const InputDecoration(
                  labelText: 'Provider',
                  hintText: 'E.g., OpenAI, DMXAPI, etc.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a provider name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // API configuration section
              const Text(
                'API Configuration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // API endpoint field
              TextFormField(
                controller: _endpointController,
                decoration: const InputDecoration(
                  labelText: 'API Endpoint',
                  hintText: 'E.g., https://www.dmxapi.cn',
                  border: OutlineInputBorder(),
                  helperText: '注意: 对于DMXAPI, 只需输入主域名如 https://www.dmxapi.cn (无需添加 /v1/chat/completions)',
                  helperMaxLines: 2,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an API endpoint';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Proxy URL field (optional)
              TextFormField(
                controller: _proxyUrlController,
                decoration: const InputDecoration(
                  labelText: 'Proxy URL (Optional)',
                  hintText: 'https://proxy.example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // API key field
              TextFormField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  hintText: 'Your API key',
                  border: OutlineInputBorder(),
                  helperText: '对于DMXAPI，输入以 sk- 开头的API密钥',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an API key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Capabilities section
              const Text(
                'Capabilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Multimodal support toggle
              SwitchListTile.adaptive(
                title: const Text('Supports Multimodal Inputs'),
                subtitle: const Text('Enable if model can process images and other media'),
                value: _supportsMultimodal,
                onChanged: (value) {
                  setState(() {
                    _supportsMultimodal = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),

              // Capabilities selection
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildCapabilityChip(AICapability.text, 'Text'),
                  _buildCapabilityChip(AICapability.image, 'Image'),
                  _buildCapabilityChip(AICapability.video, 'Video'),
                  _buildCapabilityChip(AICapability.audio, 'Audio'),
                  _buildCapabilityChip(AICapability.deepThinking, 'Deep Thinking'),
                ],
              ),

              if (_selectedCapabilities.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select at least one capability',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Description field (optional)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Notes about this model...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _saveModel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isEditing ? 'Update Model' : 'Add Model'),
              ),

              // 预设模型选择区域
              if (!_isEditing) ...[
                const SizedBox(height: 24),
                const Text(
                  '快速配置预设模型',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // 预设模型按钮列表
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildPresetModelButton('DMXAPI - gpt-4o-mini', 'dmxapi-gpt4o-mini'),
                    _buildPresetModelButton('DMXAPI - gpt-4o', 'dmxapi-gpt4o'),
                    _buildPresetModelButton('OpenAI - GPT-3.5', 'openai-gpt35'),
                  ],
                ),
              ],

              // 快速配置DMXAPI按钮
              if (!_isEditing) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _presetDMXAPI,
                  icon: const Icon(Icons.flash_on),
                  label: const Text('快速配置 DMXAPI'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],

              // Delete button (only when editing)
              if (_isEditing) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _confirmDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                  child: const Text('Delete Model'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build a capability selection chip
  Widget _buildCapabilityChip(AICapability capability, String label) {
    final isSelected = _selectedCapabilities.contains(capability);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedCapabilities.add(capability);
          } else {
            _selectedCapabilities.remove(capability);
          }
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? AppTheme.primaryColor
              : Theme.of(context).dividerColor,
        ),
      ),
    );
  }

  /// Save the model configuration
  void _saveModel() {
    if (!_formKey.currentState!.validate() || _selectedCapabilities.isEmpty) {
      // Show error for empty capabilities
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields and select at least one capability'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    final model = AIModel(
      id: _existingModel?.id ?? const Uuid().v4(),
      name: _nameController.text,
      provider: _providerController.text,
      apiEndpoint: _endpointController.text,
      proxyUrl: _proxyUrlController.text.isEmpty ? null : _proxyUrlController.text,
      apiKey: _apiKeyController.text,
      supportsMultimodal: _supportsMultimodal,
      capabilities: _selectedCapabilities.toList(),
      maxTokens: _existingModel?.maxTokens,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      isSelected: _existingModel?.isSelected ?? false,
    );

    if (_isEditing) {
      settingsProvider.updateModel(model);
    } else {
      settingsProvider.addModel(model);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Model updated' : 'Model added'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Confirm model deletion
  void _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Model'),
        content: const Text('Are you sure you want to delete this model? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'DELETE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true && _existingModel != null) {
      if (!mounted) return;

      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      settingsProvider.deleteModel(_existingModel!.id);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Model deleted'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 构建预设模型按钮
  Widget _buildPresetModelButton(String label, String modelKey) {
    return OutlinedButton(
      onPressed: () => _applyPresetModel(modelKey),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label),
    );
  }

  /// 应用预设模型配置
  void _applyPresetModel(String modelKey) {
    if (DefaultConfig.predefinedModels.containsKey(modelKey)) {
      final modelConfig = DefaultConfig.predefinedModels[modelKey]!;

      setState(() {
        _nameController.text = modelConfig['name'];
        _providerController.text = modelConfig['provider'];
        _endpointController.text = modelConfig['endpoint'];
        _apiKeyController.text = ''; // 用户需要输入自己的API密钥
        _supportsMultimodal = modelConfig['supportsMultimodal'];

        // 清除现有能力并添加新能力
        _selectedCapabilities.clear();
        final capabilities = modelConfig['capabilities'] as List<String>;
        for (final capability in capabilities) {
          switch (capability) {
            case 'text':
              _selectedCapabilities.add(AICapability.text);
              break;
            case 'image':
              _selectedCapabilities.add(AICapability.image);
              break;
            case 'video':
              _selectedCapabilities.add(AICapability.video);
              break;
            case 'audio':
              _selectedCapabilities.add(AICapability.audio);
              break;
            case 'deepThinking':
              _selectedCapabilities.add(AICapability.deepThinking);
              break;
          }
        }

        _descriptionController.text = modelConfig['description'];
      });

      // 显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已应用${modelConfig['name']}预设配置，请输入您的API密钥'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  /// 预设DMXAPI配置
  void _presetDMXAPI() {
    setState(() {
      _nameController.text = 'DMXAPI - gpt-4o-mini';
      _providerController.text = 'DMXAPI';
      _endpointController.text = 'https://www.dmxapi.cn';
      _apiKeyController.text = ''; // 用户需要输入自己的API密钥
      _supportsMultimodal = false;
      _selectedCapabilities.clear();
      _selectedCapabilities.addAll([AICapability.text, AICapability.deepThinking]);
      _descriptionController.text = 'DMXAPI提供的GPT-4o-mini模型';
    });

    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已预设DMXAPI配置，请输入您的API密钥'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}