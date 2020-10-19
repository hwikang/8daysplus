import 'dart:convert';

import '../../../core.dart';
import 'order_info_product_model.dart';

class OrderInfoOptionsModel {
  OrderInfoOptionsModel(
      {this.each = const <OrderInfoFieldListModel>[],
      this.fields = const <OrderInfoFieldModel>[],
      this.orderProduct});

  factory OrderInfoOptionsModel.fromJson(Map<String, dynamic> json) {
    // print('option model json $json');
    final List<dynamic> eachJson = json['each'];
    final List<dynamic> fieldsJson = json['fields'];

    final each = eachJson.map((dynamic e) {
      return OrderInfoFieldListModel.fromJson(e);
    }).toList();
    // print('each $each');
    final fields = fieldsJson.map((dynamic field) {
      return OrderInfoFieldModel.fromJson(field);
    }).toList();
    // print('fields $fields');
    return OrderInfoOptionsModel(
        each: each,
        fields: fields,
        orderProduct: OrderInfoProductModel.fromJson(json['orderProduct']));
  }

  //product - voucher 때문에 따로 뺌
  factory OrderInfoOptionsModel.fromOrderList(Map<String, dynamic> json) {
    final List<dynamic> eachJson = json['each'];
    final List<dynamic> fieldsJson = json['fields'];

    var each = <OrderInfoFieldListModel>[];
    var fields = <OrderInfoFieldModel>[];

    if (eachJson != null) {
      each = eachJson.map((dynamic e) {
        return OrderInfoFieldListModel.fromJson(e);
      }).toList();
    }
    if (fieldsJson != null) {
      fields = fieldsJson.map((dynamic field) {
        return OrderInfoFieldModel.fromJson(field);
      }).toList();
    }

    // print(each);

    // print(fields);
    return OrderInfoOptionsModel(
        each: each,
        fields: fields,
        orderProduct:
            OrderInfoProductModel.fromOrderList(json['orderProduct']));
  }

  List<OrderInfoFieldListModel> each;
  List<OrderInfoFieldModel> fields;
  OrderInfoProductModel orderProduct;

  Map<String, dynamic> toJson() {
    final fieldsJson = fields.map((field) {
      return field.toJson();
    }).toList();

    final productsJson = orderProduct.toJson();

    final eachMapList = each.map((eachMap) {
      return eachMap.toJson();
    }).toList();

    return <String, dynamic>{
      'each': eachMapList,
      'fields': fieldsJson,
      'orderProduct': productsJson,
    };
  }
}

class OrderInfoFieldListModel {
  OrderInfoFieldListModel({
    this.fields,
  });

  factory OrderInfoFieldListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> eachJson = json['fields'];
    final fieldList = eachJson.map((dynamic field) {
      return OrderInfoFieldModel.fromJson(field);
    }).toList();
    return OrderInfoFieldListModel(fields: fieldList);
  }

  List<OrderInfoFieldModel> fields;

  Map<String, dynamic> toJson() {
    final fieldsMap = fields.map((field) {
      return field.toJson();
    }).toList();

    return <String, dynamic>{
      'fields': fieldsMap,
    };
  }
}

class OrderInfoFieldModel {
  OrderInfoFieldModel(
      {this.isRequired,
      this.fieldExplain,
      this.fieldId,
      this.fieldName,
      this.fieldOption,
      this.fieldPlaceholder,
      this.fieldType,
      this.fieldValue});

  factory OrderInfoFieldModel.fromJson(Map<String, dynamic> json) =>
      OrderInfoFieldModel(
        isRequired: json['required'] ?? false,
        fieldExplain: json['fieldExplain'] ?? '',
        fieldId: json['fieldId'] ?? '',
        fieldName: json['fieldName'] ?? '',
        fieldOption: json['fieldOption'] ?? '',
        fieldPlaceholder: json['fieldPlaceholder'] ?? '',
        fieldType: json['fieldType'] ?? '',
        fieldValue: json['fieldValue'] ?? '',
      );

  String fieldExplain;
  String fieldId;
  String fieldName;
  String fieldOption;
  String fieldPlaceholder;
  String fieldType;
  String fieldValue;
  bool isRequired;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fieldId': json.encode(fieldId ?? ''),
      'fieldValue': json.encode(fieldValue ?? '')
    };
  }
}
