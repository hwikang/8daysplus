import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class OrderListProvider {
  Future<List<ReservationPageModel>> orderConnection(
      int first, String cursor, bool isFetch) {
    return getGraphQLClient()
        .query(_queryOptions(first, cursor, isFetch))
        .then(_toOrderConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(int first, String cursor, bool isFetch) {
    // print(_readOrderConnectionQuery(first, cursor));
    getLogger(this).d(_readOrderConnectionQuery(first, cursor));
    if (isFetch) {
      return QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          documentNode: gql(_readOrderConnectionQuery(first, cursor)));
    }
    return QueryOptions(
        documentNode: gql(_readOrderConnectionQuery(first, cursor)));
  }

  List<ReservationPageModel> _toOrderConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List list = queryResult.data['orderConnection']['edges'];
    final reservationList = list.map((dynamic edge) {
      return ReservationPageModel.fromJson(edge);
    }).toList();
    getLogger(this).d('order list length ${reservationList.length}');

    return reservationList;
  }

  String _readOrderConnectionQuery(int first, String cursor) => '''
  {
  orderConnection(first: $first,where:{
    states:[COMPLETE_RESERVE,COMPLETE_PAYMENT,PENDING_RESERVE]
  }) {
    edges{
      cursor
      node{
        id
        totalPrice
        pointPrice
        couponPrice
        paymentMethod
        quota
        orderCode
        orderDate        
        orderInfo {         
          options {           
            orderProduct {             
              product{                
                name
                typeName
                coverPrice
                salePrice
                sourceType                
                coverImage{
                  url
                }
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
                  filePath
                }
              }              
                      
              orderItemCode
              state
              voucherType              
              additionalInfo
              reserveDate
              totalPrice              
            }            
          }
        }
      }
  
      }
    }
   
      
  } 
  ''';
}
