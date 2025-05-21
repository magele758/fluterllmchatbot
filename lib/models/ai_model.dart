import 'package:json_annotation/json_annotation.dart';

part 'ai_model.g.dart';

/// Represents an AI model configuration with provider details and capabilities
@JsonSerializable()
class AIModel {
  /// Unique identifier for the model
  final String id;

  /// Display name of the model
  final String name;

  /// Provider name (e.g., OpenAI, Anthropic)
  final String provider;

  /// API endpoint for this model
  final String apiEndpoint;

  /// Optional proxy URL for network requests
  final String? proxyUrl;

  /// API key for authentication
  final String apiKey;

  /// Whether this model supports multimodal inputs (images, audio)
  final bool supportsMultimodal;

  /// List of supported capabilities
  final List<AICapability> capabilities;

  /// Maximum number of tokens this model can process
  final int? maxTokens;

  /// User-provided description or notes about this model
  final String? description;

  /// Whether this is the currently selected model
  @JsonKey(defaultValue: false)
  final bool isSelected;

  const AIModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.apiEndpoint,
    required this.apiKey,
    this.proxyUrl,
    required this.supportsMultimodal,
    required this.capabilities,
    this.maxTokens,
    this.description,
    this.isSelected = false,
  });

  /// Create a copy of this model with specified parameters changed
  AIModel copyWith({
    String? id,
    String? name,
    String? provider,
    String? apiEndpoint,
    String? proxyUrl,
    String? apiKey,
    bool? supportsMultimodal,
    List<AICapability>? capabilities,
    int? maxTokens,
    String? description,
    bool? isSelected,
  }) {
    return AIModel(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      proxyUrl: proxyUrl ?? this.proxyUrl,
      apiKey: apiKey ?? this.apiKey,
      supportsMultimodal: supportsMultimodal ?? this.supportsMultimodal,
      capabilities: capabilities ?? this.capabilities,
      maxTokens: maxTokens ?? this.maxTokens,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  /// Factory constructor for creating a model from JSON
  factory AIModel.fromJson(Map<String, dynamic> json) => _$AIModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$AIModelToJson(this);
}

/// Represents AI model capabilities
enum AICapability {
  text,
  image,
  video,
  audio,
  deepThinking
}