import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../../utils/action_link.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../common/dialog_widget.dart';
import '../common/placeholder_widget.dart';
import '../common/product-list/list_title_widget.dart';
import '../common/product-list/price_widget.dart';

class FeedPromotionWidget extends StatefulWidget {
  const FeedPromotionWidget({this.list, this.title});

  final List<FeedPromotionModel> list;
  final String title;

  @override
  _FeedPromotionWidgetState createState() => _FeedPromotionWidgetState();
}

class _FeedPromotionWidgetState extends State<FeedPromotionWidget>
    with AutomaticKeepAliveClientMixin {
  int currentIndex;
  final DialogWidget dialogWidget = DialogWidget();

  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }

  Widget _buildFeedPromotion(
      FeedPromotionModel model, int index, BuildContext context) {
    switch (model.actionLink.target) {
      case 'PROMOTION':
        if (model.product.isEmpty) {
          return _buildPromotion(model, index, context, () {
            AppRoutes.promotionListPage(
              context,
              model,
            );
          });
        } else {
          return _buildStackPromotion(model, index, context);
        }

        break;
      case 'NOTICE_EVENT_DETAIL':
      case 'WEB':
      case 'PRODUCT_DETAIL':
        return _buildPromotion(model, index, context, () {
          final actionLink = ActionLink();

          actionLink.handleActionLink(context, model.actionLink, '');
        });
        break;
      default:
        return Container();
    }
  }

  Widget _buildStackPromotion(
      FeedPromotionModel model, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.productDetailPage(context, model.product[0]);
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: 270 * DeviceRatio.scaleWidth(context),
            width: 360 * DeviceRatio.scaleWidth(context),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: model.coverImage.url,
              placeholder: (context, url) => PlaceholderWidget(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTitle(model.name),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xffffffff),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 56,
                            width: 56,
                            margin: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                  '${model.product[0].image.url}?s=112x112',
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 20 * DeviceRatio.scaleRatio(context),
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  model.product[0].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.black14TextStyle,
                                ),
                              ),
                              Container(
                                height:
                                    38 * MediaQuery.of(context).textScaleFactor,
                                child: PriceWidget(
                                    coverPrice: model.product[0].coverPrice,
                                    salePrice: model.product[0].salePrice,
                                    discountRate:
                                        model.product[0].discountRate.toInt()),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotion(FeedPromotionModel model, int index,
      BuildContext context, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 270 * DeviceRatio.scaleWidth(context),
        width: 360 * DeviceRatio.scaleWidth(context),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: model.coverImage.url,
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildTitle(String name) {
    final nameList = name.split('<br>');
    if (nameList.length >= 2) {
      return ListView.builder(
        key: PageStorageKey(UniqueKey()),
        addRepaintBoundaries: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          return Text(nameList[index], style: TextStyles.jalnanTitleTextStyle);
        },
      );
    }
    return Text(
      name,
      style: const TextStyle(
          fontFamily: 'Jalnan', fontSize: 28, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    super
        .build(context); //AutomaticKeepAliveClientMixin should call super.build

    if (widget.list.isEmpty) {
      return Container();
    }
    return Column(
      children: <Widget>[
        if (widget.title != '')
          Container(
              margin: const EdgeInsets.only(bottom: 14),
              child: ListTitleWidget(title: widget.title))
        else
          Container(),
        Container(
          height: 270 * DeviceRatio.scaleWidth(context),
          width: 360 * DeviceRatio.scaleWidth(context),
          margin: const EdgeInsets.only(bottom: 48),
          child: Stack(alignment: Alignment.topRight, children: <Widget>[
            Swiper(
              // key: PageStorageKey(UniqueKey()),
              itemCount: widget.list.length,
              onIndexChanged: (index) {
                print(index);
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildFeedPromotion(widget.list[index], index, context);
              },
            ),
            Container(
              width: 28,
              height: 16,
              margin: const EdgeInsets.only(top: 24, right: 24),
              decoration: BoxDecoration(
                  color: const Color(0xff000000).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(11)),
              child: Center(
                  child: Text(
                '${currentIndex + 1}/${widget.list.length}',
                style: TextStyles.white8TextStyle,
              )),
            ),
          ]),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
