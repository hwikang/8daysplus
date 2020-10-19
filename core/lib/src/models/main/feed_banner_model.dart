import '../../../core.dart';

class FeedBannerModel {
  FeedBannerModel(
      {this.actionLink,
      this.coverImage,
      this.id,
      this.name,
      this.positionType});

  factory FeedBannerModel.fromJson(Map<String, dynamic> json) {
    return FeedBannerModel(
        actionLink: ActionLinkModel.fromJson(json['actionLink']),
        coverImage: ImageViewModel.fromJson(json['coverImage']),
        id: json['id'],
        name: json['name'],
        positionType: json['positionType']);
  }

  ActionLinkModel actionLink;
  ImageViewModel coverImage;
  String id;
  String name;
  String positionType;
}
