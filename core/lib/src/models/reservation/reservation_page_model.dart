import 'order_list_model.dart';

class ReservationPageModel {
  ReservationPageModel({this.cursor, this.node});

  factory ReservationPageModel.fromJson(Map<String, dynamic> json) {
    return ReservationPageModel(
        cursor: json['cursor'],
        node: OrderListViewModel.fromJson(json['node']));
  }

  String cursor;
  OrderListViewModel node;
}
