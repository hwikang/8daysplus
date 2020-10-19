class TokenModel {
  TokenModel({
    this.accessToken,
    this.refreshToken,
    this.refreshTokenExpireTime,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        refreshTokenExpireTime: json['refreshTokenExpireTime'] ?? 0,
      );

  String accessToken;
  String refreshToken;
  int refreshTokenExpireTime;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'refreshTokenExpireTime': refreshTokenExpireTime,
      };
}
