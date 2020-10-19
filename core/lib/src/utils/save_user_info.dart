import 'package:mobile/utils/firebase_analytics.dart';
import 'package:mobile/utils/one_signal_client.dart';
import 'package:mobile/utils/singleton.dart';
import 'package:mobile/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core.dart';

Future<void> saveUserInfo(AuthModel auth) async {
  final token = auth.token.accessToken;
  final refreshToken = auth.token.refreshToken;
  final loginType = auth.user.loginType;
  final email = auth.user.profile.email;

  final companyCode = auth.user.company.companyCode;
  final marketingAlarm = auth.user.alarmAgreement.marketingAlarm;

  print('loginType $loginType');
  print('token $token');
  print('refreshToken $refreshToken');
  print('companyCode $companyCode');
  print('Singleton.instance.appVersion ${Singleton.instance.appVersion}');
  print('marketingAlarm $marketingAlarm');
  print('email $email');
  print('UUID ${Singleton.instance.sUUID}');
  String birthDay;
  if (auth.user.profile.birthDay == '') {
    birthDay = '';
  } else {
    birthDay =
        '${auth.user.profile.birthYear}-${auth.user.profile.birthMonth}-${auth.user.profile.birthDay}';
  }
  print(birthDay);

  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', token);
  await prefs.setString('refreshToken', refreshToken);
  await prefs.setString(UserPropertyStrings.email, email);
  await prefs.setString(UserPropertyStrings.companyCode, companyCode);
  await prefs.setString(
      UserPropertyStrings.marketingAgree, marketingAlarm.toString());
  await prefs.setString(UserPropertyStrings.signUpType, loginType);
  await prefs.setString(
      UserPropertyStrings.appVersion, Singleton.instance.appVersion);
  await prefs.setString(UserPropertyStrings.birthDay, birthDay);

  Singleton.instance.loginType = loginType;
  Singleton.instance.isLogin = true;

  Analytics.analyticsSetUserId(email);
  Analytics.analyticsSetUserProperty(
      UserPropertyStrings.uuid, Singleton.instance.sUUID);
  Analytics.analyticsSetUserProperty(UserPropertyStrings.email, email);

  Analytics.analyticsSetUserProperty(
      UserPropertyStrings.companyCode, companyCode);
  Analytics.analyticsSetUserProperty(
      UserPropertyStrings.marketingAgree, marketingAlarm.toString());
  Analytics.analyticsSetUserProperty(UserPropertyStrings.signUpType, loginType);
  Analytics.analyticsSetUserProperty(
      UserPropertyStrings.appVersion, Singleton.instance.appVersion);
  Analytics.analyticsSetUserProperty(UserPropertyStrings.birthDay, birthDay);

  OneSignalClient.instance.sendTag(UserPropertyStrings.email, email);
  OneSignalClient.instance
      .sendTag(UserPropertyStrings.companyCode, companyCode);
  OneSignalClient.instance
      .sendTag(UserPropertyStrings.marketingAgree, marketingAlarm.toString());
  OneSignalClient.instance
      .sendTag(UserPropertyStrings.appVersion, Singleton.instance.appVersion);
  OneSignalClient.instance.sendTag(UserPropertyStrings.signUpType, loginType);
  OneSignalClient.instance.sendTag(UserPropertyStrings.birthDay, birthDay);

  final _analyticsParameter = <String, dynamic>{
    'company_code': companyCode,
    'method': loginType,
    'location': '${Singleton.instance.curLat},${Singleton.instance.curLng}',
  };
  Analytics.analyticsLogEvent('login', _analyticsParameter);
  OneSignalClient.instance.sendTrigger('login', _analyticsParameter);
}
