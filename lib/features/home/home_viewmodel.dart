import 'package:flutter/foundation.dart';
import '../../utils/console.dart';

class HomeViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    Console.log('Counter incremented to $_counter');
    notifyListeners();
  }
}
