import 'dart:convert';

class CreateRefundModel {
  CreateRefundModel({this.orderCode, this.orderItemCode, this.reason});

  String orderCode;
  String orderItemCode;
  String reason;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'orderCode': json.encode(orderCode),
        'orderItemCode': json.encode(orderItemCode),
        'reason': json.encode(reason),
      };
}
