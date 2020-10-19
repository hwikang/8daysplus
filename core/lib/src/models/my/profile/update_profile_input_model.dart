import 'dart:convert';

class UpdateProfileInputModel {
  UpdateProfileInputModel(
      {this.name,
      this.birthDay,
      this.birthMonth,
      this.birthYear,
      this.mobile,
      this.countryCode});

  String birthDay;
  String birthMonth;
  String birthYear;
  String countryCode;
  String mobile;
  String name;

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'name': json.encode(name),
      'birthYear': json.encode(birthYear),
      'birthMonth': json.encode(birthMonth),
      'birthDay': json.encode(birthDay),
      'mobile': json.encode(mobile),
      'countryCode': json.encode(countryCode),
    };
  }
}
