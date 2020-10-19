import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'category_text_widget.dart';

Widget productSmallText(BuildContext context, ProductListViewModel item) {
  switch (item.typeName) {
    case 'CONTENT':
      return Container();
      break;
    case 'ECOUPON':
      return Container(
        alignment: Alignment.centerLeft,
        child: CategoryTextWidget(
          categories: item.categories,
          textStyle: TextStyle(
              fontSize: 10,
              color: Color(int.parse(item.availableDateInfo.color))),
        ),
      );
      break;
    case 'EXPERIENCE':
      return Container(
        alignment: Alignment.centerLeft,
        child: Text(
          item.availableDateInfo.name ?? '',
          style: TextStyle(
              fontSize: 10,
              color: Color(int.parse(item.availableDateInfo.color))),
        ),
      );
      break;

    default:
      return Container();
  }
}
