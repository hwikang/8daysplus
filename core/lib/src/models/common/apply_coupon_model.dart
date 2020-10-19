class ApplyCouponModel {
  ApplyCouponModel({
    this.status,
    this.message,
  });

  factory ApplyCouponModel.fromJson(Map<String, dynamic> json) {
    return ApplyCouponModel(
      status: json['status'],
      message: json['message'],
    );
  }

  String message;
  bool status;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'status': status,
        'message': message,
      };
}
