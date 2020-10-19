import '../../core.dart';

class MainPageModel {
  MainPageModel({
    this.cursor,
    this.node,
  });

  factory MainPageModel.fromJson(Map<String, dynamic> json) {
    return MainPageModel(
        cursor: json['cursor'] ?? '', node: FeedModel.fromJson(json['node']));
  }

  String cursor;
  FeedModel node;
}
