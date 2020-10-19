import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/loading_widget.dart';
import '../../components/common/network_delay_widget.dart';
import '../../components/common/product-list/grid_product_widget.dart';

class PromotionListPage extends StatelessWidget {
  const PromotionListPage({
    this.model,
  });

  final FeedPromotionModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: Text(
          // model.name,
          // model.product[0].name,
          model.summary,
          style: TextStyles.black20BoldTextStyle,
        ),
      ),
      body: Provider<PromotionBloc>(
        create: (context) => PromotionBloc(
          id: model.id,
        ),
        child: PromotionListBody(),
      ),
    );
  }
}

class PromotionListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FeedPromotionModel>(
        stream: Provider.of<PromotionBloc>(context).repoData,
        builder: (context, repoSnapshot) {
          if (repoSnapshot.hasError) {
            return NetworkDelayWidget(
                retry: () => Provider.of<PromotionBloc>(context).fetch());
          }
          if (!repoSnapshot.hasData) {
            return const LoadingWidget();
          }
          final data = repoSnapshot.data;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: data.coverImage.url,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Container(
                  height: 18,
                  margin: const EdgeInsets.only(top: 24, left: 26),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${data.product.length}여개의 상품',
                    style: TextStyles.grey12TextStyle,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                GridProductWidget(
                  list: data.product,
                  isCount: false,
                  scrollEnded: true,
                ),
                const SizedBox(
                  height: 28,
                ),
              ],
            ),
          );
        });
  }
}
