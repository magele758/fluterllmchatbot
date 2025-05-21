import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/ai_model.dart';
import '../../models/chat_message.dart';
import '../../models/generation_request.dart';
import '../../models/user.dart';
import 'ai_service.dart';

/// OpenAI API service implementation
class OpenAIService implements AIService {
  /// The model configuration
  late AIModel _model;

  /// HTTP client
  final http.Client _client = http.Client();

  /// API base URL
  late String _baseUrl;

  /// API key
  late String _apiKey;

  /// Model name
  late String _modelName;

  @override
  Future<void> initialize(AIModel model) async {
    _model = model;
    _baseUrl = model.apiEndpoint;
    _apiKey = model.apiKey;
    _modelName = model.name;

    debugPrint('OpenAI Service initialized with model: ${model.name}');
    debugPrint('API Endpoint: ${model.apiEndpoint}');
  }

  @override
  Future<ChatMessage> sendMessage({
    required String prompt,
    required List<ChatMessage> context,
    required bool deepThinking,
  }) async {
    try {
      // Convert context to OpenAI format
      final messages = _convertToOpenAIMessages(context, prompt);

      final body = {
        'model': _modelName,
        'messages': messages,
        'temperature': deepThinking ? 0.5 : 0.7,
        'max_tokens': 1000,
      };

      // 确保API端点是完整的URL，包含/v1/chat/completions路径
      final apiUrl = _baseUrl.endsWith('/')
          ? '${_baseUrl}v1/chat/completions'
          : '$_baseUrl/v1/chat/completions';

      debugPrint('发送请求到: $apiUrl');
      debugPrint('请求头: Authorization: Bearer ${_apiKey.substring(0, min(3, _apiKey.length))}...');
      debugPrint('请求体: ${jsonEncode(body)}');

      final response = await _client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'User-Agent': 'DMXAPI/1.0.0 (https://www.dmxapi.cn)',
        },
        body: jsonEncode(body),
      );

      debugPrint('响应状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('响应体: ${response.body.substring(0, min(100, response.body.length))}...');

        // 使用utf8解码确保正确处理字符
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final content = responseData['choices'][0]['message']['content'];

        debugPrint('解析的内容: $content');

        return ChatMessage.ai(
          id: const Uuid().v4(),
          content: content,
          isDeepThinking: deepThinking,
        );
      } else {
        debugPrint('API错误详情: ${response.body}');
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('发送消息失败详情: $e');
      throw Exception('Failed to communicate with OpenAI: $e');
    }
  }

  @override
  Future<MediaContent> generateImage({
    required String prompt,
    required GenerationParameters parameters,
  }) async {
    // Image generation would require DALL-E API
    throw UnimplementedError('Image generation not implemented');
  }

  @override
  Future<MediaContent> generateVideo({
    required String prompt,
    required GenerationParameters parameters,
  }) async {
    throw UnimplementedError('Video generation not implemented');
  }

  @override
  Future<MediaContent> generateAudio({
    required String prompt,
    required GenerationParameters parameters,
  }) async {
    throw UnimplementedError('Audio generation not implemented');
  }

  @override
  bool supportsCapability(AICapability capability) {
    return _model.capabilities.contains(capability);
  }

  @override
  List<AICapability> getSupportedCapabilities() {
    return _model.capabilities;
  }

  @override
  Future<GenerationResult> processRequest(GenerationRequest request) async {
    switch (request.contentType) {
      case ContentType.text:
        final message = await sendMessage(
          prompt: request.prompt,
          context: [], // No context for now
          deepThinking: request.useDeepThinking,
        );

        return GenerationResult(
          contentType: ContentType.text,
          text: message.content,
          processingTimeSeconds: 1.0, // 假设处理时间
        );

      case ContentType.image:
        // Not implemented yet
        throw UnimplementedError('Image generation not implemented');

      case ContentType.video:
        // Not implemented yet
        throw UnimplementedError('Video generation not implemented');

      case ContentType.audio:
        // Not implemented yet
        throw UnimplementedError('Audio generation not implemented');
    }
  }

  /// Convert chat messages to OpenAI format
  List<Map<String, String>> _convertToOpenAIMessages(List<ChatMessage> messages, String currentPrompt) {
    final result = <Map<String, String>>[];

    // Add system message if needed
    result.add({
      'role': 'system',
      'content': 'You are a helpful AI assistant that provides accurate and concise answers.'
    });

    // Add conversation history
    for (final message in messages) {
      final role = message.type == MessageType.user ? 'user' : 'assistant';
      result.add({
        'role': role,
        'content': message.content,
      });
    }

    // Add current prompt
    result.add({
      'role': 'user',
      'content': currentPrompt,
    });

    return result;
  }
}