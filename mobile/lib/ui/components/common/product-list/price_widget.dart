import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/singleton.dart';
import '../../../../utils/text_styles.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {this.salePrice = 0,
      this.coverPrice = 0,
      this.discountRate = 0,
      this.fontSize = 14.0,
      this.isLogin = true});

  final int coverPrice;
  final int discountRate;
  final double fontSize;
  final bool isLogin;
  final int salePrice;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Singleton.instance.isLogin
        ? discountRate == 0
            ? Container(
                height: 37 * MediaQuery.of(context).textScaleFactor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      '${formatter.format(salePrice)}원',
                      style: TextStyle(
                        fontFamily: FontFamily.bold,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        coverPrice == 0
                            ? ''
                            : '${formatter.format(coverPrice)} 원',
                        style: TextStyles.grey10LineThroughTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${formatter.format(salePrice)}원',
                            style: TextStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: fontSize,
                            ),
                          ),
                          Text('$discountRate%',
                              style: TextStyle(
                                fontFamily: FontFamily.regular,
                                fontSize: fontSize,
                                color: const Color(0xffff7500),
                                inherit: false,
                              ))
                        ],
                      )
                    ]))
        : Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text('회원가', style: TextStyles.black14BoldTextStyle));
  }
}
