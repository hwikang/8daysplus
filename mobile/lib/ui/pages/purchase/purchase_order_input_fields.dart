import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'purchase_order_info_input_page.dart';

class PurchaseOrderInputFields extends StatelessWidget {
  const PurchaseOrderInputFields({
    this.inputItem,
  });

  final CreateOrderInputModel inputItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: inputItem.fields.length,
          itemBuilder: (context, index) {
            final createOrderPrepareBloc =
                Provider.of<CreateOrderPrepareBloc>(context);

            // createOrderPrepareBloc.inputModel.fields.add(OrderInfoFieldModel());
            final inputWhere = createOrderPrepareBloc.inputModel.fields[index];
            final orderInfoFieldModel = inputItem.fields[index];

            return OrderInputFieldByTypeWidget(orderInfoFieldModel, inputWhere);
          },
        ));
  }
}

class OrderInputFieldByTypeWidget extends StatelessWidget {
  const OrderInputFieldByTypeWidget(
      // this.fields,
      this.orderInfoFieldModel,
      this.inputWhere);

  final OrderInfoFieldModel inputWhere;
  // List<OrderInfoFieldModel> fields;
  final OrderInfoFieldModel orderInfoFieldModel;

  @override
  Widget build(BuildContext context) {
    switch (orderInfoFieldModel.fieldType) {
      case 'engname':
        return MakeEnglishNameOptions(
            field: orderInfoFieldModel, inputWhere: inputWhere);
        break;
      case 'radio':
        return MakeRadioOptions(
            field: orderInfoFieldModel, inputWhere: inputWhere);
        break;
      case 'checkbox':
        return MakeCheckOptions(
            field: orderInfoFieldModel, inputWhere: inputWhere);
        break;
      case 'birthdate':
      case 'date':
        return MakeBirthDayOptions(
            field: orderInfoFieldModel, inputWhere: inputWhere);
        break;

      case 'select':
        return MakeSelectOptions(
            field: orderInfoFieldModel, inputWhere: inputWhere);
        break;
      case 'time':
        return MakeTimeOptions(
            field: orderInfoFieldModel, inputWhere: inputWhere);
        break;

      case 'mobile':
        return MakeMobileOption(
          field: orderInfoFieldModel,
          keyboardType: TextInputType.number,
          inputWhere: inputWhere,
        );
      case 'number':
        return MakeTextOption(
          field: orderInfoFieldModel,
          keyboardType: TextInputType.number,
          inputWhere: inputWhere,
          initValue: '0',
        );

      default:
        return MakeTextOption(
            field: orderInfoFieldModel,
            keyboardType: TextInputType.text,
            inputWhere: inputWhere);

        break;
    }
  }
}
