import 'dart:convert';

import 'package:flutter/foundation.dart';

class AuthEmailModel {
  AuthEmailModel({
    @required this.email,
  });

  String email;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': json.encode(email),
      };
}
