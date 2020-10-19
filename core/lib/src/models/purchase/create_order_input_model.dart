import '../../../core.dart';

class CreateOrderInputModel {
  const CreateOrderInputModel({this.fields, this.options});

  factory CreateOrderInputModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fieldsJson = json['fields'];
    final List<dynamic> optionsJson = json['options'];

    final fields = fieldsJson.map((dynamic field) {
      return OrderInfoFieldModel.fromJson(field);
    }).toList();

    print('fields $fields');
    final options = optionsJson.map((dynamic option) {
      return OrderInfoOptionsModel.fromJson(option);
    }).toList();

    print('options $options');
    return CreateOrderInputModel(
      fields: fields,
      options: options,
    );
  }

  factory CreateOrderInputModel.fromOrderList(Map<String, dynamic> json) {
    final List<dynamic> fieldsJson = json['fields'];
    final List<dynamic> optionsJson = json['options'];

    var fields = <OrderInfoFieldModel>[];
    if (fieldsJson != null) {
      fields = fieldsJson.map((dynamic field) {
        return OrderInfoFieldModel.fromJson(field);
      }).toList();
    }
    var options = <OrderInfoOptionsModel>[];
    if (optionsJson != null) {
      options = optionsJson.map((dynamic option) {
        return OrderInfoOptionsModel.fromOrderList(option);
      }).toList();
    }
    return CreateOrderInputModel(
      fields: fields,
      options: options,
    );
  }

  final List<OrderInfoFieldModel> fields;
  final List<OrderInfoOptionsModel> options;

  Map<String, dynamic> toJson() {
    final fieldMapList = fields.map((field) {
      return field.toJson();
    }).toList();
    final optionMapList = options.map((option) {
      return option.toJson();
    }).toList();

    return <String, dynamic>{'fields': fieldMapList, 'options': optionMapList};
  }
}
