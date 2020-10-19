import 'dart:convert';

import 'package:meta/meta.dart';

import '../../../core.dart';
import 'token_model.dart';

class AuthModel {
  AuthModel({
    @required this.userID,
    @required this.token,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> map) {
    return AuthModel(
        userID: map['userId'],
        token: TokenModel(
          accessToken: map['token']['accessToken'],
          refreshToken: map['token']['refreshToken'],
          refreshTokenExpireTime: map['token']['refreshTokenExpireTime'],
        ),
        user: map['user'] != null
            ? UserModel.fromJson(map['user'])
            : UserModel());
  }

  TokenModel token;
  UserModel user;
  String userID;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'userId': userID,
        'token': token,
      };
}

// Mutation model
class AuthLoginWhere {
  const AuthLoginWhere({
    @required this.email,
    @required this.password,
    @required this.userType,
  });

  final String email;
  final String password;
  final String userType;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': json.encode(email),
        'password': json.encode(password),
        'userType': userType
      };
}
