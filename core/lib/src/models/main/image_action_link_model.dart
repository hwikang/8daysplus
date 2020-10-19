// coverImage: ImageInfo!
// actionLink: ActionLink!

import '../../../core.dart';

class ImageActionLinkModel {
  ImageActionLinkModel({this.coverImage, this.actionLink});

  factory ImageActionLinkModel.fromJson(Map<String, dynamic> json) =>
      ImageActionLinkModel(
        coverImage: ImageViewModel.fromJson(json['coverImage']),
        actionLink: ActionLinkModel.fromJson(json['actionLink']),
      );

  ActionLinkModel actionLink;
// coverImage: ImageInfo!
// actionLink: ActionLink!

  ImageViewModel coverImage;
}
