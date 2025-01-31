import 'dart:ui';
import 'package:shreeveg/data/model/response/language_model.dart';
import 'package:shreeveg/helper/app_mode.dart';
import 'images.dart';

class AppConstants {
  static const String appName = 'Shree Veg';
  static const double appVersion = 7.0;
  static const AppMode appMode = AppMode.release;
  static const String baseUrl =
      // 'http://192.168.29.160/shreeveg';
      // 'http://192.168.29.51/shreeveg';
      // 'http://192.168.29.160/2024/Admin-shreeveg';
  // "http://192.168.1.110/sheeveg/admin";
      'https://shreeveg.dqot.solutions';
  //http://shreevegcrm.dqotsolutions.com
  // 'https://dashboard.indianayurveda.shop';
  // 'https://indianayurveda.shop';
  // 'http://192.168.29.94/Ecommerce';
  // https://grofresh-admin.6amtech.com
  // https://indianayurveda.shop
  // cardColor: const Color(0xFFF1F0F0),

  static const Color primaryColor = Color(0xFF0B4619);
  static const Color textFormFieldColor = Color(0xFFF1F0F0);
  static const String configUri = '/api/v1/config';
  static const String bannerUri = '/api/v1/banners';
  static const String citiesList = '/api/v1/warehouseLocation';
  static const String groupsUri = '/api/v1/products/group';
  static const String categoryUri = '/api/v1/categories';
  static const String subCategoryUri = '/api/v1/categories/childes/';
  static const String categoryProductUri = '/api/v1/categories/products/';
  static const String popularProductURI = '/api/v1/products/popular';
  static const String latestProductURI = '/api/v1/products/latest';
  static const String dailyItemUri = '/api/v1/products/daily-needs';
  static const String searchProductUri = '/api/v1/products/details/';
  static const String searchUri = '/api/v1/products/search?name=';
  static const String messageUri = '/api/v1/customer/message/get';
  static const String notificationUri = '/api/v1/notifications';
  static const String registerUri = '/api/v1/auth/register';
  static const String registerUriNew = '/api/v1/auth/register_new';
  static const String logoutUriNew = '/api/v1/auth/logout_new';
  static const String loginOtpUri = '/api/v1/auth/login-otp';
  static const String loginOtpSendNew = '/api/v1/auth/login_new';
  static const String loginOtpUriNew = '/api/v1/auth/verifyOtp';
  static const String loginUri = '/api/v1/auth/login';
  static const String forgetPasswordUri = '/api/v1/auth/forgot-password';
  static const String resetPasswordUri = '/api/v1/auth/reset-password';
  static const String checkPhoneUri = '/api/v1/auth/check-phone?phone=';
  static const String verifyPhoneUri = '/api/v1/auth/verify-phone';
  static const String checkEmailUri = '/api/v1/auth/check-email';
  static const String verifyEmailUri = '/api/v1/auth/verify-email';
  static const String verifyTokenUri = '/api/v1/auth/verify-token';
  static const String productDetailsUri = '/api/v1/products/details/';
  static const String activeReviewUri = '/api/v1/products/reviews/';
  static const String allActiveReviewUri = '/api/v1/products/all-reviews';
  static const String submitReviewUri = '/api/v1/products/reviews/submit';
  static const String couponUri = '/api/v1/coupon/list';
  static const String couponApplyUri = '/api/v1/coupon/apply?code=';
  static const String customerInfoUri = '/api/v1/customer/info';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String addressListUri = '/api/v1/customer/address/list';
  static const String removeAddressUri =
      '/api/v1/customer/address/delete?address_id=';
  static const String addAddressUri = '/api/v1/customer/address/add';
  static const String updateAddressUri = '/api/v1/customer/address/update/';
  static const String orderListUri = '/api/v1/customer/order/list';
  static const String orderCancelUri = '/api/v1/customer/order/cancel';
  static const String orderDetailsUri =
      '/api/v1/customer/order/details?order_id=';
  static const String trackUri = '/api/v1/customer/order/track?order_id=';
  static const String placeOrderUri = '/api/v1/customer/order/place';
  static const String lastLocationUri =
      '/api/v1/delivery-man/last-location?order_id=';
  static const String timeslotUri = '/api/v1/timeSlot';
  static const String tokenUri = '/api/v1/customer/cm-firebase-token';
  static const String updatePaymentMethodUri =
      '/api/v1/customer/order/payment-method';
  static const String reviewUri = '/api/v1/products/reviews/submit';
  static const String deliveryManReviewUri =
      '/api/v1/delivery-man/reviews/submit';
  static const String distanceMatrixUri = '/api/v1/mapapi/distance-api';
  static const String searchLocationUri =
      '/api/v1/mapapi/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/mapapi/place-api-details';
  static const String geocodeUri = '/api/v1/mapapi/geocode-api';
  static const String emailSubscribeUri = '/api/v1/subscribe-newsletter';
  static const String customerRemove = '/api/v1/customer/remove-account';
  static const String walletTopup = '/api/v1/customer/wallet-add-money';
  static const String walletTransactionUrl =
      '/api/v1/customer/wallet-transactions';
  static const String loyaltyTransactionUrl =
      '/api/v1/customer/loyalty-point-transactions';
  static const String loyaltyPointTransferUrl =
      '/api/v1/customer/transfer-point-to-wallet';
  static const String flashDealUri = '/api/v1/flash-deals';
  static const String flashDealProductUri = '/api/v1/flash-deals/products/';
  static const String guestLoginUri = '/api/v1/auth/login-guest-user';
  static const String featuredProduct = '/api/v1/products/featured';
  static const String mostReviewedProduct = '/api/v1/products/most-reviewed';
  static const String trendingProduct = '/api/v1/products/trending';
  static const String recommendProduct = '/api/v1/products/recommended';

  //MESSAGING
  static const String getDeliveryManMessageUri =
      '/api/v1/customer/message/get-order-message';
  static const String getAdminMessageUrl =
      '/api/v1/customer/message/get-admin-message';
  static const String sendMessageToAdminUrl =
      '/api/v1/customer/message/send-admin-message';
  static const String sendMessageToDeliveryManUrl =
      '/api/v1/customer/message/send/customer';
  // static const String wishListGetUri = '/api/v1/products/favorite';
  static const String wishListGetUri = '/api/v1/customer/wish-list';
  static const String wishListAddUri = '/api/v1/customer/wish-list/add';
  static const String wishListRemoveUri = '/api/v1/customer/wish-list/remove';
  static const String socialLogin = '/api/v1/auth/social-customer-login';

  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String selectedCityId = 'warehouseCityId';
  static const String selectedCityName = 'warehouseName';
  static const String emailOrPhone = 'email_or_phone';
  static const String otp = 'otp';
  static const String verificationId = 'verificationId';
  static const String signupModel = 'signupmodel';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userAddress = 'user_address';

  static const String searchAddress = 'search_address';
  static const String topic = 'grofresh';
  static const String onBoardingSkip = 'on_boarding_skip';
  static const String placeOrderData = 'place_order_data';
  static const String cookingManagement = 'cookies_management';
  static const String userLogData = 'user_log_data';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.englandFlag,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.arabicFlag,
        languageName: 'العربية',
        countryCode: 'SA',
        languageCode: 'ar'),
  ];
}
