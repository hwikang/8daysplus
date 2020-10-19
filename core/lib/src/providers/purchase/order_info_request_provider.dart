import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/purchase/create_order_input_model.dart';
import '../../models/purchase/order_info_product_model.dart';
import '../../models/purchase/order_info_request_model.dart';
import '../../utils/graphql_client.dart';

class OrderInfoRequestProvider {
  Future<CreateOrderInputModel> orderInfoRequest(
      List<OrderInfoProductModel> orderInputList) {
    return getGraphQLClient()
        .query(_queryOptions(orderInputList))
        .then(_toOrderInfoRequest)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(List<OrderInfoProductModel> orderInputList) {
    final inputQuery = orderInputList.map((orderInput) {
      return orderInput.toJson();
    }).toList();
    final query = readOrderInfoRequest(inputQuery);
    print(query);
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(query),
    );
  }

  CreateOrderInputModel _toOrderInfoRequest(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> fieldsJson =
        queryResult.data['orderInfoRequest']['fields'];
    var fields = <OrderInfoFieldModel>[];
    for (var i = 0; i < fieldsJson.length; i++) {
      fields = fieldsJson.map((dynamic field) {
        return OrderInfoFieldModel.fromJson(field);
      }).toList();
    }

    print('fields $fields');
    // options
    final options = <OrderInfoOptionsModel>[];
    final List<dynamic> optionsJson =
        queryResult.data['orderInfoRequest']['options'];
    for (var i = 0; i < optionsJson.length; i++) {
      final List<dynamic> optionEachJson =
          queryResult.data['orderInfoRequest']['options'][i]['each'];
      var optionEach = <OrderInfoFieldListModel>[];
      if (optionEachJson.isNotEmpty) {
        optionEach = optionEachJson.map((dynamic each) {
          return OrderInfoFieldListModel.fromJson(each);
          // List<dynamic> eachJson = each['fields'];
          // List<OrderInfoFieldModel> fieldList = eachJson.map((dynamic field){
          //   return OrderInfoFieldModel.fromJson(field);
          // }).toList();
          // return {'fields':fieldList};
        }).toList();
      }
      print('optionEach $optionEach');

      final List<dynamic> optionFieldJson = queryResult.data['orderInfoRequest']
          ['options'][i]['fields']; //우선 옵션 하나일때만
      final optionFields = optionFieldJson.map((dynamic field) {
        return OrderInfoFieldModel.fromJson(field);
      }).toList();
      print('optionFields $optionFields');

      final dynamic optionProductJson =
          queryResult.data['orderInfoRequest']['options'][i]['orderProduct'];
      final optionProduct = OrderInfoProductModel.fromJson(optionProductJson);

      print('optionProduct $optionProduct');

      final option = OrderInfoOptionsModel(
          each: optionEach, fields: optionFields, orderProduct: optionProduct);
      options.add(option);
    }

    return CreateOrderInputModel(fields: fields, options: options);
  }

  String readOrderInfoRequest(List<Map<String, dynamic>> inputQuery) => '''
    {
      orderInfoRequest(
        input: $inputQuery
        
   ) {
      fields {
        required
        fieldName
        fieldType
        fieldOption        
        fieldPlaceholder
        fieldId
        fieldExplain
      }
      options {
        orderProduct {
          state	
          orderItemCode
          cartId
          additionalInfo
          reserveDate
          totalPrice	
          reserveTimeSchedule {
            deadLine
            id
            name
            possibleNumber
            regNum
            remainNum
          }
          product{
            id
            name
            typeName
            coverImage{
              url
            }            
            availableDateInfo{
              name
              color
            }
            images{
              url
            }
          }
          				
          coupons {
            id
            name
            summary
            discountMax
            discountAmount
            discountUnit
            coverImage{
              url
            }
            expireDate
            remainDay
          }
          orderProductOptions {
            optionId
            optionName
            optionItemId
            optionItemName
            amount
            salePrice
            coverPrice
            timeSlotId
            timeSlotValue
          }
          orderRefund {
            cancelDate
            refundPrice
            reason
            refundPointPrice
            refundCouponPrice
            productPrice
            paymentMethod
          }
        }
        fields {
          required
          fieldName
          fieldType
          fieldOption
          fieldExplain
          fieldPlaceholder
          fieldId
        }
        each {
          fields {
            required
            fieldName
            fieldType
            fieldOption
            fieldExplain
            fieldPlaceholder
            fieldId
          }
        }
      }
    }
  }
    ''';
}
