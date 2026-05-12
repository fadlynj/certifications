// Centralised logger — wraps the `logger` package.
// Sensitive data MUST never be passed to any log method.
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void d(String message, [Object? extra]) =>
      _logger.d(message, error: extra);

  static void i(String message, [Object? extra]) =>
      _logger.i(message, error: extra);

  static void w(String message, [Object? extra]) =>
      _logger.w(message, error: extra);

  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
