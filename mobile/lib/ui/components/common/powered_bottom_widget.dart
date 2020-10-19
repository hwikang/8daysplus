import 'package:flutter/material.dart';

import '../../../utils/assets.dart';
import '../../../utils/text_styles.dart';

class PoweredBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            height: 40,
            child: Column(children: <Widget>[
              const Divider(
                height: 1,
                color: Color(0xffeeeeee),
              ),
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'POWERED BY',
                      style: TextStyles.black10TextStyle,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Image(
                        image: AssetImage(
                          ImageAssets.mainHanwhaImg,
                        ),
                        width: 138,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }
}
