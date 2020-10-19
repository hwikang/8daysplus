//(second page name)_name

class CommonTexts {
  static const String confirmButton = '확인';
  static const String viewMoreButton = '전체 보기 >';
  static const String more = '더보기';
  static const String noTitle = '제목없음';
  static const String yes = '네';
  static const String no = '아니오';
  static const String cancel = '취소';
  static const String next = '다음';
  static const String fail = '실패';
  static const String success = '성공';
  static const String refresh = '새로고침';
  static const String inform = '알림';
}

class ValidatorTexts {
  //validator
  static const String enterEmail = "이메일을 입력하여 주시기 바랍니다";
  static const String enterValidEmail = '올바른 형식의 이메일을 입력해주세요';
  static const String noOneTimeEmail = "일회용 이메일로는 가입을 할 수 없습니다.";
  static const String enterMobile = "번호를 입력하여 주시기 바랍니다";
  static const String enterValidMobile = "올바른 형식의 번호를 입력해주세요";
  static const String enterPassword = "비밀번호를 입력하여 주시기 바랍니다";
  static const String samePasswordError = "이전과 동일한 비밀번호는 생성이 불가합니다.";
  static const String differentPasswordError = "입력하신 비밀번호와 다릅니다.";
  static const String passwordGuide = "비밀번호는 8~15자리의 영문,숫자 조합으로 생성 가능합니다.";
  static const String empty = '입력해주세요';
}

class UserPropertyStrings {
  static const String appVersion = 'appversion';
  static const String birthDay = 'birthday';
  static const String companyCode = 'companycode';
  static const String email = 'email';
  static const String marketingAgree = 'marketingagree';
  static const String signUpType = 'signuptype';
  static const String uuid = 'uuid';
}

class MainPageStrings {
  static const String gtentionPoweredBy = '(주) 지텐션 Powered by ';
  static const String companyAdress =
      '서울시 서초구 강남대로 311\n이메일 :8daysplus@hanwha.com\n고객센터: 02-6248-8000';

  static const String companyCopyright =
      'Copyright ©GTENTION Co., Ltd. All rights reserved.';

  static const String companyInfos =
      '대표이사 : 안문호 \n사업자등록번호 : 734-88-00135 \n통신판매업신고 : 제2018-서울서초-2214호 \n보험등록번호 :  제7720010002호';

  static const String companyNotice =
      '(주)지텐션은 통신판매중계자로서 통신판매의 당사자가 아니며, 상품의 예약, 이용 및 환불 등과 관련한 의무와 책임은 각 판매자에게 있습니다.';

  static const String forceUpdateTitle =
      '새로운 중요 기능과 오류가 수정 된 새로운 버전이 출시 되었습니다. 지금 새로운 버전으로 업데이트 해주세요!';
  static const String updateTitle =
      '새로운 기능과 오류가 수정 된 새로운 버전이 출시 되었습니다. 업데이트 하시겠습니까?';
  static const String updateTrue = '업데이트 하기';
  static const String updateFalse = '다음에 하기';

  static const String period = '기간';

  static const String place = '장소';
}

class AlarmPageStrins {
  static const String alarm = '알람';
  static const String emptyAlarm = '존재하는 알림이 없습니다.';
  static const String completeCoupon = '쿠폰 지급';
  static const String expiredCoupon = '쿠폰 소멸';
  static const String replyInquiry = '1:1 문의 답변';
  static const String expiredPoint = '포인트 소멸';
  static const String cancelReserve = '예약 실패';
  static const String completeRefund = '환불 완료';
  static const String requestRefund = '환불 요청중';
  static const String pendingRefund = '환불 대기중';
  static const String pendingReserve = '예약 진행중';
  static const String completeReserve = '예약 완료';
  static const String completePayment = '결제 완료';
}

class DiscoveryPageStrings {
  static const String money = '가격';
  static const String filter = '필터';
  static const String sortFilter = '정렬';
  static const String moneyFilter = '금액';

  static const String filterLocation = '전체지역';
  static const String filterType = '전체유형';
  static const String reset = '초기화';
  static const String search_noResult = '검색 결과가 없습니다.';
  static const String search_all = '전체';

  static const String product = '상품';
  static const String discount = '할인';
}

class MemberPageStrings {
  // member main
  static const String mainSubTitle = "8DAYS+와함께\n나만의 워라밸을 시작하세요!";
  static const String loginButtonString = "이메일로 시작하기";
  static const String withoutLogin = "로그인 하지 않고 둘러보기 >";
  static const String messageSignup = "8데이즈+ 회원이 아니신가요? 회원가입 >";
  static const String kakaoLogin = "카카오로 시작하기";
  static const String googleLogin = "구글로 시작하기";
  static const String appleLogin = "Sign in with Apple";
  static const String id = '이메일 아이디';

  // email login
  static const String login_title = "로그인";
  static const String login_intro = "아이디와 비밀번호를 입력해주세요";
  static const String login_findIdGuide = '이메일 아이디를 잊으셨나요? >';
  static const String login_findPasswordGuide = "비밀번호를 잊으셨나요? >";
  static const String login_idHint = '이메일 주소 입력';
  static const String login_passwordHint = '비밀번호 입력';

  //email sign up
  static const String signUp_title = '회원가입';
  static const String signUp_intro = '아이디로 사용할 이메일을\n입력해주세요 .';
  static const String signUp_idHint = "이메일 주소 입력";
  static const String signUp_password = "비밀번호";
  static const String signUp_passwordHint = '8~15자리의 영문,숫자 조합';
  static const String signUp_companyCode = '기업코드';
  static const String signUp_companyCodeHint = '기업코드 입력';
  static const String signUp_name = '이름';
  static const String signUp_nameHint = '실명 입력(예시:홍길동)';

  //company code input
  static const String companyCode_intro = '안내 받을 기업코드를 입력해주세요.';

  // email auth
  static const String emailAuth_button = "계정인증";
  static const String emailAuth_auth = '인증';
  static const String emailAuth_success = "인증에 성공하였습니다.";
  static const String emailAuth_fail = '인증에 실패하였습니다.\n다시 시도해주세요.';
  static const String emailAuth_sendEmailSuccess = '이메일 발송 완료';
  static const String emailAuth_intro = "이메일이 발송되었습니다.";
  static const String emailAuth_guide =
      "이메일 주소로 인증 메일을 보냈습니다.\n인증 메일을 수신함에서 찾을 수 없다면\n스펨 메일함을 확인하세요.";
  static const String emailAuth_retryGuide = '이메일을 찾을 수 없나요?';
  static const String emailAuth_retrySuccess = '인증메일을 확인해주세요.';
  static const String emailAuth_retryFail = '인증메일 발송에 실패했습니다.';
  static const String emailAuth_retry = '인증메일 재발송';

  //terms
  static const String signUpTerm_title = '약관동의';
  static const String signUpTerm_intro =
      "8DAYS+ 서비스의 원활한 이용을 위해\n아래의 약관에 동의해주세요. ";
  static const String signUpTerm_agreeAll = "약관 전체 동의";
  static const String signUpTerm_agreeService = "서비스 이용약관";
  static const String signUpTerm_agreeLocation = "위치기반서비스 이용약관";
  static const String signUpTerm_agreeMarketing = "마케팅 정보 수신 동의";
  static const String signUpTerm_agreePersonalInfo = '개인정보 수집 및 이용 동의';
  static const String signUpTerm_option = "선택";
  static const String signUpTerm_required = "필수";
  static const String signUpTerm_disAgreeTitle = "필수 약관에 동의";
  static const String signUpTerm_disAgreeSubtitle = "약관에 동의해주세요";
  static const String signUpTerm_overFourTeen =
      '만 14세 이상 확인 위치기반 서비스는\n만 14세 이상만 이용 가능';
  static const String signUpTerm_marketingAlertTitle = "마케팅 정보 수신 동의 처리 안내";
  static const String signUpTerm_marketingAlertSender = '전송자: 지텐션';
  static const String signUpTerm_marketingAlertDate = '처리 일시:';
  static const String signUpTerm_marketingAlertState = '처리 내용:';
  static const String signUpTerm_marketingAlertStateAgree = '알림 수신 처리 완료';
  static const String signUpTerm_marketingAlertStateDisagree = '알림 미수신 처리 완료';

  //find email
  static const String findEmail_title = '이메일 아이디 찾기';
  static const String findEmail_fail = '이메일 아이디 찾기에 실패하셨습니다.';
  static const String findEmail_intro = '아이디를 잃어버리셨나요?';
  static const String findEmail_guide =
      '8DAYS에 등록된 휴대폰 번호를 입력하시면,\n가입하신 이메일 아이디를 안내드립니다.';
  static const String findEmail_phoneNumber = '휴대폰 번호';

  // temp password
  static const String tempPasswordRequestIntroSub =
      "8DAYS에 등록된 회사 이메일을 입력하시면,\n임시 비밀번호를 보내드립니다.";
  static const String tempPasswordRequestTitle = "임시비밀번호 발급";
  static const String tempPasswordRequestIntro = "비밀번호를 잃어버리셨나요?";
  static const String tempPasswordSendButton = "임시 비밀번호 발급";
  static const String tempPasswordErrorMessage = "확인할수없는 이메일 정보입니다.";
  static const String tempPasswordGuideMessage =
      "비밀번호 발급안내\n메일 contact@the8days.com\n카카오톡 플러스친구 : 8daysplus";
  static const String tempPasswordCompleteIntro = "임시비밀번호 발급 완료";
  static const String tempPasswordCompleteMessage =
      '으로 임시 비밀번호가 발급되었습니다.\n이메일을 확인해주세요.';

  //auth phone
  static const String authPhone_inputPhoneHint = '- 없이 입력 (예시:01000000000)';
  static const String authPhone_sendAuthCode = '인증번호 발송';
  static const String authPhone_inputAuthCode = '인증번호 입력';
  static const String authPhone_resendAuthCode = '인증번호 재발송';
  static const String authPhone_sendAuthCodeSuccess = '인증번호가 발송되었습니다';
}

class ReservationPageStrings {
  static const String title = '예약내역';
  static const String noProduct = '예약된 8DAYS+ 상품이 없습니다.';
  static const String orderDate = '주문일';
  static const String useDate = '사용예정일';
  static const String expiryDate = '유효기간';
  static const String voucherLoading = '바우처 발급중';
  static const String voucherLoadingGuide =
      '바우처 발급 중입니다.  처리가 완료되면 안내해 드리겠습니다.';
  static const String userInfo = '사용자정보';
  static const String kakao = '카카오 Plus 문의하기';

  static const String voucherSee = '바우처 보기';
  static const String barcodeSee = '바코드 보기';
  static const String barcodeTitle = '바코드 확인';
  static const String barcodeUnused = '미사용';
  static const String barcodeUsed = '사용완료';
  static const String barcodeOrderDate = '주문일';
  static const String barcodeOrderCode = '주문번호';
  static const String barcodeOrderState = '주문상태';
  static const String barcodeProductName = '상품명';
  static const String barcodeExpiryDate = '유효기간';

  static const String pendingPayment = '결제대기';
  static const String completePayment = '결제완료';
  static const String pendingReserve = '예약진행중';
  static const String completeReserve = '예약완료';
  static const String requestRefund = '환불요청';
  static const String pendingRefund = '환불대기';
  static const String completeRefund = '환불완료';
  static const String cancelReserve = '예약실패';
  static const String completeUse = '사용완료';

  static const String refundDetail_title = '환불 안내';
  static const String refundDetail_dateAndReason = '환불 요청일 및 사유';
  static const String refundDetail_date = '환불 요청일';
  static const String refundDetail_reason = '환불 사유';
  static const String refundDetail_product = '환불 상품';
  static const String refundDetail_info = '환불 정보';
  static const String refundDetail_totalPrice = '환불 금액';
  static const String refundDetail_totalDiscountPrice = '환불 할인 합계';
  static const String refundDetail_refundPrice = '총 환불 금액';
  static const String refundDetail_refundNotice =
      '환불 승인 후 결제수단에 따라 3~7일(영업일) 이내에 기존 결제수단으로 환불 됩니다.';
}

class MyPageStrings {
  static const String myAccount = '계정관리 >';
  static const String myStyle = '스타일 분석';
  static const String myStyleGuide = '나만의 레저 스타일을 추천 받고 싶다면?';

  static const String myShoppingInfo = '나의 쇼핑정보';
  static const String myOrderList = '구매내역';
  static const String myInquiryList = '1:1문의 내역';
  static const String myCustomerCenter = '고객센터';
  static const String myNoticeList = '공지사항';
  static const String myFaq = 'FAQ';
  static const String myCustomerCenterGuide =
      '서비스 이용에 불편이 있으신가요?\n8DAYS+ 고객센터로 연락주세요.';
  static const String myCoupon = '나의 쿠폰';
  static const String myPoint = '나의 포인트';

  static const String common_btn_withdraw = '회원탈퇴';
  static const String withdraw_contents_check =
      '위 내용을 확인했고, 계정 및 서비스 이용기록을 삭제하는 것에 동의합니다.';

  static const String withdraw_contents_holdingcoupon = '현재 보유 쿠폰';
  static const String withdraw_contents_holdingpoint = '현재 보유 포인트';
  static const String withdraw_screentitle_withdraw = '회원탈퇴';
  static const String withdraw_title_wantleave =
      '그 동안 8DAYS+ 서비스를 이용해주신 고객님께 감사드립니다.\n\n계정을 삭제하면, 8DAYS+ 서비스 사용 내역이 모두 삭제되고 복원할 수 없습니다.';

  static const String order_empty = '구매하신 상품이 없네요.';
  static const String order_recommendMyStyle = '추천 받고 싶은 나만의 스타일은?';

  static const String orderDetail_payAmountText = '총 결제금액';
  static const String orderDetail_totalPriceText = '주문 합계';
  static const String orderDetail_totalDiscountText = '할인 합계';
  static const String orderDetail_couponNonRefundable = '쿠폰환불 불가';
  static const String orderDetail_8daysPoint = '8DAYS+ 포인트';
  static const String orderDetail_coupon = '쿠폰';
}

class StylePageStrings {
  static const String styleViewPageAppbar = '스타일 분석';
  static const String styleViewSelectLabel = '내 스타일 Pick 하러 가기 >';
}

class ProductDetailPageStrings {
  static const String ecouponProductHowToUse = '이용 정보';
  static const String ecouponProductNotice = '공지 정보';
  static const String experienceProductDetail = '상품 스토리';
  static const String experienceProductExclusion = '불포함 사항';
  static const String experienceProductFaq = '자주 묻는 질문';
  static const String experienceProductHowToUse = '이렇게 진행해요!';
  static const String experienceProductInclusion = '제공 항목';
  static const String experienceProductLocation = '여기에 있어요!';
  static const String experienceProductNotice = '유의 사항';
  static const String experienceProductRefund = '환불 정책';
  // static const String classProductAuthor = '클래스소개';
  // static const String classProductHowToUse = '커리큘럼';
  // static const String classProductInclusion = '기타 제공사항';
  // static const String classProductNotice = '추가 제공사항 및 유의사항';
  // static const String classProductRefund = '변경 및 취소';
  static const String galleryImages = '작품갤러리';

  static const String highlight = '매력 포인트';
  static const String keyInfo = '체크 포인트';
}

class PaymentPageStrings {
  static const String corporateCardNotReady = '법인카드 결제 서비스는 준비중입니다.';
  static const String elecTerms = '결제대행서비스 이용약관';
  static const String finalPayAmount = '최종결제 금액';
  static const String thirdTerms = '개인정보 제3자 이용약관';
}

class AuthorityPageStrings {
  static const String authorityTitle = '앱 접근 권한 안내';
  static const String authoritySubTitle =
      '8DAYS+ 서비스 사용을 위해\n다음 권한의 허용이 필요합니다.';
  static const String location = '위치';
  static const String locationDescription = '주변의 액티비티, 강좌 검색 및 추천 시 사용';
  static const String storage = '저장공간(선택)';
  static const String storageDescription =
      '바우처를 스마트폰에 쉽게 다운로드하여\n언제 어디서나 간편하게 사용';
  static const String phone = '전화(선택)';
  static const String phoneDescription = '고객센터 연결 등을 위한 통화 기능';
}

class NavigagePageStrings {
  static const String navAppCloseTitle = '앱종료안내';
  static const String navAppCloseSubTitle = '앱을 종료 하시겠습니까?';
}

class ErrorTexts {
  static const String error = '에러';

  static const String optionNotExists = '상품의 옵션이 존재하지 않습니다.';
  static const String companyCodeNotExists =
      '일치하는 기업코드가 없습니다. 다시 확인 후 입력 바랍니다.';
  static const String emailExists = '이미 사용중인 이메일 주소 입니다.';
  static const String failSendSms = '문자 인증에 실패하였습니다.\n다시 시도해주세요.';
  static const String networkError =
      '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.';
  static const String needLogin = '로그인이 필요합니다.';
}
