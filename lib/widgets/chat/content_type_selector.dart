import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../models/user.dart';

/// Widget for selecting content generation type
class ContentTypeSelector extends StatelessWidget {
  /// Currently selected content type
  final ContentType selectedType;

  /// Callback when a type is selected
  final Function(ContentType) onTypeSelected;

  const ContentTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TypeButton(
            type: ContentType.text,
            label: 'Text',
            icon: Icons.chat_outlined,
            isSelected: selectedType == ContentType.text,
            onTap: () => onTypeSelected(ContentType.text),
          ),
          _TypeButton(
            type: ContentType.image,
            label: 'Image',
            icon: Icons.image_outlined,
            isSelected: selectedType == ContentType.image,
            onTap: () => onTypeSelected(ContentType.image),
          ),
          _TypeButton(
            type: ContentType.video,
            label: 'Video',
            icon: Icons.videocam_outlined,
            isSelected: selectedType == ContentType.video,
            onTap: () => onTypeSelected(ContentType.video),
          ),
          _TypeButton(
            type: ContentType.audio,
            label: 'Audio',
            icon: Icons.audio_file_outlined,
            isSelected: selectedType == ContentType.audio,
            onTap: () => onTypeSelected(ContentType.audio),
          ),
        ],
      ),
    );
  }
}

/// Individual button for content type selection
class _TypeButton extends StatelessWidget {
  final ContentType type;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.type,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.primaryColor : Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}