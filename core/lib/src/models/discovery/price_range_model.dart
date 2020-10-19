class PriceRangeModel {
  const PriceRangeModel({this.min = 0, this.max = 0, this.label = ''});

  factory PriceRangeModel.fromJson(Map<String, dynamic> json) {
    return PriceRangeModel(
        min: json['min'], max: json['max'], label: json['label'] ?? '');
  }

  final String label;
  final int max;
  final int min;

  Map<String, dynamic> toJSON() => <String, dynamic>{'min': min, 'max': max};
}
