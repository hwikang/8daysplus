import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/action_link.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/routes.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';
import '../../components/common/network_delay_widget.dart';

class NoticeEventDetailPage extends StatelessWidget {
  const NoticeEventDetailPage({this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsLogEvent('view_event', {'id': id});
    return Provider<NoticeEventDetailBloc>(
      create: (context) => NoticeEventDetailBloc(id: id),
      child: const NoticeEventDetailModule(),
    );
  }
}

class NoticeEventDetailModule extends StatelessWidget {
  const NoticeEventDetailModule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NoticeEventModel>(
        stream: Provider.of<NoticeEventDetailBloc>(context).noticeEvent,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return NetworkDelayPage(retry: () {
              Provider.of<NoticeEventDetailBloc>(context).fetch();
            });
          }
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          final imageActionLinks = snapshot.data.imageActionLinks;

          return Scaffold(
            appBar: AppBar(
              title: HeaderTitleWidget(title: snapshot.data.title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black,
                onPressed: () {
                  AppRoutes.pop(context);
                },
              ),
              titleSpacing: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Container(
                  color: Colors.black,
                  child: Column(
                      children: imageActionLinks.map((model) {
                    return GestureDetector(
                        onTap: () {
                          final actionLink = ActionLink();

                          actionLink.handleActionLink(
                              context, model.actionLink, '');

                          Analytics.analyticsLogEvent(
                              'view_event_click', snapshot.data.toJson());
                        },
                        child: CachedNetworkImage(
                          imageUrl: model.coverImage.url,
                        ));
                  }).toList())),
            ),
          );
        });
  }
}
