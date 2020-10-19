import 'package:flutter/material.dart';

import '../../../utils/assets.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';

class ExpandablePoweredBottomWidget extends StatefulWidget {
  @override
  _ExpandablePoweredBottomWidgetState createState() =>
      _ExpandablePoweredBottomWidgetState();
}

class _ExpandablePoweredBottomWidgetState
    extends State<ExpandablePoweredBottomWidget> {
  bool isOpened;

  @override
  void initState() {
    super.initState();
    isOpened = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpened = !isOpened;
        });
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffeeeeee)))),
        // height: ,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 23),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      MainPageStrings.gtentionPoweredBy,
                      style: TextStyles.grey12BoldTextStyle,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      ImageAssets.mainHanwhaImg2,
                      width: 63,
                    ),
                  ],
                ),
                Container(
                  // height: 12,
                  width: 12,
                  child: Image(
                    image: AssetImage(isOpened
                        ? ImageAssets.arrowUpImage
                        : ImageAssets.arrowDownImage),
                  ),
                ),
              ],
            ),
            if (isOpened)
              Container(
                  margin: const EdgeInsets.only(top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MainPageStrings.companyInfos,
                        style: TextStyles.grey12TextStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 20),
                        child: Text(
                          MainPageStrings.companyAdress,
                          style: TextStyles.grey12TextStyle,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        color: Color(0xffeeeeee),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 11),
                        child: Text(
                          MainPageStrings.companyNotice,
                          style: TextStyles.grey12TextStyle,
                        ),
                      ),
                      Container(
                        child: Text(
                          MainPageStrings.companyCopyright,
                          style: TextStyles.grey12TextStyle,
                        ),
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
