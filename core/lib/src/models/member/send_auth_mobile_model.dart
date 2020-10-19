import 'dart:convert';

class SendAuthMobileModel {
  SendAuthMobileModel({
    this.countryCode,
    this.mobile,
  });

  String countryCode;
  String mobile;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'countryCode': json.encode(countryCode),
        // 'mobile': mobile,
        'mobile': json.encode(mobile),
      };
}
