import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

  class IndexController extends ChangeNotifier {
  static const int NEXT = 1;
  static const int PREVIOUS = -1;
  static const int MOVE = 0;

  Completer completer;
  bool isAnimation;
  int event;

  int get index => _index;
  int _index;

  Future move(int index, {bool isAnimation: true}) {
    this.isAnimation = isAnimation ?? true;
    this._index = index;
    this.event = MOVE;
    completer = new Completer();
    notifyListeners();
    return completer.future;
  }


  Future next({bool animation: true}) {
    this.event = NEXT;
    this.isAnimation = animation ?? true;
    completer = new Completer();
    notifyListeners();
    return completer.future;
  }

  Future previous({bool animation: true}) {
    this.event = PREVIOUS;
    this.isAnimation = animation ?? true;
    completer = new Completer();
    notifyListeners();
    return completer.future;
  }

  void complete() {
    if (!completer.isCompleted) {
      completer.complete();
    }
  }
}
