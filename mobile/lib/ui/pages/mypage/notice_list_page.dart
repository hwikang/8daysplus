import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/my/notice_list_widget.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<NoticeListBloc>(
      create: (context) => NoticeListBloc(first: 10),
      child: NoticeListWidget(),
    );
  }
}
