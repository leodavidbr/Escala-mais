import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Service for handling image picking from camera or gallery.
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the camera.
  /// Returns null if the user cancels or an error occurs.
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  /// Picks an image from the gallery.
  /// Returns null if the user cancels or an error occurs.
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  /// Shows a dialog to choose between camera and gallery.
  /// Returns the selected image file or null if cancelled.
  Future<File?> pickImage({required bool fromCamera}) async {
    if (fromCamera) {
      return pickImageFromCamera();
    } else {
      return pickImageFromGallery();
    }
  }
}

