import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/purchase/create_order_input_model.dart';
import '../../models/purchase/create_order_prepare_model.dart';
import '../../utils/graphql_client.dart';

class CreateOrderPrepareProvider {
  Future<CreateOrderPrepareModel> createOrderPrepare(
      CreateOrderInputModel inputModel) {
    return getGraphQLClient()
        .query(_queryOptions(inputModel))
        .then(_toCreateOrderPrepare)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  // void printWrapped(String text) {
  //   final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  //   pattern.allMatches(text).forEach((match) => print(match.group(0)));
  // }

  QueryOptions _queryOptions(CreateOrderInputModel inputModel) {
    print(_readUserConnectionQuery(inputModel.toJson()));
    // printWrapped(inputModel.toJson().toString());
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readUserConnectionQuery(inputModel.toJson())));
  }

  CreateOrderPrepareModel _toCreateOrderPrepare(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    // print('data ${queryResult.data}');
    final model = CreateOrderPrepareModel.fromJson(
        queryResult.data['createOrderPrepare']);
    print('orderInfo ${model.orderInfo.toJson()}');
    return model;
  }

  String _readUserConnectionQuery(Map<String, dynamic> inputModelMap) => '''
  mutation {
    createOrderPrepare(
      input: $inputModelMap
      
    ) {
      orderId
      orderInfo {
        fields {
          fieldName
          fieldType
          fieldOption
          fieldExplain
          fieldPlaceholder
          fieldId
          fieldValue
        }
        options {          
          orderProduct {
            state
            additionalInfo
            reserveDate
            totalPrice
            orderItemCode
            cartId
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
              sourceType
              coverImage {
                url
              }
              images{
                url
              }
              availableDateInfo{
                color
                name
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
              availableMinPrice
            }
            orderProductOptions {
              optionId
              optionName
              optionItemId
              optionItemName
              amount
              coverPrice
              salePrice
              timeSlotId
              timeSlotValue
            } 
            orderRefund{
              quota
              cancelDate
              reason
              productPrice
              refundPrice
              refundPointPrice
              refundCouponPrice
              paymentMethod
            }



          }
          fields {
            fieldName
            fieldType
            fieldOption
            fieldExplain
            fieldPlaceholder
            fieldId
            fieldValue
          }
          each {
            fields {
              fieldName
              fieldType
              fieldOption
              fieldExplain
              fieldPlaceholder
              fieldId
              fieldValue
            }
          }
        }
      }
    }
  }

  ''';
}
