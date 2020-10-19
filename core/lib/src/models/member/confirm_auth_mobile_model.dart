import 'dart:convert';

class ConfirmAuthSmsModel {
  ConfirmAuthSmsModel({
    this.countryCode,
    this.mobile,
    this.verifyCode,
  });

  String countryCode;
  String mobile;
  String verifyCode;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'countryCode': json.encode(countryCode),
        // 'mobile': mobile,
        'mobile': json.encode(mobile),
        'verifyCode': json.encode(verifyCode),
      };
}
