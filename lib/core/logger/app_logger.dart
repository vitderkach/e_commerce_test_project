import 'package:flutter/foundation.dart';

abstract class AppLogger {
  void debug(String message);
  void info(String message);
  void warning(String message);
  void error(String message, [dynamic error, StackTrace? stackTrace]);
}

class AppLoggerImpl implements AppLogger {
  @override
  void debug(String message) {
    if (kDebugMode) {
      print('DEBUG: $message');
    }
  }

  @override
  void info(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }

  @override
  void warning(String message) {
    if (kDebugMode) {
      print('WARNING: $message');
    }
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) {
        print('Error detail: $error');
      }
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }
}
