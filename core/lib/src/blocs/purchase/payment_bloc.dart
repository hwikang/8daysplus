import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../providers/purchase/create_order_provider.dart';
import '../../providers/purchase/payment_page_provider.dart';

enum PaymentState { Normal, Loading } //결제버튼

class PaymentBloc {
  PaymentBloc() {
    servicePolicyState.add(false);
    pointErrorState.add(true);
    fetch();
    paymentState.add(PaymentState.Normal);
  }

  BehaviorSubject<List<CreditCardModel>> cardCodes =
      BehaviorSubject<List<CreditCardModel>>();

  List<String> cartIds = <String>[]; //카트 아이디 (구매이후 삭제용)
  //create order
  CreateOrderProvider createOrderProvider = CreateOrderProvider();

  BehaviorSubject<List<PaymentMethodModel>> paymentMethods =
      BehaviorSubject<List<PaymentMethodModel>>();

  BehaviorSubject<PaymentModel> paymentModel = BehaviorSubject<PaymentModel>();
  PaymentPageProvider paymentPageProvider = PaymentPageProvider();
  BehaviorSubject<PaymentState> paymentState = BehaviorSubject<PaymentState>();
  BehaviorSubject<bool> pointErrorState =
      BehaviorSubject<bool>(); //포인트 입력에러 여부,

  BehaviorSubject<Map<String, dynamic>> repo = BehaviorSubject<
      Map<String, dynamic>>(); //약관(servicePolicyInfo), lifePoint

  BehaviorSubject<bool> servicePolicyState = BehaviorSubject<bool>(); //약관동의 여부,
  BehaviorSubject<List<AppliedCouponModel>> usedCoupons =
      BehaviorSubject<List<AppliedCouponModel>>(); //사용된 쿠폰 리스트

  BehaviorSubject<int> usedLifePoint = BehaviorSubject<int>(); //사용된 라이프 포인트

  //최종 결제 금액
  final PaymentModel _payModel = PaymentModel();

  String _selectedCardHolderType;
  final List<AppliedCouponModel> _usedCouponList = <AppliedCouponModel>[];

  Stream<bool> get servicePolicyStateObserver => servicePolicyState.stream;

  Stream<bool> get pointErrorStateObserver => pointErrorState.stream;

  Stream<bool> readyToSubmit() => CombineLatestStream.combine2(
          servicePolicyStateObserver, pointErrorStateObserver,
          (servicePolicy, pointError) {
        return pointError && servicePolicy;
      });

  // int _totalPrice = 0; //주문 합계
  void addTotalPrice(int price) {
    print('add $price');
    _payModel.totalPrice += price;
    paymentModel.add(_payModel);
    print('_total ${_payModel.totalPrice}');
  }

  void clearTotalPrice() {
    _payModel.totalPrice = 0;
    paymentModel.add(_payModel);
    print('_total ${_payModel.totalPrice}');
  }

  //point
  void addLifePoint(int point) {
    usedLifePoint.add(point);
    _payModel.usedLifePoint = point;
    paymentModel.add(_payModel);
  }

  //쿠폰적용
  void addCoupon(CouponApplyModel coupon, String orderItemCode,
      int discountAmount, String reserveDate) {
    final usedCoupon = AppliedCouponModel(
        couponId: coupon.id,
        orderItemCode: orderItemCode,
        discountPrice: discountAmount,
        reserveDate: reserveDate);
    _usedCouponList.add(usedCoupon);
    usedCoupons.add(_usedCouponList);
    _payModel.usedCouponPrice += discountAmount;
    _payModel.usedCoupons = _usedCouponList;
    //만약 포인트도사용되서 할인이 주문합계 넘어갈경우
    if (_payModel.usedCouponPrice + _payModel.usedLifePoint >
        _payModel.totalPrice) {
      //포인트 사용 반감
      _payModel.usedLifePoint =
          (_payModel.totalPrice - _payModel.usedCouponPrice) ~/ 10 * 10;
    }
    // print('coupon@@');
    // print(_payModel.usedCouponPrice);
    // print(_payModel.usedLifePoint);
    // print(_payModel.totalPrice);
    // print(_payModel.getPayAmount());
    // _payModel.usedLifePoint
    paymentModel.add(_payModel);

    print(paymentModel.value);
  }

  //쿠폰취소
  void removeCoupon(AppliedCouponModel removeCoupon) {
    _usedCouponList.remove(removeCoupon);
    usedCoupons.add(_usedCouponList);
    _payModel.usedCoupons = _usedCouponList;
    _payModel.usedCouponPrice -= removeCoupon.discountPrice;

    paymentModel.add(_payModel);
  }

  //결제타입선택
  void changePaymentType(String paymentType) {
    //카드 코드 초기화
    _payModel.cardCode = 0;
    paymentModel.add(_payModel);
    //
    _payModel.paymentType = paymentType;
    paymentModel.add(_payModel);
    print('changePaymentType $paymentType');
  }

  void changeCardCode(String cardName) {
    final selectedModel = cardCodes.value.where((card) {
      return card.name == cardName;
    }).toList();
    _payModel.cardCode = selectedModel[0].cardCode;
    paymentModel.add(_payModel);
  }

  //개인,법인카드
  void changeCardHolderType(String cardHolderType) {
    _selectedCardHolderType = cardHolderType;
    _payModel.cardHolderType = _selectedCardHolderType;
    paymentModel.add(_payModel);
  }

  //약관동의
  void changeServicePolicyState(bool state) {
    servicePolicyState.add(state);
  }

  //페이지에 필요한정보
  void fetch() {
    paymentPageConnection().then((data) {
      repo.add(data);
      cardCodes.add(data['cardCodes']);
      paymentMethods.add(data['paymentMethods']);
    }).catchError(repo.addError);
  }

  Future<Map<String, dynamic>> paymentPageConnection() {
    return paymentPageProvider
        .paymentPage()
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  Future<String> createOrder(String orderId) {
    paymentState.add(PaymentState.Loading);

    return createOrderProvider
        .createOrder(orderId, paymentModel.value)
        .then((url) {
          return url;
        })
        .catchError((exception) => {ExceptionHandler.handleError(exception)})
        .whenComplete(() => paymentState.add(PaymentState.Normal));
  }
}
