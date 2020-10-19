import 'dart:async';

import 'package:graphql/client.dart';

import '../../core.dart';
import '../models/my_page_model.dart';

class MyPageProvider {
  Future<Map<String, dynamic>> userConnection({bool isFetch}) {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toUserConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions() {
    print(_readUserConnectionQuery());

    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readUserConnectionQuery()));
  }

  Map<String, dynamic> _toUserConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    // print(queryResult);
    //USER
    final user = UserModel.fromJson(queryResult.data['user']);

    //POINT
    final List list = queryResult.data['lifePointConnection']['edges'];
    final pointDetails = list.map((dynamic point) {
      return LifePointListViewModel.fromJson(point['node']);
    }).toList();

    final model = LifePointModel(
      lifePoint: queryResult.data['lifePoint'],
      lifeTobeExpiredPoint: queryResult.data['lifeTobeExpiredPoint'],
      lifeTobeSavedPoint: queryResult.data['lifeTobeSavedPoint'],
      lifePointList: pointDetails,
    );

    //COUPON
    final couponStateCount =
        CouponCountModel.fromJson(queryResult.data['couponStateCount']);
    final List couponEdges = queryResult.data['couponConnection']['edges'];
    final couponList = couponEdges.map((dynamic point) {
      return CouponListViewModel.fromJson(point['node']);
    }).toList();
    final couponModel =
        CouponModel(couponList: couponList, couponStateCount: couponStateCount);

    final map = <String, dynamic>{};
    map['user'] = user;
    map['lifePoint'] = model;
    map['coupon'] = couponModel;
    map['recommendStyleAnalysisUse'] =
        queryResult.data['recommendStyleAnalysisUse'];
    print(map);
    return map;
  }

  String _readUserConnectionQuery() => '''
  {
    recommendStyleAnalysisUse
    user {
      id
      type
      state
      loginType
      
      profile {
        email
        mobile
        name
        employeeNumber
        birthDay
        birthMonth
        birthYear
        imageInfo {
          url
        }
        authDate
        hireDate
      }     
      company {
        id
        name
        companyCode
      }
    }
    lifeTobeExpiredPoint
    lifeTobeSavedPoint
    lifePoint
    lifePointConnection(where: {
      types: [SAVED, USAGED]
    }) {
      edges{
        cursor
        node {
          id
          name
          state
          type
          point
          createdAt
          expireDay
        }
      }      
    }
    
    couponStateCount {
      enabledCount
      disabledCount
    }
    
    couponConnection(where: {
      states: [SAVED, USAGED, EXPIRED]
    }) {
      edges{
        cursor
        node {
        id
          name
          summary
          state
          discountAmount
          discountUnit
          expireDate
          coverImage {
            url
          }
          remainDay
        }
      }
      
    }
  }
  ''';
}
