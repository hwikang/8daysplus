import '../../../core.dart';

class NoticeEventModel {
  NoticeEventModel({
    this.createdAt,
    this.endDate,
    this.footerMessage,
    this.id,
    this.imageActionLinks,
    this.startDate,
    this.title,
    this.updatedAt,
  });

  factory NoticeEventModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imageActionLinkJson = json['imageActionLinks'];
    final imageActionLinks = imageActionLinkJson.map((dynamic json) {
      return ImageActionLinkModel.fromJson(json);
    }).toList();

    return NoticeEventModel(
      id: json['id'],
      title: json['title'],
      footerMessage: json['footerMessage'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      imageActionLinks: imageActionLinks,
    );
  }
  Map toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  String createdAt;
  String endDate;
  String footerMessage;
  String id;
  List<ImageActionLinkModel> imageActionLinks;
  String startDate;
  String title;
  String updatedAt;
}
