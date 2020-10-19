class ContentModel {
  ContentModel({this.id = '', this.period = '', this.place = ''});

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
        id: json['id'] ?? '',
        period: json['period'] ?? '',
        place: json['place'] ?? '');
  }

  String id;
  String period;
  String place;
}
