import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/utils/handle_network_error.dart';
import 'package:mobile/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/routes.dart';
import '../../../utils/singleton.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/button/black_button_widget.dart';
import '../../components/common/button/white_button_widget.dart';
import '../../components/common/circular_checkbox_widget.dart';
import '../../components/common/dialog_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';

class PurchaseOptionItemPage extends StatelessWidget {
  const PurchaseOptionItemPage({
    this.day,
    this.productId,
    this.selectedOptionItem,
  });

  final String day;
  final String productId;
  final ProductOptionsModel selectedOptionItem;

  Widget buildList(
    BuildContext context,
    ProductOptionsModel selectedOptionItem,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: selectedOptionItem.optionItems.length,
        itemBuilder: (context, index) {
          return ListTileItem(
              selectedOptionItem: selectedOptionItem,
              selectedOptionItemsOption: selectedOptionItem.optionItems[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SelectOptionItemBloc>(
      create: (context) => SelectOptionItemBloc(),
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                AppRoutes.pop(context);
              },
            ),
            title: const HeaderTitleWidget(title: '옵션 선택'),
          ),
          bottomNavigationBar: PurchaseBottomView(
              day: day,
              productId: productId,
              selectedOptionItem: selectedOptionItem),
          body: Builder(
            builder: (builderContext) {
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 130),
                  child: Column(
                    children: <Widget>[
                      TimeSlotWidget(selectedOptionItem),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 24,
                          top: 32,
                          right: 24,
                          bottom: 11,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedOptionItem.name,
                          style: TextStyles.black18BoldTextStyle,
                        ),
                      ),
                      buildList(builderContext, selectedOptionItem),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

class ListTileItem extends StatefulWidget {
  const ListTileItem({
    this.selectedOptionItem,
    this.selectedOptionItemsOption,
  });

  final ProductOptionsModel selectedOptionItem;
  final ProductOptionItemsModel selectedOptionItemsOption;

  @override
  _ListTileItemState createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  final NumberFormat formatter = NumberFormat('#,###');

  int _itemCount = 0;

  Widget _buildTitle(String category, String name) {
    String text;
    if (category != '') {
      text = '($category) $name';
    } else {
      text = name;
    }
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.black14BoldTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('cnt ${widget.selectedOptionItemsOption.cnt}');
    final selectOptionItemBloc = Provider.of<SelectOptionItemBloc>(context);

    return Container(
      margin:
          EdgeInsets.only(bottom: 8 * MediaQuery.of(context).textScaleFactor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
            color: _itemCount == 0
                ? const Color(0xffeeeeee)
                : const Color(0xff404040)),
      ),
      child: Column(children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              if (_itemCount > 0) {
                _itemCount = 0;
              } else {
                //최소수량 없는경우
                if (widget.selectedOptionItemsOption.minBuyItem == 0) {
                  _itemCount = 1;
                } else {
                  _itemCount = widget.selectedOptionItemsOption.minBuyItem;
                }
              }
            });
            // String salePrice =
            //     widget.selectedOptionItemsOption.salePrice.replaceAll(',', '');

            selectOptionItemBloc.addOption(
                widget.selectedOptionItem.id,
                widget.selectedOptionItemsOption.id,
                _itemCount,
                widget.selectedOptionItemsOption.salePrice);
            print('_itemCount $_itemCount');
          },
          child: Container(
            color: Colors.transparent,
            // height: 120 * MediaQuery.of(context).textScaleFactor,
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 24,
              right: 24,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircularCheckBoxWiget(
                      isAgreed: _itemCount != 0,
                    ),
                    Expanded(
                        child: _buildTitle(
                            widget.selectedOptionItemsOption.category,
                            widget.selectedOptionItemsOption.name)),
                    Text(
                      '${formatter.format(widget.selectedOptionItemsOption.salePrice)}원',
                      style: TextStyles.black14TextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (_itemCount > 0) {
                                if (_itemCount ==
                                        widget.selectedOptionItemsOption
                                            .minBuyItem &&
                                    widget.selectedOptionItemsOption
                                            .minBuyItem !=
                                        0) {
                                  //최소갯수 같으면 -> 0
                                  setState(() {
                                    _itemCount -= widget
                                        .selectedOptionItemsOption.minBuyItem;
                                  });
                                } else {
                                  setState(() => _itemCount--);
                                }
                                // String salePrice = widget
                                //     .selectedOptionItemsOption.salePrice
                                //     .replaceAll(',', '');

                                selectOptionItemBloc.addOption(
                                    widget.selectedOptionItem.id,
                                    widget.selectedOptionItemsOption.id,
                                    _itemCount,
                                    widget.selectedOptionItemsOption.salePrice);
                              } else {
                                // setState(()=>_itemCount--);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width:
                                  32 * MediaQuery.of(context).textScaleFactor,
                              height:
                                  32 * MediaQuery.of(context).textScaleFactor,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.smallBoxColor),
                              ),
                              child: Text(
                                '-',
                                textAlign: TextAlign.center,
                                style: TextStyles.black16TextStyle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 32 * MediaQuery.of(context).textScaleFactor,
                            height: 32 * MediaQuery.of(context).textScaleFactor,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.smallBoxColor),
                                bottom:
                                    BorderSide(color: AppColors.smallBoxColor),
                              ),
                            ),
                            child: Text(_itemCount.toString(),
                                // widget.indexBloc.model.selectModel.selectItemCount.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyles.black14TextStyle),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_itemCount >=
                                      widget.selectedOptionItemsOption
                                          .maxBuyItem &&
                                  widget.selectedOptionItemsOption.maxBuyItem !=
                                      0) {
                                // 최대갯수 초과
                                DialogWidget.buildDialog(
                                    context: context,
                                    title: '최대 갯수 초과',
                                    buttonTitle: '확인');
                              } else if (_itemCount <
                                      widget.selectedOptionItemsOption
                                          .minBuyItem &&
                                  widget.selectedOptionItemsOption.minBuyItem !=
                                      0) {
                                //0 이면 최소갯수로 증가
                                setState(() {
                                  _itemCount += widget
                                      .selectedOptionItemsOption.minBuyItem;
                                });
                              } else {
                                setState(() => _itemCount++);
                              }

                              // String salePrice = widget
                              //     .selectedOptionItemsOption.salePrice
                              //     .replaceAll(',', '');

                              selectOptionItemBloc.addOption(
                                  widget.selectedOptionItem.id,
                                  widget.selectedOptionItemsOption.id,
                                  _itemCount,
                                  widget.selectedOptionItemsOption.salePrice);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width:
                                  32 * MediaQuery.of(context).textScaleFactor,
                              height:
                                  32 * MediaQuery.of(context).textScaleFactor,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.smallBoxColor),
                                // color: Colors.red
                              ),
                              child: Text(
                                '+',
                                textAlign: TextAlign.center,
                                style: TextStyles.black16TextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class TimeSlotWidget extends StatefulWidget {
  const TimeSlotWidget(this.selectedOptionItem);

  final ProductOptionsModel selectedOptionItem;

  @override
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  String selectedTime;

  @override
  Widget build(BuildContext context) {
    final selectOptionItemBloc = Provider.of<SelectOptionItemBloc>(context);

    final timeStringList = <String>[];
    final timeSlots = widget.selectedOptionItem.timeSlots;
    print('timeSlot $timeSlots');
    for (var i = 0; i < timeSlots.length; i++) {
      if (timeSlots[i]['endTime'] == '') {
        timeStringList.add('${timeSlots[i]['startTime']}');
      } else {
        timeStringList
            .add('${timeSlots[i]['startTime']} ~ ${timeSlots[i]['endTime']}');
      }
    }
    if (timeSlots.isNotEmpty) {
      print('selectedTime $selectedTime');
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  left: 24, top: 32, right: 24, bottom: 0),
              alignment: Alignment.centerLeft,
              child: Text(
                '시작 시간',
                style: TextStyles.black16BoldTextStyle,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 24, top: 12, right: 24, bottom: 0),
              height: 44 * MediaQuery.of(context).textScaleFactor,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffe0e0e0)),
                borderRadius: BorderRadius.circular(4),
              ),
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.only(
                    top: 12 * MediaQuery.of(context).textScaleFactor,
                    left: 12,
                    right: 12,
                    bottom: 12 * MediaQuery.of(context).textScaleFactor),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(
                      selectedTime ?? '시간을 선��해주세요.',
                      style: TextStyles.grey14TextStyle,
                    ),
                    isExpanded: true,
                    isDense: true,
                    items: timeStringList.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTime = newValue;
                      });
                      print('changed SelectedTitme $selectedTime');
                      // timeSlot id를 찾아서 바꿔준다.
                      for (var i = 0; i < timeStringList.length; i++) {
                        print('timeStringList $i ${timeStringList[i]}');
                        if (timeStringList[i] == newValue) {
                          final String timeSlotId = timeSlots[i]['id'];
                          print(timeSlotId);

                          selectOptionItemBloc.isSelectedTimeSlot.add(true);
                          selectOptionItemBloc.changeTimeSlotId(timeSlotId);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      //time slot 없으면 true넣어줌
      selectOptionItemBloc.isSelectedTimeSlot.add(true);
      return Container(
        height: 0,
      );
    }
  }
}

class PurchaseBottomView extends StatefulWidget {
  const PurchaseBottomView({
    this.productId,
    this.day,
    this.selectedOptionItem,
  });

  final String day;
  final String productId;
  final ProductOptionsModel selectedOptionItem;

  @override
  _PurchaseBottomViewState createState() => _PurchaseBottomViewState();
}

class _PurchaseBottomViewState extends State<PurchaseBottomView> {
  bool isCartLoading;
  bool isOrderLoading;

  @override
  void initState() {
    super.initState();
    isOrderLoading = false;
    isCartLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final selectOptionItemBloc = Provider.of<SelectOptionItemBloc>(context);
    return StreamBuilder<SelectedOptionCountModel>(
        stream: Provider.of<SelectOptionItemBloc>(context).selectedOptionCount,
        builder: (context, optionCountSnapshot) {
          if (!optionCountSnapshot.hasData) {
            return const LoadingWidget();
          }
          return StreamBuilder<bool>(
              stream:
                  Provider.of<SelectOptionItemBloc>(context).isSelectedTimeSlot,
              initialData: false,
              builder: (context, timeSlotSnapshot) {
                print('timeSlotSnapshot ${timeSlotSnapshot.data}');
                return PurchaseOptionBottomWidget(
                  totalCount: optionCountSnapshot.data.totalOptionCount,
                  totalPrice: optionCountSnapshot.data.totalAmount,
                  isUnable: optionCountSnapshot.data.totalOptionCount <= 0 ||
                      timeSlotSnapshot.data != true, //timeslot , 주문합계 확인
                  isOrderLoading: isOrderLoading,
                  isCartLoading: isCartLoading,
                  onWhiteButtonClick: () {
                    setState(() {
                      isCartLoading = true;
                    });
                    final addCartBloc = AddCartBloc();
                    selectOptionItemBloc
                        .setTimeSlotIdOnSelectedOptions(); //timeslot id 넣어줌
                    addCartBloc
                        .addCart(OrderInfoProductModel(
                            additionalInfo: '',
                            product: ProductListViewModel(id: widget.productId),
                            reserveDate: widget.day,
                            orderProductOptions:
                                selectOptionItemBloc.selectedOption))
                        .then((data) {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(const SnackBar(
                        content: Text('장바구니에 추가 되었습니다'),
                        behavior: SnackBarBehavior.floating,
                      ));

                      final _analyticsParameter = <String, dynamic>{
                        'item_category': '',
                        'item_name': widget.selectedOptionItem.name,
                        'quantity': optionCountSnapshot.data.totalOptionCount,
                        'item_option_name': '',
                        'price': optionCountSnapshot.data.totalAmount,
                        'item_reservation_date': widget.day,
                        'location':
                            '${Singleton.instance.curLat},${Singleton.instance.curLng}',
                      };
                      Analytics.analyticsLogEvent(
                          'add_to_cart', _analyticsParameter);
                    }).catchError((dynamic error) {
                      if (error.contains('error_msg')) {
                        final Map<String, dynamic> map = json.decode(error);

                        DialogWidget.buildDialog(
                          context: context,
                          title: ErrorTexts.error,
                          subTitle1: map['error_msg'],
                        );
                      } else {
                        DialogWidget.buildDialog(
                          context: context,
                          subTitle1: '$error',
                          title: ErrorTexts.error,
                        );
                      }
                    }).whenComplete(() => setState(() {
                              isCartLoading = false;
                            }));
                  },
                  onBlackButtonClick: () {
                    setState(() {
                      isOrderLoading = true;
                    });
                    final orderListModel = <OrderInfoProductModel>[];
                    selectOptionItemBloc
                        .setTimeSlotIdOnSelectedOptions(); //timeslot id 넣어줌
                    orderListModel.add(OrderInfoProductModel(
                        additionalInfo: '',
                        product: ProductListViewModel(id: widget.productId),
                        reserveDate: widget.day,
                        orderProductOptions:
                            selectOptionItemBloc.selectedOption));

                    //empty test 모든 상품들의 모든 fields가 비어있을때 input page 건너뜀 (이쿠)
                    final orderInfoRequestBloc = OrderInfoRequestBloc();

                    orderInfoRequestBloc
                        .orderInfoRequest(orderListModel)
                        .then((orderInfoData) {
                      var isOptionEmpty = false;
                      for (var option in orderInfoData.options) {
                        print('option.each.isEmpty ${option.each.isEmpty}');
                        print('option.each.isEmpty ${option.fields.isEmpty}');

                        if (option.each.isEmpty && option.fields.isEmpty) {
                          isOptionEmpty = true;
                        } else {
                          isOptionEmpty = false;
                          break;
                        }
                      }
                      print('isOptionEmpty $isOptionEmpty');

                      if (orderInfoData.fields.isEmpty && isOptionEmpty) {
                        final createOrderPrepareBloc =
                            CreateOrderPrepareBloc(inputModel: orderInfoData);
                        for (var i = 0; i < orderInfoData.options.length; i++) {
                          final option = orderInfoData.options[i];
                          print(option);
                          // createOrderPrepareBloc.inputModel.options
                          //     .add(OrderInfoOptionsModel());
                          createOrderPrepareBloc.inputModel.options[i]
                              .orderProduct = option.orderProduct;
                        }

                        createOrderPrepareBloc
                            .createOrderPrepare()
                            .then((data) {
                          AppRoutes.paymentPage(context, data);
                        }).catchError((error) {
                          HandleNetworkError.showErrorDialog(context, error);
                        });
                      } else {
                        AppRoutes.purchaseOrderInfoInputPage(
                            context, orderInfoData);
                      }
                      Future<dynamic>.delayed(const Duration(milliseconds: 500),
                          () {
                        setState(() {
                          isOrderLoading = false;
                        });
                      });
                    }).catchError((dynamic error) {
                      HandleNetworkError.showErrorDialog(context, error);
                      Future<dynamic>.delayed(const Duration(milliseconds: 500),
                          () {
                        setState(() {
                          isOrderLoading = false;
                        });
                      });
                    });
                  },
                );
              });
        });
  }
}

class PurchaseOptionBottomWidget extends StatelessWidget {
  const PurchaseOptionBottomWidget(
      {this.totalCount = 0,
      this.totalPrice = 0,
      // this.totalPriceStr,
      this.isUnable,
      this.isOrderLoading,
      this.isCartLoading,
      this.onBlackButtonClick,
      this.onWhiteButtonClick});

  final bool isCartLoading;
  final bool isOrderLoading;
  final bool isUnable;
  final Function onBlackButtonClick;
  final Function onWhiteButtonClick;
  final int totalCount;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xffe0e0e0))),
        ),
        height: 24 * MediaQuery.of(context).textScaleFactor + 10 + 11 + 9 + 48,
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
            left: 24,
            right: 24,
            bottom: 11,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 24 * MediaQuery.of(context).textScaleFactor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '총 $totalCount 개',
                      style: TextStyles.black14BoldTextStyle,
                    ),
                    Text(
                      '${formatter.format(totalPrice)} 원',
                      style: TextStyles.orange16TextStyle,
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 152 * DeviceRatio.scaleWidth(context),
                      height: 48,
                      child: WhiteButtonWidget(
                        title: '장바구니',
                        onPressed: onWhiteButtonClick,
                        isUnabled: isUnable,
                        isLoading: isCartLoading,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4)),
                        width: 152 * DeviceRatio.scaleWidth(context),
                        height: 48,
                        child: BlackButtonWidget(
                          title: '구매하기',
                          onPressed: onBlackButtonClick,
                          isUnabled: isUnable,
                          isLoading: isOrderLoading,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
