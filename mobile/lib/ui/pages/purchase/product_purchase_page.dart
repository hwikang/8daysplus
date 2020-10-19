import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/ui/components/common/network_delay_widget.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';
import 'product_purchase_summary.dart';

class ProductPurchasePage extends StatelessWidget {
  const ProductPurchasePage({
    @required this.item,
    this.productAvailableIndexBloc,
    this.productOrderType,
    this.refundable,
  });

  final ProductDetailViewModel item;
  final ProductAvailableIndexBloc productAvailableIndexBloc;
  final String productOrderType;
  final bool refundable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                AppRoutes.pop(context);
              },
            ),
            title: const HeaderTitleWidget(title: '예약일 선택')),
        body: MultiProvider(
          providers: <SingleChildCloneableWidget>[
            Provider<ProductAvailableDatesBloc>(
              create: (context) => ProductAvailableDatesBloc(
                productDetailViewModel: item,
              ),
            ),
            Provider<ProductAvailableIndexBloc>(
              create: (context) => ProductAvailableIndexBloc(
                model: ProductAvailableIndexModel(),
              ),
            ),
          ],
          child: ProductPurchaseBuild(
              item: item, productOrderType: productOrderType),
        ));
  }
}

class ProductPurchaseBuild extends StatelessWidget {
  const ProductPurchaseBuild({
    @required this.item,
    this.productOrderType,
  });

  final ProductDetailViewModel item;
  final String productOrderType;

  @override
  Widget build(BuildContext context) {
    // final ProductAvailableIndexBloc indexBloc =
    //     Provider.of<ProductAvailableIndexBloc>(context);

    return StreamBuilder<List<ProductAvailableDateModel>>(
      stream: Provider.of<ProductAvailableDatesBloc>(context).repoList,
      builder: (context, repoSnapshot) {
        if (repoSnapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (repoSnapshot.hasError) {
          return NetworkDelayPage(
              retry: () =>
                  Provider.of<ProductAvailableDatesBloc>(context).fetch());
        }

        final listData = repoSnapshot.data;
        return ProductPurchaseSummary(
            listItem: listData, item: item, productOrderType: productOrderType);
      },
    );
  }
}
