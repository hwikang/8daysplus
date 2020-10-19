import '../../../core.dart';

class CategoryModel {
  const CategoryModel(
      {this.id = '',
      this.name = '',
      this.summary,
      this.type,
      this.searchType,
      this.childCount,
      this.coverImage,
      this.nodes,
      this.priceRangeModel,
      this.isTail = false});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<CategoryModel> nodeList;
    final List<dynamic> list = json['nodes'];
    if (list != null) {
      nodeList =
          list.map((dynamic item) => CategoryModel.fromJson(item)).toList();
      // print('nodeList $nodeList');
    }
    return CategoryModel(
        id: json['id'],
        name: json['name'],
        summary: json['summary'],
        type: json['type'],
        searchType: json['searchType'],
        childCount: json['childCount'],
        coverImage: json['coverImage'] == null
            ? null
            : ImageViewModel.fromJson(json['coverImage']),
        nodes: nodeList,
        priceRangeModel: json['value'] == null
            ? null
            : PriceRangeModel.fromJson(json['value']),
        isTail: json['isTail']);
  }

  final int childCount;
  final ImageViewModel coverImage;
  final String id;
  final bool isTail;
  final String name;
  final List<CategoryModel> nodes;
  final PriceRangeModel priceRangeModel;
  final String searchType;
  final String summary;
  final String type;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'coverImage': coverImage.toJSON(),
        'nodes': nodes,
      };
}
