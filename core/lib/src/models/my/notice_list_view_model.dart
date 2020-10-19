import '../../../core.dart';

class NoticeListViewModel {
  NoticeListViewModel(
      {this.id,
      this.createdAt,
      this.title,
      this.type,
      this.message,
      this.images});

  factory NoticeListViewModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> edges = json['images'];
    final images =
        edges.map((image) => ImageViewModel.fromJson(image)).toList();
    return NoticeListViewModel(
      id: json['id'],
      createdAt: json['createdAt'],
      title: json['title'],
      type: json['type'],
      message: json['message'],
      images: images,
    );
  }

  String createdAt;
  String id;
  List<ImageViewModel> images;
  String message;
  String title;
  String type;
}
