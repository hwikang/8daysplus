import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/style.dart';
import 'package:provider/provider.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../modules/common/handle_network_module.dart';
import '../common/expansion_tile_widget.dart';
import '../common/header_title_widget.dart';
import '../common/loading_widget.dart';

class NoticeListWidget extends StatelessWidget {
  Widget _buildCard(BuildContext context, NoticeListViewModel item, int index) {
    return Container(
        child: ExpansionTileWidget(
      title: Container(
        // height: 82 * DeviceRatio.scaleRatio(context),
        padding: const EdgeInsets.only(left: 24, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 272,
                child: Text(
                  '${item.title}',
                  style: TextStyles.black14TextStyle,
                )),
            const SizedBox(
              height: 4.0,
            ),
            Container(
              child: Text(
                item.createdAt,
                style: TextStyles.grey12TextStyle,
              ),
            )
          ],
        ),
      ),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          color: const Color(0xfff8f8f8),
          child: _buildText(context, item.message)),
    ));
  }

  Widget _buildText(BuildContext context, String text) {
    final data = text.replaceAll(RegExp("<font color='#373f52'>"), '');
    return Html(data: '''
        $data
      ''', style: <String, Style>{
      'body': Style(
        margin: const EdgeInsets.all(0),
        fontSize: FontSize(14.0 * MediaQuery.of(context).textScaleFactor),
        fontHeight: 2.0,
        color: const Color(0xff404040),
        fontFamily: FontFamily.regular,
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: const HeaderTitleWidget(title: '공지사항'),
      ),
      body: HandleNetworkModule(
        networkState: Provider.of<NoticeListBloc>(context).networkState,
        retry: Provider.of<NoticeListBloc>(context).fetch,
        child: StreamBuilder<List<NoticeListViewModel>>(
            stream: Provider.of<NoticeListBloc>(context).repoList,
            builder: (context, repoSnapshot) {
              if (!repoSnapshot.hasData) {
                return Center(heightFactor: 3.0, child: LoadingRingWidget());
              }
              if (repoSnapshot.data.isEmpty) {
                return Container(
                  height: 560 * DeviceRatio.scaleHeight(context),
                  child: const Center(
                    child: Text('공지사항이 없습니다.'),
                  ),
                );
              }

              final listData = repoSnapshot.data;
              return Container(
                  child: ListView.builder(
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        return _buildCard(context, listData[index], index);
                      }));
            }),
      ),
    );
  }
}
