import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/loading_widget.dart';
import '../common/product-list/list_title_widget.dart';
import '../common/product-list/small_slide_widget.dart';
import '../main/feed_bigslide_product_widget.dart';

class RecommendsListViewProvider extends StatelessWidget {
  const RecommendsListViewProvider(
      {@required this.item,
      // @required this.cursorID,
      @required this.titleName,
      @required this.typeName,
      @required this.neighbor});

  // final String cursorID;
  final ProductDetailViewModel item;
  final bool neighbor;
  final String titleName;
  final String typeName;

  @override
  Widget build(BuildContext context) {
    return Provider<RecommendBloc>(
      create: (context) => RecommendBloc(
        productId: item.id,
        typeName: typeName,
        neighbor: neighbor,
      ),
      child: RecommendsListViewWidget(titleName: titleName, typeName: typeName),
    );
  }
}

class RecommendsListViewWidget extends StatelessWidget {
  const RecommendsListViewWidget(
      {@required this.titleName, @required this.typeName});

  final String titleName;
  final String typeName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductListViewModel>>(
        stream: Provider.of<RecommendBloc>(context).repoList,
        builder: (context, repoSnapshot) {
          if (!repoSnapshot.hasData) {
            return const LoadingWidget();
          }
          final list = repoSnapshot.data;
          if (list.isEmpty == true) {
            return Container(height: 0);
          }
          return Container(
              child: Column(children: <Widget>[
            ListTitleWidget(title: titleName, left: 35),
            const SizedBox(height: 12),
            if (typeName == 'EXPERIENCE')
              SmallSlideWidget(
                  list: list,
                  // heroTagName: heroTagName,
                  labelType: 'NONE',
                  from: 'DETAIL')
            else
              BigSlideProductImageWidget(
                productList: list,
                routing: Routing.REPLACE,
              ),
            const SizedBox(height: 48),
          ]));
        });
  }
}
