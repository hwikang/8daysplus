import 'dart:convert';

import 'package:flutter/foundation.dart';

class InquiryCreateModel {
  InquiryCreateModel({@required this.message, @required this.type});

  String message;
  String type;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'message': json.encode(message), 'type': type};
}
