class OrderByModel {
  const OrderByModel(
      {this.field = 'NONE', this.direction = 'ASC', this.label = ''});

  factory OrderByModel.fromJson(Map<String, dynamic> json) {
    return OrderByModel(
        field: json['field'],
        direction: json['direction'],
        label: json['label'] ?? '');
  }

  final String direction;
  final String field;
  final String label;

  Map<String, dynamic> toJSON() =>
      <String, dynamic>{'field': field, 'direction': direction};
}
