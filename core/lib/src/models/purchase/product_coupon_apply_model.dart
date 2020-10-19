import '../../../core.dart';

class CouponApplyModel {
  CouponApplyModel({
    this.id,
    this.name,
    this.summary,
    this.discountUnit,
    this.coverImage,
    this.discountMax,
    this.discountAmount,
    this.remainDay,
    this.expireDate,
    this.availableMinPrice,
  });

  factory CouponApplyModel.fromJson(Map<String, dynamic> json) {
    return CouponApplyModel(
        id: json['id'],
        name: json['name'],
        summary: json['summary'],
        coverImage: ImageViewModel.fromJson(json['coverImage']),
        discountUnit: json['discountUnit'],
        discountMax: json['discountMax'],
        discountAmount: json['discountAmount'],
        remainDay: json['remainDay'],
        expireDate: json['expireDate'],
        availableMinPrice: json['availableMinPrice'] ?? 0);
  }

  int availableMinPrice;
  ImageViewModel coverImage;
  int discountAmount;
  int discountMax;
  String discountUnit;
  String expireDate;
  String id;
  String name;
  int remainDay;
  String summary;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'summary': summary,
        'coverImage': coverImage,
        'discountUnit': discountUnit,
        'discountMax': discountMax,
        'discountAmount': discountAmount,
      };
}
