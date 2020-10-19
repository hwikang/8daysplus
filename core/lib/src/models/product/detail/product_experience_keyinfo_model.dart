import '../../../../core.dart';

class ProductExperienceKeyInfoModel {
  ProductExperienceKeyInfoModel(
      {this.label, this.name, this.value, this.coverImage});

  factory ProductExperienceKeyInfoModel.fromJson(Map<String, dynamic> json) {
    // final formatter = new NumberFormat('#,###');

    return ProductExperienceKeyInfoModel(
        label: json['label'],
        name: json['name'],
        value: json['value'],
        coverImage: ImageViewModel.fromJson(json['coverImage']));
  }

  ImageViewModel coverImage;
  String label;
  String name;
  String value;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'label': label,
        'name': name,
        'value': value,
      };
}
