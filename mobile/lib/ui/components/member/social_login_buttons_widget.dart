import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_id_request.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/routes.dart';
import '../../../utils/singleton.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../common/blockable_widget.dart';
import '../common/dialog_widget.dart';
import '../common/loading_widget.dart';

enum LoginState { Loading, Normal }

class SocialLoginButtonsWidget extends StatelessWidget {
  const SocialLoginButtonsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 150);
    return BlockableWidget(
      child: Container(
          child: Column(
        children: <Widget>[
          KakaoLoginButton(debouncer: debouncer),
          GoogleLoginButton(debouncer: debouncer),
          AppleLoginButton(debouncer: debouncer),
          const EmailLoginButton(),
        ],
      )),
    );
  }
}

//flutter kakao sdk 는 문제가 있음
class KakaoLoginButton extends StatefulWidget {
  const KakaoLoginButton({this.debouncer});

  final Debouncer debouncer;

  @override
  _KakaoLoginButtonState createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton> {
  LoginState state;

  //DialogWidget _dialog = DialogWidget();

  @override
  void initState() {
    super.initState();
    state = LoginState.Normal;
  }

  Future<void> onLogin(BuildContext context) async {
    final processorBloc = Provider.of<ProcessorBloc>(context);

    try {
      final kakaoSignIn = FlutterKakaoLogin();

      final result = await kakaoSignIn.logIn();
      final userResult = await kakaoSignIn.getUserMe();

      print('result.status ${result.status}');
      switch (result.status) {
        case KakaoLoginStatus.loggedIn:
          final accessToken = await kakaoSignIn.currentAccessToken;
          if (accessToken != null) {
            print('@@accessToken  $accessToken');

            final token = accessToken.token;

            SocialLogin.login(context, 'KAKAO', result.account.userEmail, token,
                    userResult.account.userNickname)
                .then((res) {
              print('result $res');
              setState(() {
                state = LoginState.Normal;
              });
            });
          }

          break;
        case KakaoLoginStatus.loggedOut:
          break;
        case KakaoLoginStatus.error:
          print(result.errorMessage);
          setState(() {
            state = LoginState.Normal;
          });
          getSentryEvent(
            result.errorMessage,
            'kakao login',
          ).then((event) {
            getLogger(this).d('sending report ${result.errorMessage}');
            sendErrorReport(event);
          });

          // _dialog.buildDialog(
          //   context: context,
          //   title: '에러',
          //   subTitle1: result.errorMessage ?? '카카오 로그인 에러',
          //   buttonTitle: MemberPageStrings.signUpDialogButtonTitle,
          // );

          break;
      }
    } on Exception catch (error) {
      print(error);

      getSentryEvent(
        error,
        'kakao login',
      ).then(sendErrorReport);
    } finally {
      processorBloc.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final processorBloc = Provider.of<ProcessorBloc>(context);

    return GestureDetector(
      onTap: () {
        processorBloc.start();
        setState(() {
          state = LoginState.Loading;
        });
        widget.debouncer.run(() {
          onLogin(context);
        });
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 46,
              color: const Color(0xffffeb00),
              child: Center(
                  child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 12),
                    child: Image(
                        width: 20,
                        height: 20,
                        image: AssetImage(ImageAssets.kakaoIcon)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: state == LoginState.Loading
                        ? const LoadingWidget()
                        : Text(
                            MemberPageStrings.kakaoLogin,
                            style: TextStyles.black14BoldTextStyle,
                          ),
                  ),
                ],
              )))),
    );
  }
}

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({this.debouncer});

  final Debouncer debouncer;

  @override
  _GoogleLoginButtonState createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  LoginState state;

  @override
  void initState() {
    super.initState();
    state = LoginState.Normal;
  }

  Future<void> onLogin(BuildContext context) async {
    final processorBloc = Provider.of<ProcessorBloc>(context);

    try {
      final _googleSignIn = GoogleSignIn();
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          state = LoginState.Normal;
        });
      } else {
        final googleSignInAuthentication =
            await googleSignInAccount.authentication;
        SocialLogin.login(
                context,
                'GOOGLE',
                _googleSignIn.currentUser.email,
                googleSignInAuthentication.idToken,
                _googleSignIn.currentUser.displayName,
                onFail: _googleSignIn.disconnect)
            .then((res) {
          setState(() {
            state = LoginState.Normal;
          });
        });
      }
    } on Exception catch (e) {
      getLogger(this).e(e);
    } finally {
      processorBloc.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final processorBloc = Provider.of<ProcessorBloc>(context);

    return GestureDetector(
      onTap: () {
        processorBloc.start();
        setState(() {
          state = LoginState.Loading;
        });

        widget.debouncer.run(() {
          onLogin(context);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: const Color(0xffd0d0d0)),
          borderRadius: const BorderRadius.all(
              Radius.circular(4.0) //         <--- border radius here
              ),
        ),
        child: Center(
            child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 12),
              child: Image(
                  width: 20,
                  height: 20,
                  image: AssetImage(ImageAssets.googleIcon)),
            ),
            Container(
              alignment: Alignment.center,
              child: state == LoginState.Loading
                  ? const LoadingWidget()
                  : Text(
                      MemberPageStrings.googleLogin,
                      style: TextStyles.black14BoldTextStyle,
                    ),
            ),
          ],
        )),
      ),
    );
  }
}

class AppleLoginButton extends StatefulWidget {
  const AppleLoginButton({this.debouncer});

  final Debouncer debouncer;

  @override
  _AppleLoginButtonState createState() => _AppleLoginButtonState();
}

class _AppleLoginButtonState extends State<AppleLoginButton> {
  LoginState state;

  @override
  void initState() {
    super.initState();
    state = LoginState.Normal;
  }

  Future<void> onLogin(BuildContext context) async {
    final processorBloc = Provider.of<ProcessorBloc>(context);

    try {
      final authorizationRequest =
          AppleIdRequest(requestedScopes: <Scope>[Scope.email, Scope.fullName]);
      final result = await AppleSignIn.performRequests(
          <AuthorizationRequest>[authorizationRequest]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final tokenString =
              String.fromCharCodes(result.credential.identityToken);
          String appleName;
          String appleEmail;
          if (result.credential.fullName.familyName == null ||
              result.credential.fullName.givenName == null) {
            appleName = 'APPLE 유저';
          } else {
            appleName = result.credential.fullName.familyName +
                result.credential.fullName.givenName;
          }
          if (result.credential.email == null) {
            final parts = tokenString.split('.');
            final payload = parts[1];
            final decoded = B64urlEncRfc7515.decodeUtf8(payload);
            final valueMap = json.decode(decoded);
            appleEmail = valueMap['email'];
          } else {
            appleEmail = result.credential.email;
          }

          SocialLogin.login(
                  context, 'APPLE', appleEmail, tokenString, appleName)
              .then((res) {
            setState(() {
              state = LoginState.Normal;
            });
          });

          break;
        default:
          setState(() {
            state = LoginState.Normal;
          });
      }
    } on Exception catch (e) {
      getLogger(this).e(e);
    } finally {
      processorBloc.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final processorBloc = Provider.of<ProcessorBloc>(context);

    if (Platform.isAndroid) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        processorBloc.start();
        setState(() {
          state = LoginState.Loading;
        });
        widget.debouncer.run(() {
          onLogin(context);
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xff000000),
            // border: Border.all(width: 1.0, color: const Color(0xffd0d0d0)),
            borderRadius: BorderRadius.all(
                Radius.circular(4.0) //         <--- border radius here
                ),
          ),
          child: Center(
              child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 12),
                child: const Image(
                    width: 20,
                    height: 20,
                    color: Colors.white,
                    image: AssetImage(ImageAssets.appleIcon)),
              ),
              Container(
                alignment: Alignment.center,
                child: state == LoginState.Loading
                    ? const LoadingWidget()
                    : Text(
                        MemberPageStrings.appleLogin,
                        style: TextStyles.white14BoldTextStyle,
                      ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class EmailLoginButton extends StatelessWidget {
  const EmailLoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final _analyticsParameter = <String, dynamic>{
          'method': 'email',
        };
        Analytics.analyticsLogEvent('sign_up', _analyticsParameter);
        AppRoutes.loginPage(
          context,
        );
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            height: 46,
            color: const Color(0xff313537),
            child: Center(
                child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 12),
                  child: Image(
                      width: 20,
                      height: 20,
                      image: AssetImage(ImageAssets.emailIcon)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    MemberPageStrings.loginButtonString,
                    style: TextStyles.white14BoldTextStyle,
                  ),
                ),
              ],
            )),
          )),
    );
  }
}

class SocialLogin {
  static Future<bool> login(BuildContext context, String loginType, String id,
      String password, String name,
      {Function onFail}) {
    signUpBloc.saveLoginType(loginType);
    signUpBloc.saveIdPassword(id, password);
    signUpBloc.saveName(name);

    final verifyBloc = VerifyEmailBloc();

    return verifyBloc
        .verifyEmail(
      id,
      loginType,
      password,
    )
        .then((isVerified) async {
      if (isVerified) {
        //first login
        final _analyticsParameter = <String, dynamic>{
          'method': loginType,
        };
        Analytics.analyticsLogEvent('sign_up', _analyticsParameter);
        Singleton.instance.userEmail = id;
        AppRoutes.companyCodePage(context);

        return true;
      } else {
        return await signUpBloc.saveInputValues().then((singUpResult) {
          if (singUpResult) {
            AppRoutes.firstMainPage(context);
            return true;
          } else {
            DialogWidget.buildDialog(
                context: context, title: '실패', subTitle1: '로그인에 실패하였습니다.');
            return false;
          }
        }).catchError((dynamic error) {
          print('verify email error $error');
          if (error.contains('error_msg')) {
            final Map<String, dynamic> map = json.decode(error);

            DialogWidget.buildDialog(
                context: context,
                title: '에러',
                subTitle1: map['error_msg'],
                onPressed: () {
                  if (map['error_code'] == 4012) {
                    final abloc = AuthEmailBloc();
                    print('auth userEmail === ${signUpBloc.getUserID()}');
                    abloc.authEmail(signUpBloc.getUserID()).then((retVal) {
                      if (retVal) {
                        AppRoutes.emailAuthPage(
                            context, signUpBloc.getUserID(), 'LOGIN');
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    if (onFail != null) {
                      onFail();
                    }
                    Navigator.of(context).pop();
                  }
                });
          } else {
            DialogWidget.buildDialog(
              context: context,
              subTitle1: '$error',
              title: '에러',
            );
          }

          // print('map ? ${error is Map}');
          // if (!(error is Map)) {
          //   DialogWidget.buildDialog(
          //       context: context,
          //       subTitle1: '$error',
          //       title: '에러',
          //       buttonTitle: '확인');
          // } else {
          //   DialogWidget.buildDialog(
          //       context: context,
          //       title: '에러',
          //       subTitle1: error['error_msg'],
          //       buttonTitle: '확인',
          //       onPressed: () {
          //         if (error['error_code'] == 4012) {
          //           final abloc = AuthEmailBloc();
          //           print('auth userEmail === ${signUpBloc.getUserID()}');
          //           abloc.authEmail(signUpBloc.getUserID()).then((retVal) {
          //             if (retVal) {
          //               AppRoutes.emailAuthPage(
          //                   context, signUpBloc.getUserID(), 'LOGIN');
          //             } else {
          //               Navigator.of(context).pop();
          //             }
          //           });
          //         } else {
          //           if (onFail != null) {
          //             onFail();
          //           }
          //           Navigator.of(context).pop();
          //         }
          //       });
          // }
        });
      }
      // return isVerified;
    }).catchError((dynamic error) {
      print('verify email error $error');
      if (error.contains('error_msg')) {
        final Map<String, dynamic> map = json.decode(error);

        DialogWidget.buildDialog(
          context: context,
          title: '에러',
          subTitle1: map['error_msg'],
        );
      } else {
        DialogWidget.buildDialog(
          context: context,
          subTitle1: '$error',
          title: '에러',
        );
      }
    });
  }
}
