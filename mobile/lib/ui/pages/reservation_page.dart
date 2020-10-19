import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/assets.dart';
import '../../utils/device_ratio.dart';
import '../../utils/firebase_analytics.dart';
import '../../utils/routes.dart';
import '../../utils/strings.dart';
import '../../utils/text_styles.dart';
import '../components/common/button/white_button_widget.dart';
import '../components/common/dialog_widget.dart';
import '../components/common/loading_widget.dart';
import '../components/common/product-order/product_state_widget.dart';
import '../modules/common/handle_network_module.dart';
import 'main/main_alarm_page.dart';
import 'member/member_main_page.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  Widget page = Container(
    height: 0.0,
  );

  @override
  void initState() {
    super.initState();
    AppRoutes.authCheck(context).then((isLogin) {
      setState(() {
        if (isLogin) {
          page = Provider<ReservationPageBloc>(
              create: (context) => ReservationPageBloc(),
              child: ReservationMainPage());
        } else {
          page = SafeArea(child: MemberMainPage());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      return page;
    } else {
      return Container();
    }
  }
}

class ReservationMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Reservation');
    final reservationPageBloc = Provider.of<ReservationPageBloc>(context);

    return SafeArea(
        child: StreamBuilder<bool>(
            stream: Provider.of<RefreshPagesBloc>(context)
                .refreshReservationPageController,
            initialData: false,
            builder: (context, refreshSnapshot) {
              if (refreshSnapshot.data) {
                refreshPagesBloc.changeReservationPageRefreshState(false);
                reservationPageBloc.fetch(); // refetch
              }
              return HandleNetworkModule(
                networkState:
                    Provider.of<ReservationPageBloc>(context).networkState,
                preventStartState: true,
                retry: () {
                  Provider.of<ReservationPageBloc>(context).fetch();
                },
                child: RefreshIndicator(
                    onRefresh: () {
                      return Provider.of<ReservationPageBloc>(context).fetch();
                    },
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        titleSpacing: 0,
                        title: Container(
                          margin: const EdgeInsets.only(left: 24),
                          child: Text(
                            ReservationPageStrings.title,
                            style: TextStyles.black20BoldTextStyle,
                          ),
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.white,
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              AppRoutes.cartListPage(context);
                            },
                            child: Image.asset(
                              ImageAssets.bagImage,
                              width: 40,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 14),
                            child: GestureDetector(
                              onTap: () {
                                // MainAlarmPage();
                                Navigator.of(context).push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                      builder: (context) {
                                    return MainAlarmPage();
                                  }),
                                );
                              },
                              child: Image.asset(
                                // ImageAssets.alertOnImage,
                                ImageAssets.alertOffImage,
                                width: 40,
                              ),
                            ),
                          )
                        ],
                      ),
                      body: StreamBuilder<List<ReservationPageModel>>(
                          stream: Provider.of<ReservationPageBloc>(context)
                              .repoList,
                          builder: (context, orderSnapshot) {
                            if (!orderSnapshot.hasData) {
                              return const LoadingWidget();
                            }
                            return ReservationWidget(
                                list: orderSnapshot.data
                                    .map((e) => e.node)
                                    .toList());
                          }),
                    )),
              );
            }));
  }
}

class ReservationWidget extends StatelessWidget {
  ReservationWidget({this.list});

  final DialogWidget dialogWidget = DialogWidget();
  final List<OrderListViewModel> list;

  Widget _buildOrderContainer(BuildContext context, OrderListViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 48 * DeviceRatio.scaleRatio(context),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
            padding: const EdgeInsets.only(left: 24, top: 14),
            child: Text(
              '${ReservationPageStrings.orderDate} ${model.orderDate}',
              style: TextStyles.black12TextStyle,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            addRepaintBoundaries: false,
            key: PageStorageKey<String>('reserve-${model.id}'),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.orderInfo.options.length,
            itemBuilder: (context, index) {
              return _buildOrderItem(context, model, model.orderInfo, index);
            },
          ),
          Container(
              height: 12,
              decoration: const BoxDecoration(color: Color(0xfff8f8f8)))
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderListViewModel model,
      CreateOrderInputModel orderInfoModel, int optionIndex) {
    final productModel = orderInfoModel.options[optionIndex].orderProduct;
    final formatter = NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              AppRoutes.reservationDetailPage(
                  context, model.orderCode, optionIndex);
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.network(
                      '${productModel.product.image.url}?s=144x144',
                      width: 72,
                      height: 72,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ProductStateWidget(
                          productModel: productModel,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) + 48,
                          child: Text(
                            '${productModel.product.name}',
                            style: TextStyles.black14BoldTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${formatter.format(productModel.totalPrice)}원',
                          style: TextStyles.black12TextStyle,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        if (productModel.product.sourceType != 'EVENT' &&
                            productModel.product.sourceType != 'EVENT_COUPON')
                          Text(
                            productModel.product.typeName != 'ECOUPON'
                                ? '${ReservationPageStrings.useDate} ${productModel.reserveDate}'
                                : '${ReservationPageStrings.expiryDate} ${productModel.reserveDate} 까지',
                            style: TextStyles.black12TextStyle,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (productModel.product.sourceType != 'EVENT' &&
              productModel.product.sourceType != 'EVENT_COUPON')
            _buildVoucherButton(
                context, model, productModel, orderInfoModel, optionIndex),
        ],
      ),
    );
  }

  Widget _buildVoucherButton(
    BuildContext context,
    OrderListViewModel model,
    OrderInfoProductModel productModel,
    CreateOrderInputModel orderInfoModel,
    int optionIndex,
  ) {
    String title;
    Function onPressed;
    switch (productModel.voucherType) {
      case 'VoucherUrlPath':
        switch (productModel.state) {
          case 'COMPLETE_PAYMENT':
          case 'PENDING_RESERVE':
            title = ReservationPageStrings.voucherLoading;
            onPressed = () {
              Scaffold.of(context).showSnackBar(const SnackBar(
                content: Text(ReservationPageStrings.voucherLoadingGuide),
              ));
            };
            break;
          case 'COMPLETE_RESERVE':
            title = ReservationPageStrings.voucherSee;
            onPressed = () {
              AppRoutes.reservationVoucherPage(
                  context, optionIndex, orderInfoModel);
            };
            break;

          default:
        }

        break;
      case 'VoucherPays':
        title = ReservationPageStrings.barcodeSee;
        onPressed = () {
          AppRoutes.reservationBarcodePage(
              context, model, productModel, orderInfoModel, optionIndex);
        };
        break;

      default:
    }
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: 312 * DeviceRatio.scaleWidth(context),
      child: WhiteButtonWidget(
        title: title,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? ListView(children: <Widget>[
            Container(
                height: (560) * DeviceRatio.scaleHeight(context) - 48,
                child: Center(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        ImageAssets.reservationNotFoundImage,
                        width: 160,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '예약된 8DAYS+ 상품이 없습니다.',
                        style: TextStyles.grey16TextStyle,
                      ),
                    ],
                  ),
                ))),
          ])
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildOrderContainer(context, list[index]);
            },
          );
  }
}
