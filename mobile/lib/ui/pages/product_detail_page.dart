import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/firebase_analytics.dart';
import '../../utils/routes.dart';
import '../../utils/strings.dart';
import '../components/common/button/black_button_widget.dart';
import '../components/common/dialog_widget.dart';
import '../components/common/header_title_widget.dart';
import '../components/product/product_detail_widget.dart';
import '../modules/common/handle_network_module.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({@required this.item});

  final ProductListViewModel item;

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Products_View');
    return Provider<ProductDetailBloc>(
      create: (context) => ProductDetailBloc(
        productId: item.id,
        productType: item.typeName,
      ),
      dispose: (context, bloc) {
        print('product detail dispose');
        bloc.dispose();
      },
      child: ProductDetailBuild(item: item),
    );
  }
}

class ProductDetailBuild extends StatefulWidget {
  const ProductDetailBuild({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ProductListViewModel item;

  @override
  _ProductDetailBuildState createState() => _ProductDetailBuildState();
}

class _ProductDetailBuildState extends State<ProductDetailBuild> {
  bool buyButtonIsUnable;
  ScrollController scrollController;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);
    buyButtonIsUnable = true;
  }

  Widget buildBuyButton(BuildContext context, ProductListViewModel item) {
    return SafeArea(
      child: StreamBuilder<ProductDetailViewModel>(
          stream: Provider.of<ProductDetailBloc>(context).productModel,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              buyButtonIsUnable = true;
              return Container(
                height: 1,
              );
            } else {
              buyButtonIsUnable = false;
            }

            final product = snapshot.data;

            return ProductDetailBuyButton(
              buyButtonIsUnable: buyButtonIsUnable,
              product: product,
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ProductDetailBloc detailBloc = Provider.of<ProductDetailBloc>(context);
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
        title: HeaderTitleWidget(
            title: widget.item.typeName == 'CONTENT' ? '' : widget.item.name),
      ),
      bottomNavigationBar: buildBuyButton(context, widget.item),
      body: HandleNetworkModule(
        networkState: Provider.of<ProductDetailBloc>(context).networkState,
        retry: () {
          Provider.of<ProductDetailBloc>(context).fetch();
        },
        preventStartState: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: ProductDetailWidget(widget.item),
        ),
      ),
    );
  }
}

class ProductDetailBuyButton extends StatelessWidget {
  const ProductDetailBuyButton({
    this.buyButtonIsUnable,
    this.product,
  });

  final bool buyButtonIsUnable;
  final ProductDetailViewModel product;

  @override
  Widget build(BuildContext context) {
    final detailBloc = Provider.of<ProductDetailBloc>(context);
    if (product.typeName == 'CONTENT') {
      return Container(
        child: const Text(''),
      );
    }
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        child: BlackButtonWidget(
          isUnabled: buyButtonIsUnable,
          title: '구매하기',
          onPressed: () {
            if (product.typeName == 'EXPERIENCE') {
              AppRoutes.productPurchasePage(
                  context: context,
                  item: detailBloc.productModel.value,
                  productOrderType: product.experienceRepo.productOrderType,
                  refundable: true);
            } else if (product.typeName == 'ECOUPON') {
              if (detailBloc.productModel.value.ecouponRepo.options.isEmpty) {
                DialogWidget.buildDialog(
                  context: context,
                  title: ErrorTexts.optionNotExists,
                  buttonTitle: CommonTexts.confirmButton,
                );
              } else {
                AppRoutes.purchaseOptionItemPage(
                  context,
                  '',
                  product.id,
                  detailBloc.productModel.value.ecouponRepo.options[0],
                );
              }
            }
          },
        ),
      ),
    );
  }
}
