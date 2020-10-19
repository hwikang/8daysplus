import '../reservation/order_list_model.dart';

class MyOrderPageModel {
  MyOrderPageModel({this.cursor, this.day, this.nodes});

  factory MyOrderPageModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> nodesJson = json['nodes'];
    final nodes =
        nodesJson.map((node) => OrderListViewModel.fromJson(node)).toList();
    // print('MyOrderPageModel $json');
    return MyOrderPageModel(
        cursor: json['cursor'], day: json['day'], nodes: nodes);
  }

  String cursor;
  String day;
  List<OrderListViewModel> nodes;
}
