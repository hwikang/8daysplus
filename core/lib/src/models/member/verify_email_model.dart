import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core.dart';

class VerifyEmailModel {
  VerifyEmailModel(
      {@required this.email,
      @required this.userType,
      @required this.loginType,
      @required this.codeKey,
      @required this.deviceInfo});

  String codeKey;
  DeviceInfoModel deviceInfo;
  String email;
  String loginType;
  String userType;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': json.encode(email),
        'userType': userType,
        'loginType': loginType,
        'codeKey': json.encode(codeKey),
        'deviceInfo': deviceInfo.toJSON()
      };
}
