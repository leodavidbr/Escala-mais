import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget for displaying a route thumbnail image.
/// Shows a placeholder if the image doesn't exist or fails to load.
class RouteThumbnail extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const RouteThumbnail({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  bool _isAssetPath(String path) {
    return path.startsWith('assets/');
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _buildPlaceholder();
    }

    if (_isAssetPath(imagePath)) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    final file = File(imagePath);
    return FutureBuilder<bool>(
      future: file.exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder();
        }

        if (snapshot.hasData && snapshot.data == true) {
          return Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder();
            },
          );
        }

        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Builder(
      builder: (context) => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.placeholder,
        child: Icon(
          Icons.image_not_supported,
          color: Theme.of(context).colorScheme.placeholderIcon,
          size: (height ?? 100) * 0.3,
        ),
      ),
    );
  }
}

