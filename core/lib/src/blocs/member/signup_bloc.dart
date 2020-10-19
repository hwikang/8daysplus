import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/singleton.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../providers/member/signup_provider.dart';
import '../../utils/save_user_info.dart';

enum SignUpStateEvent { Normal, Logging, Success, Failed, Loading }

class SignUpBloc {
  SignUpBloc({@required this.signUpProvider}) {
    addTermAll(false);
  }

  final SignUpProvider signUpProvider;

  final BehaviorSubject<String> _corpCodeController = BehaviorSubject<String>();
  final BehaviorSubject<String> _countryCodeController =
      BehaviorSubject<String>();

  //inputs
  final BehaviorSubject<String> _idController = BehaviorSubject<String>();
  final BehaviorSubject<String> _loginTypeController =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _phoneController = BehaviorSubject<String>();

  //terms
  final BehaviorSubject<bool> termAllController = BehaviorSubject<bool>();
  final BehaviorSubject<bool> termLocationController = BehaviorSubject<bool>();
  final BehaviorSubject<bool> termMarketingController = BehaviorSubject<bool>();
  final BehaviorSubject<bool> termPrivateController = BehaviorSubject<bool>();
  final BehaviorSubject<bool> termServiceController = BehaviorSubject<bool>();

  void saveIdPassword(String id, String password) {
    _idController.add(id);
    _passwordController.add(password);
  }

  void saveCorpCode(String code) {
    _corpCodeController.add(code);
  }

  void saveLoginType(String type) {
    _loginTypeController.add(type);
  }

  void saveName(String name) {
    _nameController.add(name);
  }

  void savePhone(String phone) {
    _phoneController.add(phone);
  }

  void saveCountryCode(String countryCode) {
    _countryCodeController.add(countryCode);
  }

  String getLoginType() {
    return _loginTypeController.stream.value;
  }

  String getCorpCode() {
    return _corpCodeController.value;
  }

  String getUserID() {
    return _idController.value;
  }

  Future<bool> saveInputValues() {
    final signUpmodel = SignUpModel(
        email: _idController.value,
        password: _passwordController.value,
        companyId: _corpCodeController.value ?? '',
        loginType: _loginTypeController.value,
        name: _nameController.value,
        deviceInfo: DeviceInfoModel(
          uuid: Singleton.instance.sUUID,
          os: Singleton.instance.sPlatform,
          av: Singleton.instance.appVersion,
          osVer: Singleton.instance.osVer,
          deviceModel: Singleton.instance.deviceModel,
        ),
        countryCode: _countryCodeController.value ?? '+82',
        mobile: _phoneController.value ?? '',
        marketingAlarm: termMarketingController.value ?? false);

    return signUp(signUpmodel).then((data) {
      print('result sign up ${data.userID}');
      saveUserInfo(data);
      return true;
    });
  }

  Future<AuthModel> signUp(SignUpModel signUpmodel) {
    return signUpProvider
        .signUpProvider(signUpmodel)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  void addTermAll(bool value) {
    print('value $value');
    termAllController.add(value);
    termServiceController.add(value);
    termPrivateController.add(value);
    termLocationController.add(value);
    termMarketingController.add(value);
  }

  void addTermService(bool value) => termServiceController.add(value);
  void addTermPrivate(bool value) => termPrivateController.add(value);
  void addTermLocation(bool value) => termLocationController.add(value);
  void addTermMarketing(bool value) => termMarketingController.add(value);

  bool termRequired() {
    if (termServiceController.value &&
        termLocationController.value &&
        termPrivateController.value) {
      return true;
    }

    return false;
  }

  bool termMarketting() {
    if (termMarketingController.value != null) {
      if (termMarketingController.value) {
        return true;
      }
    }
    return false;
  }

  void dispose() {
    _idController.close();
    _passwordController.close();
    _nameController.close();
    _corpCodeController.close();
    _phoneController.close();
    _loginTypeController.close();

    termAllController.close();
    termLocationController.close();
    termPrivateController.close();
    termMarketingController.close();
    termServiceController.close();
  }
}

//global instance
final SignUpBloc signUpBloc = SignUpBloc(signUpProvider: SignUpProvider());
