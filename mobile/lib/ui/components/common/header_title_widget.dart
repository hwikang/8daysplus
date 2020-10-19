import 'package:flutter/material.dart';

import '../../../utils/text_styles.dart';

class HeaderTitleWidget extends StatelessWidget {
  const HeaderTitleWidget({@required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        overflow: TextOverflow.ellipsis, // 너무 긴 경우 ... 처리
        style: TextStyles.black18BoldTextStyle,
      ),
    );
  }
}
