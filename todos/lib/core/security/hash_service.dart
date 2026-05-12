// Password hashing service — SHA-256 + random salt, 10 000 iterations.
// NEVER log hashes or salts.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../constants/app_constants.dart';

class HashService {
  HashService._();

  static final HashService instance = HashService._();

  /// Generates a cryptographically-random base64-encoded salt.
  String generateSalt() {
    final random = Random.secure();
    final bytes = Uint8List(AppConstants.saltLengthBytes);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return base64Encode(bytes);
  }

  /// Hashes [password] with [salt] using [AppConstants.hashIterations] rounds.
  /// Returns a base64-encoded string safe for storage.
  String hashPassword(String password, String salt) {
    final saltBytes = base64Decode(salt);
    final passwordBytes = utf8.encode(password);

    // Initial hash: password bytes + salt bytes
    List<int> current = [...passwordBytes, ...saltBytes];

    for (var i = 0; i < AppConstants.hashIterations; i++) {
      current = sha256.convert(current).bytes;
    }

    return base64Encode(current);
  }

  /// Returns true when [plainPassword] matches [storedHash] for [storedSalt].
  bool verifyPassword(
    String plainPassword,
    String storedHash,
    String storedSalt,
  ) {
    final computed = hashPassword(plainPassword, storedSalt);
    return _constantTimeEquals(computed, storedHash);
  }

  /// Constant-time string comparison to prevent timing attacks.
  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
