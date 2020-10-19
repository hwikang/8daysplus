import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/handle_network_error.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/loading_widget.dart';

class MyOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Mypage_Purchase');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: const HeaderTitleWidget(title: MyPageStrings.myOrderList),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Provider<MyOrderBloc>(
        create: (context) => MyOrderBloc(first: 10),
        child: MyOrderPageModule(),
      ),
    );
  }
}

class MyOrderPageModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (refreshPagesBloc.refreshReservationPageState) {
      final myOrderPageBloc = Provider.of<MyOrderBloc>(context);
      myOrderPageBloc.fetch(); // refetch
      refreshPagesBloc.changeMyOrderPageRefreshState(false);
    }

    final myOrderBloc = Provider.of<MyOrderBloc>(context);
    return StreamBuilder<NetworkState>(
        stream: Provider.of<MyOrderBloc>(context).networkState,
        builder: (context, stateSnapshot) {
          return HandleNetworkError.handleNetwork(
            state: stateSnapshot.data,
            context: context,
            retry: myOrderBloc.fetch,
            child: MyOrderPageBody(),
          );
        });
  }
}

class MyOrderPageBody extends StatefulWidget {
  // MyOrderPageBody({this.list});
  // List<MyOrderPageModel> list;

  @override
  _MyOrderPageBodyState createState() => _MyOrderPageBodyState();
}

class _MyOrderPageBodyState extends State<MyOrderPageBody> {
  int nowYear;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // dropDownValue = '${DateTime.now().year}';
    nowYear = DateTime.now().year;
    _scrollController.addListener(() {
      Future<void>.delayed(Duration.zero, () {
        final bloc = Provider.of<MyOrderBloc>(context);
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (bloc.networkState.value != NetworkState.Finish) {
            bloc.getMoreOrder();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final myOrderBloc = Provider.of<MyOrderBloc>(context);
    return RefreshIndicator(
      onRefresh: myOrderBloc.fetch,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
          height: 36 * DeviceRatio.scaleRatio(context),
          padding: const EdgeInsets.only(left: 24, top: 8),
          decoration: const BoxDecoration(color: Color(0xfffafafa)),
          child: Row(
            children: <Widget>[
              Container(
                // width: 47,3
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xff909090),
                    size: 20,
                  ),
                  isExpanded: false,
                  value: myOrderBloc.selectedYear.value,
                  onChanged: (newValue) {
                    print('newValue $newValue');
                    // setState(() {
                    //   dropDownValue = newValue;
                    // });
                    myOrderBloc.selectYear(newValue);
                    final myOrderPageBloc = Provider.of<MyOrderBloc>(context);
                    myOrderPageBloc.fetch(); // refetch
                  },
                  items: <String>[
                    '${nowYear - 2}',
                    '${nowYear - 1}',
                    '$nowYear'
                  ].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        '$value년',
                        style: TextStyles.grey14TextStyle,
                      ),
                    );
                  }).toList(),
                )),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<MyOrderPageModel>>(
            stream: Provider.of<MyOrderBloc>(context).repoList,
            builder: (context, orderSnapshot) {
              if (!orderSnapshot.hasData) {
                return const LoadingWidget();
              }
              if (orderSnapshot.data.isEmpty) {
                return MyOrderPageEmptyBody();
              }
              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: orderSnapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index == orderSnapshot.data.length) {
                    final networkState =
                        Provider.of<MyOrderBloc>(context).networkState.value;
                    print(networkState);
                    if (networkState == NetworkState.Finish) {
                      return Container();
                    }
                    return const LoadingWidget();
                  }
                  return MyOrderItem(
                    orderModel: orderSnapshot.data[index],
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class MyOrderItem extends StatelessWidget {
  const MyOrderItem({this.orderModel});

  final MyOrderPageModel orderModel;

  Widget _buildOrderItemProduct(
      BuildContext context, OrderListViewModel model) {
    return GestureDetector(
      onTap: () {
        AppRoutes.myOrderDetailPage(context, model.orderCode);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xfff8f8f8),
                  borderRadius: BorderRadius.circular(4)),
              height: 72,
              width: 72,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  '${model.orderInfo.options[0].orderProduct.product.image.url}?s=144x144',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildOrderItemProductName(
                        context,
                        model.orderInfo.options[0].orderProduct.product.name,
                        model.orderInfo.options.length),
                    _buildPaymentPrice(
                        model.paymentPrice, model.totalPrice, model)
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemProductName(
      BuildContext context, String name, int itemLength) {
    var textSpan = const TextSpan(text: '');
    if (itemLength > 1) {
      textSpan = TextSpan(
        text: ' 외 ${itemLength - 1}건',
        style: TextStyles.black12TextStyle,
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 228,
      height: 40 * DeviceRatio.scaleRatio(context),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textScaleFactor:
            MediaQuery.textScaleFactorOf(context), //rich text 는 이렇게 해줘야 사이즈맞음
        text: TextSpan(
            text: '$name ',
            style: TextStyles.black14BoldTextStyle,
            children: <InlineSpan>[textSpan]),
      ),
    );
  }

  Widget _buildPaymentPrice(
      int paymentPrice, int totalPrice, OrderListViewModel orderModel) {
    final formatter = NumberFormat('#,###');
    final orderedProducts = orderModel.orderInfo.options;
    var refundPriceAll = 0;
    orderedProducts.map((option) {
      refundPriceAll += option.orderProduct.orderRefund.refundPrice;
      refundPriceAll += option.orderProduct.orderRefund.refundPointPrice;
      refundPriceAll += option.orderProduct.orderRefund.refundCouponPrice;
    }).toList();

    if (refundPriceAll == 0) {
      return Text(
        '${formatter.format(orderModel.orderPrice)}원',
        style: TextStyles.black12TextStyle,
      );
    }
    return Row(
      children: <Widget>[
        Text(
          '${formatter.format(orderModel.orderPrice)}원',
          style: TextStyles.grey12LineThroughTextStyle,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '${formatter.format(totalPrice)}원',
          style: TextStyles.black12TextStyle,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: 24,
              top: 14,
            ),
            width: MediaQuery.of(context).size.width,
            height: 48 * DeviceRatio.scaleRatio(context),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
            child: Text(
              '주문일 ${orderModel.day}',
              style: TextStyles.black12TextStyle,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderModel.nodes.length * 2 - 1,
            itemBuilder: (context, index) {
              if (index.isOdd) {
                return Container(
                  height: 1,
                  color: const Color(0xffeeeeee),
                );
              }
              return _buildOrderItemProduct(
                  context, orderModel.nodes[index ~/ 2]);
            },
          ),
          Container(
              height: 12,
              decoration: const BoxDecoration(color: Color(0xfff8f8f8)))
        ],
      ),
    );
  }
}

class MyOrderPageEmptyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: DeviceRatio.getDeviceHeight(context) -
            36 * DeviceRatio.scaleRatio(context) -
            100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              MyPageStrings.order_empty,
              style: TextStyles.grey16TextStyle,
            ),
            Text(
              MyPageStrings.order_recommendMyStyle,
              style: TextStyles.grey16TextStyle,
            ),
          ],
        ));
  }
}
