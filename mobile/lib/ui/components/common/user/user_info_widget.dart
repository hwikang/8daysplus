import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';

class UserInfoListWidget extends StatelessWidget {
  const UserInfoListWidget({
    this.each,
    this.title,
  });

  final List<OrderInfoFieldListModel> each;
  final String title;

  Widget _buildUserInfoContainer(
      BuildContext context, OrderInfoFieldListModel each, String title) {
    return Container(
      margin: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyles.black16BoldTextStyle),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: each.fields.length,
            itemBuilder: (context, index) {
              return UserInfoRow(
                  field: each.fields[index].fieldName,
                  value: each.fields[index].fieldValue);
            },
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
              //0->0 2->1 4->2
              return _buildUserInfoContainer(context, each[(index ~/ 2)],
                  '${ReservationPageStrings.userInfo}${(index / 2).floor() + 1}');
            }
            return Container(
                height: 1,
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(color: Color(0xffeeeeee)));
          },
        )
      ],
    ));
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    this.fields,
    this.title,
    this.eachTitle,
  });

  final bool eachTitle;
  final List<OrderInfoFieldModel> fields;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (fields.isEmpty) {
      return Container();
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title ?? '',
            style: TextStyles.black20BoldTextStyle,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: fields.length,
            itemBuilder: (context, index) {
              print(fields[index].toJson());
              return UserInfoRow(
                  field: fields[index].fieldName,
                  value: fields[index].fieldValue);
            },
          )
        ],
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  const UserInfoRow({
    this.field,
    this.value,
  });

  final String field;
  final String value;

  @override
  Widget build(BuildContext context) {
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
              field ?? '',
              style: TextStyles.grey14TextStyle,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyles.black14TextStyle,
              // textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}
