import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/common/network_delay_widget.dart';
import '../../../../components/discovery/category_widget.dart';
import '../../../../components/main/feed_grid_product_widget.dart';

class DiscoveryMainContent extends StatelessWidget {
  const DiscoveryMainContent({this.innerTabIndex});

  final int innerTabIndex;

  // Widget page;

  @override
  Widget build(BuildContext context) {
    final categoryBloc = Provider.of<CategoryBloc>(context);

    return StreamBuilder<DiscoveryMainPageModel>(
        stream: Provider.of<DiscoveryMainPageBloc>(context).mainModelState,
        initialData: DiscoveryMainPageModel(),
        builder: (context, snapshot) {
          //선택된 1depth의 children (ex.트렌드+. 여행+ ...)
          final rootCategoryNodes =
              categoryBloc.repoList.value[snapshot.data.outerPageState].nodes;
          return Column(children: <Widget>[
            if (rootCategoryNodes.isNotEmpty)
              CategoryWidget(
                categoryList:
                    rootCategoryNodes[snapshot.data.innerPageState].nodes,
                selectType: categoryBloc
                    .repoList.value[snapshot.data.outerPageState].type,
              ),
            RecommendCategoryFeedWidget(),
          ]);
        });
  }
}

class RecommendCategoryFeedWidget extends StatefulWidget {
  @override
  _RecommendCategoryFeedWidgetState createState() =>
      _RecommendCategoryFeedWidgetState();
}

class _RecommendCategoryFeedWidgetState
    extends State<RecommendCategoryFeedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: StreamBuilder<List<FeedModel>>(
          stream: Provider.of<RecommendCategoryFeedBloc>(context).repoList,
          builder: (context, feedSnapshot) {
            if (feedSnapshot.hasError) {
              return NetworkDelayWidget(
                retry: Provider.of<RecommendCategoryFeedBloc>(context).fetch,
              );
            }
            if (!feedSnapshot.hasData) {
              return Container();
            }

            final items = feedSnapshot.data;
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  switch (items[index].node['__typename']) {
                    case 'FeedGridProducts':
                      return FeedGridProductWidget(
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
                });
          }),
    );
  }
}
