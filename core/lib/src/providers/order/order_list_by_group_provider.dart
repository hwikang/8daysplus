import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class OrderListByGroupProvider {
  Future<List<MyOrderPageModel>> orderConnection(
      int first, String cursor, String year, bool isFetch) {
    return getGraphQLClient()
        .query(_queryOptions(first, cursor, year, isFetch))
        .then(_toOrderConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(
      int first, String cursor, String year, bool isFetch) {
    print(_readOrderConnectionQuery(first, year, cursor));
    if (isFetch) {
      return QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          documentNode: gql(_readOrderConnectionQuery(first, year, cursor)));
    }
    return QueryOptions(
        documentNode: gql(_readOrderConnectionQuery(first, year, cursor)));
  }

  List<MyOrderPageModel> _toOrderConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['orderConnection']['group'];
    if (list.isEmpty) {
      return <MyOrderPageModel>[];
    }
    final myOrderList = list.map((dynamic edge) {
      // print(edge);
      return MyOrderPageModel.fromJson(edge);
    }).toList();

    return myOrderList;
  }

  String _readOrderConnectionQuery(int first, String year, String cursor) => '''
  {
  orderConnection(
    first: $first
    after: ${json.encode(cursor)}
    where:{
      year :${json.encode(year)}
    }
  ) {
      group {
        cursor
        day      
        nodes{
          id
          paymentPrice
          totalPrice
          orderPrice
          pointPrice
          couponPrice
          paymentMethod
          quota
          orderCode
          orderDate          
          orderInfo {            
            options {      
             
              orderProduct {
                orderItemCode
                state              
                voucherType
                additionalInfo
                reserveDate
                totalPrice                
                product{
                  id
                  name
                  coverPrice
                  salePrice
                  sourceType                  
                  coverImage{
                    url
                  }               
                  summary
                  discountRate
                  typeName
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
  }
  }
  ''';
}
