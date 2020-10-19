class ProductOptionItemsModel {
  ProductOptionItemsModel(
      {this.id,
      this.name,
      this.coverPrice,
      this.salePrice,
      this.category,
      this.cnt,
      this.maxBuyItem,
      this.minBuyItem});

  factory ProductOptionItemsModel.fromJson(Map<String, dynamic> json) {
    // final formatter = new NumberFormat('#,###');

    return ProductOptionItemsModel(
      id: json['id'],
      name: json['name'],
      // coverPrice: formatter.format(json['coverPrice']),
      // salePrice: formatter.format(json['salePrice']),
      category: json['category'],
      cnt: json['cnt'],
      coverPrice: json['coverPrice'],
      salePrice: json['salePrice'],
      minBuyItem: json['minBuyItem'],
      maxBuyItem: json['maxBuyItem'],
    );
  }

  String category;
  int cnt;
  int coverPrice;
  String id;
  int maxBuyItem;
  int minBuyItem;
  String name;
  int salePrice;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'coverPrice': coverPrice,
        'salePrice': salePrice,
        'category': category,
        'cnt': cnt,
        'minBuyItem': minBuyItem,
        'maxBuyItem': maxBuyItem
      };
}
