import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../loading_widget.dart';
import '../placeholder_widget.dart';
import 'category_text_widget.dart';
import 'price_widget.dart';
import 'product_label_by_type_widget.dart';
import 'product_small_text_widget.dart';

class GridProductWidget extends StatelessWidget {
  const GridProductWidget({
    @required this.list,
    this.isCount,
    this.totalCount,
    this.scrollEnded = false,
    this.labelType,
    this.typeKorName,
    // this.isLogin = true,
  });

  final bool isCount;
  final String labelType;
  final List<ProductListViewModel> list;
  final bool scrollEnded;
  final int totalCount;
  final String typeKorName;

  // final bool isLogin;

  Widget _buildLoadingWidget() {
    //true , false
    if (scrollEnded != null && !scrollEnded) {
      return const Center(heightFactor: 2, child: LoadingWidget());
    }
    return Container();
  }

  Widget _buildCounter(BuildContext context, String typeKorName) {
    return Container(
      margin: const EdgeInsets.only(
        top: 24,
        bottom: 14,
      ),
      height: 20 * MediaQuery.of(context).textScaleFactor,
      child: Text(
        '$totalCount 개의 $typeKorName ${DiscoveryPageStrings.product}',
        style: TextStyles.grey12TextStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Text('');
    }
    final typeName = list[0].typeName;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isCount) _buildCounter(context, typeKorName),
            Column(
              children: <Widget>[
                GridView.builder(
                    //products are disappear<->appear if don't use PageStorageKey
                    key: PageStorageKey(UniqueKey()),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio:
                            DeviceRatio.productRatio(context, typeName),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 28),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return GridProductListItem(
                        item: list[index],
                        index: index,
                        typeName: typeName,
                        labelType: labelType,
                      );
                    }),
                _buildLoadingWidget()
              ],
            ),
          ]),
    );
  }
}

class GridProductListItem extends StatelessWidget {
  const GridProductListItem({
    @required this.item,
    this.index,
    this.typeName,
    this.labelType,
  });

  final int index;
  final ProductListViewModel item;
  final String labelType;
  final String typeName;

  Widget _buildTexts(
    BuildContext context,
  ) {
    if (item.typeName == 'CONTENT') {
      return Container(
          margin: const EdgeInsets.only(top: 6),
          //api 제공하는것까지만,
          child: CategoryTextWidget(
            categories: item.categories,
          ));
    }
    return Container(
        margin: const EdgeInsets.only(top: 4),
        child: PriceWidget(
          salePrice: item.salePrice,
          coverPrice: item.coverPrice,
          discountRate: item.discountRate.toInt(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRoutes.productDetailPage(context, item),
      child: Stack(children: <Widget>[
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 112 * DeviceRatio.scaleWidth(context),
              width: 150 * DeviceRatio.scaleWidth(context),
              decoration: BoxDecoration(
                border: Border.all(
                    color: item.typeName == 'ECOUPON'
                        ? const Color(0xffeeeeee)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  fit: typeName == 'ECOUPON'
                      ? BoxFit.fitHeight
                      : BoxFit.cover, // 대표님 요청에 따라 fit style 제거.
                  imageUrl: '${item.image.url}',
                  placeholder: (context, url) => PlaceholderWidget(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 6),
                child: productSmallText(context, item)),
            Container(
              height: 40 * MediaQuery.of(context).textScaleFactor,
              child: Text(
                item.name ?? CommonTexts.noTitle,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyles.black14TextStyle,
              ),
            ),
            _buildTexts(
              context,
            ),
            //SizedBox(height: 25),
          ],
        )),
        ProductLabelByType(
          labelType: labelType,
          saleText: '${item.discountRate}%${DiscoveryPageStrings.discount}',
          bestText: 'TOP ${index + 1}',
        )
      ]),
    );
  }
}
