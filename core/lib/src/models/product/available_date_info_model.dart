class AvailableDateInfoModel {
  const AvailableDateInfoModel({
    this.color = '',
    this.name = '',
  });

  factory AvailableDateInfoModel.fromJson(Map<String, dynamic> json) {
    return AvailableDateInfoModel(
        color: json['color'] ?? '', name: json['name'] ?? '');
  }

  final String color;
  final String name;
}
