// FeedBigSlideProductWidget

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/product-list/category_text_widget.dart';
import '../common/placeholder_widget.dart';
import '../common/product-list/list_title_widget.dart';
import '../common/product-list/price_widget.dart';
import '../product/html_widget.dart';

class FeedCardViewWidget extends StatelessWidget {
  const FeedCardViewWidget({
    this.title,
    this.productList,
  });

  final List<ProductListViewModel> productList;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (productList.isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        child: Column(
          children: <Widget>[
            ListTitleWidget(title: title),
            CardViewWidget(
              productList: productList,
            ),
          ],
        ));
  }
}

class CardViewWidget extends StatelessWidget {
  const CardViewWidget({
    this.productList,
  });

  final List<ProductListViewModel> productList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: ListView.builder(
          key: PageStorageKey(UniqueKey()),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return CardListProductItem(
              item: productList[index],
              typeName: productList[index].typeName,
              isLast: index == productList.length - 1,
            );
          }),
    );
  }
}

class CardListProductItem extends StatelessWidget {
  const CardListProductItem({
    @required this.item,
    this.typeName,
    this.isLast,
  });

  final bool isLast;
  final ProductListViewModel item;
  final String typeName;

  Widget _buildPrice() {
    if (item.typeName == 'CONTENT') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(HtmlWidget(html: item.summary).html,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyles.black14TextStyle),
          ),
          const SizedBox(
            height: 8,
          ),
          CategoryTextWidget(
            categories: item.categories,
          )
        ],
      );
    }
    return Container(
        margin: const EdgeInsets.only(top: 2),
        child: PriceWidget(
            salePrice: item.salePrice,
            coverPrice: item.coverPrice,
            discountRate: item.discountRate.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => AppRoutes.productDetailPage(context, item),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 233,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: item.image.url,
                    placeholder: (context, url) => PlaceholderWidget(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: isLast ? 0 : 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 24,
                      child: Text(
                        item.name,
                        style: TextStyles.black16BoldTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildPrice(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
