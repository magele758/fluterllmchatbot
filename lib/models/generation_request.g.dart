// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerationRequest _$GenerationRequestFromJson(Map<String, dynamic> json) =>
    GenerationRequest(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      contentType: $enumDecode(_$ContentTypeEnumMap, json['contentType']),
      status: $enumDecode(_$GenerationStatusEnumMap, json['status']),
      parameters: GenerationParameters.fromJson(
          json['parameters'] as Map<String, dynamic>),
      modelId: json['modelId'] as String,
      useDeepThinking: json['useDeepThinking'] as bool,
      result: json['result'] == null
          ? null
          : GenerationResult.fromJson(json['result'] as Map<String, dynamic>),
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$GenerationRequestToJson(GenerationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prompt': instance.prompt,
      'contentType': _$ContentTypeEnumMap[instance.contentType]!,
      'status': _$GenerationStatusEnumMap[instance.status]!,
      'parameters': instance.parameters,
      'modelId': instance.modelId,
      'useDeepThinking': instance.useDeepThinking,
      'result': instance.result,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.image: 'image',
  ContentType.video: 'video',
  ContentType.audio: 'audio',
};

const _$GenerationStatusEnumMap = {
  GenerationStatus.pending: 'pending',
  GenerationStatus.processing: 'processing',
  GenerationStatus.completed: 'completed',
  GenerationStatus.failed: 'failed',
  GenerationStatus.cancelled: 'cancelled',
};

GenerationParameters _$GenerationParametersFromJson(
        Map<String, dynamic> json) =>
    GenerationParameters(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxLength: (json['maxLength'] as num?)?.toInt(),
      imageStyle: json['imageStyle'] as String?,
      imageSize: json['imageSize'] as String?,
      videoDurationSeconds: (json['videoDurationSeconds'] as num?)?.toInt(),
      audioVoice: json['audioVoice'] as String?,
      audioDurationSeconds: (json['audioDurationSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GenerationParametersToJson(
        GenerationParameters instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'maxLength': instance.maxLength,
      'imageStyle': instance.imageStyle,
      'imageSize': instance.imageSize,
      'videoDurationSeconds': instance.videoDurationSeconds,
      'audioVoice': instance.audioVoice,
      'audioDurationSeconds': instance.audioDurationSeconds,
    };

GenerationResult _$GenerationResultFromJson(Map<String, dynamic> json) =>
    GenerationResult(
      contentType: $enumDecode(_$ContentTypeEnumMap, json['contentType']),
      text: json['text'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      processingTimeSeconds: (json['processingTimeSeconds'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GenerationResultToJson(GenerationResult instance) =>
    <String, dynamic>{
      'contentType': _$ContentTypeEnumMap[instance.contentType]!,
      'text': instance.text,
      'mediaUrl': instance.mediaUrl,
      'processingTimeSeconds': instance.processingTimeSeconds,
      'metadata': instance.metadata,
    };
