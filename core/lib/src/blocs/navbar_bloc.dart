import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/utils/routes.dart';
import 'package:rxdart/rxdart.dart';

enum NavbarEvent { Main, Search, My, Reservation }

class NavbarBloc {
  NavbarBloc({this.initialEvent}) {
    dispatch(initialEvent);

    // mainPageScroll.add(ScrollController());
  }

  ScrollController discoveryPageScrollController = ScrollController();
  NavbarEvent initialEvent;
  ScrollController mainPageScrollController = ScrollController();
  ScrollController myPageScrollController = ScrollController();
  ScrollController reservationPageScrollController = ScrollController();

  Timer _clearTimeout;
  int _easter = 0;
  final BehaviorSubject<NavbarEvent> _eventController =
      BehaviorSubject<NavbarEvent>();

  // final BehaviorSubject<ScrollController> mainPageScroll =
  //     BehaviorSubject<ScrollController>();

  void dispose() {
    _eventController.close();
  }

  // Observable<NavbarEvent> get event => _eventController.stream;

  void mainDoubleTap(BuildContext context) {
    print(_easter);
    if (_easter >= 15) {
      _easter = 0;
      print(_easter);
      clearTimeout();
      developerPage(context);
    } else {
      _easter++;
      clearTimeout();
      _clearTimeout = Timer(const Duration(seconds: 5), () {
        _clearTimeout = null;
        _easter = 0;
        print(_easter);
      });
    }
    mainPageScrollController.animateTo(10,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeIn);
  }

  void discoveryDoubleTap() {
    discoveryPageScrollController.animateTo(10,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void reservationDoubleTap() {
    if (reservationPageScrollController.hasClients) {
      reservationPageScrollController.animateTo(10,
          duration: const Duration(milliseconds: 1000), curve: Curves.easeIn);
    }
  }

  void myDoubleTap() {
    myPageScrollController.animateTo(10,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void refreshMyPage() {}

  void clearTimeout() {
    if (_clearTimeout != null) {
      _clearTimeout.cancel();
    }
    _clearTimeout = null;
  }

  void developerPage(BuildContext context) {
    AppRoutes.developerOptionPage(context);
  }

  void dispatch(NavbarEvent e) {
    if (e != null) {
      _eventController.sink.add(e);
    }
  }
}
