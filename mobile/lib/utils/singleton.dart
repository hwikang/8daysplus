import 'package:core/core.dart';

class Singleton {
  Singleton._internal();

  static final Singleton _singleton = Singleton._internal();

  String appVersion = '';
  bool bSendPushToken = false;
  bool bVersionCheck; // 켤때마다 처음만 버전체를 보임.
  double curLat = 0.0;
  double curLng = 0.0;
  String deviceModel = '';
  FeedMainPopupModel feedPopModel;
  bool isLogin = false;
  String loginType = '';
  String osVer = '';
  String popId;
  String serverUrl = '';
  String sPlatform = '';
  String sPushToken = '';
  double statusBarHeight = 24;
  String sUUID = '';
  String userEmail = '';
  VersionModel versionModel;

  static Singleton get instance => _singleton;
}
