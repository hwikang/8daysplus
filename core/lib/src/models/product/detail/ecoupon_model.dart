import '../../../../core.dart';

class EcouponModel {
  EcouponModel({
    this.id = '',
    this.notice = '',
    this.refund = '',
    this.howtouse = '',
    this.options,
    this.productOrderType,
  });

  factory EcouponModel.fromJson(Map<String, dynamic> json) {
    print('ecoupon options = ${json['options']}');

    final List<dynamic> optionsJson = json['options'];
    final options = optionsJson.map((dynamic option) {
      print(option);
      return ProductOptionsModel.fromJson(option);
    }).toList();
    print(options);
    return EcouponModel(
        id: json['id'],
        notice: json['notice'],
        refund: json['refund'],
        howtouse: json['howtouse'],
        productOrderType: json['productOrderType'],
        options: options);
  }

  factory EcouponModel.orderListFromJson(Map<String, dynamic> json) {
    return EcouponModel(refund: json['refund']);
  }

  String howtouse;
  String id;
  String notice;
  List<ProductOptionsModel> options;
  String productOrderType;
  String refund;

  Map<String, dynamic> toJSON() {
    final List<dynamic> optionList = options.map((option) {
      option.toJSON();
    }).toList();
    return <String, dynamic>{
      'id': id,
      'notice': notice,
      'refund': refund,
      'howtouse': howtouse,
      'options': optionList
    };
  }
}
