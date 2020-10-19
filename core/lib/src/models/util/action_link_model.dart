class ActionLinkModel {
  ActionLinkModel({
    this.target,
    this.value,
  });

  factory ActionLinkModel.fromJson(Map<String, dynamic> json) {
    return ActionLinkModel(target: json['target'], value: json['value']);
  }

  String target;
  String value;
}
