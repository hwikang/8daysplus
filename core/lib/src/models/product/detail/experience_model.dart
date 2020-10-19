import '../../../../core.dart';

class ExperienceModel {
  ExperienceModel({
    this.id,
    this.inclusions,
    this.exclusions,
    this.faq,
    this.orderInfo,
    this.notice,
    this.refund,
    this.howtouse,
    this.storeInfo,
    this.sourceType,
    this.state,
    this.highlight,
    this.options,
    this.keyinfos,
    this.pointInfo,
    this.galleryImages,
    this.actionLink,
    this.author,
    this.productOrderType,
    this.refundable,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    print('json $json');
    List<ProductOptionsModel> optionList;
    final List<dynamic> list = json['options'];
    optionList = list.map((dynamic item) {
      return ProductOptionsModel.fromJson(item);
    }).toList();

    List<ProductExperienceKeyInfoModel> keyinfoList;
    final List<dynamic> tKeyinfoList = json['keyinfos'];
    keyinfoList = tKeyinfoList.map((dynamic item) {
      return ProductExperienceKeyInfoModel.fromJson(item);
    }).toList();
    // List<ImageViewModel> galleryImages;
    final List<dynamic> tGalleryImages = json['galleryImages'];
    final galleryImages = tGalleryImages.map((dynamic image) {
      return ImageViewModel.fromJson(image);
    }).toList();
    return ExperienceModel(
        id: json['id'],
        inclusions: json['inclusions'],
        exclusions: json['exclusions'],
        faq: json['faq'],
        orderInfo: json['orderInfo'],
        notice: json['notice'],
        refund: json['refund'],
        howtouse: json['howtouse'],
        storeInfo: json['storeInfo'],
        sourceType: json['sourceType'],
        state: json['state'],
        highlight: json['highlight'],
        options: optionList,
        keyinfos: keyinfoList,
        pointInfo: json['pointInfo'],
        galleryImages: galleryImages,
        productOrderType: json['productOrderType'],
        refundable: json['refundable'],
        actionLink: ActionLinkModel.fromJson(
          json['actionLink'],
        ),
        author: AuthorModel.fromJson(json['author']));
  }

  factory ExperienceModel.orderListFromJson(Map<String, dynamic> json) {
    return ExperienceModel(refund: json['refund']);
  }

  ActionLinkModel actionLink;
  AuthorModel author;
  String exclusions;
  String faq;
  List<ImageViewModel> galleryImages;
  String highlight;
  String howtouse;
  String id;
  String inclusions;
  List<ProductExperienceKeyInfoModel> keyinfos;
  String notice;
  List<ProductOptionsModel> options;
  String orderInfo;
  String pointInfo;
  String productOrderType;
  String refund;
  bool refundable;
  String sourceType;
  String state;
  String storeInfo;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'inclusions': inclusions,
        'exclusions': exclusions,
        'faq': faq,
        'orderInfo': orderInfo,
        'notice': notice,
        'refund': refund,
        'howtouse': howtouse,
        'storeInfo': storeInfo,
        'sourceType': sourceType,
        'state': state,
        'highlight': highlight,
        'options': options,
        'keyinfos': keyinfos,
        'pointInfo': pointInfo,
      };
}
