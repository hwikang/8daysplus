import '../../../core.dart';

class FeedPromotionModel {
  FeedPromotionModel({
    this.actionLink,
    this.coverImage,
    this.id,
    this.name,
    this.type,
    this.summary,
    this.product,
  });

  factory FeedPromotionModel.fromJson(Map<String, dynamic> json) {
    print('promotion $json');
    final List<dynamic> list = json['products'];
    final products = list.map((dynamic product) {
      return ProductListViewModel.fromJson(product);
    }).toList();
    return FeedPromotionModel(
        coverImage: ImageViewModel.fromJson(json['coverImage']),
        actionLink: ActionLinkModel.fromJson(json['actionLink']),
        id: json['id'],
        name: json['name'],
        summary: json['summary'],
        type: json['type'],
        product: products);
  }

  ActionLinkModel actionLink;
  ImageViewModel coverImage;
  String id;
  String name;
  List<ProductListViewModel> product;
  String summary;
  String type;
}
