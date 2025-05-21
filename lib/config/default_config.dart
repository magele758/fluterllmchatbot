/// 默认配置文件，存储应用程序的默认设置
class DefaultConfig {
  DefaultConfig._(); // 私有构造函数，防止实例化

  // DMXAPI默认配置
  static const String dmxApiName = 'DMXAPI - gpt-4o-mini';
  static const String dmxApiProvider = 'DMXAPI';
  static const String dmxApiEndpoint = 'https://www.dmxapi.cn';
  static const String dmxModelName = 'gpt-4o-mini';
  static const bool dmxSupportsMultimodal = false;
  static const List<String> dmxCapabilities = ['text', 'deepThinking'];
  static const String dmxDescription = 'DMXAPI提供的GPT-4o-mini模型';

  // 常用模型列表
  static const Map<String, Map<String, dynamic>> predefinedModels = {
    'dmxapi-gpt4o-mini': {
      'name': 'gpt-4o-mini',
      'provider': 'DMXAPI',
      'endpoint': 'https://www.dmxapi.cn',
      'modelName': 'gpt-4o-mini',
      'supportsMultimodal': false,
      'capabilities': ['text'],
      'description': 'DMXAPI提供的GPT-4o-mini模型'
    },
    'dmxapi-gpt4o': {
      'name': 'DMXAPI - gpt-4o',
      'provider': 'DMXAPI',
      'endpoint': 'https://www.dmxapi.cn',
      'modelName': 'gpt-4o',
      'supportsMultimodal': true,
      'capabilities': ['text', 'image', 'deepThinking'],
      'description': 'DMXAPI提供的GPT-4o多模态模型'
    },
    'openai-gpt35': {
      'name': 'OpenAI - GPT-3.5 Turbo',
      'provider': 'OpenAI',
      'endpoint': 'https://api.openai.com/v1/chat/completions',
      'modelName': 'gpt-3.5-turbo',
      'supportsMultimodal': false,
      'capabilities': ['text'],
      'description': 'OpenAI的GPT-3.5 Turbo模型'
    }
  };

  // 应用程序设置
  static const bool defaultDeepThinkingEnabled = true;
  static const bool defaultUseCloudStorage = false;
  static const String defaultThemeMode = 'system';
}