import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../common/placeholder_widget.dart';
import '../common/product-list/list_title_widget.dart';

class FeedSlideProductWidget extends StatelessWidget {
  const FeedSlideProductWidget({this.productList, this.title});

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
          ListTitleWidget(
            title: title,
          ),
          const SizedBox(height: 14),
          PageProductWidget(
            productList: productList,
          ),
          // SizedBox(height: 48),
        ],
      ),
    );
  }
}

class PageProductWidget extends StatelessWidget {
  const PageProductWidget({this.productList});

  final List<ProductListViewModel> productList;

  Widget _buildPage(BuildContext context, ProductListViewModel model) {
    return GestureDetector(
      onTap: () => AppRoutes.productDetailPage(context, model),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Stack(
          children: <Widget>[
            Container(
              height: 224,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${model.image.url}',
                  placeholder: (context, url) => PlaceholderWidget(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Container(
              height: 224,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xff000000).withOpacity(0.2999999821186066),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 24, right: 24, top: 50),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${model.name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Container(
                        child: _buildPlaceAndPeriodText(context,
                            model.contentRepo.period, model.contentRepo.place),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceAndPeriodText(
      BuildContext context, String period, String place) {
    final formatter = DateFormat('yyyy.MM.dd');

    Widget periodText;
    Widget placeText;

    if (period.isEmpty && place.isEmpty) {
      return Container();
    }

    if (period.isEmpty) {
      periodText = const Text('');
    } else {
      final dateArr = period.split('~');

      periodText = Text(
        '${formatter.format(DateTime.parse(dateArr[0]))}~${formatter.format(DateTime.parse(dateArr[1]))}',
        style: TextStyles.white14TextStyle,
      );
    }
    if (place.isEmpty) {
      placeText = const Text('');
    } else {
      placeText = Text(
        '$place',
        maxLines: 2,
        style: TextStyles.white14TextStyle,
      );
    }
    return Container(
        margin: const EdgeInsets.only(top: 16),
        height: 45 * MediaQuery.of(context).textScaleFactor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  MainPageStrings.period,
                  style: TextStyles.white14TextStyle,
                ),
                const SizedBox(
                  width: 6,
                ),
                periodText,
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 39),
                    child: Text(
                      MainPageStrings.place,
                      style: TextStyles.white14TextStyle,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth:
                            300 * DeviceRatio.scaleWidth(context) - 48 - 39),
                    child: Container(child: placeText),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 224,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        key: PageStorageKey(UniqueKey()),
        controller:
            PageController(viewportFraction: 1 - (0.12), initialPage: 0),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return _buildPage(context, productList[index]);
        },
      ),
    );
  }
}
