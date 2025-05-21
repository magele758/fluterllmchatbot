import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Represents a user of the application
@JsonSerializable()
class User {
  /// Unique identifier for the user
  final String id;

  /// Display name of the user
  final String name;

  /// Profile picture URL
  final String? avatarUrl;

  /// Email address (optional)
  final String? email;

  /// WeChat user identifier (if logged in via WeChat)
  final String? wechatUserId;

  /// User preferences
  final UserPreferences preferences;

  /// When the user account was created
  final DateTime createdAt;

  /// Last login timestamp
  final DateTime lastLoginAt;

  const User({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.email,
    this.wechatUserId,
    required this.preferences,
    required this.createdAt,
    required this.lastLoginAt,
  });

  /// Create a copy of this user with specified parameters changed
  User copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? email,
    String? wechatUserId,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      wechatUserId: wechatUserId ?? this.wechatUserId,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Factory constructor for creating a user from WeChat login
  factory User.fromWechat({
    required String id,
    required String name,
    String? avatarUrl,
    required String wechatUserId,
  }) {
    final now = DateTime.now();
    return User(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      wechatUserId: wechatUserId,
      preferences: UserPreferences(),
      createdAt: now,
      lastLoginAt: now,
    );
  }

  /// Factory constructor for creating a user from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Convert user to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

/// User preferences for the application
@JsonSerializable()
class UserPreferences {
  /// Whether dark mode is enabled
  @JsonKey(defaultValue: false)
  final bool isDarkModeEnabled;

  /// Whether notifications are enabled
  @JsonKey(defaultValue: true)
  final bool notificationsEnabled;

  /// Whether deep thinking mode is enabled by default
  @JsonKey(defaultValue: false)
  final bool deepThinkingEnabled;

  /// Default content type for new conversations
  @JsonKey(defaultValue: ContentType.text)
  final ContentType defaultContentType;

  /// Whether to use cloud storage for conversations by default
  @JsonKey(defaultValue: false)
  final bool useCloudStorage;

  const UserPreferences({
    this.isDarkModeEnabled = false,
    this.notificationsEnabled = true,
    this.deepThinkingEnabled = false,
    this.defaultContentType = ContentType.text,
    this.useCloudStorage = false,
  });

  /// Create a copy of preferences with specified parameters changed
  UserPreferences copyWith({
    bool? isDarkModeEnabled,
    bool? notificationsEnabled,
    bool? deepThinkingEnabled,
    ContentType? defaultContentType,
    bool? useCloudStorage,
  }) {
    return UserPreferences(
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      deepThinkingEnabled: deepThinkingEnabled ?? this.deepThinkingEnabled,
      defaultContentType: defaultContentType ?? this.defaultContentType,
      useCloudStorage: useCloudStorage ?? this.useCloudStorage,
    );
  }

  /// Factory constructor for creating preferences from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

  /// Convert preferences to JSON
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

/// Content type enum for generation
enum ContentType {
  text,
  image,
  video,
  audio,
}