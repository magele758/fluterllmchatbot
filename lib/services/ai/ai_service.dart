import '../../models/ai_model.dart';
import '../../models/chat_message.dart';
import '../../models/generation_request.dart';
import '../../models/user.dart';

/// Abstract interface for AI model integrations
abstract class AIService {
  /// Initialize the service with model configuration
  Future<void> initialize(AIModel model);

  /// Send a message to the AI model and get a response
  Future<ChatMessage> sendMessage({
    required String prompt,
    required List<ChatMessage> context,
    required bool deepThinking,
  });

  /// Generate an image based on the provided prompt
  Future<MediaContent> generateImage({
    required String prompt,
    required GenerationParameters parameters,
  });

  /// Generate a video based on the provided prompt
  Future<MediaContent> generateVideo({
    required String prompt,
    required GenerationParameters parameters,
  });

  /// Generate audio based on the provided prompt
  Future<MediaContent> generateAudio({
    required String prompt,
    required GenerationParameters parameters,
  });

  /// Check if the model supports a specific capability
  bool supportsCapability(AICapability capability);

  /// Get all supported capabilities of the model
  List<AICapability> getSupportedCapabilities();

  /// Process a general content generation request
  Future<GenerationResult> processRequest(GenerationRequest request);
}