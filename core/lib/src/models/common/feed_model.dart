import '../../../core.dart';
import '../main/feed_banner_model.dart';
import '../main/feed_summary_model.dart';

class FeedModel {
  FeedModel({this.node});

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    var node = <String, dynamic>{};

    node['__typename'] = json['__typename'];
    node['actionLink'] = json['actionLink']; //actionLink

    node['title'] = json['title'] ?? '';
    node['subTitle'] = json['subTitle'] ?? '';
    node['labelType'] = json['labelType'] ?? 'NONE';
    node['bannerView'] = json['bannerView'] ?? false;
    node['overView'] = json['overView'] ?? false;
    node['subMessage'] = json['subMessage'] ?? '';
    switch (json['__typename']) {
      case 'FeedPromotions':
        // print('FeedPromotions == ${json['feedPromotions']}');
        final List<dynamic> feedPromotions = json['feedPromotions'];
        node['feedPromotions'] = feedPromotions.map((dynamic promotion) {
          return FeedPromotionModel.fromJson(promotion);
        }).toList();
        break;
      case 'FeedSmallBanners':
        final List<dynamic> feedSmallBanners = json['feedSmallBanners'];
        node['feedSmallBanners'] = feedSmallBanners.map((dynamic banner) {
          return FeedBannerModel.fromJson(banner);
        }).toList();
        break;
      case 'FeedBanners':
        final List<dynamic> feedBanners = json['feedBanners'];
        node['feedBanners'] = feedBanners.map((dynamic banner) {
          return FeedBannerModel.fromJson(banner);
        }).toList();
        break;
      case 'FeedGridProducts':
        final List<dynamic> feedGridProducts = json['feedGridProducts'];
        node['feedGridProducts'] = feedGridProducts.map((dynamic experience) {
          return ProductListViewModel.fromJson(experience);
        }).toList();
        break;
      case 'FeedGridGroupProducts':
        final List<dynamic> feedGridProducts = json['feedGridGroupProducts'];
        node['feedGridGroupProducts'] = feedGridProducts.map((dynamic data) {
          final List<dynamic> nodes = data['nodes'];
          final productList = nodes.map((dynamic product) {
            return ProductListViewModel.fromJson(product);
          }).toList();
          final map = <String, dynamic>{
            'name': data['name'],
            'nodes': productList,
          };
          return map;
        }).toList();
        break;

      case 'FeedSmallSlideProducts':
        final List<dynamic> feedSmallSlideProducts =
            json['feedSmallSlideProducts'];
        node['feedSmallSlideProducts'] =
            feedSmallSlideProducts.map((dynamic ecoupon) {
          return ProductListViewModel.fromJson(ecoupon);
        }).toList();
        break;
      case 'FeedSlideProducts':
        final List<dynamic> feedSlideProducts = json['feedSlideProducts'];
        node['feedSlideProducts'] = feedSlideProducts.map((dynamic festival) {
          return ProductListViewModel.fromJson(festival);
        }).toList();
        break;
      case 'FeedBigSlideProducts':
        final List<dynamic> feedBigSlideProducts = json['feedBigSlideProducts'];
        node['feedBigSlideProducts'] =
            feedBigSlideProducts.map((dynamic bigSlide) {
          return ProductListViewModel.fromJson(bigSlide);
        }).toList();
        break;
      case 'FeedCoupons':
        final List<dynamic> feedCoupons = json['feedCoupons'];
        node['feedCoupons'] = feedCoupons.map((dynamic coupons) {
          return FeedCouponModel.fromJson(coupons);
        }).toList();
        break;
      case 'FeedListViewMapProducts':
        // print(json['feedListViewMapProducts']);
        final List<dynamic> feedListViewMapProducts =
            json['feedListViewMapProducts'];
        node['feedListViewMapProducts'] =
            feedListViewMapProducts.map((dynamic data) {
          final List<dynamic> nodes = data['nodes'];
          final productList = nodes.map((dynamic product) {
            return ProductListViewModel.fromJson(product);
          }).toList();
          final map = <String, dynamic>{
            'name': data['name'],
            'nodes': productList,
          };
          return map;
        }).toList();
        break;
      case 'FeedListViewProducts':
        final List<dynamic> feedListViewProducts = json['feedListViewProducts'];
        node['feedListViewProducts'] = feedListViewProducts.map((dynamic list) {
          return ProductListViewModel.fromJson(list);
        }).toList();
        break;
      case 'FeedCardProducts':
        final List<dynamic> feedCardProducts = json['feedCardProducts'];
        // print('feedCardProducts44 === ${feedCardProducts}');
        node['feedCardProducts'] = feedCardProducts.map((dynamic card) {
          return ProductListViewModel.fromJson(card);
        }).toList();
        break;

      case 'FeedSummary':
        final List<dynamic> feedSummary = json['feedSummary'];
        node['feedSummary'] = feedSummary.map((dynamic summary) {
          return FeedSummaryModel.fromJson(summary);
        }).toList();
        break;
      case 'FeedStyleAnaylze':
        // final List<dynamic> feedSummary = json['feedSummary'];
        node['feedStyleAnaylze'] = '';
        break;

      default:
        node = <String, dynamic>{};
    }
    return FeedModel(
      node: node,
    );

    // returb
  }

  Map<String, dynamic> node;
}
