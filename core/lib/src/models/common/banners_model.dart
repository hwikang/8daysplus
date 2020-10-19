import '../../../core.dart';

class BannersModel {
  BannersModel({
    this.id,
    this.name,
    this.coverImage,
    this.actionLink,
    this.positionType,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    return BannersModel(
      id: json['id'],
      name: json['name'],
      coverImage: ImageViewModel.fromJson(json['coverImage']),
      actionLink: ActionLinkModel.fromJson(json['actionLink']),
      positionType: json['positionType'],
    );
  }

  ActionLinkModel actionLink;
  ImageViewModel coverImage;
  String id;
  String name;
  String positionType;
}
