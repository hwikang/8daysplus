import 'package:core/core.dart';
import 'package:flutter/material.dart';

class CategoryTextWidget extends StatelessWidget {
  const CategoryTextWidget(
      {this.categories,
      this.textStyle = const TextStyle(
          fontFamily: 'Spoqa', fontSize: 12, color: Color(0xff404040))});
  final List<CategoryModel> categories;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return categories.isNotEmpty
        ? categories[0].nodes.isNotEmpty
            ? categories[0].nodes[0].nodes.isNotEmpty
                ? Text(
                    categories[0].nodes[0].nodes[0].name,
                    style: textStyle,
                  )
                : Text(
                    categories[0].nodes[0].name,
                    style: textStyle,
                  )
            : Text(
                categories[0].name,
                style: textStyle,
              )
        : const Text('');
  }
}
