// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String?,
      wechatUserId: json['wechatUserId'] as String?,
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'email': instance.email,
      'wechatUserId': instance.wechatUserId,
      'preferences': instance.preferences,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt.toIso8601String(),
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      isDarkModeEnabled: json['isDarkModeEnabled'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      deepThinkingEnabled: json['deepThinkingEnabled'] as bool? ?? false,
      defaultContentType: $enumDecodeNullable(
              _$ContentTypeEnumMap, json['defaultContentType']) ??
          ContentType.text,
      useCloudStorage: json['useCloudStorage'] as bool? ?? false,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'isDarkModeEnabled': instance.isDarkModeEnabled,
      'notificationsEnabled': instance.notificationsEnabled,
      'deepThinkingEnabled': instance.deepThinkingEnabled,
      'defaultContentType': _$ContentTypeEnumMap[instance.defaultContentType]!,
      'useCloudStorage': instance.useCloudStorage,
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.image: 'image',
  ContentType.video: 'video',
  ContentType.audio: 'audio',
};
