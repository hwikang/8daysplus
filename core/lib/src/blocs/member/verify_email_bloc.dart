// import 'dart:js';

import 'package:mobile/utils/singleton.dart';

import '../../../core.dart';

enum VerifyEmailEventState {
  Normal,
  Logging,
  Success,
  Failed,
}

class VerifyEmailBloc {
  VerifyEmailProvider verifyEmailProvider = VerifyEmailProvider();

  // final BehaviorSubject<String> _errMessageController =
  //     BehaviorSubject<String>();

  // final BehaviorSubject<VerifyEmailEventState> _eventStateController =
  //     BehaviorSubject<VerifyEmailEventState>();

  // final BehaviorSubject<String> _verifyEmailController =
  //     BehaviorSubject<String>();

  // Observable<String> get verifyEmailStream => _verifyEmailController.stream;

  // Observable<VerifyEmailEventState> get eventState =>
  //     _eventStateController.stream;

  // Observable<VerifyEmailEventState> get errMessage =>
  //     _eventStateController.stream;

  // void changeState(VerifyEmailEventState state) =>
  //     _eventStateController.add(state);

  // void dispose() {
  // _verifyEmailController.close();
  // _errMessageController.close();
  // _eventStateController.close();
  // }

  Future<bool> verifyEmail(
    String email,
    String loginType,
    String codeKey,
  ) {
    // _eventStateController.add(VerifyEmailEventState.Logging);
    email = email.trim();

    final model = VerifyEmailModel(
      email: email,
      userType: 'EMPLOYEE',
      deviceInfo: DeviceInfoModel(
        uuid: Singleton.instance.sUUID,
        os: Singleton.instance.sPlatform,
        av: Singleton.instance.appVersion,
        osVer: Singleton.instance.osVer,
        deviceModel: Singleton.instance.deviceModel,
      ),
      loginType: loginType,
      codeKey: codeKey,
    );

    return verifyEmailProvider.verifyEmail(model).then((result) {
      print('verify sns $result');
      return result;
    }).catchError((exception) => {ExceptionHandler.handleError(exception)});

    // return retVal;
  }
}
