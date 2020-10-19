import 'dart:convert';

import '../../../core.dart';

class SearchInputModel {
  SearchInputModel({
    this.categoryIds = const <String>[],
    this.categoryRegionIds = const <String>[],
    this.types = const <String>[],
    this.keyword = '',
    this.priceRange = const PriceRangeModel(),
    this.state = 'OPEN',
    this.location = const LocationModel(),
  });

  List<String> categoryIds;
  List<String> categoryRegionIds;
  String keyword;
  LocationModel location;
  PriceRangeModel priceRange;
  String state;
  List<String> types;

  Map<String, dynamic> toJSON() {
    print('categoryRegionIds $categoryRegionIds');
    print('types $types');
    print('categoryIds $categoryIds');
    print(
      'priceRange ${priceRange.toJSON()}',
    );

    return <String, dynamic>{
      'categoryRegionIds': categoryRegionIds[0] == ''
          ? categoryRegionIds
          : json.encode(categoryRegionIds),
      'categoryIds':
          categoryIds[0] == '' ? categoryIds : json.encode(categoryIds),
      'types': types,
      'keyword': json.encode(keyword),
      'priceRange': priceRange.toJSON(),
      'state': state,
      'location': location.toJson(),
    };
  }
}
