import 'dart:convert';

import 'package:flutter/material.dart';

class AddRecommendPickInputModel {
  AddRecommendPickInputModel({@required this.productId, @required this.type});

  final String productId;
  final String type;

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{'productId': json.encode(productId), 'type': type};
  }
}
