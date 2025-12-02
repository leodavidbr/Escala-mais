import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Global application logger.
///
/// Conventions:
/// - debug: detailed developer-only information (e.g., intermediate values).
/// - info: high-level app flow (screen opened, request started/completed).
/// - warning: unexpected but handled situations (e.g., retries, fallbacks).
/// - error: failures that prevent an operation from completing.
/// - fatal: serious, unexpected failures or invariants being broken (antigo wtf).
///
/// Environment behaviour:
/// - In debug/profile (`kReleaseMode == false`), logs are pretty-printed with
///   colors, timestamps and stack traces.
/// - In release (`kReleaseMode == true`), logs use a simple printer to
///   minimise overhead while still emitting details to the console.
Logger _buildLogger() {
  if (kReleaseMode) {
    return Logger(printer: SimplePrinter());
  }

  return Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
    level: Level.fatal,
  );
}

final Logger appLogger = _buildLogger();

void logDebug(String message, [dynamic error, StackTrace? stackTrace]) {
  appLogger.d(message, error: error, stackTrace: stackTrace);
}

void logInfo(String message, [dynamic error, StackTrace? stackTrace]) {
  appLogger.i(message, error: error, stackTrace: stackTrace);
}

void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
  appLogger.w(message, error: error, stackTrace: stackTrace);
}

void logError(String message, [dynamic error, StackTrace? stackTrace]) {
  appLogger.e(message, error: error, stackTrace: stackTrace);
}

void logFatal(String message, [dynamic error, StackTrace? stackTrace]) {
  appLogger.f(message, error: error, stackTrace: stackTrace);
}
