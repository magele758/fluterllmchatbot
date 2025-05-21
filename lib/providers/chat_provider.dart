import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../models/user.dart';
import '../services/storage/local_storage.dart';

/// Provider for managing chat conversations
class ChatProvider extends ChangeNotifier {
  /// List of messages in the current conversation
  List<ChatMessage> _messages = [];

  /// Current conversation ID
  String? _conversationId;

  /// Whether the AI is currently generating a response
  bool _isGenerating = false;

  /// Error message if something goes wrong
  String? _errorMessage;

  /// Get all messages in the current conversation
  List<ChatMessage> get messages => _messages;

  /// Get the current conversation ID
  String? get conversationId => _conversationId;

  /// Check if the AI is currently generating a response
  bool get isGenerating => _isGenerating;

  /// Get any error message
  String? get errorMessage => _errorMessage;

  /// Initialize with empty conversation
  ChatProvider() {
    startNewConversation();
  }

  /// Start a new conversation
  void startNewConversation() {
    _messages = [];
    _conversationId = const Uuid().v4();
    _errorMessage = null;
    notifyListeners();
  }

  /// Load a conversation by ID
  Future<void> loadConversation(String id) async {
    try {
      final conversationJson = await LocalStorage.getConversation(id);
      if (conversationJson != null) {
        final List<dynamic> messagesJson = jsonDecode(conversationJson);
        _messages = messagesJson
            .map((json) => ChatMessage.fromJson(json))
            .toList();
        _conversationId = id;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load conversation: $e';
      notifyListeners();
    }
  }

  /// Save the current conversation
  Future<void> saveConversation() async {
    try {
      if (_conversationId != null) {
        final messagesJson = jsonEncode(_messages.map((m) => m.toJson()).toList());
        await LocalStorage.saveConversation(_conversationId!, messagesJson);
      }
    } catch (e) {
      _errorMessage = 'Failed to save conversation: $e';
      notifyListeners();
    }
  }

  /// Add a user message to the conversation
  void addUserMessage(String content, {MediaContent? media}) {
    final message = ChatMessage.user(
      id: const Uuid().v4(),
      content: content,
      media: media,
    );

    _messages.add(message);
    notifyListeners();
    saveConversation();
  }

  /// Add an AI message to the conversation
  void addAIMessage(String content, {bool isDeepThinking = false, MediaContent? media}) {
    // 尝试修复可能的乱码
    final fixedContent = _fixPossibleUnicodeIssues(content);

    final message = ChatMessage.ai(
      id: const Uuid().v4(),
      content: fixedContent,
      isDeepThinking: isDeepThinking,
      media: media,
    );

    _messages.add(message);
    notifyListeners();
    saveConversation();
  }

  /// 尝试修复可能的Unicode编码问题
  String _fixPossibleUnicodeIssues(String content) {
    // 如果内容看起来像乱码，这是一种简单的尝试来修复它
    if (content.contains('Ã') || content.contains('â') || content.contains('ä')) {
      try {
        return content;
      } catch (e) {
        debugPrint('修复编码失败: $e');
        return content;
      }
    }
    return content;
  }

  /// Set the AI response generation status
  void setGenerating(bool isGenerating) {
    _isGenerating = isGenerating;
    notifyListeners();
  }

  /// Update a message in the conversation
  void updateMessage(String id, ChatMessage updatedMessage) {
    final index = _messages.indexWhere((m) => m.id == id);
    if (index >= 0) {
      _messages[index] = updatedMessage;
      notifyListeners();
      saveConversation();
    }
  }

  /// Delete a message from the conversation
  void deleteMessage(String id) {
    _messages.removeWhere((m) => m.id == id);
    notifyListeners();
    saveConversation();
  }

  /// Clear the current conversation
  void clearConversation() {
    _messages = [];
    notifyListeners();
    saveConversation();
  }

  /// Set an error message
  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear any error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}