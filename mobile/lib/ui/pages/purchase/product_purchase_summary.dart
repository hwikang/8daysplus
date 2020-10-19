import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:mobile/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/border_widget.dart';
import '../../components/common/dialog_widget.dart';
import 'purchase_option_item_page.dart';

class ProductPurchaseSummary extends StatefulWidget {
  const ProductPurchaseSummary({
    @required this.listItem,
    this.item,
    this.productOrderType,
  });

  final ProductDetailViewModel item;
  final List<ProductAvailableDateModel> listItem;
  final String productOrderType;

  @override
  ProductPurchaseSummaryState createState() =>
      ProductPurchaseSummaryState(listItem);
}

class ProductPurchaseSummaryState extends State<ProductPurchaseSummary> {
  ProductPurchaseSummaryState(this.listItem);

  bool isCartLoading;
  bool isOrderLoading;
  List<ProductAvailableDateModel> listItem;
  //button state
  bool readyToOrder;

  String selectedTime;

  @override
  void initState() {
    super.initState();
    readyToOrder = false;
    isCartLoading = false;
    isOrderLoading = false;
  }

  Widget buildOptionTimeView(BuildContext context,
      List<ProductAvailableDateModel> listItem, int firstIndex) {
    if (listItem.isEmpty) {
      return Container();
    }
    final indexBloc = Provider.of<ProductAvailableIndexBloc>(context);

    final timeStringList = <String>[];
    listItem[firstIndex].timeSchedules.map((model) {
      timeStringList.add(model.name);
    }).toList();
    // int k = indexBloc.model.firstIndex;
    // print('timeStringList ${timeStringList} $k');
    if (timeStringList.isEmpty) {
      return Container();
    }
    if (indexBloc.model.otherIndex == '') {
      return Container(
        padding:
            const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 24),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee))),
        ),
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffe0e0e0)),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.only(
              top: 12 * MediaQuery.of(context).textScaleFactor,
              left: 12,
              right: 12,
              bottom: 12 * MediaQuery.of(context).textScaleFactor),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(
                selectedTime ?? '시간을 선택해주세요.',
                style: TextStyles.grey14TextStyle,
              ),
              isExpanded: true,
              isDense: true,
              items: listItem[firstIndex].timeSchedules.map((model) {
                return DropdownMenuItem<String>(
                  value: '${model.name}/${model.id}',
                  // onTap: () {
                  //   // print(model.id);
                  //   indexBloc.changeTimeScheduleId(model.id);
                  // },
                  child: Container(
                    child: Text(
                      model.name,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                final str = newValue.split('/');

                setState(() {
                  selectedTime = str[0];
                  indexBloc.changeTimeScheduleId(str[1]);
                  readyToOrder = true;
                });
                // indexBloc.changeTimeScheduleId(id)
                print('changed SelectedTitme $selectedTime');
              },
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildOptionTitleView(
      BuildContext context,
      // ProductAvailableIndexBloc indexBloc,
      List<ProductAvailableDateModel> listItem,
      int firstIndex) {
    if (listItem.isEmpty) {
      return Container();
    }
    final indexBloc = Provider.of<ProductAvailableIndexBloc>(context);
    final dateFormat = DateFormat('yyyy-MM-dd');
    var dateTime = dateFormat.parse(listItem[firstIndex].day);

    if (indexBloc.model.otherIndex != '') {
      dateTime = dateFormat.parse(indexBloc.model.otherIndex);
    }

    return Container(
      decoration: const BoxDecoration(color: Color(0xfff8f8f8)),
      height: 40 * DeviceRatio.scaleWidth(context),
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 26, right: 26),
        child: Text(
          '${dateTime.year.toString()}년 ${dateTime.month.toString()}월 ${dateTime.day.toString()}일',
          textAlign: TextAlign.left,
          style: TextStyles.black12TextStyle,
        ),
      ),
    );
  }

  Widget buildOptionListView(
      BuildContext context,
      // ProductAvailableIndexBloc indexBloc,
      List<ProductAvailableDateModel> listItem,
      int firstIndex) {
    if (listItem.isEmpty) {
      return Container();
    }
    final indexBloc = Provider.of<ProductAvailableIndexBloc>(context);

    if (indexBloc.model.otherIndex == '') {
      final k = indexBloc.model.firstIndex;
      final formatter = NumberFormat('#,###');

      return Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listItem[k].options.length,
              itemBuilder: (context, index) {
                var lowestPrice =
                    listItem[k].options[index].optionItems[0].salePrice;
                listItem[k].options[index].optionItems.map((model) {
                  if (lowestPrice > model.salePrice) {
                    lowestPrice = model.salePrice;
                  }
                }).toList();
                return GestureDetector(
                  onTap: () {
                    indexBloc.changeOptionIndex(index);
                    print('index ${indexBloc.model.toJson()}');
                    print(indexBloc.getIndex().firstIndex);

                    final availableDateModel =
                        widget.listItem[indexBloc.getIndex().firstIndex];
                    print(availableDateModel.toJSON());
                    final selectedOptionItem = availableDateModel
                        .options[indexBloc.getIndex().optionIndex];

                    print(selectedOptionItem.toJSON());

                    AppRoutes.purchaseOptionItemPage(
                      context,
                      availableDateModel.day,
                      widget.item.id,
                      selectedOptionItem,
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                              left: 24, top: 24, right: 24, bottom: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width:
                                          280 * DeviceRatio.scaleWidth(context),
                                      child: Text(
                                        listItem[k].options[index].name,
                                        textAlign: TextAlign.left,
                                        style: TextStyles.black16BoldTextStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '${formatter.format(lowestPrice)}원',
                                        textAlign: TextAlign.left,
                                        style: TextStyles.black14TextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 14,
                                width: 8,
                                child: Image(
                                  image:
                                      AssetImage(ImageAssets.arrowRightImage),
                                ),
                              ),
                            ],
                          ),
                        ),
                        BoarderWidget(),
                      ],
                    ),
                  ),
                );
              }));
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget buildListWithTitle(
      BuildContext context,
      // ProductAvailableIndexBloc indexBloc,
      List<ProductAvailableDateModel> listItem) {
    return Container(
      child: Column(
        children: buildListWithTitleList(context, listItem),
      ),
    );
  }

  List<Widget> buildListWithTitleList(
      BuildContext context, List<ProductAvailableDateModel> listItem) {
    final indexBloc = Provider.of<ProductAvailableIndexBloc>(context);

    final list = <Widget>[];
    final k = indexBloc.model.firstIndex;
    for (var i = 0; i < listItem[k].options.length; i++) {
      list.add(Container(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 26, top: 24, right: 26),
                child: Text(
                  listItem[indexBloc.model.firstIndex].options[i].name,
                  style: TextStyles.black18BoldTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 24),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 2.0,
                      height: 2.0,
                      color: const Color.fromRGBO(144, 144, 144, 1),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      child: Text(
                        '유효기간 : ~${listItem[indexBloc.model.firstIndex].day}',
                        style: TextStyles.grey14TextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 24),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 2.0,
                      height: 2.0,
                      color: const Color.fromRGBO(144, 144, 144, 1),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      child: Text(
                        listItem[indexBloc.model.firstIndex].options[i].name,
                        style: TextStyles.grey14TextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            buildList(context, indexBloc, listItem, i),
          ],
        ),
      ));
    }

    return list;
  }

  Widget buildList(BuildContext context, ProductAvailableIndexBloc indexBloc,
      List<ProductAvailableDateModel> listItem, int optionIndex) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child:
          Column(children: buildListDetail(listItem, indexBloc, optionIndex)),
    );
  }

  List<Widget> buildListDetail(List<ProductAvailableDateModel> listItem,
      ProductAvailableIndexBloc indexBloc, int optionIndex) {
    final list = <Widget>[];
    // bool _value = false;
    final k = indexBloc.model.firstIndex;

    // for(int i=0;i<listItem[k].options.length;i++) {
    for (var j = 0;
        j < listItem[k].options[optionIndex].optionItems.length;
        j++) {
      list.add(Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: AppColors.smallBoxColor),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      listItem[k].options[optionIndex].optionItems[j].name,
                      style: TextStyles.black16BoldTextStyle,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${listItem[k].options[optionIndex].optionItems[j].salePrice}원',
                    style: TextStyles.black16TextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    }
    // }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final indexBloc = Provider.of<ProductAvailableIndexBloc>(context);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: <Widget>[
            Container(
              child: BuildCalendarView(
                  listItem: listItem,
                  onChange: () {
                    setState(() {
                      selectedTime = null;
                      readyToOrder = false;
                    });
                  }),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 26, right: 26, top: 20),
                child: Text(
                  '예약이 불가능한 날짜는 선택 할 수 없습니다.',
                  style: TextStyles.grey12TextStyle,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // MultiStream
            StreamBuilder<int>(
                stream: Provider.of<ProductAvailableIndexBloc>(context)
                    .firstIndexController,
                initialData: 0,
                builder: (context, firstIndexSnapshot) {
                  final firstIndex = firstIndexSnapshot.data;

                  return StreamBuilder<String>(
                      stream: Provider.of<ProductAvailableIndexBloc>(context)
                          .otherIndexController,
                      initialData: '',
                      builder: (context, snapshot) {
                        return Column(
                          children: <Widget>[
                            buildOptionTitleView(context, listItem, firstIndex),
                            buildOptionTimeView(context, listItem, firstIndex),
                            buildOptionListView(context, listItem, firstIndex),
                            // if (widget.productOrderType == 'SCHEDULE_TIME')
                            // PurchaseOptionBottomWidget(
                            //   totalCount: readyToOrder ? 1 : 0,
                            //   totalPrice:
                            //       readyToOrder ? widget.item.salePrice : 0,
                            //   isUnable: !readyToOrder,
                            //   isCartLoading: isCartLoading,
                            //   isOrderLoading: isOrderLoading,
                            //   onWhiteButtonClick: () {
                            //     setState(() {
                            //       isCartLoading = true;
                            //     });
                            //     final addCartBloc = AddCartBloc();
                            //     final selectedTimeSechedule =
                            //         indexBloc.selectedTimeScheduleId.value;
                            //     addCartBloc
                            //         .addCart(OrderInfoProductModel(
                            //       additionalInfo: '',
                            //       product: ProductListViewModel(
                            //           id: widget.item.id),
                            //       reserveDate: listItem[firstIndex].day,
                            //       reserveTimeScheduleId:
                            //           selectedTimeSechedule,
                            //     ))
                            //         .then((data) {
                            //       Scaffold.of(context).hideCurrentSnackBar();
                            //       Scaffold.of(context)
                            //           .showSnackBar(const SnackBar(
                            //         content: Text('장바구니에 추가 되었습니다'),
                            //         behavior: SnackBarBehavior.floating,
                            //       ));
                            //     }).catchError((dynamic error) {
                            //       print('@@@ error $error');
                            //       if (error.contains('error_msg')) {
                            //         final Map<String, dynamic> map =
                            //             json.decode(error);

                            //         DialogWidget.buildDialog(
                            //           context: context,
                            //           title: ErrorTexts.error,
                            //           subTitle1: map['error_msg'],
                            //         );
                            //       } else {
                            //         DialogWidget.buildDialog(
                            //           context: context,
                            //           subTitle1: '$error',
                            //           title: ErrorTexts.error,
                            //         );
                            //       }
                            //     }).whenComplete(() => setState(() {
                            //               isCartLoading = false;
                            //             }));
                            //   },
                            //   onBlackButtonClick: () {
                            //     setState(() {
                            //       isOrderLoading = true;
                            //     });
                            //     final orderListModel =
                            //         <OrderInfoProductModel>[];
                            //     final selectedTimeSechedule =
                            //         indexBloc.selectedTimeScheduleId.value;
                            //     orderListModel.add(OrderInfoProductModel(
                            //         additionalInfo: '',
                            //         product: ProductListViewModel(
                            //             id: widget.item.id),
                            //         reserveDate: listItem[firstIndex].day,
                            //         reserveTimeScheduleId:
                            //             selectedTimeSechedule));

                            //     AppRoutes.purchaseOrderInfoInputPage(
                            //         context, orderListModel, 1);

                            //     setState(() {
                            //       isOrderLoading = false;
                            //     });
                            //   },
                            // )
                          ],
                        );
                      });
                }),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class BuildCalendarView extends StatefulWidget {
  const BuildCalendarView({
    @required this.listItem,
    this.onChange,
  });

  final List<ProductAvailableDateModel> listItem;
  final Function onChange;

  @override
  _BuildCalendarState createState() => _BuildCalendarState(listItem);
}

class _BuildCalendarState extends State<BuildCalendarView> {
  _BuildCalendarState(this.listItem);

  List<String> daysArray = <String>[];
  List<ProductAvailableDateModel> listItem;

  DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    if (listItem.isNotEmpty) {
      final firstDate = DateTime.parse(listItem[0].day);
      _currentDate = firstDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final indexBloc = Provider.of<ProductAvailableIndexBloc>(context);

    for (var i = 0; i < listItem.length; i++) {
      daysArray.add(listItem[i].day);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: CalendarCarousel<Event>(
        onDayPressed: (date, events) {
          widget.onChange();
          setState(() => _currentDate = date);
          final dateString = DateFormat('yyyy-MM-dd').format(date);
          for (var i = 0; i < listItem.length; i++) {
            if (listItem[i].day == dateString) {
              print(i);
              indexBloc.changeFirstIndex(i);
            } else {
              if (daysArray.contains(dateString)) {
              } else {
                indexBloc.changeOtherIndex(dateString);
              }
            }
          }
        },

        weekDayFormat: WeekdayFormat.short,
        //header
        headerTextStyle: TextStyles.black18BoldTextStyle,
        headerMargin: const EdgeInsets.only(bottom: 26),
        rightButtonIcon: Text(
          '>',
          style: TextStyle(
            color: const Color(0xffd0d0d0),
            fontSize: 18,
            fontFamily: FontFamily.regular,
          ),
        ),
        leftButtonIcon: Text(
          '<',
          style: TextStyle(
            color: const Color(0xffd0d0d0),
            fontSize: 18,
            fontFamily: FontFamily.regular,
          ),
        ),

        // weekDayMargin: EdgeInsets.only(bottom: 30),
        // weekDayPadding: EdgeInsets.only(bottom: 10),
        // weekDayBackgroundColor: Colors.red,

        customWeekDayBuilder: (weekday, weekdayName) {
          if (weekday == 0) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 9),
                child: Center(
                  child: Text(
                    weekdayName,
                    style: TextStyles.orange12TextStyle,
                  ),
                ),
              ),
            );
          } else if (weekday == 6) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 9),
                child: Center(
                  child: Text(
                    weekdayName,
                    style: TextStyles.black12TextStyle,
                  ),
                ),
              ),
            );
          } else {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 9),
                child: Center(
                  child: Text(
                    weekdayName,
                    style: TextStyles.black12TextStyle,
                  ),
                  // ),
                ),
              ),
            );
          }
        },

        locale: 'ko',

        todayBorderColor: Colors.transparent,
        todayButtonColor: Colors.transparent,
        todayTextStyle: const TextStyle(color: Color(0xff303030)),
        weekdayTextStyle: const TextStyle(
          color: Color(0xff404040),
        ),
        weekendTextStyle: const TextStyle(
          color: Color(0xffff7500),
        ),
        // 선택된 날
        selectedDayButtonColor: const Color(0xff404040),
        selectedDayBorderColor: const Color(0xff404040),
        selectedDayTextStyle: const TextStyle(
          color: Colors.white,
        ),
        dayCrossAxisAlignment: CrossAxisAlignment.start,
        dayMainAxisAlignment: MainAxisAlignment.start,
        // dayPadding: 10,
        customDayBuilder: (
          /// you can provide your own build function to make custom day containers
          isSelectable,
          index,
          isSelectedDay,
          isToday,
          isPrevMonthDay,
          textStyle,
          isNextMonthDay,
          isThisMonthDay,
          day,
        ) {
          isSelectable = true;

          final dayString = DateFormat('yyyy-MM-dd').format(day);
          if (daysArray.contains(dayString)) {
            if (day.weekday != 7) {
              if (isSelectedDay) {
                return Center(
                  child: Text(
                    // 선택 한 평일
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.regular,
                      color: const Color(0xffffffff),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    // 선택 가능한 평일
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.regular,
                      color: const Color(0xff303030),
                    ),
                  ),
                );
              }
            } else {
              return Container(
                child: Center(
                  child: Text(
                    // 선택 가능한 일요일
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.regular,
                      color: const Color(0xffff7500),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                // 선택불가능한날
                day.day.toString(),
                style: TextStyle(
                    color: const Color(0xffd0d0d0),
                    fontSize: 14,
                    fontFamily: FontFamily.regular),
              ),
            );
          }
        },

        isScrollable: true,
        scrollDirection: Axis.horizontal,
        height: 360.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: true,

        /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }
}
