import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core.dart';

class SignUpModel {
  SignUpModel({
    @required this.email,
    @required this.password,
    @required this.name,
    this.birthDay = '',
    this.birthMonth = '',
    this.birthYear = '',
    @required this.deviceInfo,
    @required this.companyId,
    @required this.loginType,
    @required this.mobile,
    @required this.countryCode,
    this.marketingAlarm,
  }) {
    // devideBirthDay(this.birthDay);
  }

  String birthDay;
  String birthMonth;
  String birthYear;
  String companyId;
  String countryCode;
  DeviceInfoModel deviceInfo;
  String email;
  String loginType;
  bool marketingAlarm;
  String mobile;
  String name;
  String password;

  // void devideBirthDay(String birthDay) {
  //   String year = birthDay.substring(0, 2);
  //   //1950~ 2049
  //   if (int.parse(year) >= 50) {
  //     this.birthYear = '19$year';
  //   } else {
  //     this.birthYear = '20$year';
  //   }
  //   this.birthMonth = birthDay.substring(2, 4);
  //   this.birthDay = birthDay.substring(4, 6);
  // }

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': json.encode(email),
        'password': json.encode(password),
        'name': json.encode(name),
        'birthYear': json.encode(birthYear),
        'birthMonth': json.encode(birthMonth),
        'birthDay': json.encode(birthDay),
        'deviceInfo': deviceInfo.toJSON(),
        // 'companyId': json.encode(companyId),
        'companyCode': json.encode(companyId),
        // 'loginType': 'EMAIL'
        'loginType': loginType,
        'userType': 'EMPLOYEE',

        'mobile': json.encode(mobile),

        'countryCode': json.encode(countryCode),
        'marketingAlarm': marketingAlarm ?? false
      };
}
