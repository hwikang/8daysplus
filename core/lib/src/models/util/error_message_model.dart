class ErrorMessageModel {
  ErrorMessageModel(
      {this.errorCode,
      this.errorMsg,
      this.message,
      this.statusCode,
      this.createdAt});

  factory ErrorMessageModel.fromJSON(Map<String, dynamic> json) {
    return ErrorMessageModel(
        errorCode: json['error_code'],
        errorMsg: json['error_msg'],
        message: json['message'],
        statusCode: json['status_code'],
        createdAt: json['created_at']);
  }

  int createdAt;
  int errorCode;
  String errorMsg;
  String message;
  int statusCode;
}
