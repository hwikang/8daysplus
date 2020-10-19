import '../purchase/create_order_input_model.dart';

class OrderListViewModel {
  OrderListViewModel(
      {this.id,
      this.paymentPrice,
      this.totalPrice,
      this.orderPrice,
      this.couponPrice,
      this.paymentMethod,
      this.orderCode,
      this.orderDate,
      this.pointPrice,
      this.orderInfo,
      this.quota});

  factory OrderListViewModel.fromJson(Map<String, dynamic> json) {
    return OrderListViewModel(
      id: json['id'],
      paymentPrice: json['paymentPrice'],
      totalPrice: json['totalPrice'],
      orderPrice: json['orderPrice'],
      couponPrice: json['couponPrice'],
      paymentMethod: json['paymentMethod'],
      orderCode: json['orderCode'],
      pointPrice: json['pointPrice'],
      orderDate: json['orderDate'],
      orderInfo: CreateOrderInputModel.fromOrderList(json['orderInfo']),
    );
  }

  factory OrderListViewModel.fromJsonOnPaymentSuccess(
      Map<String, dynamic> json) {
    return OrderListViewModel(
        id: json['id'],
        totalPrice: json['totalPrice'],
        paymentPrice: json['paymentPrice'],
        couponPrice: json['couponPrice'],
        paymentMethod: json['paymentMethod'],
        orderCode: json['orderCode'],
        pointPrice: json['pointPrice'],
        orderDate: json['orderDate'],
        orderInfo: CreateOrderInputModel.fromOrderList(json['orderInfo']),
        quota: json['quota']);
  }

  int couponPrice;
  String id;
  String orderCode;
  String orderDate;
  CreateOrderInputModel orderInfo;
  int orderPrice;
  String paymentMethod;
  int paymentPrice;
  int pointPrice;
  String quota;
  int totalPrice;

  Map toJson() {
    return {
      'id': id,
      'totalPrice': totalPrice,
      'paymentPrice': paymentPrice,
      'couponPrice': couponPrice,
      'paymentMethod': paymentMethod,
      'orderCode': orderCode,
      'pointPrice': pointPrice,
      'orderDate': orderDate,
      'orderInfo': orderInfo.toJson(),
    };
  }
}
