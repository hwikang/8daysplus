import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/cart_list_view_model.dart';

class CartListProvider {
  int firstOption;
  Future<Map<String, dynamic>> cartConnection(int first, String after) {
    firstOption = first;
    return getGraphQLClient()
        .query(_queryOptions(first, after))
        .then(_toCartConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(int first, String after) {
    print(readCartConnectionQuery(first, after));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readCartConnectionQuery(first, after)));
  }

  Map<String, dynamic> _toCartConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['cartConnection']['edges'];
    if (list.isEmpty) {
      return <String, dynamic>{
        'nodes': <CartListViewModel>[],
        'lastCursor': ''
      };
    }
    final cartList = list
        .map((dynamic repoJson) => CartListViewModel.fromJson(repoJson['node']))
        .toList();
    final lastCursor = list[list.length - 1]['cursor'];

    final maps = <String, dynamic>{'nodes': cartList, 'lastCursor': lastCursor};

    print('cartList $maps');
    return maps;
  }

  String readCartConnectionQuery(int first, String after) => '''
  
  {
    cartConnection(first: $first,after:${json.encode(after)}) {
      edges{
        cursor
        node{
          id
          createdAt
          productId
          orderProduct {
            state
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
              categories{
                id
                name
                nodes{
                  id
                  name       
                  nodes{
                    id
                    name
                  }       
                }
              }
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
              summary
              discountRate
              typeName
            }
            additionalInfo
            reserveDate
            totalPrice
            orderProductOptions {
              optionName
              optionItemName
              amount
              salePrice
              optionId
              optionItemId
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
        }
      }
      
    }
  }
  ''';
}
