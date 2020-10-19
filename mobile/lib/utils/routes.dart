import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/components/common/header_title_widget.dart';
import '../ui/pages/authority_page.dart';
import '../ui/pages/developer_page.dart';
import '../ui/pages/discovery/list/discovery_list_page.dart';
import '../ui/pages/discovery/search/discovery_search_page.dart';
import '../ui/pages/main/notice_event_detail_page.dart';
import '../ui/pages/main/promotion_list_page.dart';
import '../ui/pages/member/login/email_login_page.dart';
import '../ui/pages/member/login/temp_password_complete_page.dart';
import '../ui/pages/member/login/temp_password_request_page.dart';
import '../ui/pages/member/member_main_page.dart';
import '../ui/pages/member/signup/company_code_page.dart';
import '../ui/pages/member/signup/email_auth_page.dart';
import '../ui/pages/member/signup/memeber_phone_page.dart';
import '../ui/pages/member/signup/signup_complete_page.dart';
import '../ui/pages/member/signup/signup_page.dart';
import '../ui/pages/member/signup/signup_term_page.dart';
import '../ui/pages/mypage/cart_list_page.dart';
import '../ui/pages/mypage/coupon/apply_coupon_page.dart';
import '../ui/pages/mypage/coupon/my_coupon_page.dart';
import '../ui/pages/mypage/faq_page.dart';
import '../ui/pages/mypage/inquiry_create_page.dart';
import '../ui/pages/mypage/inquiry_list_page.dart';
import '../ui/pages/mypage/my_setting_page.dart';
import '../ui/pages/mypage/notice_list_page.dart';
import '../ui/pages/mypage/order/create_refund_page.dart';
import '../ui/pages/mypage/order/my_order_detail_page.dart';
import '../ui/pages/mypage/order/my_order_detail_user_page.dart';
import '../ui/pages/mypage/order/my_order_page.dart';
import '../ui/pages/mypage/style/my_page_style_select_page.dart';
import '../ui/pages/mypage/style/my_style_page.dart';
import '../ui/pages/navigate_page.dart';
import '../ui/pages/product_detail_page.dart';
import '../ui/pages/product_detail_simple_page.dart';
import '../ui/pages/purchase/payment/each_list_page.dart';
import '../ui/pages/purchase/payment/payment_page.dart';
import '../ui/pages/purchase/payment/payment_success_page.dart';
import '../ui/pages/purchase/payment/select_coupon_page.dart';
import '../ui/pages/purchase/product_purchase_page.dart';
import '../ui/pages/purchase/purchase_option_item_page.dart';
import '../ui/pages/purchase/purchase_order_info_input_page.dart';
import '../ui/pages/reservation/reservation_barcode_page.dart';
import '../ui/pages/reservation/reservation_detail_page.dart';
import '../ui/pages/reservation/reservation_refund_detail_page.dart';
import '../ui/pages/reservation/reservation_voucher_page.dart';
import 'assets.dart';
import 'firebase_analytics.dart';
import 'handle_network_error.dart';
import 'page_router.dart';
import 'singleton.dart';
import 'strings.dart';

class AppRoutes {
  static Future<bool> authCheck(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('token');
    logger.d('accessToken = $accessToken');
    if (accessToken == null) {
      return false;
    }
    return true;
  }

  static void logout(BuildContext context) {
    final logoutProvider = LogoutProvider();
    logoutProvider.logout().then((value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      Singleton.instance.isLogin = false;
      Analytics.analyticsSetUserId('');
      Analytics.analyticsSetUserProperty(UserPropertyStrings.uuid, '');
      Analytics.analyticsSetUserProperty(UserPropertyStrings.email, '');
      Analytics.analyticsSetUserProperty(UserPropertyStrings.companyCode, '');
      Analytics.analyticsSetUserProperty(
          UserPropertyStrings.marketingAgree, '');
      Analytics.analyticsSetUserProperty(UserPropertyStrings.signUpType, '');
      Analytics.analyticsSetUserProperty(UserPropertyStrings.appVersion, '');
      Analytics.analyticsSetUserProperty(UserPropertyStrings.birthDay, '');

      switch (Singleton.instance.loginType) {
        case 'KAKAO':
          final kakaoSignIn = FlutterKakaoLogin();
          kakaoSignIn.logOut();
          break;
        case 'GOOGLE':
          final _googleSignIn = GoogleSignIn();
          _googleSignIn.signOut();
          break;

        default:
      }

      makeFirst(context, MemberMainPage());
    }).catchError((error) {
      HandleNetworkError.showErrorDialog(context, error);
    });
  }

  static void authorityPage(BuildContext context) {
    push(
      context,
      AuthorityPage(),
    );
  }

  // 초기 로딩을 위한 메인 페이지
  static void firstMainPage(BuildContext context) {
    makeFirst(context, const NavigatePage(event: NavbarEvent.Main));
  }

  static void firstMyPage(BuildContext context) {
    makeFirst(context, const NavigatePage(event: NavbarEvent.My));
  }

  static Future<T> buildModalBottomSheet<T>({
    BuildContext context,
    Widget child,
  }) async {
    return showModalBottomSheet<T>(
        elevation: 0.0,
        isScrollControlled: true,
        isDismissible: false,
        // useRootNavigator: true, // if it's true, android back button will close app
        backgroundColor: const Color(0xFFffffff),
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.only(top: 35),
            child: child,
          );
        });
  }

  static Future<T> buildTitledModalBottomSheet<T>({
    BuildContext context,
    String title,
    Widget child,
  }) {
    return showModalBottomSheet<T>(
        elevation: 0.0,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: const Color(0xFFffffff),
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: Singleton.instance.statusBarHeight),
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.black,
                      onPressed: () {
                        AppRoutes.pop(context);
                      },
                    ),
                    title: HeaderTitleWidget(title: title)),
                body: child,
              ),
            ),
          );
        });
  }

  static Future<T> buildButtonModalBottomSheet<T>({
    BuildContext context,
    Widget child,
  }) async {
    return showModalBottomSheet<T>(
        isScrollControlled: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.01),
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(top: 34),
                    margin: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage(ImageAssets.modalCloseIcon),
                      width: 48,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          );
        });
  }

  static void productDetailPage(
    BuildContext context,
    ProductListViewModel item,
  ) {
    authCheck(context).then((isLogin) {
      if (isLogin) {
        push(
            context,
            //item.name,
            ProductDetailPage(item: item));
      } else {
        return memberMainPage(
          context,
        );
      }
    }).catchError((dynamic err) => print('Error getting authCheck $err'));
  }

  static void productDetailSimplePage(
      {BuildContext context,
      String heroTagName,
      String productId,
      String productType,
      String title}) {
    authCheck(context).then((isLogin) {
      if (isLogin) {
        push(
            context,
            ProductDetailSimplePage(
                // heroTagName: heroTagName,
                productId: productId,
                productType: productType,
                title: title));
      } else {
        return memberMainPage(
          context,
        );
      }
    }).catchError((dynamic err) => print('Error getting authCheck $err'));
  }

  static void productPurchasePage(
      {BuildContext context,
      ProductDetailViewModel item,
      // String typeName,
      String productOrderType,
      bool refundable}) {
    buildModalBottomSheet(
        context: context,
        child: ProductPurchasePage(
            item: item,
            productOrderType: productOrderType,
            refundable: refundable));
  }

  static void purchaseOptionItemPage(BuildContext context, String day,
      String productId, ProductOptionsModel selectedOptionItem) {
    buildModalBottomSheet(
        context: context,
        child: PurchaseOptionItemPage(
          day: day,
          productId: productId,
          selectedOptionItem: selectedOptionItem,
        ));
  }

  static void modalSheet(BuildContext context, Widget child) {
    buildModalBottomSheet(context: context, child: child);
  }

  static void purchaseOrderInfoInputPage(
      BuildContext context, CreateOrderInputModel orderInfoData) {
    buildModalBottomSheet(
        context: context,
        child: PurchaseOrderInfoInputPage(orderInfoData: orderInfoData));
  }

  static void paymentPage(BuildContext context, CreateOrderPrepareModel model) {
    buildModalBottomSheet(context: context, child: PaymentPage(model: model));
  }

  static void eachListPage(BuildContext context, CreateOrderPrepareModel model,
      List<OrderInfoFieldListModel> each, List<OrderInfoFieldModel> fields) {
    push(context, EachListPage(model: model, each: each, fields: fields));
  }

  static Future<CouponApplyModel> selectCouponPage(
    BuildContext context,
    List<CouponApplyModel> coupons,
    OrderInfoProductModel product,
  ) {
    return Navigator.push<CouponApplyModel>(
      context,
      MaterialPageRoute<CouponApplyModel>(
          builder: (context) => SelectCouponPage(
                coupons: coupons,
                product: product,
              )),
    ).then((data) {
      return data;
    });
  }

  static void paymentSuccessPage(
      BuildContext context, String orderCode, int payAmount) {
    replace(context,
        PaymentSuccessPage(orderCode: orderCode, payAmount: payAmount));
  }

  // 메인 피드 페이지 로드
  static void mainPage(BuildContext context) {
    push(context, const NavigatePage(event: NavbarEvent.Main));
  }

  // 메인 서치 페이지
  static void searchPage(BuildContext context) {
    makeFirst(context, const NavigatePage(event: NavbarEvent.Search));
  }

  //action link
  static void promotionListPage(
      BuildContext context, FeedPromotionModel model) {
    push(
        context,
        PromotionListPage(
          model: model,
        ));
  }

  static void noticeEventDetailPage(BuildContext context, String id) {
    push(context, NoticeEventDetailPage(id: id));
  }

  //discovery

  static void discoverySearchPage(
    BuildContext context, {
    SearchBodyState searchBodyState = SearchBodyState.Suggestion,
    String keyword = '',
  }) {
    fade(
        context,
        DiscoverySearchPage(
          searchBodyState: searchBodyState,
          keyword: keyword,
        ));
  }

  static void discoveryListPage(
      {BuildContext context,
      String typeName,
      SearchFilterModel searchFilterModel,
      String appTitle}) {
    push(
        context,
        DiscoveryListPage(
          typeName: typeName,
          appTitle: appTitle,
          searchFilterModel: searchFilterModel,
        ));
  }

  //reservation
  static void reservationDetailPage(
      BuildContext context, String orderCode, int orderInfoIndex) {
    buildModalBottomSheet(
        context: context,
        child: ReservationDetailPage(
          orderCode: orderCode,
          orderInfoIndex: orderInfoIndex,
        ));
  }

  static void reservationVoucherPage(
      BuildContext context, int index, CreateOrderInputModel orderInfo) {
    buildModalBottomSheet(
        context: context,
        child: ReservationVoucherPage(
          orderInfo: orderInfo,
          index: index,
        ));
  }

  static void reservationBarcodePage(
      BuildContext context,
      OrderListViewModel order,
      OrderInfoProductModel product,
      CreateOrderInputModel orderInfo,
      int index) {
    buildModalBottomSheet(
        context: context,
        child: ReservationBarcodePage(
            order: order,
            orderInfo: orderInfo,
            orderProduct: product,
            index: index));
  }

  static void reservationRefundDetailPage(
    BuildContext context,
    OrderInfoProductModel product,
  ) {
    buildModalBottomSheet(
        context: context,
        child: ReservationRefundDetailPage(
          product: product,
        ));
  }

  //MyPage
  static void noticeListPage(BuildContext context) {
    push(context, const NoticeListPage());
  }

  static void faqPage(BuildContext context) {
    push(context, FaqPage());
  }

  static void inquiryListPage(BuildContext context) {
    push(context, InquiryListPage());
  }

  static void inquiryCreatePage(BuildContext context) {
    push(context, InquiryCreatePage());
  }

  static void cartListPage(BuildContext context) {
    push(context, CartListPage());
  }

  static void myOrderPage(BuildContext context) {
    push(context, MyOrderPage());
  }

  static void myOrderDetailPage(BuildContext context, String orderCode) {
    push(context, MyOrderDetailPage(orderCode: orderCode));
  }

  static void notiMyOrderDetailPage(BuildContext context, String orderCode) {
    noAniPush(context, MyOrderDetailPage(orderCode: orderCode));
  }

  static void myStylePage(BuildContext context) {
    push(context, MyStylePage());
  }

  static void myStyleSelectPage(BuildContext context, bool isSkippable) {
    push(context, MyPageStyleSelectPage(isSkippable: isSkippable));
  }

  static void mySettingPage(
    BuildContext context,
  ) {
    push(context, MySettingPage());
  }

  static void myOrderDetailUserPage(BuildContext context,
      CreateOrderInputModel orderInfo, String orderCode, int index) {
    buildModalBottomSheet(
        context: context,
        child: MyOrderDetailUserPage(
          orderInfo: orderInfo,
          orderCode: orderCode,
          index: index,
        ));
  }

  static void createRefundPage(
      BuildContext context, String orderCode, OrderInfoOptionsModel option) {
    push(
        context,
        CreateRefundPage(
          orderCode: orderCode,
          option: option,
        ));
  }

  static void jumpOrderPage(BuildContext context) {
    firstMyPage(context);
    push(context, MyOrderPage());
  }

  // 로그인 회원가입
  static void memberMainPage(
    BuildContext context,
  ) {
    push(context, MemberMainPage());
  }

  static void replaceMemberMainPage(
    BuildContext context,
  ) {
    replace(context, MemberMainPage());
  }

  static void loginPage(BuildContext context) {
    push(context, EmailLoginPage());
  }

  static void signUpPage(BuildContext context) {
    push(context, SignUpPage());
  }

  static void emailAuthPage(
      BuildContext context, String email, String processType) {
    push(
        context,
        EmailAuthPage(
          email: email,
          processType: processType,
        ));
  }

  static void termsAuthPage(
      BuildContext context, ServicePolicyInfoModel servicePolicies) {
    push(context, SignUpTermPage(servicePolicies: servicePolicies));
  }

  static void memberPhonePage(BuildContext context) {
    push(context, MemberPhonePage());
  }

  static void companyCodePage(BuildContext context) {
    push(context, CompanyCodePage());
  }

  static void signUpCompletePage(BuildContext context) {
    push(context, SingUpCompletePage());
  }

  static void tempPasswordRequestPage(BuildContext context) {
    push(context, TempPasswordRequestPage());
  }

  static void tempPasswordCompletePage(BuildContext context, String mail) {
    push(context, TempPasswordCompletePage(mail));
  }

  //MY PAGE
  static void myCouponPage(BuildContext context, CouponModel couponInfo) {
    push(context, MyCouponPage(couponInfo: couponInfo));
  }

  static void applyCouponPage(BuildContext context) {
    push(context, ApplyCouponPage());
  }

  static void developerOptionPage(BuildContext context) {
    push(context, DeveloperPage());
  }

  static void push(BuildContext context, Widget page) {
    final pageName = page.toString();
    switch (pageName) {
      case 'ProductDetailPage':
        authCheck(context).then((isLogin) {
          if (isLogin) {
            Navigator.of(context).push<Route<dynamic>>(
              Right2LeftRouter<Route<dynamic>>(child: page),
            );
          } else {
            return memberMainPage(context);
          }
        }).catchError((dynamic err) => print('Error getting authCheck $err'));
        break;
      default:
        Navigator.of(context).push<Route<dynamic>>(
          Right2LeftRouter<Route<dynamic>>(child: page),
        );
    }
  }

  static void fade(BuildContext context, Widget page) {
    final pageName = page.toString();
    switch (pageName) {
      case 'ProductDetailPage':
        authCheck(context).then((isLogin) {
          if (isLogin) {
            Navigator.of(context).push<Route<dynamic>>(
              Right2LeftRouter<Route<dynamic>>(child: page),
            );
          } else {
            return memberMainPage(context);
          }
        }).catchError((dynamic err) => print('Error getting authCheck $err'));
        break;
      default:
        Navigator.of(context).push<Route<dynamic>>(
          FadeRouter<Route<dynamic>>(child: page),
        );
    }
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement<Route<dynamic>, Route<dynamic>>(
      Right2LeftRouter<Route<dynamic>>(child: page),
    );
  }

  static void noAniPush(BuildContext context, Widget page) {
    Navigator.of(context).push<Route<dynamic>>(
      NoAnimRouter<Route<dynamic>>(page),
    );
  }

  static void makeFirst(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) {
      print(predicate);
      print(predicate.isFirst);
      assert(predicate != null);
      return predicate.isFirst;
    });
    Navigator.of(context).pushReplacement<dynamic, dynamic>(
      Right2LeftRouter<dynamic>(child: page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void dismissAlert(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popUntil(BuildContext context, int number) {
    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == number;
    });
  }
}
