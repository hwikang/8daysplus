import 'dart:convert';

class OrderProductOptionModel {
  OrderProductOptionModel({
    this.productId,
    this.optionId,
    this.optionItemId,
    this.amount,
    this.coverPrice,
    this.salePrice,
    this.optionName,
    this.optionItemName,
    this.timeSlotId,
    this.timeSlotValue,
    this.reserveDate,
  });

  factory OrderProductOptionModel.fromJson(Map<String, dynamic> json) {
    // print('is coverPrice int? = ${json['coverPrice'] is int}');
    // print('is salePrice int? = ${json['salePrice'] is int}');

    return OrderProductOptionModel(
      optionId: json['optionId'],
      optionItemId: json['optionItemId'],
      amount: json['amount'],
      salePrice: json['salePrice'],
      coverPrice: json['coverPrice'],
      optionName: json['optionName'],
      optionItemName: json['optionItemName'],
      timeSlotId: json['timeSlotId'],
      timeSlotValue: json['timeSlotValue'] ?? '',
    );
  }

  factory OrderProductOptionModel.fromOrderList(Map<String, dynamic> json) {
    // print('is coverPrice int? = ${json['coverPrice'] is int}');
    // print('is salePrice int? = ${json['salePrice'] is int}');

    return OrderProductOptionModel(
      optionId: json['optionId'],
      optionItemId: json['optionItemId'],
      amount: json['amount'],
      salePrice: json['salePrice'],
      coverPrice: json['coverPrice'],
      optionName: json['optionName'],
      optionItemName: json['optionItemName'],
      timeSlotValue: json['timeSlotValue'] ?? '',
    );
  }

  int amount;
  int coverPrice;
  String optionId;
  String optionItemId;
  String optionItemName;
  String optionName;
  String productId;
  String reserveDate;
  int salePrice;
  String timeSlotId;
  String timeSlotValue;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'optionId': json.encode(optionId),
        'optionItemId': json.encode(optionItemId),
        'amount': amount,
        'timeSlotId': json.encode(timeSlotId)
      };
}
