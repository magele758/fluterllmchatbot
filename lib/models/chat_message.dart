import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'chat_message.g.dart';

/// Represents a message in the chat conversation
@JsonSerializable()
class ChatMessage {
  /// Unique identifier for the message
  final String id;

  /// Content of the message
  final String content;

  /// Message type (user or AI)
  final MessageType type;

  /// Timestamp when the message was created
  final DateTime timestamp;

  /// Whether this message was processed with deep thinking
  final bool isDeepThinking;

  /// Media content attached to this message (if any)
  final MediaContent? media;

  /// Status of the message (sent, delivered, error)
  @JsonKey(defaultValue: MessageStatus.sent)
  final MessageStatus status;

  /// Error message if status is error
  final String? errorMessage;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isDeepThinking = false,
    this.media,
    this.status = MessageStatus.sent,
    this.errorMessage,
  });

  /// Create a copy of this message with specified parameters changed
  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isDeepThinking,
    MediaContent? media,
    MessageStatus? status,
    String? errorMessage,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isDeepThinking: isDeepThinking ?? this.isDeepThinking,
      media: media ?? this.media,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Factory constructor for creating a new user message
  factory ChatMessage.user({
    required String id,
    required String content,
    MediaContent? media,
  }) {
    return ChatMessage(
      id: id,
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
      media: media,
    );
  }

  /// Factory constructor for creating a new AI message
  factory ChatMessage.ai({
    required String id,
    required String content,
    bool isDeepThinking = false,
    MediaContent? media,
  }) {
    return ChatMessage(
      id: id,
      content: content,
      type: MessageType.ai,
      timestamp: DateTime.now(),
      isDeepThinking: isDeepThinking,
      media: media,
    );
  }

  /// Factory constructor for creating a message from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  /// Convert message to JSON
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

/// Message type enum (user or AI)
enum MessageType {
  user,
  ai,
}

/// Message status enum
enum MessageStatus {
  sending,
  sent,
  delivered,
  error,
}

/// Media content attached to a message
@JsonSerializable()
class MediaContent {
  /// Type of media content
  final MediaType type;

  /// URL or local path to the media
  final String url;

  /// Optional caption for the media
  final String? caption;

  /// Optional thumbnail URL for video/audio
  final String? thumbnailUrl;

  /// Additional metadata for the media
  final Map<String, dynamic>? metadata;

  const MediaContent({
    required this.type,
    required this.url,
    this.caption,
    this.thumbnailUrl,
    this.metadata,
  });

  /// Factory constructor for creating media content from JSON
  factory MediaContent.fromJson(Map<String, dynamic> json) => _$MediaContentFromJson(json);

  /// Convert media content to JSON
  Map<String, dynamic> toJson() => _$MediaContentToJson(this);
}

/// Media type enum
enum MediaType {
  image,
  video,
  audio,
}