import 'package:json_annotation/json_annotation.dart';

import 'user.dart';
import 'ai_model.dart';

part 'generation_request.g.dart';

/// Represents a request for AI content generation
@JsonSerializable()
class GenerationRequest {
  /// Unique identifier for the request
  final String id;

  /// Prompt or input for the generation
  final String prompt;

  /// Type of content to generate
  final ContentType contentType;

  /// Current status of the generation request
  final GenerationStatus status;

  /// Parameters for generation
  final GenerationParameters parameters;

  /// ID of the AI model to use
  final String modelId;

  /// Whether to use deep thinking mode
  final bool useDeepThinking;

  /// Result of the generation (if completed)
  final GenerationResult? result;

  /// Error message (if failed)
  final String? errorMessage;

  /// When the request was created
  final DateTime createdAt;

  /// When the request was completed (if applicable)
  final DateTime? completedAt;

  const GenerationRequest({
    required this.id,
    required this.prompt,
    required this.contentType,
    required this.status,
    required this.parameters,
    required this.modelId,
    required this.useDeepThinking,
    this.result,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
  });

  /// Create a copy of this request with specified parameters changed
  GenerationRequest copyWith({
    String? id,
    String? prompt,
    ContentType? contentType,
    GenerationStatus? status,
    GenerationParameters? parameters,
    String? modelId,
    bool? useDeepThinking,
    GenerationResult? result,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return GenerationRequest(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      contentType: contentType ?? this.contentType,
      status: status ?? this.status,
      parameters: parameters ?? this.parameters,
      modelId: modelId ?? this.modelId,
      useDeepThinking: useDeepThinking ?? this.useDeepThinking,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Create a new generation request
  factory GenerationRequest.create({
    required String id,
    required String prompt,
    required ContentType contentType,
    required String modelId,
    required bool useDeepThinking,
    GenerationParameters? parameters,
  }) {
    return GenerationRequest(
      id: id,
      prompt: prompt,
      contentType: contentType,
      status: GenerationStatus.pending,
      parameters: parameters ?? GenerationParameters.defaultFor(contentType),
      modelId: modelId,
      useDeepThinking: useDeepThinking,
      createdAt: DateTime.now(),
    );
  }

  /// Create a completed request with result
  GenerationRequest complete(GenerationResult result) {
    return copyWith(
      status: GenerationStatus.completed,
      result: result,
      completedAt: DateTime.now(),
    );
  }

  /// Create a failed request with error
  GenerationRequest fail(String errorMessage) {
    return copyWith(
      status: GenerationStatus.failed,
      errorMessage: errorMessage,
      completedAt: DateTime.now(),
    );
  }

  /// Factory constructor for creating a request from JSON
  factory GenerationRequest.fromJson(Map<String, dynamic> json) => _$GenerationRequestFromJson(json);

  /// Convert request to JSON
  Map<String, dynamic> toJson() => _$GenerationRequestToJson(this);
}

/// Status of a generation request
enum GenerationStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

/// Parameters for generation
@JsonSerializable()
class GenerationParameters {
  // Common parameters
  final double temperature;
  final int? maxLength;

  // Image parameters
  final String? imageStyle;
  final String? imageSize;

  // Video parameters
  final int? videoDurationSeconds;

  // Audio parameters
  final String? audioVoice;
  final int? audioDurationSeconds;

  const GenerationParameters({
    this.temperature = 0.7,
    this.maxLength,
    this.imageStyle,
    this.imageSize,
    this.videoDurationSeconds,
    this.audioVoice,
    this.audioDurationSeconds,
  });

  /// Create default parameters for a content type
  factory GenerationParameters.defaultFor(ContentType type) {
    switch (type) {
      case ContentType.text:
        return const GenerationParameters(
          temperature: 0.7,
          maxLength: 1000,
        );
      case ContentType.image:
        return const GenerationParameters(
          temperature: 0.8,
          imageSize: '1024x1024',
          imageStyle: 'natural',
        );
      case ContentType.video:
        return const GenerationParameters(
          temperature: 0.8,
          videoDurationSeconds: 10,
        );
      case ContentType.audio:
        return const GenerationParameters(
          temperature: 0.7,
          audioVoice: 'neutral',
          audioDurationSeconds: 30,
        );
    }
  }

  /// Create a copy of parameters with specified fields changed
  GenerationParameters copyWith({
    double? temperature,
    int? maxLength,
    String? imageStyle,
    String? imageSize,
    int? videoDurationSeconds,
    String? audioVoice,
    int? audioDurationSeconds,
  }) {
    return GenerationParameters(
      temperature: temperature ?? this.temperature,
      maxLength: maxLength ?? this.maxLength,
      imageStyle: imageStyle ?? this.imageStyle,
      imageSize: imageSize ?? this.imageSize,
      videoDurationSeconds: videoDurationSeconds ?? this.videoDurationSeconds,
      audioVoice: audioVoice ?? this.audioVoice,
      audioDurationSeconds: audioDurationSeconds ?? this.audioDurationSeconds,
    );
  }

  /// Factory constructor for creating parameters from JSON
  factory GenerationParameters.fromJson(Map<String, dynamic> json) => _$GenerationParametersFromJson(json);

  /// Convert parameters to JSON
  Map<String, dynamic> toJson() => _$GenerationParametersToJson(this);
}

/// Result of a generation request
@JsonSerializable()
class GenerationResult {
  /// Content type of the result
  final ContentType contentType;

  /// Text content (for text responses)
  final String? text;

  /// URL to generated media (for image/video/audio)
  final String? mediaUrl;

  /// Processing time in seconds
  final double processingTimeSeconds;

  /// Additional metadata about the generation
  final Map<String, dynamic>? metadata;

  const GenerationResult({
    required this.contentType,
    this.text,
    this.mediaUrl,
    required this.processingTimeSeconds,
    this.metadata,
  });

  /// Factory constructor for creating a result from JSON
  factory GenerationResult.fromJson(Map<String, dynamic> json) => _$GenerationResultFromJson(json);

  /// Convert result to JSON
  Map<String, dynamic> toJson() => _$GenerationResultToJson(this);
}