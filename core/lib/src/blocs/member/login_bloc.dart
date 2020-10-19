import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mobile/utils/singleton.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../utils/save_user_info.dart';
import 'validators.dart';

class LoginBloc with Validators {
  LoginBloc({@required this.loginProvider});

  final LoginProvider loginProvider;
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<int> _errorCodeController = BehaviorSubject<int>();
  final BehaviorSubject<String> _errorMessageController =
      BehaviorSubject<String>();

  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<AuthModel> _repoData = BehaviorSubject<AuthModel>();
  final BehaviorSubject<StateEvent> _stateController =
      BehaviorSubject<StateEvent>();

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Function(StateEvent) get dispatchStateEvent => _stateController.sink.add;

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<StateEvent> get loginState =>
      _stateController.stream.transform(validateState);

  String getUserEmail() {
    return _emailController.value;
  }

  void saveErrorMessage(String msg) {
    _errorMessageController.add(msg);
  }

  String getErrorMsg() {
    return _errorMessageController.value;
  }

  void saveErrorCode(int code) {
    _errorCodeController.add(code);
  }

  int getErrorCode() {
    return _errorCodeController.value;
  }

  Future<bool> submit() {
    dispatchStateEvent(StateEvent.Logging);

    final validEmail = _emailController.value.trim();
    final validPassword = _passwordController.value;

    final loginWhere = AuthLoginWhere(
        email: validEmail, password: validPassword, userType: 'EMPLOYEE');

    final deviceInfoModel = DeviceInfoModel(
      uuid: Singleton.instance.sUUID,
      os: Singleton.instance.sPlatform,
      av: Singleton.instance.appVersion,
      osVer: Singleton.instance.osVer,
      deviceModel: Singleton.instance.deviceModel,
    );

    return login(loginWhere, deviceInfoModel).then((data) {
      dispatchStateEvent(StateEvent.Success);
      _repoData.add(data);
      saveUserInfo(data);
      return true;
    });
  }

  Future<AuthModel> login(AuthLoginWhere where, DeviceInfoModel input) {
    return loginProvider
        .login(where, input)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  void dispose() {
    print('dispose call');
    _repoData.close();
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _errorMessageController.close();
  }
}
