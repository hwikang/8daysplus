class FaqModel {
  FaqModel({
    this.id,
    this.title,
    this.type,
    this.message,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      message: json['message'],
    );
  }

  String id;
  String message;
  String title;
  String type;
}

class FaqTypeModel {
  FaqTypeModel({this.type, this.name});

  factory FaqTypeModel.fromJson(Map<String, dynamic> json) {
    return FaqTypeModel(type: json['type'], name: json['name']);
  }

  String name;
  String type;
}
