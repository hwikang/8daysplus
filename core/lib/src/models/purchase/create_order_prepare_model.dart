import '../../../core.dart';

class CreateOrderPrepareModel {
  CreateOrderPrepareModel({this.orderId, this.orderInfo});

  factory CreateOrderPrepareModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderPrepareModel(
        orderId: json['orderId'],
        orderInfo: CreateOrderInputModel.fromJson(json['orderInfo']));
  }

  String orderId;
  CreateOrderInputModel orderInfo;
}
