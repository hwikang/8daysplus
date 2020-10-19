class ServicePolicyInfoModel {
  ServicePolicyInfoModel(
      {this.couponPolicyUrl,
      this.locationUseTermsUrl,
      this.personalInfoUrl,
      this.pointPolicyUrl,
      this.serviceUseTermsUrl,
      this.elecTermsUrl,
      this.thirdTermsUrl});

  factory ServicePolicyInfoModel.fromJson(Map<String, dynamic> json) {
    return ServicePolicyInfoModel(
      couponPolicyUrl: json['couponPolicyUrl'],
      locationUseTermsUrl: json['locationUseTermsUrl'],
      personalInfoUrl: json['personalInfoUrl'],
      pointPolicyUrl: json['pointPolicyUrl'],
      serviceUseTermsUrl: json['serviceUseTermsUrl'],
      thirdTermsUrl: json['thirdTermsUrl'],
      elecTermsUrl: json['elecTermsUrl'],
    );
  }

  String couponPolicyUrl;
  String elecTermsUrl;
  String locationUseTermsUrl;
  String personalInfoUrl;
  String pointPolicyUrl;
  String serviceUseTermsUrl;
  String thirdTermsUrl;
}
