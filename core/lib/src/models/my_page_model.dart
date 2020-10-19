import '../../core.dart';

class UserModel {
  UserModel({
    this.id,
    // this.point,
    this.loginType,
    this.profile,
    this.state,
    this.type,
    this.company,
    this.alarmAgreement,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('json ${json['loginType']}');
    return UserModel(
        id: json['id'] ?? '',
        loginType: json['loginType'] ?? '',
        profile: json['profile'] != null
            ? ProfileModel.fromJson(json['profile'])
            : ProfileModel(),
        state: json['state'] ?? '',
        type: json['type'] ?? '',
        company: json['company'] != null
            ? CompanyModel.fromJson(json['company'])
            : CompanyModel(),
        alarmAgreement: json['alarmAgreement'] != null
            ? AlarmAgreementModel.fromJson(json['alarmAgreement'])
            : AlarmAgreementModel());
  }

  AlarmAgreementModel alarmAgreement;
  CompanyModel company;
  String id;
  String loginType;
  // PointModel point;
  ProfileModel profile;

  String state;
  String type;
}

class PointModel {
  PointModel({this.lifePoint, this.walfarePoint});

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
        lifePoint: json['lifePoint'], walfarePoint: json['walfarePoint']);
  }

  int lifePoint;
  int walfarePoint;
}

class ProfileModel {
  ProfileModel({
    this.authDate,
    this.email,
    this.employeeNumber,
    this.hireDate,
    this.imageInfo,
    this.mobile,
    this.name,
    this.birthDay,
    this.birthMonth,
    this.birthYear,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
        authDate: json['authDate'] ?? '',
        email: json['email'] ?? '',
        employeeNumber: json['employeeNumber'] ?? '',
        hireDate: json['hireDate'] ?? '',
        imageInfo: json['imageInfo'] != null
            ? ImageViewModel.fromJson(json['imageInfo'])
            : const ImageViewModel(),
        mobile: json['mobile'] ?? '',
        birthDay: json['birthDay'] ?? '',
        birthMonth: json['birthMonth'] ?? '',
        birthYear: json['birthYear'] ?? '',
        name: json['name'] ?? '');
  }

  String authDate;
  String birthDay;
  String birthMonth;
  String birthYear;
  String email;
  String employeeNumber;
  String hireDate;
  ImageViewModel imageInfo;
  String mobile;
  String name;
}

class CompanyModel {
  CompanyModel({
    this.id,
    this.name,
    this.companyCode,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        companyCode: json['companyCode'] ?? '');
  }

  String companyCode;
  String id;
  String name;
}

class LifePointModel {
  LifePointModel(
      {this.lifePoint,
      this.lifeTobeExpiredPoint,
      this.lifeTobeSavedPoint,
      this.lifePointList});

  factory LifePointModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['lifePointConnection']['nodes'];

    final pointDetails = list.map((dynamic point) {
      return LifePointListViewModel.fromJson(point);
    }).toList();

    return LifePointModel(
        lifePoint: json['lifePoint'],
        lifeTobeExpiredPoint: json['lifeTobeExpiredPoint'],
        lifeTobeSavedPoint: json['lifeTobeSavedPoint'],
        lifePointList: pointDetails);
  }

  int lifePoint;
  List<LifePointListViewModel> lifePointList;
  int lifeTobeExpiredPoint;
  int lifeTobeSavedPoint;
}

class LifePointListViewModel {
  LifePointListViewModel(
      {this.id,
      this.name,
      this.state,
      this.point,
      this.createdAt,
      this.expireDay,
      this.type});

  factory LifePointListViewModel.fromJson(Map<String, dynamic> json) {
    return LifePointListViewModel(
        id: json['id'],
        name: json['name'],
        state: json['state'],
        point: json['point'],
        createdAt: json['createdAt'],
        expireDay: json['expireDay'],
        type: json['type']);
  }

  String createdAt;
  int expireDay;
  String id;
  String name;
  int point;
  String state;
  String type;
}

class CouponModel {
  CouponModel({
    this.couponStateCount,
    this.couponList,
  });

  List<CouponListViewModel> couponList;
  CouponCountModel couponStateCount;
}

class CouponCountModel {
  CouponCountModel({
    this.enabledCount,
    this.disabledCount,
  });

  factory CouponCountModel.fromJson(Map<String, dynamic> json) {
    return CouponCountModel(
      enabledCount: json['enabledCount'],
      disabledCount: json['disabledCount'],
    );
  }

  int disabledCount;
  int enabledCount;
}

class CouponListViewModel {
  CouponListViewModel(
      {this.id,
      this.name,
      this.summary,
      this.state,
      this.discountAmount,
      this.discountUnit,
      this.expireDate,
      this.coverImage,
      this.remainDay});

  factory CouponListViewModel.fromJson(Map<String, dynamic> json) {
    return CouponListViewModel(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      state: json['state'],
      discountAmount: json['discountAmount'],
      discountUnit: json['discountUnit'],
      expireDate: json['expireDate'],
      coverImage: ImageViewModel.fromJson(json['coverImage']),
      remainDay: json['remainDay'],
    );
  }

  ImageViewModel coverImage;
  int discountAmount;
  String discountUnit;
  String expireDate;
  String id;
  String name;
  int remainDay;
  String state;
  String summary;
}
