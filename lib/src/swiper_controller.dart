import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tswiper/src/swiper_plugin.dart';

import 'transform_page_view/transformer_page_view.dart';

class SwiperController extends IndexController {
  // Autoplay is started
  static const int START_AUTOPLAY = 2;

  // Autoplay is stopped.
  static const int STOP_AUTOPLAY = 3;

  // Indicate that the user is swiping
  static const int SWIPE = 4;

  // Indicate that the `Swiper` has changed it's index and is building it's ui ,so that the
  // `SwiperPluginConfig` is available.
  static const int BUILD = 5;

  // available when `event` == SwiperController.BUILD
  SwiperPluginConfig config;

  // available when `event` == SwiperController.SWIPE
  // this value is PageViewController.pos
  double pos;
  int length;
  bool autoplay;
  bool loop;

  int get index => _index;
  int _index;

  set index(int value) {
    if (value > length) value = 0;
    _changeIndex(value);
  }

  SwiperController({
    int initialIndex = 0,
    @required this.length,
    @required TickerProvider vsync,
    this.loop,
  })  : _index = initialIndex ?? 0,
        _animationController = AnimationController.unbounded(
          value: initialIndex.toDouble(),
          vsync: vsync,
        );

  Animation<double> get animation => _animationController?.view;

  AnimationController _animationController;

  bool get indexIsChanging => _indexIsChangingCount != 0;
  int _indexIsChangingCount = 0;

  int get previousIndex => _previousIndex;
  int _previousIndex;

  @override
  Future next({bool animation: true}) {
    this.event = IndexController.NEXT;
    this.isAnimation = animation ?? true;
    completer = new Completer();
//    _index = (_index+1)%length;
//    notifyListeners();

    animateTo(_index + 1);
    return completer.future;
  }

  void _changeIndex(int value, {Duration duration, Curve curve}) {
    if (value == index||indexIsChanging) {
      return;
    }
//    if (value > length) {
//      _index = 0;
//    } else
    _previousIndex = index;
      _index = value;


    if (duration != null) {
      _indexIsChangingCount += 1;
//      print('_changeIndex--->$_index');

//      notifyListeners(); // Because the value of indexIsChanging may have changed.
      _animationController
          .animateTo(_index.toDouble(), duration: duration, curve: curve)
          .whenCompleteOrCancel(() {
        _index = value%length;
        _animationController.value = _index.toDouble();
        _indexIsChangingCount -= 1;
//        notifyListeners();
      });
    } else {
      _indexIsChangingCount += 1;
      _animationController.value = _index.toDouble();
      _indexIsChangingCount -= 1;
      notifyListeners();
    }
  }

  TransformerPageController pageController;

  double get offset => _animationController.value - index.toDouble();

  void animateTo(int value,
      {Duration duration = kTabScrollDuration, Curve curve = Curves.ease}) {

    _changeIndex(value, duration: duration, curve: curve);
  }

  set offset(double value) {
    assert(value != null);
    assert(value >= -1.0 && value <= 1.0);
//    assert(!indexIsChanging);
    if (value == offset) return;
    _animationController.value = value + index.toDouble();
//    print('set offset--->>${value}');
  }

  void startAutoplay() {
    event = SwiperController.START_AUTOPLAY;
    this.autoplay = true;
    notifyListeners();
  }

  void stopAutoplay() {
    event = SwiperController.STOP_AUTOPLAY;
    this.autoplay = false;
    notifyListeners();
  }
}
