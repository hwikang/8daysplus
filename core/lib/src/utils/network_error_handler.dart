import 'dart:async';
import 'dart:convert';

import 'package:mobile/utils/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core.dart';

class NetworkErrorHandler {
  // NetworkErrorHandler({
  //   this.onNetworkError,
  //   this.onLoginError,
  // });
  // Function onNetworkError;
  // Function onLoginError;

  static Future<void> handleError(
      {dynamic err,
      Function onNetworkError,
      Function onTokenExpired,
      Function onLoginError,
      Function defaultError}) async {
    print(err);
    if (err is TimeoutException) {
      logger.w(err);
      onNetworkError();
    } else {
      final prefs = await SharedPreferences.getInstance();

      int errorCode;

      //에러코드 분석
      if (err == '4009') {
        //바로 에러코드인경우 ex:4009
        errorCode = int.parse(err);
      } else if (err.contains('error_code')) {
        final Map<String, dynamic> error = json.decode(err);
        errorCode = error['error_code'];
      }

      print('errorCode $errorCode');
      if (errorCode == null) {
        print('on NETWORK ERROR');
        onNetworkError();
      } else {
        // 4001 비밀번호에러
        if (errorCode == 4000 ||
            errorCode == 4005 ||
            errorCode == 4008 ||
            errorCode == 4010) {
          //토큰에러
          onLoginError();
          print('on LOGIN ERROR');
        } else if (errorCode == 4002 ||
            errorCode == 4003 ||
            errorCode == 4009) {
          print('on TOKEN EXPIRED ERROR');

          //remove previous token & get new token with previous refresh token
          final token = prefs.getString('token');
          final refreshToken = prefs.getString('refreshToken');
          print('token $token');
          print('refreshTokenn $refreshToken');

          Singleton.instance.isLogin = false;

          final tokenProvider = TokenProvider();
          tokenProvider //need access token + refresh token
              .tokenProvider(refreshToken)
              .then((token) async {
            await prefs.setString('token', token.accessToken);
            await prefs.setString('refreshToken', token.refreshToken);
            Singleton.instance.isLogin = true;
            print('${prefs.getString("token")}');
            print('${prefs.getString("refreshToken")}');

            onTokenExpired(); //Do this after refresh Token ex>refresh function
          }).catchError((dynamic err) {
            onLoginError();
          });
        } else {
          print('on DEFAULT ERROR');

          defaultError();
        }
      }
    }
  }
}
