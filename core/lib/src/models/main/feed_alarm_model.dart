import '../../../core.dart';

class FeedMainAlarmModel {
  FeedMainAlarmModel({
    this.actionLink,
    this.message,
    this.id,
    this.createdAt,
    this.name,
    this.type,
  });

  factory FeedMainAlarmModel.fromJson(Map<String, dynamic> json) {
    // print('promotion $json');

    return FeedMainAlarmModel(
      actionLink: ActionLinkModel.fromJson(json['actionLink']),
      message: MessageModel.fromJson(json['message']),
      createdAt: json['createdAt'],
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }

  ActionLinkModel actionLink;
  String createdAt;
  String id;
  MessageModel message;
  String name;
  String type;
}

class MessageModel {
  MessageModel({
    this.coverImage,
    this.name,
    this.price,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        coverImage: ImageViewModel.fromJson(json['imageInfo']),
        name: json['name'],
        price: json['price']);
  }

  ImageViewModel coverImage;
  String name;
  int price;
}
