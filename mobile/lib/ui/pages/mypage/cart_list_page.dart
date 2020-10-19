import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase_analytics.dart';
import '../../../utils/handle_network_error.dart';
import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/button/black_button_widget.dart';
import '../../components/common/circular_checkbox_widget.dart';
import '../../components/common/dialog_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';
import '../../components/common/product-order/reservation_product_widget.dart';

class CartListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Cart');
    return Provider<CartListBloc>(
        create: (context) => CartListBloc(first: 20),
        child: Scaffold(
          backgroundColor: Colors.white,
          // resizeToAvoidBottomPadding: false,
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
            title: const HeaderTitleWidget(title: '장바구니'),
          ),
          bottomNavigationBar: CartListBottom(),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(color: Color(0xfff8f8f8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('예약일 만료/판매 종료/매진 상품에 해당되는 경우',
                          style: TextStyles.grey12TextStyle),
                      Text('장바구니에서 자동으로 삭제됩니다',
                          style: TextStyles.grey12TextStyle),
                    ],
                  ),
                ),
                Expanded(child: CartListModule()),
              ],
            ),
          ),
        ));
  }
}

class CartListModule extends StatefulWidget {
  @override
  _CartListModuleState createState() => _CartListModuleState();
}

class _CartListModuleState extends State<CartListModule> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final bloc = Provider.of<CartListBloc>(context);

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (bloc.networkState.value != NetworkState.Finish) {
        bloc.getMoreCartList();
      }
    }
  }

  void fetch() {
    final bloc = Provider.of<CartListBloc>(context);
    bloc.fetch('');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkState>(
        stream: Provider.of<CartListBloc>(context).networkState,
        builder: (context, networkSnapshot) {
          return HandleNetworkError.handleNetwork(
            state: networkSnapshot.data,
            retry: fetch,
            context: context,
            child: StreamBuilder<List<CartListViewModel>>(
                stream: Provider.of<CartListBloc>(context).repoList,
                builder: (context, repoSnapshot) {
                  if (!repoSnapshot.hasData) {
                    return const Center(
                        heightFactor: 3.0, child: LoadingWidget());
                  }
                  if (repoSnapshot.data.isEmpty) {
                    return const Center(
                        heightFactor: 3.0, child: Text('장바구니가 비었습니다 '));
                  }

                  final listData = repoSnapshot.data;
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listData.length * 2 - 1 + 1,
                        itemBuilder: (context, index) {
                          if (index == listData.length * 2 - 1) {
                            if (networkSnapshot.data == NetworkState.Finish) {
                              return Container();
                            } else {
                              return Container(
                                  height: 50,
                                  child: const Center(child: LoadingWidget()));
                            }
                          }
                          if (index.isOdd) {
                            return Container(
                              height: 12,
                              color: const Color(0xfff8f8f8),
                            );
                          }
                          return CartItem(
                            cartItem: listData[(index ~/ 2)],
                          );
                        }),
                  );
                }),
          );
        });
  }
}

class CartItem extends StatefulWidget {
  const CartItem({this.cartItem});

  final CartListViewModel cartItem;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool isClicked;
  int totalPrice;

  @override
  void initState() {
    super.initState();

    isClicked = false;
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = 0;
    for (var model in widget.cartItem.orderProduct.orderProductOptions) {
      totalPrice += model.amount * (model.salePrice);
    }

    final cartListBloc = Provider.of<CartListBloc>(context);
    return Container(
      padding: const EdgeInsets.only(
        right: 24,
        left: 24,
        top: 14,
        bottom: 24,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isClicked = !isClicked;
                    });
                    if (isClicked) {
                      cartListBloc.addCartList(widget.cartItem, totalPrice);
                    } else {
                      cartListBloc.removeCartList(widget.cartItem, totalPrice);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 30,
                    ),
                    color: Colors.transparent,
                    child: CircularCheckBoxWiget(
                      isAgreed: isClicked,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    DialogWidget.buildTwoButtonDialog(
                        context: context,
                        title: '삭제 하시겠습니까?',
                        buttonTitle1: '예',
                        buttonTitle2: '아니오',
                        onPressed1: () {
                          cartListBloc
                              .deleteFromCart(widget.cartItem, totalPrice)
                              .then((res) {
                            if (res) {
                              return Navigator.of(context).pop();
                            } else {
                              DialogWidget.buildDialog(
                                  context: context,
                                  title: '삭제 실패',
                                  buttonTitle: '닫기',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  });
                            }
                          }).catchError((error) {
                            HandleNetworkError.showErrorDialog(context, error);
                          });
                        },
                        onPressed2: () {
                          Navigator.of(context).pop();
                        });
                  },
                  child: Container(
                    width: 39,
                    height: 24,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xffd0d0d0), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Text(
                        '삭제',
                        style: TextStyles.grey12TextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // margin: const EdgeInsets.only(top: 10),
            child: ReservationProductWidget(
              productModel: widget.cartItem.orderProduct,
            ),
          )
        ],
      ),
    );
  }
}

class CartListBottom extends StatefulWidget {
  @override
  _CartListBottomState createState() => _CartListBottomState();
}

class _CartListBottomState extends State<CartListBottom> {
  final NumberFormat formatter = NumberFormat('#,###');
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget _buildOrderButton(BuildContext context, int selectedItemLength) {
    final cartListBloc = Provider.of<CartListBloc>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 9),
      child: BlackButtonWidget(
        title: '구매하기',
        isLoading: isLoading,
        isUnabled: selectedItemLength == 0,
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          final cartList = cartListBloc.getSelectedList();
          final orderList = cartList.map((item) {
            return OrderInfoProductModel(
                additionalInfo: item.orderProduct.additionalInfo,
                reserveDate: item.orderProduct.reserveDate,
                // productId: item.productId,
                product: item.orderProduct.product,
                cartId: item.id,
                orderProductOptions: item.orderProduct.orderProductOptions);
          }).toList();

          //empty test 모든 상품들의 모든 fields가 비어있을때 input page 건너뜀
          final orderInfoRequestBloc = OrderInfoRequestBloc();
          orderInfoRequestBloc.orderInfoRequest(orderList).then((data) {
            var isOptionEmpty = false;
            for (var option in data.options) {
              if (option.each.isEmpty && option.fields.isEmpty) {
                isOptionEmpty = true;
              } else {
                isOptionEmpty = false;
                break;
              }
            }
            if (data.fields.isEmpty && isOptionEmpty) {
              final createOrderPrepareBloc =
                  CreateOrderPrepareBloc(inputModel: data);
              // for (int i = 0; i < data.options.length; i++) {
              //   OrderInfoOptionsModel option = data.options[i];
              //   createOrderPrepareBloc.inputModel.options
              //       .add(OrderInfoOptionsModel());
              //   createOrderPrepareBloc.inputModel.options[i].orderProduct =
              //       option.orderProduct;
              // }

              createOrderPrepareBloc.createOrderPrepare().then((data) {
                AppRoutes.paymentPage(context, data);
              }).catchError((error) {
                HandleNetworkError.showErrorDialog(context, error);
              });
            } else {
              AppRoutes.purchaseOrderInfoInputPage(context, data);
            }
            setState(() {
              isLoading = false;
            });
          }).catchError((dynamic error) {
            HandleNetworkError.showErrorDialog(context, error);
            setState(() {
              isLoading = false;
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartListBloc = Provider.of<CartListBloc>(context);
    return SafeArea(
      child: Container(
        height: 24 * MediaQuery.of(context).textScaleFactor + 80,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffeeeeee)))),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 24),
        child: StreamBuilder<Map<String, int>>(
            stream: cartListBloc.selectedItems,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              final selectedItemLength = snapshot.data['selectedItemLength'];
              return Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '총 $selectedItemLength 개',
                      style: TextStyles.black14BoldTextStyle,
                    ),
                    Text(
                      '${formatter.format(snapshot.data['totalPrice'])}원',
                      style: TextStyles.orange16TextStyle,
                    ),
                  ],
                ),
                _buildOrderButton(context, selectedItemLength),
              ]);
            }),
      ),
    );
  }
}
