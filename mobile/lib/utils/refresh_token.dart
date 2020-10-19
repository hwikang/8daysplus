import 'package:core/core.dart';
import 'package:mobile/utils/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshToken {
  static Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    final tokenProvider = TokenProvider();
    return tokenProvider //need access token + refresh token
        .tokenProvider(refreshToken)
        .then((token) async {
      await prefs.setString('token', token.accessToken);
      await prefs.setString('refreshToken', token.refreshToken);
      Singleton.instance.isLogin = true;
      return true;
    }).catchError(print);
  }
}
