// Wrapper around flutter_secure_storage.
// All reads/writes go through this service so the storage key namespace is
// centralised and error handling is consistent.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../errors/exceptions.dart';
import '../services/logger_service.dart';

class SecureStorageService {
  SecureStorageService()
    : _storage = const FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );

  final FlutterSecureStorage _storage;

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, st) {
      AppLogger.e(
        'SecureStorage write failed',
        error: '[redacted]',
        stackTrace: st,
      );
      throw const SecureStorageException('Failed to write to secure storage');
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, st) {
      AppLogger.e(
        'SecureStorage read failed',
        error: '[redacted]',
        stackTrace: st,
      );
      throw const SecureStorageException('Failed to read from secure storage');
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, st) {
      AppLogger.e(
        'SecureStorage delete failed',
        error: '[redacted]',
        stackTrace: st,
      );
      throw const SecureStorageException(
        'Failed to delete from secure storage',
      );
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, st) {
      AppLogger.e(
        'SecureStorage deleteAll failed',
        error: '[redacted]',
        stackTrace: st,
      );
      throw const SecureStorageException('Failed to clear secure storage');
    }
  }
}
