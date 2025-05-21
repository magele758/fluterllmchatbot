import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/ai_model.dart';
import '../models/generation_request.dart';
import '../models/user.dart';
import '../services/ai/ai_service.dart';

/// Provider for managing content generation requests
class GenerationProvider extends ChangeNotifier {
  /// Current content generation request
  GenerationRequest? _currentRequest;

  /// History of generation requests
  List<GenerationRequest> _requestHistory = [];

  /// Error message if something goes wrong
  String? _errorMessage;

  /// AI service for generation
  AIService? _aiService;

  /// Get the current generation request
  GenerationRequest? get currentRequest => _currentRequest;

  /// Get the history of generation requests
  List<GenerationRequest> get requestHistory => _requestHistory;

  /// Check if generation is in progress
  bool get isGenerating => _currentRequest != null &&
      (_currentRequest!.status == GenerationStatus.pending ||
       _currentRequest!.status == GenerationStatus.processing);

  /// Get any error message
  String? get errorMessage => _errorMessage;

  /// Set the AI service for generation
  void setAIService(AIService service) {
    _aiService = service;
  }

  /// Create a new generation request
  Future<GenerationResult?> generateContent({
    required String prompt,
    required ContentType contentType,
    required AIModel model,
    required bool useDeepThinking,
    GenerationParameters? parameters,
  }) async {
    if (_aiService == null) {
      _errorMessage = 'AI service not initialized';
      notifyListeners();
      return null;
    }

    // Check if model supports this content type
    final capability = _contentTypeToCapability(contentType);
    if (!model.capabilities.contains(capability)) {
      _errorMessage = 'The selected model does not support ${contentType.name} generation';
      notifyListeners();
      return null;
    }

    try {
      // Create a new request
      final request = GenerationRequest.create(
        id: const Uuid().v4(),
        prompt: prompt,
        contentType: contentType,
        modelId: model.id,
        useDeepThinking: useDeepThinking,
        parameters: parameters,
      );

      _currentRequest = request;
      notifyListeners();

      // Initialize AI service with the model
      await _aiService!.initialize(model);

      // Update status to processing
      _currentRequest = _currentRequest!.copyWith(
        status: GenerationStatus.processing,
      );
      notifyListeners();

      // Process the request
      final result = await _aiService!.processRequest(_currentRequest!);

      // Update with completed status
      _currentRequest = _currentRequest!.complete(result);
      _requestHistory.add(_currentRequest!);
      notifyListeners();

      return result;
    } catch (e) {
      if (_currentRequest != null) {
        _currentRequest = _currentRequest!.fail(e.toString());
        _requestHistory.add(_currentRequest!);
      }
      _errorMessage = 'Generation failed: $e';
      notifyListeners();
      return null;
    } finally {
      // Reset current request after completion or failure
      final completedRequest = _currentRequest;
      _currentRequest = null;
      notifyListeners();
    }
  }

  /// Cancel the current generation request
  void cancelGeneration() {
    if (_currentRequest != null) {
      _currentRequest = _currentRequest!.copyWith(
        status: GenerationStatus.cancelled,
        completedAt: DateTime.now(),
      );
      _requestHistory.add(_currentRequest!);
      _currentRequest = null;
      notifyListeners();
    }
  }

  /// Clear the request history
  void clearHistory() {
    _requestHistory = [];
    notifyListeners();
  }

  /// Clear any error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Convert content type to AI capability
  AICapability _contentTypeToCapability(ContentType type) {
    switch (type) {
      case ContentType.text:
        return AICapability.text;
      case ContentType.image:
        return AICapability.image;
      case ContentType.video:
        return AICapability.video;
      case ContentType.audio:
        return AICapability.audio;
    }
  }
}