# Project Structure

This document outlines the detailed structure for the AI Assistant Flutter application.

```
ai_assistant/
├── android/                # Android platform code
├── ios/                    # iOS platform code
├── lib/
│   ├── main.dart           # Application entry point
│   ├── app.dart            # Main application widget
│   │
│   ├── config/
│   │   ├── app_config.dart # App-wide configuration
│   │   ├── theme.dart      # UI theme configuration
│   │   └── routes.dart     # App navigation routes
│   │
│   ├── models/
│   │   ├── chat_message.dart        # Chat message data model
│   │   ├── ai_model.dart            # AI model configuration model
│   │   ├── user.dart                # User model
│   │   └── generation_request.dart  # Content generation request model
│   │
│   ├── screens/
│   │   ├── home_screen.dart         # Main chat interface
│   │   ├── settings_screen.dart     # Settings configuration
│   │   ├── model_config_screen.dart # AI model configuration
│   │   ├── auth_screen.dart         # Authentication screen
│   │   └── splash_screen.dart       # Loading/splash screen
│   │
│   ├── widgets/
│   │   ├── chat/
│   │   │   ├── chat_input.dart      # Chat input with send button
│   │   │   ├── chat_bubble.dart     # Message display bubble
│   │   │   ├── chat_list.dart       # Scrollable chat message list
│   │   │   └── content_type_selector.dart # Content type selection widget
│   │   │
│   │   ├── settings/
│   │   │   ├── model_card.dart      # AI model display card
│   │   │   ├── deep_thinking_toggle.dart # Deep thinking mode toggle
│   │   │   └── proxy_input.dart     # Proxy URL input field
│   │   │
│   │   └── common/
│   │       ├── loading_indicator.dart # Loading animation
│   │       ├── error_display.dart     # Error display widget
│   │       └── media_preview.dart     # Media content preview
│   │
│   ├── services/
│   │   ├── ai/
│   │   │   ├── ai_service.dart       # Base AI service interface
│   │   │   ├── text_generation.dart  # Text generation implementation
│   │   │   ├── image_generation.dart # Image generation implementation
│   │   │   ├── video_generation.dart # Video generation implementation
│   │   │   └── music_generation.dart # Music generation implementation
│   │   │
│   │   ├── auth/
│   │   │   ├── auth_service.dart     # Authentication service interface
│   │   │   └── wechat_auth.dart      # WeChat authentication implementation
│   │   │
│   │   └── storage/
│   │       ├── storage_service.dart  # Storage service interface
│   │       ├── local_storage.dart    # Local storage implementation
│   │       └── wechat_oss_storage.dart # WeChat OSS storage implementation
│   │
│   ├── utils/
│   │   ├── api_client.dart           # HTTP client with proxy support
│   │   ├── media_utils.dart          # Media file handling utilities
│   │   └── validators.dart           # Input validation functions
│   │
│   └── providers/
│       ├── chat_provider.dart        # Chat state management
│       ├── settings_provider.dart    # App settings state management
│       ├── auth_provider.dart        # Authentication state management
│       └── generation_provider.dart  # Content generation state management
│
├── test/                   # Test files
├── assets/                 # Static assets (images, fonts, etc.)
├── pubspec.yaml            # Flutter dependencies
└── README.md               # Project documentation
```

## Key Dependencies

The following dependencies will be needed in the `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5          # State management
  http: ^0.13.5             # HTTP client for API calls
  shared_preferences: ^2.1.0 # Local storage
  fluttertoast: ^8.2.1      # Toast notifications
  image_picker: ^0.8.7+5    # Image selection
  file_picker: ^5.3.0       # File selection
  path_provider: ^2.0.15    # File system access
  flutter_markdown: ^0.6.14 # Markdown rendering
  url_launcher: ^6.1.11     # URL opening
  wechat_sdk: ^0.4.0        # WeChat integration
  flutter_secure_storage: ^8.0.0 # Secure storage for tokens
  logging: ^1.1.1           # Logging utility
  flutter_dotenv: ^5.0.2    # Environment configuration
```