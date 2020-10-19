import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/style.dart';
import 'package:provider/provider.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/handle_network_error.dart';
import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/expansion_tile_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';

class InquiryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<InquiryListBloc>(
      create: (context) => InquiryListBloc(first: 5),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              AppRoutes.pop(context);
            },
          ),
          title: const HeaderTitleWidget(title: '1:1문의'),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                AppRoutes.inquiryCreatePage(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  // margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Text(
                    '문의하기',
                    style: TextStyles.black14TextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: InquiryListModule(),
      ),
    );
  }
}

class InquiryListModule extends StatelessWidget {
  Widget _buildReplyStateText(BuildContext context, int length) {
    if (length == 0) {
      return Text('답변대기', style: TextStyles.black12BoldTextStyle);
    }
    return Text('답변완료', style: TextStyles.orange12BoldTextStyle);
  }

  Widget _buildReply(BuildContext context, List<InquiryReplyModel> replies) {
    if (replies.isEmpty) {
      return Container();
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        color: const Color(0xfff8f8f8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                '${replies[0].createdAt}에 작성 됨',
                style: TextStyles.grey12TextStyle,
              ),
            ),
            _buildText(context, replies[0].message),
          ],
        ));
  }

  Widget _buildText(BuildContext context, String text) {
    print(text);
    // String data =
    //     text.replaceAll(RegExp('<font color='#373f52'>'), ''); //지원하지 않는 태그
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Html(
        data: '''
          $text
        ''',
        style: <String, Style>{
          'body': Style(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
          ),
          'p': Style(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
          )
        },
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    final inquiryListBloc = Provider.of<InquiryListBloc>(context);

    return GestureDetector(
      onTap: () {
        if (inquiryListBloc.networkState.value != NetworkState.Finish) {
          // faqBloc.getMore(widget.typeList[_tabController.index].type);
          inquiryListBloc.getMore();
        }
      },
      child: Container(
        height: 48,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            '+더 보기',
            style: TextStyles.grey14TextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inquiryListBloc = Provider.of<InquiryListBloc>(context);

    return StreamBuilder<NetworkState>(
        stream: Provider.of<InquiryListBloc>(context).networkState,
        builder: (context, stateSnapshot) {
          print('inquiry list page sate ${stateSnapshot.data}');
          return HandleNetworkError.handleNetwork(
            state: stateSnapshot.data,
            context: context,
            retry: () {
              inquiryListBloc.fetch('');
            },
            child: StreamBuilder<List<InquiryListModel>>(
                stream: Provider.of<InquiryListBloc>(context).inquiryList,
                builder: (context, inquirySnapshot) {
                  if (!inquirySnapshot.hasData) {
                    return Container(
                      height: 560 * DeviceRatio.scaleHeight(context),
                      child: const Center(
                        child: Text('문의내역이 없습니다.'),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (inquirySnapshot.data == null
                                ? 0
                                : inquirySnapshot.data.length) +
                            1,
                        itemBuilder: (context, index) {
                          if (index == inquirySnapshot.data.length) {
                            if (stateSnapshot.data == NetworkState.Loading) {
                              return const Center(
                                  heightFactor: 3.0, child: LoadingWidget());
                            }
                            if (stateSnapshot.data == NetworkState.Finish) {
                              return Container();
                            }

                            return _buildMoreButton(context);
                          } else {
                            return ExpansionTileWidget(
                              // item: inquirySnapshot.data[index],
                              title: Container(
                                margin: const EdgeInsets.only(left: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildReplyStateText(
                                        context,
                                        inquirySnapshot
                                            .data[index].replies.length),
                                    Container(
                                        width: 272,
                                        child: Text(
                                          '${inquirySnapshot.data[index].message}',
                                          style: TextStyles.black14TextStyle,
                                        )),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Container(
                                      child: Text(
                                        inquirySnapshot.data[index].createdAt,
                                        style: TextStyles.grey12TextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              child: _buildReply(
                                  context, inquirySnapshot.data[index].replies),
                            );
                          }
                        }),
                  );
                }),
          );
        });
  }
}
