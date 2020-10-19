import 'dart:async';
import 'dart:ui' as ui;

import 'package:core/core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import 'ui/pages/splash_screen.dart';
import 'utils/custom_cache_manager.dart';
import 'utils/service_locator.dart';
import 'utils/theme.dart';

Future<void> main() async {
  CustomImageCache();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  setupLocator();

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = ui.window.physicalSize / ui.window.devicePixelRatio;
    final landscape = s.width > s.height;
    if (landscape) {
      SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    }

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getLogger(this).d('app start');
    return Provider<ProcessorBloc>(
      create: (context) => ProcessorBloc(initial: false),
      child: MaterialApp(
        builder: OneContext().builder,
        theme: whiteTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
