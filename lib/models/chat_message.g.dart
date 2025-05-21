// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isDeepThinking: json['isDeepThinking'] as bool? ?? false,
      media: json['media'] == null
          ? null
          : MediaContent.fromJson(json['media'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isDeepThinking': instance.isDeepThinking,
      'media': instance.media,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
    };

const _$MessageTypeEnumMap = {
  MessageType.user: 'user',
  MessageType.ai: 'ai',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.error: 'error',
};

MediaContent _$MediaContentFromJson(Map<String, dynamic> json) => MediaContent(
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      url: json['url'] as String,
      caption: json['caption'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MediaContentToJson(MediaContent instance) =>
    <String, dynamic>{
      'type': _$MediaTypeEnumMap[instance.type]!,
      'url': instance.url,
      'caption': instance.caption,
      'thumbnailUrl': instance.thumbnailUrl,
      'metadata': instance.metadata,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.audio: 'audio',
};
