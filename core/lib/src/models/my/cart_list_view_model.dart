import '../../../core.dart';

class CartListViewModel {
  CartListViewModel({
    this.createdAt,
    this.id,
    this.productId,
    this.orderProduct,
  });

  factory CartListViewModel.fromJson(Map<String, dynamic> json) {
    return CartListViewModel(
      id: json['id'],
      createdAt: json['createdAt'],
      productId: json['productId'],
      orderProduct: OrderInfoProductModel.fromJson(json['orderProduct']),
    );
  }

  String createdAt;
  String id;
  OrderInfoProductModel orderProduct;
  String productId;
}
