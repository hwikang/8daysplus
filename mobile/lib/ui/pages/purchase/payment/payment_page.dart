import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:mobile/ui/components/common/network_delay_widget.dart';
import 'package:mobile/utils/handle_network_error.dart';
import 'package:provider/provider.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/device_ratio.dart';
import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/singleton.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/loading_widget.dart';
import '../../../components/common/payment_webview.dart';
import '../../../components/common/product-order/payment_price_widget.dart';
import '../../../components/common/text_form_field_widget.dart';
import '../../../components/common/user/user_info_widget.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({@required this.model});

  final CreateOrderPrepareModel model;

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Order');

    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                AppRoutes.pop(context);
              },
            ),
            title: const HeaderTitleWidget(title: '결제하기'),
          ),
          body: Provider<PaymentBloc>(
              create: (context) => PaymentBloc(),
              child: PaymentPageBody(model: model))),
    );
  }
}

class PaymentPageBody extends StatelessWidget {
  const PaymentPageBody({this.model});
  final CreateOrderPrepareModel model;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<PaymentBloc>(context).repo,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingWidget();
              break;
            default:
              if (snapshot.hasError) {
                return NetworkDelayPage(retry: () {
                  Provider.of<PaymentBloc>(context).fetch();
                });
              }
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: model.orderInfo.fields.isNotEmpty ? 24 : 0,
                        ),
                        child: UserInfoWidget(
                          fields: model.orderInfo.fields,
                          title: '예약자 정보',
                        ),
                      ),
                      // _buildPersonalInfo(context, model.orderInfo.fields),
                      OrderProductDetailWidget(model: model),
                      OrderPointWidget(),
                      OrderTotalAmountWidget(),
                      OrderPaymentTypeWidget(),
                      OrderServicePolicyWidget(),
                      OrderSubmitButton(
                        orderId: model.orderId,
                        model: model,
                      ),
                      _buildNoticeText(context),
                    ],
                  ),
                ),
              );
          }
        });
  }

  Widget _buildNoticeText(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 24),
      child: Text(
          '지텐션은 통신판매중개자이며 통신판매의 당사자가 아닙니다. 따라서 지텐션은 상품ㆍ거래정보 및 거래에 대하여 책임을 지지 않습니다.',
          style: TextStyles.grey12TextStyle),
    );
  }
}

class OrderSubmitButton extends StatefulWidget {
  const OrderSubmitButton({
    this.orderId,
    this.model,
  });

  final CreateOrderPrepareModel model;
  final String orderId;

  @override
  _OrderSubmitButtonState createState() => _OrderSubmitButtonState();
}

class _OrderSubmitButtonState extends State<OrderSubmitButton> {
  bool buttonIsUnabled;

  @override
  void initState() {
    super.initState();
    buttonIsUnabled = false;
  }

  void analyticslogEvent(PaymentModel model) {
    var itemName = '';
    var cateName = '';
    var reserveDate = '';
    var optionName = '';
    if (widget.model.orderInfo.options != null &&
        widget.model.orderInfo.options.isNotEmpty) {
      itemName = widget.model.orderInfo.options[0].orderProduct.product.name;
      cateName =
          widget.model.orderInfo.options[0].orderProduct.product.categoryName;
      reserveDate = widget.model.orderInfo.options[0].orderProduct.reserveDate;

      if (widget.model.orderInfo.options[0].orderProduct.orderProductOptions !=
              null &&
          widget.model.orderInfo.options[0].orderProduct.orderProductOptions
              .isNotEmpty) {
        optionName = widget.model.orderInfo.options[0].orderProduct
            .orderProductOptions[0].optionName;
      }
    }

    final _analyticsParameter = <String, dynamic>{
      'item_category': cateName,
      'point': model.usedLifePoint + model.usedWelfarePoint,
      'coupon': model.usedCouponPrice,
      'item_name': itemName,
      'quantity': widget.model.orderInfo.options.length,
      'item_option_name': optionName,
      'price': model.totalPrice,
      'item_reservation_date': reserveDate,
      'location': '${Singleton.instance.curLat},${Singleton.instance.curLng}',
    };

    print(_analyticsParameter);
    Analytics.analyticsLogEvent('begin_checkout', _analyticsParameter);
  }

  @override
  Widget build(BuildContext context) {
    final paymentBloc = Provider.of<PaymentBloc>(context);
    final formatter = NumberFormat('#,###');
    return StreamBuilder<PaymentModel>(
        stream: Provider.of<PaymentBloc>(context).paymentModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final model = snapshot.data;
          analyticslogEvent(model);

          return StreamBuilder<bool>(
              stream: Provider.of<PaymentBloc>(context).readyToSubmit(),
              initialData: false,
              builder: (context, searvicePolicysnapshot) {
                return StreamBuilder<PaymentState>(
                    stream: Provider.of<PaymentBloc>(context).paymentState,
                    initialData: PaymentState.Normal,
                    builder: (context, stateSnapshot) {
                      return Container(
                        margin: const EdgeInsets.only(top: 48),
                        width: MediaQuery.of(context).size.width,
                        child: BlackButtonWidget(
                          title:
                              '${formatter.format(snapshot.data.getPayAmount())}원 결제하기',
                          isUnabled:
                              buttonIsUnabled || !searvicePolicysnapshot.data,
                          isLoading: stateSnapshot.data == PaymentState.Loading,
                          onPressed: () {
                            print('delete these ${paymentBloc.cartIds}');
                            print(
                                'card holder ${paymentBloc.paymentModel.value.cardHolderType}');
                            if (paymentBloc.paymentModel.value.cardHolderType ==
                                'CORPORATE') {
                              return DialogWidget.buildDialog(
                                context: context,
                                title: PaymentPageStrings.corporateCardNotReady,
                              );
                            }

                            // 0원 카드
                            final model = paymentBloc.paymentModel.value;
                            if (model.getPayAmount() == 0 &&
                                model.paymentType == 'CREDITCARD' &&
                                model.cardCode == 0) {
                              model.cardCode = 1;
                            }

                            //카드선택 확인
                            if (paymentBloc.paymentModel.value.paymentType ==
                                    'CREDITCARD' &&
                                paymentBloc.paymentModel.value.cardCode == 0) {
                              Scaffold.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                  content: Text('카드를 선택해 주세요'),
                                  duration: Duration(seconds: 1),
                                ));
                            } else {
//약관동의
                              if (paymentBloc.servicePolicyState.value) {
                                setState(() {
                                  buttonIsUnabled = true;
                                });
                                paymentBloc
                                    .createOrder(widget.orderId)
                                    .then((url) {
                                  AppRoutes.buildTitledModalBottomSheet(
                                    context: context,
                                    title: '결제',
                                    child: PaymentWebview(
                                        url: url,
                                        onSuccess: (query) {
                                          AppRoutes.paymentSuccessPage(
                                              context,
                                              query['orderCode'],
                                              model.payAmount);

                                          refreshPagesBloc.changeRefresh(
                                              true); //refresh my,reservation page
                                          //delete from cart
                                          final deleteCartProvider =
                                              DeleteCartProvider();
                                          print(
                                              'delete these ${paymentBloc.cartIds}');
                                          deleteCartProvider
                                              .deleteCart(paymentBloc.cartIds);
                                        },
                                        onFail: (query) {
                                          DialogWidget.buildDialog(
                                              context: context,
                                              title: query['msg']);
                                        }),
                                  );

                                  setState(() {
                                    buttonIsUnabled = false;
                                  });
                                  print('$buttonIsUnabled 4');
                                }).catchError((dynamic error) {
                                  HandleNetworkError.showErrorSnackBar(
                                      context, error);

                                  setState(() {
                                    buttonIsUnabled = false;
                                  });
                                });
                              }
                            }
                          },
                        ),
                      );
                    });
              });
        });
  }
}

class OrderServicePolicyWidget extends StatefulWidget {
  @override
  _OrderServicePolicyWidgetState createState() =>
      _OrderServicePolicyWidgetState();
}

class _OrderServicePolicyWidgetState extends State<OrderServicePolicyWidget> {
  bool isAgreed = false;

  Widget buildTermContainer(BuildContext context, String url, String title) {
    return Container(
      height: 44,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: OutlineButton(
        onPressed: () {
          AppRoutes.buildTitledModalBottomSheet(
            context: context,
            title: '결제하기',
            child: WebviewScaffold(
              url: url,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyles.black14TextStyle,
            ),
            Text(
              '>',
              style: TextStyles.black16TextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentBloc = Provider.of<PaymentBloc>(context);

    return StreamBuilder<Map<String, dynamic>>(
        stream: Provider.of<PaymentBloc>(context).repo,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Container(
              margin: const EdgeInsets.only(top: 48),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('약관동의', style: TextStyles.black20BoldTextStyle),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: buildTermContainer(
                        context,
                        paymentBloc
                            .repo.value['servicePolicyInfo'].thirdTermsUrl,
                        PaymentPageStrings.thirdTerms,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: buildTermContainer(
                        context,
                        paymentBloc
                            .repo.value['servicePolicyInfo'].elecTermsUrl,
                        PaymentPageStrings.elecTerms,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isAgreed = !isAgreed;
                          });
                          paymentBloc.changeServicePolicyState(isAgreed);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(right: 6),
                                  child: Image.asset(isAgreed
                                      ? ImageAssets.cehckOnBlackImage
                                      : ImageAssets.cehckOffImage)),
                              Expanded(
                                child: Container(
                                  height: 40 *
                                      MediaQuery.of(context).textScaleFactor,
                                  child: Text(
                                    '주문 상품정보 및 결제대행 서비스 이용약관에 모두 동의하십니까?',
                                    style: TextStyles.black14TextStyle,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ]));
        });
  }
}

class OrderPaymentTypeWidget extends StatefulWidget {
  @override
  _OrderPaymentTypeWidgetState createState() => _OrderPaymentTypeWidgetState();
}

class _OrderPaymentTypeWidgetState extends State<OrderPaymentTypeWidget> {
  String selectedCard;
  String selectedCardHolderType;
  String selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = 'CREDITCARD';
    selectedCardHolderType = '개인카드';
  }

  Widget _buildRadioButtons(BuildContext context) {
    final paymentBloc = Provider.of<PaymentBloc>(context);
    const value1 = '개인카드';
    const value2 = '법인카드';
    return StreamBuilder<PaymentModel>(
        stream: Provider.of<PaymentBloc>(context).paymentModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.paymentType != 'CREDITCARD') {
            return Container();
          }

          return Container(
            margin: const EdgeInsets.only(
              top: 32,
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCardHolderType = value1;
                    });
                    paymentBloc.changeCardHolderType('PERSONAL');
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        child: Radio<String>(
                          onChanged: (dynamic value) {
                            setState(() {
                              selectedCardHolderType = value1;
                            });
                            paymentBloc.changeCardHolderType('PERSONAL');
                          },
                          groupValue: selectedCardHolderType,
                          value: value1,
                        ),
                      ),
                      Text(
                        value1,
                        style: TextStyles.black14TextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCardHolderType = value2;
                    });
                    paymentBloc.changeCardHolderType('CORPORATE');
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        child: Radio<String>(
                          onChanged: (dynamic value) {
                            setState(() {
                              selectedCardHolderType = value2;
                            });
                            paymentBloc.changeCardHolderType('CORPORATE');
                          },
                          groupValue: selectedCardHolderType,
                          value: value2,
                        ),
                      ),
                      Text(
                        value2,
                        style: TextStyles.black14TextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildCardDropdown(BuildContext context) {
    final paymentBloc = Provider.of<PaymentBloc>(context);
    return StreamBuilder<PaymentModel>(
        stream: Provider.of<PaymentBloc>(context).paymentModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.paymentType != 'CREDITCARD') {
            return Container();
          }
          // print('card Drop down ${snapshot.data.paymentType}');

          return StreamBuilder<List<CreditCardModel>>(
              stream: Provider.of<PaymentBloc>(context).cardCodes,
              builder: (context, cardsSnapshot) {
                if (!cardsSnapshot.hasData) {
                  return Container();
                }
                final cardList = paymentBloc.cardCodes.value.map((card) {
                  return card.name;
                }).toList();

                return Container(
                    margin: const EdgeInsets.only(top: 22),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 44,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xffe0e0e0), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          hint: Text(
                            selectedCard ?? '카드 선택',
                            style: TextStyles.grey14TextStyle,
                          ),
                          isExpanded: true,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCard = newValue;
                            });
                            paymentBloc.changeCardCode(newValue);
                          },
                          items: cardList.map<DropdownMenuItem<String>>((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: TextStyles.black16TextStyle,
                              ),
                            );
                          }).toList()),
                    ));
              });
        });
  }

  Widget paymentTypeContainer({Widget content, String paymentType}) {
    final paymentBloc = Provider.of<PaymentBloc>(context);

    var isSelected = false;
    if (paymentType == selectedType) {
      isSelected = true;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = paymentType;
          selectedCard = null; //신용카드 선택 초기화
          selectedCardHolderType = '개인카드'; //홀더타입 변경
        });

        paymentBloc.changeCardHolderType('PERSONAL');
        paymentBloc.changePaymentType(paymentType);
      },
      child: Container(
        width: 104 * DeviceRatio.scaleWidth(context),
        height: 77,
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? Colors.black : const Color(0xffe0e0e0),
                width: 1)),
        child: Center(child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaymentModel>(
        stream: Provider.of<PaymentBloc>(context).paymentModel,
        builder: (context, amountSnapshot) {
          if (!amountSnapshot.hasData) {
            return const LoadingWidget();
          }
          if (amountSnapshot.data.getPayAmount() <= 0) {
            return Container();
          }

          return Container(
              margin: const EdgeInsets.only(top: 48),
              width: 312 * DeviceRatio.scaleWidth(context),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('결제수단', style: TextStyles.black20BoldTextStyle),
                    StreamBuilder<List<PaymentMethodModel>>(
                        stream:
                            Provider.of<PaymentBloc>(context).paymentMethods,
                        builder: (context, paymentMethodsnapshot) {
                          if (!paymentMethodsnapshot.hasData) {
                            return const LoadingWidget();
                          }
                          final paymentMethods = paymentMethodsnapshot.data;
                          final list = <List<PaymentMethodModel>>[];
                          final rowNum =
                              (paymentMethods.length / 3).ceil(); //줄 갯수
                          for (var i = 0; i < rowNum; i++) {
                            //마지막줄( 3개보다 적을수있으므로)-> 마지막까지만 add
                            if (i == rowNum - 1) {
                              list.add(paymentMethods.sublist(
                                  i * 3, paymentMethods.length));
                            } else {
                              list.add(paymentMethods.sublist(
                                  i * 3, (i + 1) * 3)); //0-3 3-6 6-9 이렇게 들어감
                            }
                          }
                          return Container(
                              constraints: const BoxConstraints(
                                maxHeight: 154,
                                minHeight: 77,
                              ),
                              margin: const EdgeInsets.only(top: 16),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: rowNum,
                                  itemBuilder: (context, listIndex) {
                                    return Container(
                                      height: 77,
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: list[listIndex].length,
                                        itemBuilder: (context, index) {
                                          return paymentTypeContainer(
                                              content: CachedNetworkImage(
                                                imageUrl: list[listIndex][index]
                                                    .coverImage
                                                    .url,
                                                width: 64,
                                              ),
                                              paymentType:
                                                  list[listIndex][index].type);
                                        },
                                      ),
                                    );
                                  }));
                        }),
                    _buildRadioButtons(context),
                    _buildCardDropdown(context),
                  ]));
        });
  }
}

class OrderTotalAmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaymentModel>(
        stream: Provider.of<PaymentBloc>(context).paymentModel,
        builder: (context, amountSnapshot) {
          if (!amountSnapshot.hasData) {
            return const LoadingWidget();
          }
          return Container(
            margin: const EdgeInsets.only(top: 48),
            child: PaymentPriceWidget(
              title: PaymentPageStrings.finalPayAmount,
              payAmountText: MyPageStrings.orderDetail_payAmountText,
              totalPriceText: MyPageStrings.orderDetail_totalPriceText,
              totalDiscountText: MyPageStrings.orderDetail_totalDiscountText,
              totalPrice: amountSnapshot.data.totalPrice,
              usedLifePoint: amountSnapshot.data.usedLifePoint,
              usedCouponPrice: amountSnapshot.data.usedCouponPrice,
              payAmount: amountSnapshot.data.getPayAmount(),
            ),
          );
        });
  }
}

class OrderPointWidget extends StatefulWidget {
  @override
  _OrderPointWidgetState createState() => _OrderPointWidgetState();
}

class _OrderPointWidgetState extends State<OrderPointWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final paymentBloc = Provider.of<PaymentBloc>(context);

    _textEditingController.text =
        '${paymentBloc.paymentModel.value.usedLifePoint}';
  }

  @override
  Widget build(BuildContext context) {
    print('buld pointWidget');
    final paymentBloc = Provider.of<PaymentBloc>(context);

    final formatter = NumberFormat('###,###,###');

    return StreamBuilder<Map<String, dynamic>>(
        stream: Provider.of<PaymentBloc>(context).repo,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          final int myLifePoint = snapshot.data['lifePoint'];
          return Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('포인트 사용', style: TextStyles.black20BoldTextStyle),
                    Container(
                      margin: const EdgeInsets.only(top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '라이프 포인트',
                            style: TextStyles.black16BoldTextStyle,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '보유 포인트 ',
                                  style: TextStyles.black12TextStyle,
                                ),
                                Text(
                                  '${formatter.format(myLifePoint)}P',
                                  style: TextStyles.black12BoldTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<PaymentModel>(
                        stream: Provider.of<PaymentBloc>(context).paymentModel,
                        builder: (context, payModelSnapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          final payModel = payModelSnapshot.data;

                          return Form(
                            key: _formKey,
                            child: Container(
                                // height: 64, //에러텍스트 포함된 크기
                                margin: const EdgeInsets.only(top: 12),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: <Widget>[
                                    TextFormFieldWidget(
                                      validator: (data) {
                                        if (data.isEmpty) {
                                          return null;
                                        }
                                        final value = int.parse(data);
                                        if (value > myLifePoint) {
                                          //오바되면
                                          paymentBloc.pointErrorState
                                              .add(false);
                                          return '보유한 포인트보다 초과 사용은 불가능합니다.';
                                        }
                                        if (value % 10 != 0) {
                                          paymentBloc.pointErrorState
                                              .add(false);
                                          return '최소 사용 가능한 포인트는 10P입니다.';
                                        }
                                        if (value >
                                            payModel.totalPrice -
                                                payModel.usedCouponPrice) {
                                          return '최대 사용 가능한 포인트는 ${payModel.totalPrice - payModel.usedCouponPrice} P입니다.';
                                        }
                                        paymentBloc.pointErrorState.add(true);
                                        getLogger(this).d('value $value');
                                        return null;
                                      },
                                      textEditingController:
                                          _textEditingController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (data) {
                                        if (_formKey.currentState.validate()) {
                                          int value;
                                          if (_textEditingController
                                              .text.isEmpty) {
                                            value = 0;
                                          } else {
                                            value = int.parse(
                                                _textEditingController.text);
                                          }
                                          print('value in onchange $value');
                                          paymentBloc.addLifePoint(value);
                                        }
                                        print(_textEditingController.text);
                                      },
                                      hintText: '0',
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (payModel.usedLifePoint +
                                                payModel.usedCouponPrice <
                                            payModel.totalPrice) {
                                          int willUsePoint;
                                          if (myLifePoint >=
                                              payModel.totalPrice -
                                                  payModel.usedCouponPrice) {
                                            //가진포인트가 합계보다 많을때

                                            willUsePoint = (payModel
                                                        .totalPrice -
                                                    payModel.usedCouponPrice) ~/
                                                10 *
                                                10;
                                          } else {
                                            // 적을때
                                            willUsePoint =
                                                myLifePoint ~/ 10 * 10;
                                          }
                                          paymentBloc
                                              .addLifePoint(willUsePoint);
                                          _textEditingController.text =
                                              '$willUsePoint';
                                          _formKey.currentState.validate();
                                        } else {}
                                        print(_textEditingController.text);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 13, horizontal: 12),
                                        child: Text(
                                          '전액사용',
                                          style:
                                              TextStyles.orange12BoldTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        '최소 사용 가능한 포인트는 10P 입니다.',
                        style: TextStyles.grey12TextStyle,
                      ),
                    ),
                  ]));
        });
  }
}

class OrderProductDetailWidget extends StatelessWidget {
  const OrderProductDetailWidget({this.model});

  final CreateOrderPrepareModel model;

  Widget _buildEachButton(BuildContext context, CreateOrderPrepareModel model,
      List<OrderInfoFieldListModel> each, List<OrderInfoFieldModel> fields) {
    if (each.isEmpty && fields.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 40),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 40),
      width: MediaQuery.of(context).size.width,
      height: 48,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: OutlineButton(
        onPressed: () {
          AppRoutes.eachListPage(context, model, each, fields);
        },
        child: Text(
          '사용자 정보 보기',
          style: TextStyles.black14BoldTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentBloc = Provider.of<PaymentBloc>(context);
    paymentBloc.clearTotalPrice();
    return Container(
      margin: const EdgeInsets.only(top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Text('상품정보', style: TextStyles.black20BoldTextStyle),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: model.orderInfo.options.length,
            itemBuilder: (context, index) {
              paymentBloc.addTotalPrice(
                  model.orderInfo.options[index].orderProduct.totalPrice);
              //카트id 목록생성
              if (model.orderInfo.options[index].orderProduct.cartId != '') {
                if (!paymentBloc.cartIds.contains(
                    model.orderInfo.options[index].orderProduct.cartId)) {
                  paymentBloc.cartIds
                      .add(model.orderInfo.options[index].orderProduct.cartId);
                }
              }

              return Column(children: <Widget>[
                OrderProductWidget(
                  productModel: model.orderInfo.options[index].orderProduct,
                ),
                _buildEachButton(
                    context,
                    model,
                    model.orderInfo.options[index].each,
                    model.orderInfo.options[index].fields)
              ]);
            },
          )
        ],
      ),
    );
  }
}

class OrderProductWidget extends StatelessWidget {
  const OrderProductWidget({
    this.productModel,
  });

  final OrderInfoProductModel productModel;

  Widget _buildReserveDate(
      BuildContext context, OrderInfoProductModel productModel) {
    String reserveDate;
    String timeValue;
    String optionName;

    if (productModel.orderProductOptions.isEmpty ||
        productModel.orderProductOptions[0].timeSlotValue == '') {
      timeValue = '';
    } else {
      // String timeSlotValue = productModel.orderProductOptions[0].timeSlotValue;
      // timeSlotValue.replaceFirst('/', '~');
      timeValue = '/ ${productModel.orderProductOptions[0].timeSlotValue}';
    }
    if (productModel.orderProductOptions.isEmpty) {
      optionName = '';
    } else {
      optionName = '${productModel.orderProductOptions[0].optionName}';
    }

    switch (productModel.product.typeName) {
      case 'ECOUPON':
        reserveDate = '';
        break;
      default:
        reserveDate = '사용예정일 : ${productModel.reserveDate}';
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (reserveDate != '' && timeValue != '')
            Text(
              '$reserveDate $timeValue',
              style: TextStyles.black12TextStyle,
            ),
          Text(
            optionName,
            style: TextStyles.black13TextStyle,
          ),
        ],
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
    );
  }

  Widget _buildOptionText(OrderInfoProductModel productModel) {
    final formatter = NumberFormat('#,###');
    if (productModel.orderProductOptions.isEmpty) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: productModel.orderProductOptions.length,
        itemBuilder: (context, index) {
          final model = productModel.orderProductOptions[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 168 * DeviceRatio.scaleWidth(context),
                margin: const EdgeInsets.only(right: 16),
                child: Text(
                  '${model.optionItemName}',
                  style: TextStyles.black13TextStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  '${model.amount}개 x ${formatter.format(model.salePrice.floor())}원',
                  style: TextStyles.black13TextStyle,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          );
        },
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
    );
  }

  Widget _buildTotalText(int totalPrice) {
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '총',
            style: TextStyles.black14BoldTextStyle,
          ),
          Text(
            '${formatter.format(totalPrice)} 원',
            style: TextStyles.black14BoldTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildCouponWidget(
      BuildContext context, OrderInfoProductModel product, int totalPrice) {
    // print(product.coupons);
    if (product.coupons.isEmpty) {
      return Container();
    }
    bool isCouponUsed;

    return StreamBuilder<List<AppliedCouponModel>>(
        stream: Provider.of<PaymentBloc>(context).usedCoupons,
        builder: (context, couponsSnapshot) {
          isCouponUsed = false;
          if (couponsSnapshot.hasData && couponsSnapshot.data.isNotEmpty) {
            //현재사용된 쿠폰있음
            for (var usedCoupon in couponsSnapshot.data) {
              if (usedCoupon.orderItemCode == product.orderItemCode) {
                isCouponUsed = true;
                break;
              }
            }
          }
          return Container(
            padding: const EdgeInsets.only(
              top: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '쿠폰사용',
                  style: TextStyles.black16BoldTextStyle,
                ),
                buildCouponButton(context, isCouponUsed, product, totalPrice),
              ],
            ),
          );
        });
  }

  Widget buildCouponButton(BuildContext context, bool isCouponUsed,
      OrderInfoProductModel product, int totalPrice) {
    final paymentBloc = Provider.of<PaymentBloc>(context);

    if (isCouponUsed) {
      //해당 프로덕트에 사용된 쿠폰정보
      final coupon = paymentBloc.usedCoupons.value.where((usedCoupon) {
        return usedCoupon.orderItemCode == product.orderItemCode;
      }).toList();
      final formatter = NumberFormat('#,###');
      return Container(
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Text(
                '-${formatter.format(coupon[0].discountPrice.round())}',
                style: TextStyles.orange14BoldTextStyle,
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  paymentBloc.removeCoupon(coupon[0]);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffd0d0d0)),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Text(
                    '적용 취소',
                    style: TextStyles.black10TextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: GestureDetector(
        onTap: () {
          //보유 ���폰 카피
          final validCouppons = List<CouponApplyModel>.from(product.coupons);
          if (paymentBloc.usedCoupons.hasValue) {
            //사용된 쿠폰은 제외 시킴
            print('has value?? ${paymentBloc.usedCoupons.value} ');
            for (var item in paymentBloc.usedCoupons.value) {
              final usedCoupon = product.coupons.where((coupon) {
                return coupon.id == item.couponId;
              }).toList();
              if (usedCoupon.isNotEmpty) {
                validCouppons.remove(usedCoupon[0]);
              }
            }
          }
          print('un used coupons $validCouppons');
          AppRoutes.selectCouponPage(context, validCouppons, product)
              .then((data) {
            if (data != null) {
              //뒤로가기가 아닐시
              print('return data $data');
              //할인계산
              int discountAmount;
              switch (data.discountUnit) {
                case 'PERCENT':
                  final exactDiscount =
                      totalPrice * (data.discountAmount / 100);
                  //최대할인가 넘지않게 조정
                  if (exactDiscount >= data.discountMax) {
                    discountAmount = data.discountMax;
                  } else {
                    discountAmount = ((exactDiscount / 10).floor()) * 10;
                  }
                  break;
                case 'PRICE':
                  if (data.discountAmount >= totalPrice) {
                    print('totalPrice $totalPrice');
                    discountAmount = totalPrice;
                  } else {
                    discountAmount = data.discountAmount;
                  }

                  break;

                default:
              }
              // totalPrice
              paymentBloc.addCoupon(data, product.orderItemCode, discountAmount,
                  product.reserveDate);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
              color: const Color(0xff909090),
              borderRadius: BorderRadius.circular(4.0)),
          child: Text(
            '쿠폰 적용',
            style: TextStyles.white10TextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    productModel.product.image.url,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  productModel.product.name,
                  style: TextStyles.black14BoldTextStyle,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffeeeeee), width: 1),
              borderRadius: BorderRadius.circular(4)),
          child: Column(
            children: <Widget>[
              _buildReserveDate(context, productModel),
              _buildOptionText(productModel),
              _buildTotalText(productModel.totalPrice),
              if (productModel.product.sourceType != 'EVENT')
                _buildCouponWidget(
                    context, productModel, productModel.totalPrice),
            ],
          ),
        )
      ],
    );
  }
}
