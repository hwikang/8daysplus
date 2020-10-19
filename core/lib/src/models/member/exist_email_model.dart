import 'dart:convert';

import 'package:flutter/foundation.dart';

class ExistsEmailModel {
  ExistsEmailModel({
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
