import '../../../core.dart';

class FeedMainPopupModel {
  FeedMainPopupModel({
    this.actionLink,
    this.coverImage,
    this.id,
    this.name,
    this.positionType,
  });

  factory FeedMainPopupModel.fromJson(Map<String, dynamic> json) {
    // print('promotion $json');

    return FeedMainPopupModel(
      coverImage: ImageViewModel.fromJson(json['coverImage']),
      actionLink: ActionLinkModel.fromJson(json['actionLink']),
      id: json['id'],
      name: json['name'],
      positionType: json['positionType'],
    );
  }

  ActionLinkModel actionLink;
  ImageViewModel coverImage;
  String id;
  String name;
  String positionType;
}
