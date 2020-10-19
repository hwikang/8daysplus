import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/expansion_tile_widget.dart';
import '../../components/common/placeholder_widget.dart';
import 'purchase_order_input_fields.dart';

class PurchaseOrderInputOptions extends StatefulWidget {
  const PurchaseOrderInputOptions({this.inputItem});

  final CreateOrderInputModel inputItem;

  @override
  _PurchaseOrderInputOptionsState createState() =>
      _PurchaseOrderInputOptionsState();
}

class _PurchaseOrderInputOptionsState extends State<PurchaseOrderInputOptions> {
  bool isEmpty;

  @override
  void initState() {
    super.initState();
    isEmpty = true;
    for (var i = 0; i < widget.inputItem.options.length; i++) {
      if (widget.inputItem.options[i].each.isEmpty &&
          widget.inputItem.options[i].fields.isEmpty) {
      } else {
        isEmpty = false;
        break;
      }
      print('$i $isEmpty');
    }
  }

  Widget buildImageAndTitle(
      BuildContext context, CreateOrderInputModel inputItem, int i) {
    final orderInfoProductModel = inputItem.options[i].orderProduct;
    return Container(
      width: 282 * DeviceRatio.scaleWidth(context),
      margin: const EdgeInsets.only(left: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: orderInfoProductModel.product.image.url,
                placeholder: (context, url) => PlaceholderWidget(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${orderInfoProductModel.product.name}',
                    textAlign: TextAlign.start,
                    style: TextStyles.black16BoldTextStyle,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                      '사용예정일 ${orderInfoProductModel.reserveDate} / ${orderInfoProductModel.orderProductOptions[0].timeSlotValue}',
                      style: TextStyles.black12TextStyle)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 24, top: 16),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffeeeeee)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('사용자 정보', style: TextStyles.black20BoldTextStyle),
                  Text('실제 상품을 사용하는 분의 정보를 기입해 \n주시기 바랍니다.',
                      style: TextStyles.black16TextStyle),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.inputItem.options.length,
                itemBuilder: (context, index) {
                  if (widget.inputItem.options[index].each.isEmpty &&
                      widget.inputItem.options[index].fields.isEmpty) {
                    return Container();
                  } else {
                    return ExpansionTileWidget(
                      initiallyOpened: index == 0,
                      title: Container(
                          child: buildImageAndTitle(
                              context, widget.inputItem, index)),
                      child: GestureDetector(
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod<dynamic>('TextInput.hide');
                        },
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 24,
                              ),

                              OptionFieldsWidget(
                                  inputItem: widget.inputItem,
                                  count: index), //for loop count

                              OptionEachWidget(
                                  inputItem: widget.inputItem,
                                  count: index), //for loop count

                              const SizedBox(
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ],
        ));
  }
}

class OptionFieldsWidget extends StatelessWidget {
  const OptionFieldsWidget({this.inputItem, this.count});

  final int count;
  final CreateOrderInputModel inputItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: inputItem.options[count].fields.length,
            itemBuilder: (context, index) {
              final createOrderPrepareBloc =
                  Provider.of<CreateOrderPrepareBloc>(context);

              final inputWhere = createOrderPrepareBloc
                  .inputModel.options[count].fields[index];
              final orderInfoFieldModel =
                  inputItem.options[count].fields[index];

              return OrderInputFieldByTypeWidget(
                  orderInfoFieldModel, inputWhere);
            }));
  }
}

class OptionEachWidget extends StatelessWidget {
  const OptionEachWidget({this.inputItem, this.count});

  final int count;
  final CreateOrderInputModel inputItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: inputItem.options[count].each.length,
          itemBuilder: (context, eachIndex) {
            final createOrderPrepareBloc =
                Provider.of<CreateOrderPrepareBloc>(context);
            return Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '사용자 정보${eachIndex + 1}',
                        style: TextStyles.black18BoldTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: inputItem
                              .options[count].each[eachIndex].fields.length,
                          itemBuilder: (context, fieldIndex) {
                            final inputWhere = createOrderPrepareBloc
                                .inputModel
                                .options[count]
                                .each[eachIndex]
                                .fields[fieldIndex];
                            final orderInfoFieldModel = inputItem.options[count]
                                .each[eachIndex].fields[fieldIndex];
                            return OrderInputFieldByTypeWidget(
                                orderInfoFieldModel, inputWhere);
                          }),
                    ]));
          }),
    );
  }
}
