import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/reservation/order_list_model.dart';
import '../../utils/graphql_client.dart';

class OrderDetailProvider {
  Future<OrderListViewModel> order(String orderCode) {
    return getGraphQLClient()
        .query(_queryOptions(orderCode))
        .then(_toOrderDetail)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String orderCode) {
    print(_readOrderDetailQuery(orderCode));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readOrderDetailQuery(orderCode)));
  }

  OrderListViewModel _toOrderDetail(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final model = OrderListViewModel.fromJson(queryResult.data['order']);

    getLogger(this).d('order detail ${model.toJson()}');

    return model;
  }

  String _readOrderDetailQuery(String orderCode) => '''
  {
  order(where: { orderCode: ${json.encode(orderCode)}}) {
    id
    paymentPrice
    orderPrice
    totalPrice
    couponPrice
    paymentMethod
    quota
    orderCode
    pointPrice
    orderDate
    user {
      id
      profile {
        name
      }
    }
    orderInfo {
      fields {
        fieldName
       
        fieldValue
      }
      options {
        fields {
          fieldName         
          fieldValue
        }
        each {
          fields {
            fieldName           
            fieldValue
          }
        }
        orderProduct {          
          state          
          voucherType
          additionalInfo
          reserveDate
          totalPrice
          orderItemCode
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
            coverPrice
            salePrice
            typeName
            coverImage{
              url
            }
            images{
              url
            }
            availableDateInfo{
              name
              color
            }
            productContent {
              ... on Experience{
                refund                      
              }
              ... on Ecoupon{
                refund
              }
            }
            summary
            discountRate
          }        
          voucher {
            __typename
            ... on VoucherPays {
              barcode
              templete {
                left {
                  url
                }
                color
                right {
                  url
                }
              }
            }
            ... on VoucherUrlPath {
              barcode
            }
          }
          coupons {
            id
            name
            discountMax
            discountAmount
            discountUnit
            summary
            coverImage{
              url
            }
            remainDay
            expireDate
          }
          orderProductOptions {
            optionId
            optionName
            optionItemId
            optionItemName
            amount
            coverPrice
            salePrice
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
        
      }
    }
  }
}
  ''';
}
