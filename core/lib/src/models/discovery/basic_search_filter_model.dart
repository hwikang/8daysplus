import '../../../core.dart';

class BasicSearchFilterModel {
  BasicSearchFilterModel({this.orderBy, this.priceRange});

  factory BasicSearchFilterModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> orderbyJson = json['orderby'];
    final List<dynamic> priceRangeJson = json['priceRange'];

    final orderByList = orderbyJson.map((dynamic json) {
      return OrderByModel.fromJson(json);
    }).toList();

    final priceRangeList = priceRangeJson.map((dynamic json) {
      return PriceRangeModel.fromJson(json);
    }).toList();

    return BasicSearchFilterModel(
        orderBy: orderByList, priceRange: priceRangeList);
  }

  List<OrderByModel> orderBy;
  List<PriceRangeModel> priceRange;
}
