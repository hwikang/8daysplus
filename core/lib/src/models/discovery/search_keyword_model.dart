import '../../../core.dart';

class SearchKeywordModel {
  SearchKeywordModel({this.bestKeywords, this.recentKeywords, this.products});

  factory SearchKeywordModel.fromJson(Map<String, dynamic> json) {
    List<ProductListViewModel> productList;
    final List<dynamic> jsonList = json['products'];
    productList = jsonList.map((dynamic product) {
      return ProductListViewModel.fromJson(product);
    }).toList();

    return SearchKeywordModel(
        bestKeywords: json['bestKeywords'].cast<String>(),
        recentKeywords: json['recentKeywords'].cast<String>(),
        products: productList);
  }

  List<String> bestKeywords;
  List<ProductListViewModel> products;
  List<String> recentKeywords;
}
