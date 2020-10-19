import 'package:meta/meta.dart';

import '../../../../core.dart';

class ProductDetailViewModel {
  ProductDetailViewModel({
    @required this.id,
    @required this.name,
    this.message,
    this.summary,
    this.categoryName,
    this.categories,
    @required this.typeName,
    this.rating,
    this.createdAt,
    @required this.coverImage,
    this.experienceRepo,
    this.ecouponRepo,
    this.tags,
    this.categoryIds,
    this.discountRate,
    @required this.coverPrice,
    @required this.salePrice,
    this.images,
    this.lat,
    this.lng,
    this.availableDateInfo,
  });

  factory ProductDetailViewModel.fromEcouponJson(dynamic json) {
    // final NumberFormat formatter = new NumberFormat('#,###');
    List<ImageViewModel> imageList;
    final List<dynamic> tImageList = json['images'];
    imageList = tImageList.map((dynamic item) {
      return ImageViewModel.fromJson(item);
    }).toList();
    return ProductDetailViewModel(
      id: json['id'],
      name: json['name'],
      message: json['message'],
      summary: json['summary'],
      typeName: json['typeName'],
      rating: json['rating'],
      createdAt: json['createdAt'],
      tags: json['tags'],
      discountRate: json['discountRate'],
      coverPrice: json['coverPrice'],
      salePrice: json['salePrice'] ?? 0,
      images: imageList,
      coverImage: ImageViewModel.fromJson(json['coverImage']),
      availableDateInfo:
          AvailableDateInfoModel.fromJson(json['availableDateInfo']),
      ecouponRepo: EcouponModel.fromJson(json['productContent']),
    );
  }

  factory ProductDetailViewModel.fromExperienceJson(dynamic json) {
    print(json['productContent']);

    List<ImageViewModel> imageList;
    final List<dynamic> tImageList = json['images'];
    imageList = tImageList.map((dynamic item) {
      return ImageViewModel.fromJson(item);
    }).toList();

    var latt = 0.0;
    var lngg = 0.0;

    if (json['lat'] == 0) {
      latt = 0.0;
    } else {
      latt = json['lat'];
    }
    if (json['lng'] == 0) {
      latt = 0.0;
    } else {
      lngg = json['lng'];
    }

    return ProductDetailViewModel(
      id: json['id'],
      name: json['name'],
      message: json['message'],
      summary: json['summary'],
      // categoryName: json['categoryName'],
      typeName: json['typeName'],
      rating: json['rating'],
      createdAt: json['createdAt'],
      tags: json['tags'],
      categoryIds: json['categoryIds'],
      discountRate: json['discountRate'],
      coverPrice: json['coverPrice'],
      salePrice: json['salePrice'] ?? 0,
      lat: latt,
      lng: lngg,
      images: imageList,
      coverImage: ImageViewModel.fromJson(json['coverImage']),
      availableDateInfo:
          AvailableDateInfoModel.fromJson(json['availableDateInfo']),
      experienceRepo: ExperienceModel.fromJson(json['productContent']),

      // experienceRepo: ExperienceModel.fromJson(json['Experience']),
      // detailUsageInfo: json['productContent']['detailUsageInfo'],
    );
  }

  factory ProductDetailViewModel.fromJson(dynamic json) {
    // final formatter = new NumberFormat('#,###');

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

    double lat;
    double lng;
    if (json['lat'] != null && json['lng'] != null) {
      lat = json['lat'].toDouble();
      lng = json['lng'].toDouble();
    } else {
      lat = 0.0;
      lng = 0.0;
    }

    // ContentModel contentRepo = ContentModel();
    var experienceRepo = ExperienceModel();
    var ecouponRepo = EcouponModel();

    if (json['productContent'] != null) {
      switch (json['typeName']) {
        case 'CONTENT':
          // contentRepo = ContentModel.fromJson(json['productContent']);
          break;
        case 'EXPERIENCE':
          experienceRepo = ExperienceModel.fromJson(json['productContent']);
          break;
        case 'ECOUPON':
          ecouponRepo = EcouponModel.fromJson(json['productContent']);
          break;
        default:
      }
    }
    return ProductDetailViewModel(
        id: json['id'],
        name: json['name'],
        message: json['message'],
        summary: json['summary'] ?? '',
        categoryName: json['categoryName'] ?? '',
        categories: categories,
        typeName: json['typeName'],
        rating: json['rating'],
        createdAt: json['createdAt'] ?? '',
        tags: json['tags'] ?? <dynamic>[],
        categoryIds: json['categoryIds'],
        discountRate: json['discountRate'] ?? 0,
        coverPrice: json['coverPrice'] ?? 0,
        salePrice: json['salePrice'] ?? 0,
        lat: lat,
        lng: lng,
        images: imageList,
        availableDateInfo:
            AvailableDateInfoModel.fromJson(json['availableDateInfo']),
        coverImage:
            ImageViewModel.fromJson(json['coverImage'] ?? <String, dynamic>{}),
        ecouponRepo: ecouponRepo,
        experienceRepo: experienceRepo);
  }

  AvailableDateInfoModel availableDateInfo;
  List<CategoryModel> categories;
  List<dynamic> categoryIds;
  String categoryName;
  ImageViewModel coverImage;
  int coverPrice;
  String createdAt;
  int discountRate;
  EcouponModel ecouponRepo;
  ExperienceModel experienceRepo;
  String id;
  List<ImageViewModel> images;
  double lat;
  double lng;
  String message;
  String name;
  int rating;
  int salePrice;
  String summary;
  List<dynamic> tags;
  String typeName;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'message': message,
        'summary': summary,
        // 'categoryName': categoryName,
        'typeName': typeName,
        'rating': rating,
        'createdAt': createdAt,
        'coverImage': coverImage,
        'experienceRepo': experienceRepo,
        'ecouponRepo': ecouponRepo,
        'tags': tags,
        'categoryIds': categoryIds,
        'discountRate': discountRate,
        'coverPrice': coverPrice,
        'salePrice': salePrice,
        'lat': lat,
        'lng': lng,
        'images': images,
      };
}
