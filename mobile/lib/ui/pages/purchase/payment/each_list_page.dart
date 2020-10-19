import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/routes.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/user/user_info_widget.dart';

//결제하기 페이지 -> 사용자 정보보기
class EachListPage extends StatelessWidget {
  const EachListPage({this.model, this.each, this.fields});

  final List<OrderInfoFieldListModel> each;
  final List<OrderInfoFieldModel> fields;
  final CreateOrderPrepareModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              AppRoutes.pop(context);
            },
          ),
          title: const HeaderTitleWidget(title: '사용자 정보'),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  UserInfoWidget(
                    title: '예약자 정보',
                    fields: fields,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 48),
                    child: UserInfoListWidget(
                      title: '사용자 정보',
                      each: each,
                    ),
                  )
                ],
              )),
        ));
  }
}
