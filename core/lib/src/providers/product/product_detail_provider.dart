import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class ProductDetailProvider {
  String tProductType = '';
  Future<Map<String, dynamic>> product(String id, String productType) {
    tProductType = productType;
    return getGraphQLClient()
        .query(_queryOptions(id))
        .then(_toProduct)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String id) {
    // print('query ${readProductQuery(id)}');
    // print('query ${readProductContentQuery(id)}');

    if (tProductType == 'EXPERIENCE' || tProductType == 'Experience') {
      print('EXPERIENCE query ${readProductExperienceQuery(id)}');

      return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readProductExperienceQuery(id)),
      );
    } else if (tProductType == 'ECOUPON' || tProductType == 'Ecoupon') {
      print('ECOUPON query ${readProductEcouponQuery(id)}');

      return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readProductEcouponQuery(id)),
      );
    } else if (tProductType == 'CONTENT') {
      print('CONTENT query ${readProductContentQuery(id)}');
      return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readProductContentQuery(id)),
      );
    } else {
      print('ALL query ${readProductQuery(id)}');

      return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readProductQuery(id)),
      );
    }
  }

  Map<String, dynamic> _toProduct(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    ProductDetailViewModel productModel;
    // print('provider type === ${tProductType}');
    // print(queryResult.data['product']);
    final dynamic json = queryResult.data['product'] as dynamic;
    if (tProductType == 'EXPERIENCE' || tProductType == 'Experience') {
      productModel = ProductDetailViewModel.fromExperienceJson(json);
    } else if (tProductType == 'ECOUPON' || tProductType == 'Ecoupon') {
      productModel = ProductDetailViewModel.fromEcouponJson(json);
    } else {
      productModel = ProductDetailViewModel.fromJson(json);
    }

    final List<dynamic> couponsJson = queryResult.data['couponApplyProduct'];
    List<dynamic> couponList = <FeedCouponModel>[];
    if (couponsJson != null) {
      couponList = couponsJson.map((dynamic coupon) {
        return FeedCouponModel.fromJson(coupon);
      }).toList();
    }

    final map = <String, dynamic>{};
    map['product'] = productModel;
    map['couponList'] = couponList;

    print(map);

    return map;
  }
}

String readProductQuery(String id) => '''
query getProduct {
  product(
    where: {
      id: ${json.encode(id)},
    }
  ) {
   id
   name
   summary
   typeName
   tags
   rating
   message
   createdAt
   salePrice
   coverPrice
   lat
   lng
   discountRate
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
   coverImage {
     url
   }
   images {
     url
   }
   availableDateInfo  {
     name
     color 
   }
   
   productContent {
     ... on Experience {
      id
      inclusions
      exclusions
      faq
      highlight
      pointInfo
      orderInfo
      notice
      refund
      howtouse
      storeInfo
      sourceType
      productOrderType
      refundable
      galleryImages{
        url
      }
      actionLink{
        value
        target
      }      
      keyinfos {
        name
        value
        label
        coverImage{
          url
        }
      }
      options {
        id
        name
        optionItems {
          id
          name
          salePrice
          coverPrice
        }
      }
      author{
        name
        profileImage{
          url
        }
        introduction
      }
     }
     ... on Ecoupon {
        id
        howtouse
        refund
        notice
        productOrderType
        options{
          id
          name  
          summary
          
          optionItems {
            id
            name
            category
            cnt
            minBuyItem
            maxBuyItem
            salePrice
            coverPrice
          }
          timeSlots{
            id
            startTime
            endTime
          }
          additionalInfo{
            required
            label
          }
        }
     }
    
   }
 }
 couponApplyProduct(productId:${json.encode(id)},) {
   id
   name
   summary
   discountMax
   discountUnit
   discountAmount
   coverImage {
     url
   }
 }
}
''';

String readProductExperienceQuery(String id) => '''
query getProduct {
  product(
    where: {
     id: ${json.encode(id)},
    }
  ) {
    id
    name
    summary
    typeName
    tags
    rating
    message
    createdAt
    salePrice
    coverPrice
    lat
    lng
    discountRate
    
    coverImage {
      url
    }
    images {
      url
    }
    availableDateInfo  {
      name
      color 
    }
   
    productContent {
      ... on Experience {
        id
        inclusions
        exclusions
        faq
        highlight
        pointInfo
        orderInfo
        notice
        refund
        howtouse
        storeInfo
        sourceType
        productOrderType   
        refundable
        galleryImages{
          url
        }
        actionLink{
          value
          target
        }      
        keyinfos {
          name
          value
          label
          coverImage{
            url
          }
        }
        options {
          id
          name
          optionItems {
            id
            name
            salePrice
            coverPrice
          }
        }
        author{
          name
          profileImage{
            url
          }
          introduction
        }
      }
      
    }
 }
 couponApplyProduct(productId:${json.encode(id)},) {
   id
   name
   summary
   discountMax
   discountUnit
   discountAmount
   coverImage {
     url
   }
 }
}
''';

String readProductContentQuery(String id) => '''
query getProduct {
  product(
    where: {
      id: ${json.encode(id)},,
    }
  ) {
   id
   name
   summary
   typeName
   tags
   rating
   createdAt
   salePrice
   message
   coverPrice
   lat
   lng
   discountRate
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
   images {
     url
   }
   availableDateInfo  {
     name
     color 
   }
   coverImage {
     url
   }
   
 }
}
''';

String readProductEcouponQuery(String id) => '''
query getProduct {
  product(
    where: {
      id: ${json.encode(id)},,
    }
  ) {
   id
   name
   summary
   typeName
   tags
   rating
   createdAt
   salePrice
   message
   coverPrice
   discountRate
   images {
     url
   }
   coverImage {
     url
   }
   availableDateInfo  {
     name
     color 
   }
   productContent {
     ... on Ecoupon {
        id
        howtouse
        refund
        notice
        productOrderType
        options{
          id
          name  
          summary

          optionItems {
            id
            name
            category
            cnt
            minBuyItem
            maxBuyItem
            salePrice
            coverPrice
          }
          timeSlots{
            id
            startTime
            endTime
          }
          additionalInfo{
            required
            label
          }
        }
     }
   }
 }
 couponApplyProduct(productId:${json.encode(id)},) {
   id
   name
   summary
   discountMax
   discountUnit
   discountAmount
   coverImage {
     url
   }
 }
}
''';
