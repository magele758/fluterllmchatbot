import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// A customized loading indicator widget
class LoadingIndicator extends StatelessWidget {
  /// Size of the loading indicator
  final double size;

  /// Color of the loading indicator (default is app primary color)
  final Color? color;

  /// Width of the loading stroke
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size = 30.0,
    this.color,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppTheme.primaryColor,
        ),
      ),
    );
  }
}