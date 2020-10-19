import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/html_parser.dart';
import 'package:html_widget/style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/custom_cache_manager.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/routes.dart';
import '../../../utils/singleton.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../pages/discovery/search/discovery_search_page.dart';
import '../common/border_widget.dart';
import '../common/customer_center_widget.dart';
import '../common/list_style_text_widget.dart';
import '../common/loading_widget.dart';
import '../common/placeholder_widget.dart';
import '../common/product-list/category_text_widget.dart';
import '../common/product-list/list_title_widget.dart';
import '../main/feed_coupon_widget.dart';
import 'html_widget.dart';
import 'recommends_listview_widget.dart';

class ProductDetailWidget extends StatelessWidget {
  const ProductDetailWidget(
    this.item,
  );

  final ProductListViewModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          ProductTopHead(
            // heroTagName: heroTagName,
            name: item.name,
            images: item.images,
            coverImage: item.image,
            availableDateInfo: item.availableDateInfo,
            typeName: item.typeName,
            categories: item.categories,
            salePrice: item.salePrice,
            coverPrice: item.coverPrice,
            discountRate: item.discountRate,
            summary: item.summary,
          ),
          BoarderWidget(),
          ProductDetail(),
        ]));
  }
}

//productListModel productDetailModel 둘중아무나 들어올수있으므로 각각받음
class ProductTopHead extends StatelessWidget {
  const ProductTopHead(
      {this.name,
      this.images,
      this.coverImage,
      this.availableDateInfo = const AvailableDateInfoModel(),
      this.typeName,
      this.categories,
      this.salePrice,
      this.coverPrice,
      this.discountRate,
      this.summary});

  final AvailableDateInfoModel availableDateInfo;
  final List<CategoryModel> categories;
  final ImageViewModel coverImage;
  final int coverPrice;
  final int discountRate;
  final List<ImageViewModel> images;
  final String name;
  final int salePrice;
  final String summary;
  final String typeName;

  Widget buildSwipe(BuildContext context, String url) {
    return Container(
        height: 270,
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager(),
          fit: typeName == 'ECOUPON' ? BoxFit.fitHeight : BoxFit.cover,
          imageUrl: url,
          placeholder: (context, url) => PlaceholderWidget(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
  }

  Widget buildSummary(BuildContext context) {
    if (summary != '' && summary != null) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Text(
                summary.toString(),
                textAlign: TextAlign.left,
                style: TextStyles.black14TextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget buildContent(BuildContext context) {
    final formatter = NumberFormat('#,###');
    print('typeName $typeName');
    if (typeName == 'EXPERIENCE') {
      return Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),

            // buildSummary(context),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: RichText(
                  text: TextSpan(
                    text: coverPrice == 0
                        ? ''
                        : '${formatter.format(coverPrice)} 원',
                    style: TextStyles.grey14LineThroughTextStyle,
                  ),
                ),
              ),
            ),
            buildSalePriceRow(context),
            const SizedBox(height: 24),
          ],
        ),
      );
    } else if (typeName == 'CONTENT') {
      return categories.isEmpty
          ? Container(
              height: 24,
            )
          : Container(
              margin: const EdgeInsets.only(
                  top: 16, left: 24, right: 24, bottom: 24),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      categories.isEmpty ? '' : categories[0].nodes[0].name,
                      style: TextStyles.black14TextStyle,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 1,
                    color: const Color(0xffeeeeee),
                    height: 12,
                  ),
                  Container(
                    child: Text(
                      categories.isEmpty
                          ? ''
                          : categories[0].nodes[0].nodes[0].name,
                      style: TextStyles.black14TextStyle,
                    ),
                  ),
                ],
              ),
            );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            buildSummary(context),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: RichText(
                  text: TextSpan(
                    text: coverPrice == 0
                        ? ''
                        : '${formatter.format(coverPrice)} 원',
                    style: TextStyles.grey14LineThroughTextStyle,
                  ),
                ),
              ),
            ),
            buildSalePriceRow(context),
            const SizedBox(height: 24),
          ],
        ),
      );
    }
  }

  Widget buildSalePriceRow(BuildContext context) {
    final formatter = NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              salePrice == 0 ? '' : '${formatter.format(salePrice)} 원',
              textAlign: TextAlign.left,
              style: TextStyles.black24BoldTextStyle,
            ),
          ),
          const SizedBox(width: 6.0),
          Text(
            '${discountRate.toStringAsFixed(0)}%할인',
            style: TextStyles.orange18TextStyle,
          ),
        ],
      ),
    );
  }

//images , availableDateInfo , typename, price , categories , summary
  @override
  Widget build(BuildContext context) {
    var itemImages = <ImageViewModel>[];
    if (images != null) {
      itemImages = images;
    } else {
      itemImages.add(coverImage);
    }
    print(itemImages[0].url);
    //images ==null?
    return Container(
        // color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
      // 디자인의 요청으로 상단에 이미지 고정.
      Align(
        child: Container(
          height: 270 * DeviceRatio.scaleWidth(context),
          child: itemImages.length > 1
              ? Swiper(
                  itemCount: itemImages.length > 22 ? 22 : itemImages.length,
                  autoplay: true,
                  loop: true,
                  curve: Curves.ease,
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          color: const Color(0xffffffff).withOpacity(0.5),
                          activeColor: Colors.white)),
                  itemBuilder: (context, index) {
                    return buildSwipe(context, images[index].url);
                  },
                )
              : Swiper(
                  itemCount: 1,
                  autoplay: false,
                  loop: false,
                  itemBuilder: (context, index) {
                    return buildSwipe(context, itemImages[0].url);
                  },
                ),
        ),
      ),
      if (typeName == 'EXPERIENCE')
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (availableDateInfo.name != '')
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 7, bottom: 7),
                  color: const Color(0xfff8f8f8), //Color(0xff000000),
                  child: Text(
                    availableDateInfo.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(int.parse(availableDateInfo.color))),
                  ),
                ),
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
                child: Text(name,
                    textAlign: TextAlign.left,
                    style: TextStyles.black20BoldTextStyle),
              )
            ],
          ),
        ),
      if (typeName == 'ECOUPON' && categories != null)
        Container(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CategoryTextWidget(
                categories: categories,
                textStyle: TextStyles.black14TextStyle,
              ),
              Container(
                child: Text(name,
                    textAlign: TextAlign.left,
                    style: TextStyles.black20BoldTextStyle),
              ),
            ],
          ),
        ),

      if (typeName == 'CONTENT')
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: Text(name,
                    textAlign: TextAlign.left,
                    style: TextStyles.black20BoldTextStyle),
              )
            ],
          ),
        ),

      buildContent(context)
    ]));
  }
}

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: Provider.of<ProductDetailBloc>(context).repoData,
        builder: (context, repoSnapshot) {
          if (!repoSnapshot.hasData) {
            return Container(
                margin: const EdgeInsets.only(top: 48),
                child: const LoadingWidget());
          }
          final ProductDetailViewModel detailItem =
              repoSnapshot.data['product'];

          final List<FeedCouponModel> couponList =
              repoSnapshot.data['couponList'];

          // print(detailItem.experienceRepo);
          return ProductDetailSummary(
              detailItem: detailItem, couponList: couponList);
        });
  }
}

class ProductDetailSummary extends StatelessWidget {
  ProductDetailSummary({
    @required this.detailItem,
    @required this.couponList,
  });

  final List<FeedCouponModel> couponList;
  final ProductDetailViewModel detailItem;

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  Widget buildGalleryImages(
      BuildContext context, List<ImageViewModel> galleryImages) {
    if (galleryImages.isEmpty) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: BoarderWidget()),
          ListTitleWidget(title: ProductDetailPageStrings.galleryImages),
          Container(
            height: 224 * DeviceRatio.scaleWidth(context),
            // width: 300 * DeviceRatio.scaleWidth(context),
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 16),
            child: PageView.builder(
              controller:
                  PageController(viewportFraction: 0.86, initialPage: 0),
              itemCount: galleryImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 300 * DeviceRatio.scaleWidth(context),
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 224,
                      width: MediaQuery.of(context).size.width,
                      imageUrl: galleryImages[index].url,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAuthorInfo(BuildContext context, AuthorModel author) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BoarderWidget(),
          Container(
              margin: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                '안녕하세요 ${author.name} 입니다.',
                style: TextStyles.black20BoldTextStyle,
              )),
          Text(
            author.introduction,
            style: TextStyles.black14TextStyle,
          )
        ],
      ),
    );
  }

  Widget buildCuration(BuildContext context) {
    if (detailItem.typeName == 'EXPERIENCE') {
      return Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 48),
            RecommendsListViewProvider(
                item: detailItem,
                titleName: '다음 액티비티',
                typeName: detailItem.typeName,
                neighbor: true),
            // 추천 컨텐츠
            RecommendsListViewProvider(
                item: detailItem,
                titleName: '추천 액티비티',
                typeName: detailItem.typeName,
                neighbor: false),
          ],
        ),
      );
    } else if (detailItem.typeName == 'CONTENT') {
      return RecommendsListViewProvider(
          item: detailItem,
          titleName: '추천 콘텐츠',
          typeName: detailItem.typeName,
          neighbor: false);
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget buildKakaoButton(BuildContext context) {
    if (detailItem.typeName == 'CONTENT') {
      return Container();
    } else {
      return Container(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(children: <Widget>[
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  '고객센터',
                  textAlign: TextAlign.left,
                  style: TextStyles.black20BoldTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const CustomerCenterWidget(
              onlyKakao: true,
            ),
          ]));
    }
  }

  Widget buildRelationTags(BuildContext context) {
    if (detailItem.tags.isNotEmpty && detailItem.tags != null) {
      return Column(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 24, top: 24),
                  child: Text(
                    '관련태그',
                    textAlign: TextAlign.left,
                    style: TextStyles.black20BoldTextStyle,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: buildTagRowWidget(context),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  List<Widget> buildTagRowWidget(BuildContext context) {
    final list = <Widget>[];
    final tArray = detailItem.tags;
    for (var i = 0; i < tArray.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          AppRoutes.replace(
              context,
              DiscoverySearchPage(
                keyword: tArray[i],
                searchBodyState: SearchBodyState.Result,
              ));

          // AppRoutes.discoverySearchPage(context,
          //     searchBodyState: SearchBodyState.Result, keyword: tArray[i]);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 4, bottom: 4),
          padding:
              const EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.smallBoxColor),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            tArray[i],
            style: TextStyles.grey14TextStyle,
          ),
        ),
      ));
    }

    return list;
  }

  // 위치
  Widget buildLocation(BuildContext context) {
    final markers = <Marker>{};

    if (detailItem.lat == 0.0 ||
        detailItem.lng == 0.0 ||
        detailItem.lat == null ||
        detailItem.lng == null) {
      return Container(
        height: 0.0,
      );
    } else {
      markers.add(
        Marker(
            markerId: MarkerId('detailmarker'),
            // icon: BitmapDescriptor.fromAsset('assets/images/group_3.png'),
            position: LatLng(detailItem.lat, detailItem.lng)),
      );
      return Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BoarderWidget(),
            const SizedBox(height: 24),
            Container(
              child: Text(
                ProductDetailPageStrings.experienceProductLocation,
                textAlign: TextAlign.left,
                style: TextStyles.black20BoldTextStyle,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 24),
              height: 210.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: GoogleMap(
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
                zoomGesturesEnabled: true,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(detailItem.lat, detailItem.lng),
                  zoom: 16,
                ),
                markers: Set<Marker>.of(markers),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
              ),
            ),
            if (detailItem.experienceRepo.sourceType == 'SSSD')
              Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Image.asset(ImageAssets.somssidangImage)),
            BoarderWidget(),
          ],
        ),
      );
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _markers.clear();
    final markerId = MarkerId('11234');

    final marker = Marker(
      markerId: markerId,
      position: LatLng(detailItem.lat, detailItem.lng),
      icon: BitmapDescriptor.defaultMarker,
    );

    _markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {
    var contentTitle = '';
    if (detailItem.categories != null && detailItem.categories.isNotEmpty) {
      contentTitle = detailItem.categories[0].name;
    }
    final _analyticsParameter = <String, dynamic>{
      'item_id': detailItem.id,
      'item_name': detailItem.name,
      'content_title': contentTitle,
      'location': '${Singleton.instance.curLat},${Singleton.instance.curLng}',
    };
    Analytics.analyticsLogEvent('view_item', _analyticsParameter);

    switch (detailItem.typeName) {
      case 'EXPERIENCE':
        const fontHeight = 1.4;
        return Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 8),
              child: CouponListWidget(
                couponList: couponList,
              ),
            ),
            ProductDetailCheckPointWidget(
                keyinfos: detailItem.experienceRepo.keyinfos),

            // 매력포인트
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.highlight,
              html: detailItem.experienceRepo.highlight,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            //강사소개
            if (detailItem.experienceRepo.sourceType == 'SSSD')
              buildAuthorInfo(context, detailItem.experienceRepo.author),

            //프로그램,클래스소개
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductDetail,
              html: detailItem.message,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            // 사용방법
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductHowToUse,
              html: detailItem.experienceRepo.howtouse,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            //포함사항
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductInclusion,
              html: detailItem.experienceRepo.inclusions,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            //불포함 사항
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductExclusion,
              html: detailItem.experienceRepo.exclusions,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            if (detailItem.experienceRepo.sourceType == 'SSSD')
              buildGalleryImages(
                  context, detailItem.experienceRepo.galleryImages),

            //꼭 알아두세요
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductNotice,
              html: detailItem.experienceRepo.notice,
              subHtml: detailItem.experienceRepo.pointInfo,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            //환불 규정
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductRefund,
              html: detailItem.experienceRepo.refund,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            //자주 묻는 질문
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductFaq,
              html: detailItem.experienceRepo.faq,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            // //지도
            buildLocation(context),
            // //추천
            buildCuration(context),
            // //관련태그
            buildRelationTags(context),
            // //고객센터
            buildKakaoButton(context),

            const SizedBox(height: 20.0),
          ],
        ));
        break;
      case 'CONTENT':
        return Container(
          child: Column(
            children: <Widget>[
              ProductDetailHtmlWidget(
                topBorder: false,
                html: detailItem.message,
                fontHeight: 2.0,
                typeName: detailItem.typeName,
              ),
              buildCuration(context),
            ],
          ),
        );

        break;
      case 'ECOUPON':
        const fontHeight = 1.4;
        return Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 8),
              child: CouponListWidget(
                couponList: couponList,
              ),
            ),
            //이용 정보
            ProductDetailHtmlWidget(
              topBorder: false,
              label: ProductDetailPageStrings.ecouponProductHowToUse,
              html: detailItem.ecouponRepo.howtouse,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),
            //공지 정보
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.ecouponProductNotice,
              html: detailItem.ecouponRepo.notice,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),

            //환불 규정
            ProductDetailHtmlWidget(
              label: ProductDetailPageStrings.experienceProductRefund,
              html: detailItem.ecouponRepo.refund,
              fontHeight: fontHeight,
              typeName: detailItem.typeName,
            ),

            buildRelationTags(context),
            buildKakaoButton(context),
            buildCuration(context),
            const SizedBox(height: 20.0),
          ],
        ));
        break;

      default:
        return ProductDetailHtmlWidget(
            topBorder: false, html: detailItem.message, fontHeight: 2.0);
        break;
    }
  }
}

class ProductDetailHtmlWidget extends StatelessWidget {
  const ProductDetailHtmlWidget({
    this.label = '',
    @required this.html,
    this.subHtml = '',
    this.topBorder = true,
    this.fontHeight = 1.2,
    this.typeName,
  });

  final double fontHeight;
  final String html;
  final String label;
  final String subHtml;
  final bool topBorder;
  final String typeName;

  @override
  Widget build(BuildContext context) {
    if (html.length < 10) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (topBorder)
          Container(
              margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: BoarderWidget())
        else
          Container(),
        if (label != '')
          Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: TextStyles.black20BoldTextStyle,
            ),
          )
        else
          Container(),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: HtmlWidget(
              html: html, fontHeight: fontHeight, typeName: typeName),
        ),
        if (subHtml.length > 10)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                // color: Colors.red,
                border: Border.all(color: const Color(0xffffc7c7)),
                borderRadius: BorderRadius.circular(4)),
            child: Html(
              data: subHtml,
              customRender: <String, CustomRender>{
                'p': (context, child, attributes, element) {
                  print('element.text ${element.text}');
                  if (element.text.isEmpty) {
                    return Container();
                  }
                  return Container(
                      child: ListStyleTextWidget(
                    text: element.text,
                    style: TextStyles.red14TextStyle,
                    dotColor: const Color(0xffff4242),
                  ));
                },
                'li': (context, child, attributes, element) {
                  print('element.text ${element.text}');
                  if (element.text.isEmpty) {
                    return Container();
                  }
                  return Container(
                      child: ListStyleTextWidget(
                    text: element.text,
                    style: TextStyles.red14TextStyle,
                    dotColor: const Color(0xffff4242),
                  ));
                },
              },
              style: <String, Style>{
                'body': Style(
                  margin: const EdgeInsets.all(0),
                ),
              },
            ),
          )
        else
          Container(),
        const SizedBox(height: 24),
      ],
    );
  }
}

class ProductDetailCheckPointWidget extends StatelessWidget {
  const ProductDetailCheckPointWidget({this.keyinfos});

  final List<ProductExperienceKeyInfoModel> keyinfos;

  Widget buildCheckPointRowWidget(BuildContext context, int nowRow) {
    print(
      keyinfos[nowRow].coverImage.url,
    );
    return Row(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(right: 6),
            child: CachedNetworkImage(
              imageUrl: keyinfos[nowRow].coverImage.url,
              width: 28,
              height: 28,
            )),
        Container(
            width: 78 * DeviceRatio.scaleWidth(context),
            margin: const EdgeInsets.only(right: 16),
            child: Text(
              keyinfos[nowRow].label,
              style: TextStyles.black14TextStyle,
            )),
        Container(
            width: 184 * DeviceRatio.scaleWidth(context),
            child: Text(
              keyinfos[nowRow].value,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.grey14TextStyle,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (keyinfos == null || keyinfos.isEmpty) {
      return Container(
        height: 0.0,
      );
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 24), // right 24 -> 0
              child: Text(
                ProductDetailPageStrings.keyInfo,
                textAlign: TextAlign.left,
                style: TextStyles.black20BoldTextStyle,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 24, right: 0, top: 16, bottom: 24),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: keyinfos.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: buildCheckPointRowWidget(context, index));
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
