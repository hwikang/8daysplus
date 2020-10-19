import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../../utils/text_styles.dart';

class UserInfoInBoxWidget extends StatelessWidget {
  const UserInfoInBoxWidget({this.title, this.each});

  final List<OrderInfoFieldListModel> each;
  final String title;

  Widget _buildUserInfoContainer(
      BuildContext context, OrderInfoFieldListModel each, String title) {
    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyles.black13BoldTextStyle),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: each.fields.length,
            itemBuilder: (context, index) {
              return _buildRow(
                  each.fields[index].fieldName, each.fields[index].fieldValue);
            },
          )
        ],
      ),
    );
  }

  Widget _buildRow(String key, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 84,
            margin: const EdgeInsets.only(
              right: 16,
            ),
            child: Text(
              key,
              style: TextStyles.grey14TextStyle,
            ),
          ),
          Text(
            value,
            style: TextStyles.black14TextStyle,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (each.isEmpty) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffeeeeee), width: 1),
            borderRadius: BorderRadius.circular(4)),
        margin: const EdgeInsets.only(top: 12),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyles.black20BoldTextStyle,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: each.length * 2 - 1, //for border
              itemBuilder: (context, index) {
                if (index.isEven) {
                  return _buildUserInfoContainer(
                      context, each[(index ~/ 2)], '사용자정보${index + 1}');
                }
                return Container(
                    height: 1,
                    decoration: const BoxDecoration(color: Color(0xffeeeeee)));
              },
            )
          ],
        )));
  }
}
