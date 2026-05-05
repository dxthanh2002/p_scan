import 'package:flutter/foundation.dart';

class SettingViewModel extends ChangeNotifier {
  bool _startAppWithCamera = false;
  bool _autoCapture = false;
  bool _highQuality = false;

  bool get startAppWithCamera => _startAppWithCamera;
  bool get autoCapture => _autoCapture;
  bool get highQuality => _highQuality;

  void toggleStartAppWithCamera(bool value) {
    _startAppWithCamera = value;
    notifyListeners();
  }

  void toggleAutoCapture(bool value) {
    _autoCapture = value;
    notifyListeners();
  }

  void toggleHighQuality(bool value) {
    _highQuality = value;
    notifyListeners();
  }
}
