import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/firebase_analytics.dart';
import '../../utils/handle_network_error.dart';
import '../../utils/routes.dart';
import '../components/common/border_widget.dart';
import '../components/common/header_title_widget.dart';
import '../components/common/loading_widget.dart';
import '../components/product/product_detail_widget.dart';
import 'product_detail_page.dart';

class ProductDetailSimplePage extends StatelessWidget {
  const ProductDetailSimplePage(
      {this.heroTagName = '',
      @required this.productId,
      this.productType = '',
      this.title = ''});

  final String heroTagName;
  final String productId;
  final String productType;
  final String title;

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Products_View');
    return Provider<ProductDetailBloc>(
      create: (context) => ProductDetailBloc(
        productId: productId,
        productType: productType,
      ),
      dispose: (context, bloc) {
        print('product detail dispose');
        bloc.dispose();
      },
      child: ProductDetailBuild(
        // heroTagName: heroTagName,
        productId: productId,
        productType: productType,
        title: title,
      ),
    );
  }
}

class ProductDetailBuild extends StatefulWidget {
  const ProductDetailBuild({
    Key key,
    @required this.productId,
    @required this.productType,
    this.title,
  }) : super(key: key);

  final String productId;

  final String productType;
  final String title;

  @override
  _ProductDetailBuildState createState() => _ProductDetailBuildState();
}

class _ProductDetailBuildState extends State<ProductDetailBuild> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final detailBloc = Provider.of<ProductDetailBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        titleSpacing: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: StreamBuilder<Map<String, dynamic>>(
            stream: Provider.of<ProductDetailBloc>(context).repoData,
            builder: (context, repoSnapshot) {
              if (!repoSnapshot.hasData) {
                return const HeaderTitleWidget(title: '');
              } else {
                final ProductDetailViewModel detailItem =
                    repoSnapshot.data['product'];
                return HeaderTitleWidget(title: detailItem.name);
              }
            }),
      ),
      bottomNavigationBar: StreamBuilder<Map<String, dynamic>>(
          stream: Provider.of<ProductDetailBloc>(context).repoData,
          builder: (context, repoSnapshot) {
            if (!repoSnapshot.hasData) {
              return Container(
                height: 1,
              );
            } else {
              final ProductDetailViewModel detailItem =
                  repoSnapshot.data['product'];

              return ProductDetailBuyButton(
                buyButtonIsUnable: false,
                product: detailItem,
              );
            }
          }),
      body: StreamBuilder<NetworkState>(
          stream: Provider.of<ProductDetailBloc>(context).networkState,
          builder: (context, stateSnapshot) {
            return HandleNetworkError.handleNetwork(
              context: context,
              state: stateSnapshot.data,
              preventStartState: true,
              retry: () {
                detailBloc.fetch();
              },
              child: StreamBuilder<Map<String, dynamic>>(
                  stream: Provider.of<ProductDetailBloc>(context).repoData,
                  builder: (context, repoSnapshot) {
                    if (!repoSnapshot.hasData) {
                      return Container(
                          alignment: Alignment.center,
                          child: const LoadingWidget());
                    } else {
                      final ProductDetailViewModel detailItem =
                          repoSnapshot.data['product'];

                      final List<FeedCouponModel> couponList =
                          repoSnapshot.data['couponList'];

                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ProductTopHead(
                              // heroTagName: heroTagName,
                              name: detailItem.name,
                              images: detailItem.images,
                              coverImage: detailItem.coverImage,
                              availableDateInfo: detailItem.availableDateInfo,
                              typeName: detailItem.typeName,
                              categories: detailItem.categories,
                              salePrice: detailItem.salePrice,
                              coverPrice: detailItem.coverPrice,
                              discountRate: detailItem.discountRate,
                              summary: detailItem.summary,
                            ),
                            BoarderWidget(),
                            ProductDetailSummary(
                                detailItem: detailItem, couponList: couponList),
                          ],
                        ),
                      );
                    }
                  }),
            );
          }),
    );
  }
}
