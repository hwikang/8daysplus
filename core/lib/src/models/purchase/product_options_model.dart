import '../../../core.dart';

class ProductOptionsModel {
  ProductOptionsModel({
    this.id,
    this.name,
    this.summary,
    this.timeSlots,
    this.optionItems,
  });

  factory ProductOptionsModel.fromJson(Map<String, dynamic> json) {
    List<ProductOptionItemsModel> optionItemList;
    final List<dynamic> list = json['optionItems'];
    optionItemList = list.map((dynamic item) {
      return ProductOptionItemsModel.fromJson(item);
    }).toList();

    // List<ProductPurchaseTimeSlotModel> timeSlotList;
    // var list2 = json['timeSlots'] as List;
    // timeSlotList= list2.map((dynamic item){

    //   return ProductPurchaseTimeSlotModel.fromJson(item);
    // }).toList();

    return ProductOptionsModel(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      // timeSlots: timeSlotList,
      timeSlots: json['timeSlots'],
      optionItems: optionItemList,
    );
  }

  String id;
  String name;
  List<ProductOptionItemsModel> optionItems;
  String summary;
  // List<ProductPurchaseTimeSlotModel> timeSlots;
  List<dynamic> timeSlots;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'summary': summary,
        'timeSlots': timeSlots,
        'optionItems': optionItems,
      };
}
