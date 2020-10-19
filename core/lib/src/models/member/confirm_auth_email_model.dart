import 'dart:convert';

import 'package:flutter/foundation.dart';

class ConfirmEmailModel {
  ConfirmEmailModel({
    @required this.email,
    @required this.userType,
  });

  String email;
  String userType;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': json.encode(email),
        'userType': userType,
      };
}
