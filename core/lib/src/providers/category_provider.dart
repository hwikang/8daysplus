import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';
import 'package:rxdart/rxdart.dart';

import '../../core.dart';

class CategoryProvider {
  String tSearchTypeName;
  Future<List<CategoryModel>> categories(
      {String typeName,
      String searchTypeName,
      String categoryId,
      BehaviorSubject networkStateStream}) {
    tSearchTypeName = searchTypeName;
    return getGraphQLClient()
        .query(_queryOptions(
            typeName: typeName,
            searchTypeName: searchTypeName,
            categoryId: categoryId))
        .then(_toCategory)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(
      {String typeName, String searchTypeName, String categoryId}) {
    var typeNameQuery = '';
    var searchTypeNameQuery = '';
    var categoryIdQuery = '';
    if (typeName != null && typeName != '') {
      typeNameQuery = 'types: $typeName';
    }
    if (searchTypeName != null && searchTypeName != '') {
      //'PRICE_RANGE' 같은 타입 있을때만적용
      searchTypeNameQuery = 'searchType: $searchTypeName';
    }
    if (categoryId != null && categoryId != '') {
      //'PRICE_RANGE' 같은 타입 있을때만적용
      categoryIdQuery = 'categoryId: "$categoryId"';
    }

    print(
        'category query ${readCategoryQuery(typeNameQuery, searchTypeNameQuery, categoryIdQuery)}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readCategoryQuery(
            typeNameQuery, searchTypeNameQuery, categoryIdQuery)));
  }

  List<CategoryModel> _toCategory(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['categories'];
    // print( list);
    return list.map((dynamic repoJson) {
      return CategoryModel.fromJson(repoJson);
    }).toList();
  }

  String readCategoryQuery(String typeNameQuery, String searchTypeNameQuery,
          String categoryIdQuery) =>
      '''
  {
    categories(where: {
      $typeNameQuery
      $categoryIdQuery
      $searchTypeNameQuery
    }) {
      id
      name
      summary
      type
      searchType
      childCount
      coverImage{
        url
      }
      value{
        min
        max
      }
      isTail
      nodes{
        id
        name
        summary
        type
        searchType
        childCount
        coverImage{
          url
        }
        value{
          min
          max
        }
        isTail
        nodes{
          id
          name
          summary
          type
          searchType
          childCount
          coverImage{
            url
          }
          value{
            min
            max
          }
          isTail
          nodes{
            id
            name
            summary
            type
            searchType
            childCount
            coverImage{
              url
            }
            value{
              min
              max
            }
            isTail
            nodes{
              id
              name
              summary
              type
              searchType
              childCount
              coverImage{
                url
              }
              value{
                min
                max
              }
              isTail
            }
            
          }
        }
      }
    }
  }
  ''';
}
