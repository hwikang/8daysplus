class ProductOrderInfosModel {
  ProductOrderInfosModel({
    this.id,
    this.optionId,
    this.optionItemId,
    this.optionTimeslotId,
    this.amount,
    this.useDate,
    this.coverPrice,
    this.salePrice,
    this.discountRate,
  });

  factory ProductOrderInfosModel.fromJson(Map<String, dynamic> json) {
    return ProductOrderInfosModel(
      id: json['id'],
      optionId: json['optionId'],
      optionItemId: json['optionItemId'],
      optionTimeslotId: json['optionTimeslotId'],
      amount: json['amount'],
      useDate: json['useDate'],
      coverPrice: json['coverPrice'],
      salePrice: json['salePrice'],
      discountRate: json['discountRate'],
    );
  }

  int amount;
  int coverPrice;
  int discountRate;
  String id;
  String optionId;
  String optionItemId;
  String optionTimeslotId;
  int salePrice;
  String useDate;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'optionId': optionId,
        'optionItemId': optionItemId,
        'optionTimeslotId': optionTimeslotId,
        'amount': amount,
        'useDate': useDate,
        'coverPrice': coverPrice,
        'salePrice': salePrice,
        'discountRate': discountRate,
      };
}
