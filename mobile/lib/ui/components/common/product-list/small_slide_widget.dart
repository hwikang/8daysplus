import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../pages/product_detail_page.dart';
import '../placeholder_widget.dart';
import 'category_text_widget.dart';
import 'price_widget.dart';
import 'product_label_by_type_widget.dart';
import 'product_small_text_widget.dart';

class SmallSlideWidget extends StatelessWidget {
  const SmallSlideWidget({
    @required this.list,
    this.labelType,
    this.from = 'MAIN',
  });

  final String from; // the page where using this widget
  final String labelType;
  final List<ProductListViewModel> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 107 * DeviceRatio.scaleWidth(context) +
          (100 * MediaQuery.of(context).textScaleFactor),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        key: PageStorageKey(UniqueKey()),
        addAutomaticKeepAlives: true,
        controller: PageController(viewportFraction: 0.79, initialPage: 0),
        physics: const PageScrollPhysics(),
        padding: const EdgeInsets.only(left: 24),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SmallSlideItemWidget(
          item: list[index],
          index: index,
          labelType: labelType,
          from: from,
        ),
        itemCount: list.length,
      ),
    );
  }
}

class SmallSlideItemWidget extends StatelessWidget {
  const SmallSlideItemWidget({
    @required this.item,
    @required this.index,
    this.labelType = 'NONE',
    this.from,
  });

  final String from;
  final int index;
  final ProductListViewModel item;
  final String labelType;

  Widget buildProductSummaryByType(BuildContext context, String productType) {
    switch (productType) {
      case 'EXPERIENCE':
      case 'ECOUPON':
        return Container(
          height: 38 * WidgetsBinding.instance.window.textScaleFactor,
          child: PriceWidget(
            salePrice: item.salePrice,
            coverPrice: item.coverPrice,
            discountRate: item.discountRate.toInt(),
          ),
        );

        break;
      case 'CONTENT':
        return Container(
            margin: const EdgeInsets.only(top: 6),
            child: CategoryTextWidget(categories: item.categories));
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        from == 'MAIN'
            ? AppRoutes.productDetailPage(context, item)
            : AppRoutes.replace(context, ProductDetailPage(item: item));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 144 * DeviceRatio.scaleWidth(context),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 107 * DeviceRatio.scaleWidth(context),
                  width: 144 * DeviceRatio.scaleWidth(context),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: item.typeName == 'ECOUPON'
                            ? const Color(0xffeeeeee)
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.0),
                      child: CachedNetworkImage(
                        imageUrl: item.image.url,
                        fit: item.typeName == 'ECOUPON'
                            ? BoxFit.fitHeight
                            : BoxFit.cover,
                        placeholder: (context, url) => PlaceholderWidget(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                ),
                ProductLabelByType(
                  labelType: labelType,
                  saleText: '${item.discountRate}%할인',
                  bestText: 'TOP$index',
                ),
              ],
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: productSmallText(context, item)),
                Container(
                  height: 40 * MediaQuery.of(context).textScaleFactor,
                  child: Text(item.name,
                      maxLines: 2, style: TextStyles.black14TextStyle),
                ),
                buildProductSummaryByType(context, item.typeName)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
