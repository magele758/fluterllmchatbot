import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../../config/theme.dart';
import '../../models/chat_message.dart';
import '../../models/user.dart';
import '../../providers/chat_provider.dart';
import '../../providers/generation_provider.dart';
import '../../providers/settings_provider.dart';
import '../common/loading_indicator.dart';
import '../../services/ai/openai_service.dart';

/// Input widget for sending messages or generating content
class ChatInput extends StatefulWidget {
  /// Current content type
  final ContentType contentType;

  /// Whether deep thinking mode is enabled
  final bool useDeepThinking;

  const ChatInput({
    super.key,
    required this.contentType,
    required this.useDeepThinking,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  File? _selectedMedia;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final generationProvider = Provider.of<GenerationProvider>(context);
    final isGenerating = chatProvider.isGenerating || generationProvider.isGenerating;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Selected media preview
          if (_selectedMedia != null) ...[
            _buildMediaPreview(),
            const SizedBox(height: 8),
          ],

          // Input row
          Row(
            children: [
              // Media attachment button
              if (_supportsMediaAttachment())
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: isGenerating ? null : _pickMedia,
                ),

              // Text input field
              Expanded(
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: _handleKeyEvent,
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    enabled: !isGenerating,
                    decoration: InputDecoration(
                      hintText: _getHintText(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      helperText: "按Enter发送, Shift+Enter换行",
                      helperStyle: TextStyle(fontSize: 10),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ),

              // Send button
              _isSubmitting || isGenerating
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingIndicator(
                        size: 24,
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      color: AppTheme.primaryColor,
                      onPressed: _submitInput,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build preview for selected media
  Widget _buildMediaPreview() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Stack(
        children: [
          // Media preview
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _getMediaPreview(),
            ),
          ),

          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedMedia = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get media preview based on type
  Widget _getMediaPreview() {
    if (_selectedMedia == null) {
      return const SizedBox();
    }

    switch (widget.contentType) {
      case ContentType.image:
        return Image.file(
          _selectedMedia!,
          fit: BoxFit.cover,
        );
      case ContentType.video:
        // Video thumbnail would require video_thumbnail package
        return Container(
          color: Colors.black,
          child: const Center(
            child: Icon(
              Icons.videocam,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      case ContentType.audio:
        return Container(
          color: Colors.blueGrey.shade200,
          child: const Center(
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  /// Check if current content type supports media attachment
  bool _supportsMediaAttachment() {
    return widget.contentType != ContentType.text;
  }

  /// Get hint text based on content type
  String _getHintText() {
    switch (widget.contentType) {
      case ContentType.text:
        return 'Type a message...';
      case ContentType.image:
        return 'Describe the image you want to generate...';
      case ContentType.video:
        return 'Describe the video you want to generate...';
      case ContentType.audio:
        return 'Describe the audio you want to generate...';
    }
  }

  /// Pick media file based on content type
  Future<void> _pickMedia() async {
    switch (widget.contentType) {
      case ContentType.image:
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedMedia = File(pickedFile.path);
          });
        }
        break;

      case ContentType.video:
        final picker = ImagePicker();
        final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedMedia = File(pickedFile.path);
          });
        }
        break;

      case ContentType.audio:
        final result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
        );
        if (result != null && result.files.isNotEmpty) {
          setState(() {
            _selectedMedia = File(result.files.first.path!);
          });
        }
        break;

      default:
        break;
    }
  }

  /// Submit the input content
  void _submitInput() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedMedia == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      // Create media content if needed
      MediaContent? media;
      if (_selectedMedia != null) {
        MediaType mediaType;
        switch (widget.contentType) {
          case ContentType.image:
            mediaType = MediaType.image;
            break;
          case ContentType.video:
            mediaType = MediaType.video;
            break;
          case ContentType.audio:
            mediaType = MediaType.audio;
            break;
          default:
            mediaType = MediaType.image;
        }

        media = MediaContent(
          type: mediaType,
          url: _selectedMedia!.path,
        );
      }

      // Add user message
      chatProvider.addUserMessage(text, media: media);

      // Clear input
      _textController.clear();
      setState(() {
        _selectedMedia = null;
        _isSubmitting = false;
      });

      // TODO: Process AI response
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final generationProvider = Provider.of<GenerationProvider>(context, listen: false);

      chatProvider.setGenerating(true);

      // 使用OpenAI服务处理消息
      try {
        // 获取当前选择的模型
        final model = settingsProvider.selectedModel;

        debugPrint('当前选择的模型: ${model?.name ?? "无"}');
        debugPrint('当前模型列表长度: ${settingsProvider.models.length}');

        if (model == null) {
          debugPrint('错误: 没有选择AI模型');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请在设置中选择一个AI模型'),
              backgroundColor: Colors.red,
            ),
          );
          throw Exception('没有选择AI模型');
        }

        debugPrint('模型配置信息: endpoint=${model.apiEndpoint}, key=${model.apiKey.substring(0, min(3, model.apiKey.length))}...');

        // 使用OpenAI服务发送消息
        final aiService = OpenAIService();
        await aiService.initialize(model);

        // 获取对话历史
        final chatHistory = chatProvider.messages;
        debugPrint('发送消息内容: $text');
        debugPrint('对话历史长度: ${chatHistory.length}');

        // 发送消息到OpenAI
        final response = await aiService.sendMessage(
          prompt: text,
          context: chatHistory,
          deepThinking: widget.useDeepThinking,
        );

        // 添加AI回复
        chatProvider.addAIMessage(
          response.content,
          isDeepThinking: widget.useDeepThinking,
        );
      } catch (e) {
        debugPrint('发送消息错误详情: $e');

        // 在UI上显示详细错误
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发送失败: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: '关闭',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

        // 出错时添加一条错误消息
        chatProvider.addAIMessage(
          '抱歉，我无法处理这条消息: $e',
          isDeepThinking: false,
        );
      } finally {
        chatProvider.setGenerating(false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 处理键盘事件
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (event.isShiftPressed) {
          // Shift+Enter: 添加换行符
          // 不做任何操作，让TextField默认添加换行
        } else {
          // 仅Enter: 发送消息
          if (!_isSubmitting && _textController.text.trim().isNotEmpty) {
            _submitInput();
          }
          // 阻止默认的换行行为
          _focusNode.unfocus();
          Future.delayed(Duration(milliseconds: 10), () {
            _focusNode.requestFocus();
          });
        }
      }
    }
  }
}