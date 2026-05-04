import 'package:flutter/foundation.dart';

class Console {
  Console._();

  static void log(String message) {
    if (kDebugMode) {
      print('[LOG]: $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[ERROR]: $message');
      if (error != null) print(error);
      if (stackTrace != null) print(stackTrace);
    }
  }
}
