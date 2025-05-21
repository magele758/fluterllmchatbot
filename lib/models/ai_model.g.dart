// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIModel _$AIModelFromJson(Map<String, dynamic> json) => AIModel(
      id: json['id'] as String,
      name: json['name'] as String,
      provider: json['provider'] as String,
      apiEndpoint: json['apiEndpoint'] as String,
      apiKey: json['apiKey'] as String,
      proxyUrl: json['proxyUrl'] as String?,
      supportsMultimodal: json['supportsMultimodal'] as bool,
      capabilities: (json['capabilities'] as List<dynamic>)
          .map((e) => $enumDecode(_$AICapabilityEnumMap, e))
          .toList(),
      maxTokens: (json['maxTokens'] as num?)?.toInt(),
      description: json['description'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$AIModelToJson(AIModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'provider': instance.provider,
      'apiEndpoint': instance.apiEndpoint,
      'proxyUrl': instance.proxyUrl,
      'apiKey': instance.apiKey,
      'supportsMultimodal': instance.supportsMultimodal,
      'capabilities':
          instance.capabilities.map((e) => _$AICapabilityEnumMap[e]!).toList(),
      'maxTokens': instance.maxTokens,
      'description': instance.description,
      'isSelected': instance.isSelected,
    };

const _$AICapabilityEnumMap = {
  AICapability.text: 'text',
  AICapability.image: 'image',
  AICapability.video: 'video',
  AICapability.audio: 'audio',
  AICapability.deepThinking: 'deepThinking',
};
