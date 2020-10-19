import 'package:flutter/material.dart';

import '../../../../utils/text_styles.dart';

class ProductLabelByType extends StatelessWidget {
  const ProductLabelByType(
      {this.labelType, this.saleText = '', this.bestText = ''});

  final String bestText;
  final String labelType;
  final String saleText;

  @override
  Widget build(BuildContext context) {
    switch (labelType) {
      case 'NONE':
        return Container();
        break;
      case 'SALE':
        return Container(
          width: 48 * WidgetsBinding.instance.window.textScaleFactor,
          height: 20 * WidgetsBinding.instance.window.textScaleFactor,
          margin: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 14,
          ),
          decoration: BoxDecoration(
              color: const Color(0xffff7500),
              borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: Text(
              saleText,
              style: TextStyles.white10TextStyle,
            ),
          ),
        );
        break;
      case 'BEST':
        return Container(
          width: 42 * WidgetsBinding.instance.window.textScaleFactor,
          height: 20 * WidgetsBinding.instance.window.textScaleFactor,
          margin: const EdgeInsets.only(top: 10, left: 10),
          decoration: BoxDecoration(
              color: const Color(0xff404040),
              borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: Text(
              bestText,
              style: TextStyles.white10TextStyle,
            ),
          ),
        );
        break;

      default:
        return Container();
    }
  }
}
