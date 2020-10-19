import 'package:flutter/material.dart';

import '../../../utils/assets.dart';
import '../../../utils/text_styles.dart';

class MyPageMainList extends StatelessWidget {
  const MyPageMainList({
    this.title,
    this.listTitle1,
    this.listTitle2,
    this.actionTitle,
    this.actionColor,
    this.listOnTap1,
    this.listOnTap2,
  });

  final Color actionColor;
  final String actionTitle;
  final Function listOnTap1;
  final Function listOnTap2;
  final String listTitle1;
  final String listTitle2;
  final String title;

  Widget _buildList(BuildContext context, String title, Function onTap) {
    if (title == null) {
      return Container();
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee))),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyles.black16TextStyle,
              ),
              Row(
                children: <Widget>[
                  Text(
                    actionTitle,
                    style: TextStyle(
                      fontFamily: FontFamily.bold,
                      fontSize: 16,
                      color: actionColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Image.asset(
                      ImageAssets.arrowRightImage,
                      width: 6,
                    ),
                  )
                ],
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 48,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff404040)))),
            child: Text(
              title,
              style: TextStyles.black18BoldTextStyle,
            ),
          ),
          _buildList(context, listTitle1, listOnTap1),
          _buildList(context, listTitle2, listOnTap2),
        ],
      ),
    );
  }
}
