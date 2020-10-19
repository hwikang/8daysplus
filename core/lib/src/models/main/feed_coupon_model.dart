class FeedCouponModel {
  FeedCouponModel({
    this.id,
    this.name,
    this.summary,
    this.discountMax,
    this.discountUnit,
    this.discountAmount,
  });

  factory FeedCouponModel.fromJson(Map<String, dynamic> json) {
    return FeedCouponModel(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      discountMax: json['discountMax'],
      discountUnit: json['discountUnit'],
      discountAmount: json['discountAmount'],
    );
  }

  int discountAmount;
  int discountMax;
  String discountUnit;
  String id;
  String name;
  String summary;
}
