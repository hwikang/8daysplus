class OrderRefundModel {
  OrderRefundModel(
      {this.cancelDate,
      this.paymentMethod,
      this.productPrice,
      this.reason,
      this.refundCouponPrice,
      this.refundPointPrice,
      this.refundPrice});

  factory OrderRefundModel.fromJson(Map<String, dynamic> json) {
    return OrderRefundModel(
      cancelDate: json['cancelDate'],
      paymentMethod: json['paymentMethod'],
      productPrice: json['productPrice'],
      reason: json['reason'],
      refundCouponPrice: json['refundCouponPrice'],
      refundPointPrice: json['refundPointPrice'],
      refundPrice: json['refundPrice'],
    );
  }

  String cancelDate;
  String paymentMethod;
  int productPrice;
  String reason;
  int refundCouponPrice;
  int refundPointPrice;
  int refundPrice;
}
