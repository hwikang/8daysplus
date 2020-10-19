import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../loading_widget.dart';
import 'category_text_widget.dart';
import 'price_widget.dart';
import 'product_small_text_widget.dart';

class ListProductWidget extends StatelessWidget {
  const ListProductWidget({
    @required this.list,
    this.isCount = false,
    this.totalCount,
    this.scrollEnded = false,
    this.typeKorName = '',
    this.highlightText = '',
    this.scrollController,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final String highlightText;
  final bool isCount;
  final List<ProductListViewModel> list;
  final ScrollPhysics physics;
  final ScrollController scrollController;
  final bool scrollEnded;
  final int totalCount;
  final String typeKorName;

  Widget _buildCounter(BuildContext context, bool isCount, String typeName) {
    if (isCount) {
      return Container(
        margin: const EdgeInsets.only(
          top: 16,
        ),
        height: 20 * DeviceRatio.scaleRatio(context),
        child: Text(
          '$totalCount 개의 $typeKorName 상품',
          style: TextStyles.grey14TextStyle,
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final typeName = list[0].typeName;

    if (list.isEmpty) {
      return const Text('');
    }

    return ListView.builder(
      key: PageStorageKey(typeKorName),
      physics: physics,
      shrinkWrap: true,
      itemCount: list.length + 1 + 1, //counter,loading widget
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildCounter(context, isCount, typeName);
        }

        if (index == list.length + 1) {
          if (scrollEnded != null && !scrollEnded) {
            return const Center(heightFactor: 3, child: LoadingWidget());
          } else {
            return Container();
          }
        }

        return ListProductItem(
          item: list[index - 1], //19
          index: index,
          typeName: typeName,
          highlightText: highlightText,
        );
      },
    );
  }
}

class ListProductItem extends StatelessWidget {
  const ListProductItem({
    Key key,
    @required this.item,
    this.typeName,
    this.index,
    this.highlightText,
  }) : super(key: key);

  final String highlightText;
  final int index;
  final ProductListViewModel item;
  final String typeName;

  Widget _buildTextsByType(BuildContext context, String typeName) {
    switch (typeName) {
      case 'CONTENT':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 20 * DeviceRatio.scaleRatio(context),
              child: ListProductTitleWidget(
                  maxLine: 1,
                  isBold: true,
                  title: item.name,
                  standard: highlightText),
            ),
            Container(
                margin: const EdgeInsets.only(top: 4),
                height: 40 * DeviceRatio.scaleRatio(context),
                child: Text(
                  item.summary,
                  style: TextStyles.black14TextStyle,
                )),
            Container(
                margin: const EdgeInsets.only(top: 6),
                child: CategoryTextWidget(
                  categories: item.categories,
                )),
          ],
        );
        break;
      case 'EXPERIENCE':
      case 'ECOUPON':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  productSmallText(context, item),
                  Container(
                    height: 42 * MediaQuery.of(context).textScaleFactor,
                    child: ListProductTitleWidget(
                        maxLine: 2,
                        isBold: false,
                        title: item.name,
                        standard: highlightText),
                  ),
                ],
              ),
            ),
            Container(
                // margin: const const EdgeInsets.only(top: 2),
                child: PriceWidget(
                    salePrice: item.salePrice,
                    coverPrice: item.coverPrice,
                    // isLogin: isLogin,
                    discountRate: item.discountRate.toInt())),
          ],
        );
        break;

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => AppRoutes.productDetailPage(context, item),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 96,
                width: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: 96,
                    width: 96,
                    // cacheManager: ,
                    imageUrl: '${item.image.url}',
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    height: 96 * MediaQuery.of(context).textScaleFactor,
                    margin: const EdgeInsets.only(left: 12),
                    child: _buildTextsByType(context, typeName)),
              )
            ],
          ),
        ));
  }
}

class ListProductTitleWidget extends StatelessWidget {
  const ListProductTitleWidget(
      {this.maxLine, this.isBold, this.title, this.standard});

  final bool isBold;
  final int maxLine;
  final String standard;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (standard != '') {
      final splitTitle = title.toUpperCase().split(standard.toUpperCase());
      if (splitTitle.length == 2) {
        return RichText(
          text: TextSpan(
            style: isBold
                ? TextStyles.black14BoldTextStyle
                : TextStyles.black14TextStyle,
            children: <TextSpan>[
              TextSpan(text: splitTitle[0]),
              TextSpan(
                text: standard,
                style: isBold
                    ? TextStyles.orange14BoldTextStyle
                    : TextStyles.orange14TextStyle,
              ),
              TextSpan(text: splitTitle[1]),
            ],
          ),
          maxLines: maxLine,
          overflow: TextOverflow.ellipsis,
        );
      }
    }
    return Text(
      title,
      style: isBold
          ? TextStyles.black14BoldTextStyle
          : TextStyles.black14TextStyle,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}
