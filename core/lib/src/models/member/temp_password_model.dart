import 'dart:convert';

import 'package:meta/meta.dart';

// Mutation model
class FindPasswordInput {
  FindPasswordInput({
    @required this.email,
    @required this.userType,
  });

  final String email;
  final String userType;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': json.encode(email),
        'userType': userType,
      };
}
