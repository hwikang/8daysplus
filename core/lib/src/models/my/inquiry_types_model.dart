class InquiryTypeModel {
  InquiryTypeModel({
    this.name,
    this.type,
  });

  factory InquiryTypeModel.fromJson(Map<String, dynamic> json) {
    return InquiryTypeModel(
      name: json['name'],
      type: json['type'],
    );
  }

  String name;
  String type;
}
