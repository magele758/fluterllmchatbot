import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';
import '../../models/chat_message.dart';

/// Displays a single message bubble in the chat
class ChatBubble extends StatelessWidget {
  /// Message to display
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determine bubble color based on message type and theme
    final bubbleColor = isUser
        ? AppTheme.userBubbleColor
        : isDarkMode
            ? AppTheme.darkAiBubbleColor
            : AppTheme.aiBubbleColor;

    // Determine text color based on message type and theme
    final textColor = isUser
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Message bubble with content
            Container(
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Deep thinking badge
                  if (message.isDeepThinking && !isUser) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Deep Thinking',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Media content if any
                  if (message.media != null) ...[
                    _buildMediaContent(context),
                    const SizedBox(height: 8),
                  ],

                  // Message text content
                  Text(
                    message.content,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),

            // Timestamp
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build media content based on type
  Widget _buildMediaContent(BuildContext context) {
    final media = message.media;
    if (media == null) return const SizedBox();

    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: _getMediaWidget(media),
    );
  }

  /// Get appropriate widget for media type
  Widget _getMediaWidget(MediaContent media) {
    switch (media.type) {
      case MediaType.image:
        if (media.url.startsWith('http')) {
          return Image.network(
            media.url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          );
        } else {
          return Image.file(
            File(media.url),
            fit: BoxFit.cover,
          );
        }

      case MediaType.video:
        // Video would require a video player package
        return Container(
          color: Colors.black,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 50,
            ),
          ),
        );

      case MediaType.audio:
        // Audio would require an audio player package
        return Container(
          color: Colors.blueGrey.shade200,
          child: const Center(
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
              size: 50,
            ),
          ),
        );
    }
  }

  /// Format timestamp to a readable string
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    String prefix;
    if (messageDate == today) {
      prefix = 'Today';
    } else if (messageDate == yesterday) {
      prefix = 'Yesterday';
    } else {
      prefix = DateFormat('MMM d').format(timestamp);
    }

    return '$prefix, ${DateFormat('h:mm a').format(timestamp)}';
  }
}