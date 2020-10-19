import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/device_ratio.dart';
import '../../../../utils/handle_network_error.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/loading_widget.dart';
import '../../../components/main/feed_bigslide_product_widget.dart';
import '../../../components/main/feed_small_slide_product_widget.dart';
import '../../../components/main/feed_summary_widget.dart';

class MyStylePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0,
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            StylePageStrings.styleViewPageAppbar,
            style: TextStyles.black18BoldTextStyle,
          ),
        ),
      ),
      body: Provider<MyStylePageBloc>(
        create: (context) => MyStylePageBloc(),
        dispose: (context, bloc) {
          bloc.dispose();
        },
        child: StyleAnalysisNetworkHandle(),
      ),
    );
  }
}

class StyleAnalysisNetworkHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkState>(
        stream: Provider.of<MyStylePageBloc>(context).networkState,
        initialData: NetworkState.Start,
        builder: (context, mainStateSnapshot) {
          print('my style page state ${mainStateSnapshot.data}');
          // if (mainStateSnapshot.data == NetworkState.Start) {
          //   return ShimmerList();
          // }
          final myStylePageBloc = Provider.of<MyStylePageBloc>(context);
          return HandleNetworkError.handleNetwork(
              state: mainStateSnapshot.data,
              retry: () {
                myStylePageBloc.networkState.add(NetworkState.Start);
                return myStylePageBloc.fetch();
              },
              context: context,
              child: StyleAnalysisWidget());
        });
  }
}

class StyleAnalysisWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('ddddddd ${mainPageBloc.repoList.value.length}');
    return StreamBuilder<List<FeedModel>>(
      stream: Provider.of<MyStylePageBloc>(context).repoList,
      builder: (context, repoSnapshot) {
        if (!repoSnapshot.hasData) {
          return const LoadingWidget();
        }

        final items = repoSnapshot.data;
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    print(items[index].node);
                    switch (items[index].node['__typename']) {
                      case 'FeedSmallSlideProducts':
                        return FeedSmallSlideProductWidget(
                          node: items[index].node,
                        );
                        break;

                      case 'FeedBigSlideProducts':
                        return FeedBigSlideProductWidget(
                          node: items[index].node,
                        );
                        break;

                      case 'FeedStyleAnaylze':
                        return FeedStyleAnaylze(
                          node: items[index].node,
                        );
                        break;
                      case 'FeedSummary':
                        return FeedSummaryWidget(
                          node: items[index].node,
                        );
                        break;
                      default:
                        return Container(
                          color: Colors.green,
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                        );
                        break;
                    }
                  }),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: 76 * MediaQuery.of(context).textScaleFactor,
                color: const Color(0xfff8f8f8),
                child: Center(
                  child: Text(
                    '여행 상품 및 콘텐츠를 즐기면 즐길수록 더 정확한\n 상품을 추천해드립니다.',
                    style: TextStyles.grey12TextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class FeedStyleAnaylze extends StatelessWidget {
  const FeedStyleAnaylze({this.node});

  final Map<String, dynamic> node;

  @override
  Widget build(BuildContext context) {
    print(node);
    return GestureDetector(
      onTap: () {
        AppRoutes.myStyleSelectPage(context, true);
      },
      child: Container(
        // height: 116 * MediaQuery.of(context).textScaleFactor,
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        color: const Color(0xff313537),
        padding:
            const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 203 * DeviceRatio.scaleWidth(context),
                    child: Text(
                      node['subTitle'],
                      style: TextStyles.white14TextStyle,
                    )),
                const Center(
                  child: SizedBox(
                    height: 12,
                  ),
                ),
                Text(
                  StylePageStrings.styleViewSelectLabel,
                  style: TextStyles.white12TextStyle,
                ),
              ],
            ),
            Image.asset(
              ImageAssets.stylePickLogoImage,
              width: 56,
            )
          ],
        ),
      ),
    );
  }
}
