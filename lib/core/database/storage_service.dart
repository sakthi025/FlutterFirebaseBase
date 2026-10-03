import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../logging/app_logger.dart';

/// Generic Cloud Storage service wrapping [FirebaseStorage].
/// Supports file uploads, raw byte uploads, progress observation, and download URLs.
class StorageService {
  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  FirebaseStorage get rawInstance => _storage;

  /// Upload file from local device path
  UploadTask uploadFile({
    required String storagePath,
    required File file,
    SettableMetadata? metadata,
  }) {
    AppLogger.instance.info('Starting file upload to $storagePath');
    final ref = _storage.ref().child(storagePath);
    return ref.putFile(file, metadata);
  }

  /// Upload raw bytes (useful for web or memory buffers)
  UploadTask uploadData({
    required String storagePath,
    required Uint8List data,
    SettableMetadata? metadata,
  }) {
    AppLogger.instance.info('Starting data upload to $storagePath');
    final ref = _storage.ref().child(storagePath);
    return ref.putData(data, metadata);
  }

  /// Get public download URL for a storage path
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } catch (e, stack) {
      AppLogger.instance.error('Failed to get download URL for $storagePath', e, stack);
      rethrow;
    }
  }

  /// Delete file from storage
  Future<void> deleteFile(String storagePath) async {
    try {
      AppLogger.instance.info('Deleting file at $storagePath');
      final ref = _storage.ref().child(storagePath);
      await ref.delete();
    } catch (e, stack) {
      AppLogger.instance.error('Failed to delete file at $storagePath', e, stack);
      rethrow;
    }
  }

  /// List all files in a folder prefix
  Future<ListResult> listFiles(String storagePath) async {
    final ref = _storage.ref().child(storagePath);
    return await ref.listAll();
  }
}
