import 'package:flutter/material.dart';

import '../../../utils/text_styles.dart';

class ListStyleTextWidget extends StatelessWidget {
  const ListStyleTextWidget(
      {this.text, this.style, this.dotColor = Colors.black});

  final Color dotColor;
  final TextStyle style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 2,
            width: 2,
            margin: EdgeInsets.only(
                right: 6, top: style != null ? (style.fontSize * 1.5) / 2 : 10),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
              child: Text(
            text,
            style: style ?? TextStyles.black14TextStyle,
            // maxLines: 3,
          ))
        ],
      ),
    );
  }
}
