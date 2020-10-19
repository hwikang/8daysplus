// FeedBigSlideProductWidget

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/product-list/category_text_widget.dart';
import '../../components/common/product-list/product_small_text_widget.dart';
import '../../pages/product_detail_page.dart';
import '../common/product-list/list_title_widget.dart';
import '../common/product-list/price_widget.dart';

enum Routing { PUSH, REPLACE }

class FeedBigSlideProductWidget extends StatelessWidget {
  const FeedBigSlideProductWidget({this.node, this.routing = Routing.PUSH});

  final Routing routing;
  final Map<String, dynamic> node;

  @override
  Widget build(BuildContext context) {
    if (node['feedBigSlideProducts'].isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        child: Column(
          children: <Widget>[
            ListTitleWidget(title: node['title']),
            BigSlideProductImageWidget(
                productList: node['feedBigSlideProducts'], routing: routing),
          ],
        ));
  }
}

class BigSlideProductImageWidget extends StatelessWidget {
  const BigSlideProductImageWidget({this.productList, this.routing});

  final Routing routing;
  final List<ProductListViewModel> productList;

  Widget _buildPage(
    BuildContext context,
    ProductListViewModel item,
  ) {
    return GestureDetector(
      onTap: () {
        routing == Routing.PUSH
            ? AppRoutes.productDetailPage(context, item)
            : AppRoutes.replace(context, ProductDetailPage(item: item));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 224 * DeviceRatio.scaleWidth(context),
                  width: MediaQuery.of(context).size.width,
                  imageUrl: '${item.image.url}',
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            _buildTexts(
              context,
              item.typeName,
              item,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTexts(
    BuildContext context,
    String typeName,
    ProductListViewModel item,
    // bool isLogin
  ) {
    switch (typeName) {
      case 'EXPERIENCE':
      case 'ECOUPON':
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 11,
              ),
              productSmallText(context, item),
              Container(
                margin: const EdgeInsets.only(top: 2),
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name ?? '제목없음',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyles.black16TextStyle,
                ),
              ),
              _buildPrice(
                item,
              ),
            ],
          ),
        );
        break;
      case 'CONTENT':
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Text(
                item.name ?? CommonTexts.noTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // textAlign: TextAlign.left,
                style: TextStyles.black16BoldTextStyle,
              ),
              const SizedBox(height: 2),
              Text(
                item.summary ?? CommonTexts.noTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // textAlign: TextAlign.left,
                style: TextStyles.black14TextStyle,
              ),
              const SizedBox(height: 6),
              CategoryTextWidget(
                categories: item.categories,
              )
            ],
          ),
        );
        break;
      default:
        return Container();
    }
  }

  Widget _buildPrice(
    ProductListViewModel item,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: PriceWidget(
        salePrice: item.salePrice,
        coverPrice: item.coverPrice,
        discountRate: item.discountRate.toInt(),
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textFactor = MediaQuery.of(context).textScaleFactor;
    if (textFactor <= 0.83) {
      textFactor = 0.85;
    }
    return Container(
      height: 102 * textFactor + (224 * DeviceRatio.scaleWidth(context)),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 14),
      child: PageView.builder(
        key: PageStorageKey(UniqueKey()),
        controller: PageController(viewportFraction: 1 - 0.12, initialPage: 0),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return _buildPage(
            context, productList[index],
            // authSnapshot.data
          );
        },
      ),
    );
  }
}
