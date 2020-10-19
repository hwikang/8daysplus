import 'dart:convert';

import '../../../core.dart';
import 'image_view_model.dart';

class ProductListViewModel {
  ProductListViewModel({
    this.id,
    this.name,
    this.categoryName,
    this.categories,
    this.typeName,
    this.summary,
    this.createdAt,
    this.cursorID,
    this.tags,
    this.image,
    this.coverPrice,
    this.salePrice,
    this.discountRate,
    this.lat,
    this.lng,
    this.images,
    this.availableDateInfo,
    this.sourceType,
    this.productContent,
    this.contentRepo,
    this.experienceRepo,
    this.ecouponRepo,
  });

  factory ProductListViewModel.fromJson(Map<String, dynamic> json) {
    List<ImageViewModel> imageList;
    final List<dynamic> tempImageList = json['images'];
    if (tempImageList != null) {
      imageList = tempImageList.map((dynamic item) {
        return ImageViewModel.fromJson(item);
      }).toList();
    }

    final List<dynamic> categorieJson = json['categories'];
    List<CategoryModel> categories;
    if (categorieJson != null) {
      categories = categorieJson.map((dynamic category) {
        return CategoryModel.fromJson(category);
      }).toList();
    }

    var contentRepo = ContentModel();
    var experienceRepo = ExperienceModel();
    var ecouponRepo = EcouponModel();

    if (json['productContent'] != null) {
      switch (json['typeName']) {
        case 'CONTENT':
          contentRepo = ContentModel.fromJson(json['productContent']);
          break;
        case 'EXPERIENCE':
          experienceRepo =
              ExperienceModel.orderListFromJson(json['productContent']);
          break;
        case 'ECOUPON':
          ecouponRepo = EcouponModel.orderListFromJson(json['productContent']);
          break;
        default:
      }
    }

    double lat;
    double lng;
    if (json['lat'] != null && json['lng'] != null) {
      lat = json['lat'].toDouble();
      lng = json['lng'].toDouble();
    } else {
      lat = 0.0;
      lng = 0.0;
    }

    return ProductListViewModel(
        id: json['id'],
        name: json['name'],
        categories: categories,
        categoryName: json['categoryName'] ?? '',
        typeName: json['typeName'],
        summary: json['summary'] ?? '',
        createdAt: json['createdAt'] ?? '',
        cursorID: json['cursor'] ?? '',
        tags: json['tags'] ?? <dynamic>[],
        image:
            ImageViewModel.fromJson(json['coverImage'] ?? <String, dynamic>{}),
        coverPrice: json['coverPrice'] ?? 0,
        salePrice: json['salePrice'] ?? 0,
        discountRate: json['discountRate'] ?? 0,
        images: imageList,
        availableDateInfo: AvailableDateInfoModel.fromJson(
            json['availableDateInfo'] ?? <String, dynamic>{}),
        lat: lat,
        lng: lng,
        productContent: json['productContent'], //order 에서사용중
        sourceType: json['sourceType'] ?? '',
        contentRepo: contentRepo,
        experienceRepo: experienceRepo,
        ecouponRepo: ecouponRepo);
  }

  factory ProductListViewModel.fromStylePick(Map<String, dynamic> json) {
    return ProductListViewModel(
      id: json['id'],
      name: json['name'],
      tags: json['tags'],
      typeName: json['typeName'],
      image: ImageViewModel.fromJson(json['coverImage']),
    );
  }

  AvailableDateInfoModel availableDateInfo;
  List<CategoryModel> categories;
  String categoryName;
  ContentModel contentRepo;
  int coverPrice;
  String createdAt;
  String cursorID;
  int discountRate;
  EcouponModel ecouponRepo;
  ExperienceModel experienceRepo;
  String id;
  ImageViewModel image;
  List<ImageViewModel> images;
  double lat;
  double lng;
  String name;
  Map<String, dynamic> productContent;
  int salePrice;
  String sourceType;
  String summary;
  List<dynamic> tags;
  String typeName;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'categoryName': categoryName,
        'typeName': typeName,
        'summary': summary,
        'createdAt': createdAt,
        'cursorID': cursorID,
        'tags': tags,
        'coverImage': image,
        'coverPrice': coverPrice,
        'salePrice': salePrice,
        'images': images,
      };

  Map<String, dynamic> toJsonOnlyId() => <String, dynamic>{
        'id': json.encode(id),
      };
}
