import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../core.dart';

class MainPageProvider {
  Future<Map<String, dynamic>> feedConnection(
      {int first, String cursor, bool isFetch, double lat, double lng}) {
    return getGraphQLClient()
        .query(_queryOptions(first, cursor, isFetch, lat, lng))
        .then(_toFeedConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(
      int first, String cursor, bool isFetch, double lat, double lng) {
    // print(_readFeedConnectionQuery(first, cursor, lat, lng));
    if (isFetch) {
      return QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          documentNode: gql(_readFeedConnectionQuery(first, cursor, lat, lng)));
    }
    return QueryOptions(
        documentNode: gql(_readFeedConnectionQuery(first, cursor, lat, lng)));
  }

  Map<String, dynamic> _toFeedConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['feedConnection']['edges'];
    if (list.isEmpty) {
      return <String, dynamic>{};
    }
    final mainFeed = list.map((dynamic feed) {
      return FeedModel.fromJson(feed['node']);
    }).toList();
    final String lastCursor = list[list.length - 1]['cursor'];

    return <String, dynamic>{
      'lastCursor': lastCursor,
      'feed': mainFeed,
    };
  }

  String _readFeedConnectionQuery(
          int first, String cursor, double lat, double lng) =>
      '''
  {
 feedConnection(
   first: $first
   after:${json.encode(cursor)},
   location:{lat:$lat,lng:$lng},
  ) {
   edges {
   cursor
    
    node {
       __typename
      ... on FeedCardProducts {
        title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
        feedCardProducts {
          id
          name
          tags
          summary
          typeName
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
          availableDateInfo{
             name
             color            
          }
          coverImage {
            url
          }
          images {
            url
          }
          coverPrice
          salePrice
        }
      }
      
      
      __typename
      ... on FeedListViewProducts {
        title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
        feedListViewProducts {
          id
          name
          summary
          typeName
          tags
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
          availableDateInfo{
             name
             color            
          }
          coverImage {
            url
          }
          images {
            url
          }
          coverPrice
          salePrice
          lat
          lng
        }
      }
      __typename
      ... on FeedListViewMapProducts {
        title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
        feedListViewMapProducts {
          name
          nodes{
            id
            name
            summary
            tags
            typeName
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
            availableDateInfo{
              name
              color            
            }
            coverImage {
              url
            }
            images {
              url
            }
            coverPrice
            salePrice
            lat
            lng
          }
          
          
        }
      }
      
       __typename
      
       ... on FeedPromotions {
        title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
           feedPromotions {
           id
           summary
           type
           name
           coverImage {
             url
           }
           actionLink {
            value
            target
          }
           products{
              id
              name
              summary
              tags
              typeName
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
              availableDateInfo{
                name
                color            
              }
              coverImage {
                url
              }
              images {
                url
              }
              coverPrice
              salePrice
              lat
              lng
           }
         }
       }
       __typename
       ... on FeedCoupons {
         title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
         feedCoupons {
            id
            name
          	summary
          	remainDay
          	expireDate
          	discountAmount
          	discountUnit
          	discountMax
          }
       }
       __typename
       ... on FeedSmallBanners {
        title
        labelType
        bannerView
        overView
      
        actionLink {
            target
            value
          }
         feedSmallBanners {
           id
           name
           positionType
           coverImage {
             url
           }
           actionLink {
             value
             target
           }
         }
       }
       __typename
       ... on FeedBanners {
        
        title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
         feedBanners {
           id
           name
           positionType
           coverImage {
             url
           }
           actionLink {
             value
             target
           }
         }
       }
      
      
      __typename
       ... on FeedGridGroupProducts {
      	  title
        labelType
        bannerView
        overView
        subMessage
         actionLink {
            target
            value
          }
         feedGridGroupProducts {
          name
          nodes{
            id
            name
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
            tags
            typeName
            salePrice
            coverPrice
            discountRate
            availableDateInfo{
              name
              color            
            }
          }
        
        
        }
      }
       __typename
       ... on FeedGridProducts {
         title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
          target
          value
        }
        feedGridProducts {          
          id
          name
          coverImage {
            url
          }
          images {
            url
          }
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
          tags
          typeName
          salePrice
          coverPrice
          discountRate
          availableDateInfo{
            name
            color            
          }
        }
      }
      __typename
      ... on FeedBigSlideProducts {
        title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
        feedBigSlideProducts {
          id
          name
          summary
          tags
          typeName
          discountRate
          availableDateInfo{
             name
             color            
          }
          coverImage {
            url
          }
          images {
            url
          }
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
          coverPrice
          salePrice
        }
      }
       __typename
       ... on FeedSlideProducts {
         title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
          target
          value
        }
        feedSlideProducts {
          id
          name
          coverImage {
            url
          }
          images {
            url
          }
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
          tags
          typeName
          availableDateInfo{
            name
            color            
          }
          productContent {
            __typename
            ... on Content {
              place
              period
            }
          }
         }
       }
       __typename
       ... on FeedSmallSlideProducts {
         title
        labelType
        bannerView
        overView
        subMessage
        actionLink {
            target
            value
          }
         feedSmallSlideProducts {
          id
          name
          coverImage {
            url
          }
          images {
          url
          }
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
          tags
          typeName
          salePrice
          coverPrice
          discountRate
          availableDateInfo{
            name
            color            
          } 
          productContent {
            ... on Ecoupon {
       
                id
                howtouse
                refund
                notice
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
