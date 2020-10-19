import '../../../core.dart';

class SearchFilterModel {
  SearchFilterModel({
    this.sort = const SortFilterModel(orderBy: OrderByModel()),
    this.money = const MoneyFilterModel(),
    this.location = const CategoryModel(),
    this.type = const CategoryModel(),
  });

  CategoryModel location;
  MoneyFilterModel money;
  SortFilterModel sort;
  CategoryModel type;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sort': sort.toJSON(),
      'money': money.toJSON(),
      'location': location.toJSON(),
      'type': type.toJSON(),
    };
  }
}

class SortFilterModel {
  const SortFilterModel({
    this.name = '',
    this.orderBy = const OrderByModel(),
  });

  factory SortFilterModel.fromJson(Map<String, dynamic> json) {
    return SortFilterModel(orderBy: OrderByModel.fromJson(json['orderBy']));
  }
  final String name;
  final OrderByModel orderBy;

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{'name': name, 'orderBy': orderBy.toJSON()};
  }
}

class MoneyFilterModel {
  const MoneyFilterModel({
    this.id = '',
    this.name = '',
    this.priceRange = const PriceRangeModel(),
  });

  final String id;
  final String name;
  final PriceRangeModel priceRange;

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{'name': name, 'priceRange': priceRange.toJSON()};
  }
}
