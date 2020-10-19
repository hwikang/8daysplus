import 'dart:io';

import 'package:core/core.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:mobile/utils/refresh_token.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/assets.dart';
import '../../utils/routes.dart';
import '../../utils/singleton.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoaded = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // String _homeScreenText = 'Waiting for token...';

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((packageInfo) async {
      final pref = await SharedPreferences.getInstance();

      Singleton.instance.appVersion =
          pref.getString('overriden_app_version') ?? packageInfo.version;
    });

    SharedPreferences.getInstance().then((pref) {
      final value = pref.getInt('api_server') ?? 0;
      if (value > 0) {
        debugAPI = value == 1;
      }
    }).whenComplete(() {
      // firebaseConfig();
      if (Platform.isIOS) {
        requestNotification().then((result) {
          //when user change setting
          _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
            getLogger(this).d('Settings registered: $settings');
          });
          getLocationAndDeviceInfo();
        }).catchError(print);
      } else {
        getLocationAndDeviceInfo();
      }
    });
    RefreshToken.refreshToken()
        .then((value) => getLogger(this).i('Refresh token Success'));
  }

  Future<bool> requestNotification() async {
    final res = await _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    getLogger(this).i('ios notification permission $res');
    if (res) {
      return true;
    }
    return false;
  }

  void getLocationAndDeviceInfo() {
    saveMyLocation();
    saveDeviceInfo().then((uuidResult) async {
      updatePushToken();
      await getVersionInfo();

      AppRoutes.authCheck(context).then((isLogin) async {
        Singleton.instance.isLogin = isLogin;
        await checkFirstBootAndRedirect();
      });
    });
  }

  Future<bool> saveMyLocation() {
    final location = Location();
    return location.getLocation().then((userLocation) {
      print('get my Location $userLocation');
      Singleton.instance.curLat = userLocation.latitude;
      Singleton.instance.curLng = userLocation.longitude;
      return true;
    }).catchError((dynamic error) {
      print('get location error $error');
      getLogger(this).e(error);

      return false;
    });
  }

  Future<bool> saveDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final prefs = await SharedPreferences.getInstance();

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return deviceInfo.iosInfo.then((iosDeviceInfo) {
        Singleton.instance.sUUID = iosDeviceInfo.identifierForVendor;
        Singleton.instance.sPlatform = 'IOS';
        Singleton.instance.deviceModel = iosDeviceInfo.model;
        Singleton.instance.osVer = iosDeviceInfo.systemVersion;
        Singleton.instance.statusBarHeight = MediaQuery.of(context).padding.top;

        prefs.setString('uuid', iosDeviceInfo.identifierForVendor);
        prefs.setString('devicePlatform', 'IOS');
        return true;
      });

      // unique ID on iOS
    } else {
      return deviceInfo.androidInfo.then((androidDeviceInfo) {
        Singleton.instance.sUUID = androidDeviceInfo.androidId;
        Singleton.instance.sPlatform = 'ANDROID';
        Singleton.instance.deviceModel = androidDeviceInfo.model;
        Singleton.instance.osVer = androidDeviceInfo.version.release;
        Singleton.instance.statusBarHeight = MediaQuery.of(context).padding.top;

        prefs.setString('uuid', androidDeviceInfo.androidId);
        prefs.setString('devicePlatform', 'ANDROID');
        return true;
      });
    }
  }

  void updatePushToken() {
    _firebaseMessaging.getToken().then((token) {
      assert(token != null);
      Singleton.instance.sPushToken = token;
      final pushTokenBloc = PushTokenBloc();
      pushTokenBloc
          .updatePushToken(
              Singleton.instance.sUUID, Singleton.instance.sPushToken)
          .catchError(print);

      getLogger(this).i('Push Messaging token: $token');
    }).catchError((dynamic error) {
      getSentryEvent(
        error,
        'firebase get token',
      ).then(sendErrorReport);
    });
  }

  Future<bool> getVersionInfo() {
    final versionBloc = VersionBloc();
    return versionBloc
        .getVersionRepos(
      Singleton.instance.sPlatform,
      Singleton.instance.appVersion,
    )
        .then((value) {
      Singleton.instance.versionModel = value;
      return true;
    }).catchError((error) {
      getSentryEvent(
        error,
        'get Version Info',
      ).then(sendErrorReport);
      return false;
    });
  }

  // 첫 부팅인 경우 true, 기존에 권한을 본적이 있는경우 false
  Future<void> checkFirstBootAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('first')) {
      AppRoutes.firstMainPage(context);
    } else {
      prefs.setBool('first', false);
      //push member/auth page upon Main page
      AppRoutes.firstMainPage(context);
      if (Platform.isAndroid) {
        AppRoutes.authorityPage(context);
      } else {
        AppRoutes.memberMainPage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xff313537),
          image: DecorationImage(
              image: AssetImage(ImageAssets.introSplashImage),
              fit: BoxFit.fitWidth)),
    );
  }
}

class UserLocation {
  UserLocation({this.latitude, this.longitude});

  final double latitude;
  final double longitude;
}
