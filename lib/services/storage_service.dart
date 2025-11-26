import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// Service for handling file storage operations.
class StorageService {
  /// Gets the application documents directory.
  Future<Directory> get _documentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  /// Gets the routes directory, creating it if it doesn't exist.
  Future<Directory> get _routesDirectory async {
    final docsDir = await _documentsDirectory;
    final routesDir = Directory(path.join(docsDir.path, 'routes'));
    if (!await routesDir.exists()) {
      await routesDir.create(recursive: true);
    }
    return routesDir;
  }

  /// Saves an image file to the routes directory.
  /// Returns the path to the saved file.
  /// Throws an exception if the file cannot be saved.
  Future<String> saveImage(File imageFile) async {
    if (!await imageFile.exists()) {
      throw Exception('Source image file does not exist');
    }

    final routesDir = await _routesDirectory;
    final extension = path.extension(imageFile.path);
    final fileName = '${const Uuid().v4()}$extension';
    final destinationPath = path.join(routesDir.path, fileName);

    await imageFile.copy(destinationPath);

    return destinationPath;
  }

  /// Deletes an image file by its path.
  /// Returns true if the file was deleted, false if it didn't exist.
  Future<bool> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  }

  /// Checks if an image file exists at the given path.
  Future<bool> imageExists(String imagePath) async {
    final file = File(imagePath);
    return await file.exists();
  }

  /// Gets a File object for the given image path.
  File getImageFile(String imagePath) {
    return File(imagePath);
  }
}

