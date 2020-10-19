import 'package:flutter/material.dart';

import '../../../../utils/text_styles.dart';

class ListTitleWidget extends StatelessWidget {
  const ListTitleWidget(
      {this.title = '', this.left, this.more, this.onClickMore});

  final double left;
  final bool more;
  final Function onClickMore;
  final String title;

  @override
  Widget build(BuildContext context) {
    return _buildListTitle(context, title, left, more);
  }
}

Container _buildListTitle(
    BuildContext context, String title, double left, bool more) {
  Widget _buildText() {
    print(title);
    final titleList = title.split('<br>');
    if (titleList.length > 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titleList[0],
            style: TextStyles.black20BoldTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            titleList[1],
            style: TextStyles.black20BoldTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    }
    return Text(
      title,
      style: TextStyles.black20BoldTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(left: 24, right: 24),
    child: _buildText(),
  );
}
