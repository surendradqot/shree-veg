import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/body/place_order_body.dart';
import 'package:shreeveg/data/model/new_flash_modal.dart';
import 'package:shreeveg/data/model/response/address_model.dart';
import 'package:shreeveg/data/model/response/category_model.dart';
import 'package:shreeveg/data/model/response/order_model.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/data/model/response/userinfo_model.dart';
import 'package:shreeveg/helper/html_type.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/view/screens/address/add_new_address_screen.dart';
import 'package:shreeveg/view/screens/address/address_screen.dart';
import 'package:shreeveg/view/screens/address/select_location_screen.dart';
import 'package:shreeveg/view/screens/address/set_address_screen.dart';
import 'package:shreeveg/view/screens/auth/create_account_screen.dart';
import 'package:shreeveg/view/screens/auth/login_screen.dart';
import 'package:shreeveg/view/screens/auth/maintainance_screen.dart';
import 'package:shreeveg/view/screens/auth/otp_screen.dart';
import 'package:shreeveg/view/screens/auth/signup_screen.dart';
import 'package:shreeveg/view/screens/cart/cart_screen.dart';
import 'package:shreeveg/view/screens/category/all_category_screen.dart';
import 'package:shreeveg/view/screens/chat/chat_screen.dart';
import 'package:shreeveg/view/screens/checkout/checkout_screen.dart';
import 'package:shreeveg/view/screens/checkout/order_successful_screen.dart';
import 'package:shreeveg/view/screens/checkout/payment_screen.dart';
import 'package:shreeveg/view/screens/checkout/razorpay_payment_screen.dart';
import 'package:shreeveg/view/screens/checkout/widget/order_web_payment.dart';
import 'package:shreeveg/view/screens/contact/contact_screen.dart';
import 'package:shreeveg/view/screens/coupon/coupon_screen.dart';
import 'package:shreeveg/view/screens/filters/filters_screen.dart';
import 'package:shreeveg/view/screens/forgot_password/create_new_password_screen.dart';
import 'package:shreeveg/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:shreeveg/view/screens/forgot_password/verification_screen.dart';
import 'package:shreeveg/view/screens/html/html_viewer_screen.dart';
import 'package:shreeveg/view/screens/menu/menu_screen.dart';
import 'package:shreeveg/view/screens/notification/notification_screen.dart';
import 'package:shreeveg/view/screens/onboarding/on_boarding_screen.dart';
import 'package:shreeveg/view/screens/order/my_order_screen.dart';
import 'package:shreeveg/view/screens/order/order_details_screen.dart';
import 'package:shreeveg/view/screens/order/track_order_screen.dart';
import 'package:shreeveg/view/screens/product/add_review_screen.dart';
import 'package:shreeveg/view/screens/product/category_product_screen_new.dart';
import 'package:shreeveg/view/screens/product/image_zoom_screen.dart';
import 'package:shreeveg/view/screens/product/product_description_screen.dart';
import 'package:shreeveg/view/screens/product/product_details_screen.dart';
import 'package:shreeveg/view/screens/profile/profile_edit_screen.dart';
import 'package:shreeveg/view/screens/profile/profile_screen.dart';
import 'package:shreeveg/view/screens/refer_and_earn/refer_and_earn_screen.dart';
import 'package:shreeveg/view/screens/search/search_result_screen.dart';
import 'package:shreeveg/view/screens/search/search_screen.dart';
import 'package:shreeveg/view/screens/settings/setting_screen.dart';
import 'package:shreeveg/view/screens/splash/splash_screen.dart';
import 'package:shreeveg/view/screens/update/update_screen.dart';
import 'package:shreeveg/view/screens/wallet/wallet_screen.dart';
import 'package:shreeveg/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import '../view/screens/home/home_items_screen/home_item_screen.dart';
import '../view/screens/menu/main_screen.dart';
import '../view/screens/order/cancel_order_screen.dart';
import '../view/screens/wallet/widget/wallet_transactions.dart';

class RouteHelper {
  static final FluroRouter router = FluroRouter();

  static String splash = '/splash';
  static String orderDetails = '/order-details';
  static String onBoarding = '/on-boarding';
  static String main = '/';
  static String login = '/login';
  static String otp = '/otp';
  static String favorite = '/favorite';
  static String forgetPassword = '/forget-password';
  static String signUp = '/sign-up';
  static String verification = '/verification';
  static String createAccount = '/create-account';
  static String resetPassword = '/reset-password';
  static String updateAddress = '/update-address';
  static String selectLocation = '/select-location/';
  static String setAddress = '/set-address/';
  static String orderSuccessful = '/order-successful';
  static String payment = '/payment';
  static String razorpayPayment = '/razorpay-payment';
  static String checkout = '/checkout';
  static String notification = '/notification';
  static String trackOrder = '/track-order';
  static String categoryProductsNew = '/category-products-new';
  static String productDescription = '/product-description';
  static String productDetails = '/product-details';
  static String filter = '/filters';
  static String submitReview = '/submit-review';
  static String productImages = '/product-images';
  static String profile = '/profile';
  static String searchProduct = '/search-product';
  static String profileEdit = '/profile-edit';
  static String searchResult = '/search-result';
  static String cart = '/cart';
  static String categories = '/categories';
  static String profileMenus = '/menus';
  static String myOrder = '/my-order';
  static String cancelOrder = '/cancel-order';
  static String address = '/address';
  static String coupon = '/coupon';
  static const String chatScreen = '/chat-screen';
  static String settings = '/settings';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String faqScreen = '/faqScreen';
  static const String homeItem = '/home-item';
  static const String maintenance = '/maintenance';
  static const String contactScreen = '/contact';
  static const String update = '/update';
  static const String addAddressScreen = '/add-address';
  static const String orderWebPayment = '/order-web-payment';
  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet-history';
  static const String referAndEarn = '/referAndEarn';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';

  static String getMainRoute() => main;
  static String getLoginRoute() => login;
  static String getTermsRoute() => termsScreen;
  static String getPolicyRoute() => policyScreen;
  static String getAboutUsRoute() => aboutUsScreen;
  static String getfaqRoute() => faqScreen;
  static String getUpdateRoute() => update;
  static String getSelectLocationRoute() => selectLocation;
  static String getSetAddressRoute() => setAddress;

  static String getOrderDetailsRoute(int? id) => '$orderDetails?id=$id';
  static String getVerifyRoute(String page, String email) {
    String data = Uri.encodeComponent(jsonEncode(email));
    return '$verification?page=$page&email=$data';
  }

  static String getNewPassRoute(String? email, String token) =>
      '$resetPassword?email=$email&token=$token';
  //static String getAddAddressRoute(String page) => '$addAddress?page=$page';
  static String getAddAddressRoute(
      String page, String action, AddressModel addressModel) {
    String data =
        base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$addAddressScreen?page=$page&action=$action&address=$data';
  }

  static String getUpdateAddressRoute(
    AddressModel addressModel,
  ) {
    String data =
        base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$updateAddress?address=$data';
  }

  static String getPaymentRoute(
      {required String page,
      String? id,
      int? user,
      String? selectAddress,
      PlaceOrderBody? placeOrderBody}) {
    String address = selectAddress != null
        ? base64Encode(utf8.encode(selectAddress))
        : 'null';
    String data = placeOrderBody != null
        ? base64Url.encode(utf8.encode(jsonEncode(placeOrderBody.toJson())))
        : 'null';
    return '$payment?page=$page&id=$id&user=$user&address=$address&place_order=$data';
  }

  static String getRazorpayPaymentRoute(
      {required String type,
      required String userId,
      required String amount,
      required String phone,
      required String email}) {
    return '$razorpayPayment?type=$type&userId=$userId&amount=$amount&phone=$phone&email=$email';
  }

  static String getCheckoutRoute(double amount, double? discount, String? type,
          String code, String freeDelivery) =>
      '$checkout?amount=$amount&discount=$discount&type=$type&code=${base64Encode(utf8.encode(code))}&c-type=${base64Encode(utf8.encode(freeDelivery))}&delivery';
  static String getOrderTrackingRoute(int? id) => '$trackOrder?id=$id';

  static String getCategoryProductsRouteNew(
      {required CategoryModel categoryModel, String? subCategory}) {
    print('cat model is: ${categoryModel.id}');
    print('sub cat is: $subCategory');

    String data =
        base64Url.encode(utf8.encode(jsonEncode(categoryModel.toJson())));
    if (subCategory != null) {
      subCategory = base64Url.encode(utf8.encode(subCategory));
    }
    return '$categoryProductsNew?category=$data&subcategory=$subCategory';
  }

  static String getProductDescriptionRoute(String description) =>
      '$productDescription?description=$description';

  static String getProductDetailsRoute(
      {required Product product,
      bool formSearch = false,
      String fromParam = ''}) {
    String product1 = Uri.encodeComponent(jsonEncode(product.toJson()));
    String fromSearch = jsonEncode(formSearch);
    return '$productDetails?product=$product1&search=$fromSearch';
  }

  static String getFiltersRoute() => filter;

  static String getProductSubmitReviewRoute({
    required Product product,
    ActiveReview? myReview,
  }) {
    String productJson = jsonEncode(product.toJson());

    String productComponent = Uri.encodeComponent(productJson);

    if (myReview == null) {
      return '$submitReview?product=$productComponent';
    } else {
      String reviewJson = jsonEncode(myReview.toJson());

      String reviewComponent = Uri.encodeComponent(reviewJson);

      return '$submitReview?product=$productComponent&myReview=$reviewComponent';
    }
  }

  static final Handler _submitReviewHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    // Check if 'product' key is present in the params
    if (!params.containsKey('product')) {
      // Handle the case where 'product' key is missing
      // You may want to throw an error, show a message, or navigate back to a previous screen
      return Container(); // Placeholder return, replace it with your error handling logic
    }

    Product product = Product.fromJson(jsonDecode(params['product'][0]));
    ActiveReview? myReview;

    // Check if 'myReview' key is present in the params
    if (params.containsKey('myReview')) {
      myReview = ActiveReview.fromJson(jsonDecode(params['myReview'][0]));
    }

    return _routeHandler(
      child: AddProductReview(product: product, myReview: myReview),
    );
  });

  static String getProductImagesRoute(String? name, String images) =>
      '$productImages?name=$name&images=$images';
  static String getProfileEditRoute(UserInfoModel? userInfoModel) {
    String? data;
    if (userInfoModel != null) {
      data = base64Url.encode(utf8.encode(jsonEncode(userInfoModel.toJson())));
    }
    return '$profileEdit?user=$data';
  }

  static String getHomeItemRoute({NewFlashDealModal? productType}) {
    String itemFlash = base64Encode(utf8.encode(jsonEncode(productType!.toJson())));
    return '$homeItem?item=$itemFlash';
  }

  static String getmaintenanceRoute() => maintenance;
  static String getSearchResultRoute(String text) {
    List<int> encoded = utf8.encode(text);
    String data = base64Encode(encoded);
    return '$searchResult?text=$data';
  }

  static String getChatRoute({OrderModel? orderModel}) {
    String orderModel0 = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$chatScreen?order=$orderModel0';
  }

  static String getContactRoute() => contactScreen;
  static String getFavoriteRoute() => favorite;
  static String getWalletRoute(bool fromWallet) =>
      '$wallet?page=${fromWallet ? 'wallet' : 'loyalty_points'}';
  static String getWalletHistoryRoute() => walletHistory;
  static String getReferAndEarnRoute() => referAndEarn;
  static String getReturnPolicyRoute() => returnPolicyScreen;
  static String getCancellationPolicyRoute() => cancellationPolicyScreen;
  static String getRefundPolicyRoute() => refundPolicyScreen;

  static final Handler _splashHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const SplashScreen());

  static final Handler _orderDetailsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    OrderDetailsScreen? orderDetailsScreen =
        ModalRoute.of(context!)!.settings.arguments as OrderDetailsScreen?;
    return _routeHandler(
        child: orderDetailsScreen ??
            OrderDetailsScreen(
                orderId: int.parse(params['id'][0]), orderModel: null));
  });

  static final Handler _onBoardingHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: OnBoardingScreen()));

  static final Handler _mainHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const MainScreen()));

  static final Handler _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const LoginScreen()));

  static final Handler _loginOTPHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const OTPScreen()));

  static final Handler _forgetPassHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const ForgotPasswordScreen()));

  static final Handler _signUpHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const SignUpScreen()));

  static final Handler _verificationHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(
        child: VerificationScreen(
      fromSignUp: params['page'][0] == 'sign-up',
      emailAddress: jsonDecode(params['email'][0]),
    ));
  });

  static final Handler _createAccountHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const CreateAccountScreen()));

  static final Handler _resetPassHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    CreateNewPasswordScreen? createPassScreen =
        ModalRoute.of(context!)!.settings.arguments as CreateNewPasswordScreen?;

    return _routeHandler(
        child: createPassScreen ??
            CreateNewPasswordScreen(
              email: params['email'][0],
              resetToken: params['token'][0],
            ));
  });

  static final Handler _updateAddressHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    AddNewAddressScreen? addNewAddressScreen =
        ModalRoute.of(context!)!.settings.arguments as AddNewAddressScreen?;

    String decoded = utf8
        .decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
    return _routeHandler(
        child: addNewAddressScreen ??
            AddNewAddressScreen(
              isEnableUpdate: true,
              fromCheckout: false,
              address: AddressModel.fromJson(jsonDecode(decoded)),
            ));
  });

  static final Handler _selectLocationHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen? locationScreen =
        ModalRoute.of(context!)!.settings.arguments as SelectLocationScreen?;
    return _routeHandler(child: locationScreen ?? const Text('Not Found'));
  });

  static final Handler _setAddressHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SetAddressScreen? setAddressScreen =
        ModalRoute.of(context!)!.settings.arguments as SetAddressScreen?;
    return _routeHandler(child: setAddressScreen ?? const Text('Not Found'));
  });

  static final Handler _orderSuccessHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    int status = (params['status'][0] == 'success' ||
            params['status'][0] == 'payment-success')
        ? 0
        : (params['status'][0] == 'fail' ||
                params['status'][0] == 'payment-fail')
            ? 1
            : 2;
    return _routeHandler(
        child: OrderSuccessfulScreen(orderID: params['id'][0], status: status));
  });

  static final Handler _orderWebPaymentHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(
        child: OrderWebPayment(
      token: params['token'][0],
    ));
  });

  static final Handler _paymentHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    bool fromCheckOut = params['page'][0] == 'checkout';
    String decoded = fromCheckOut
        ? utf8.decode(
            base64Url.decode(params['place_order'][0].replaceAll(' ', '+')))
        : 'null';

    return _routeHandler(
        child: PaymentScreen(
            fromCheckout: fromCheckOut,
            orderModel: fromCheckOut
                ? OrderModel()
                : OrderModel(
                    userId: int.parse(params['user'][0]),
                    id: int.parse(params['id'][0])),
            url: fromCheckOut
                ? utf8.decode(base64Decode(params['address'][0]))
                : '',
            placeOrderBody: decoded != 'null'
                ? PlaceOrderBody.fromJson(jsonDecode(decoded))
                : null));
  });

  static final Handler _razorpayPaymentHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String keyIdTest = 'rzp_test_b48tsAse5ndlpN';
    String razorPayKeyTest = 'Bxtex87Yu6e2yNsXp7Q5OOWe';

    String type = params['type'][0];
    String userId = params['userId'][0];
    String amount = params['amount'][0];
    String phone = params['phone'][0];
    String email = params['email'][0];

    return _routeHandler(
        child: RazorPayPaymentScreen(
            keyIdTest, type, userId, amount, phone, email));
  });

  static final Handler _checkoutHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    CheckoutScreen? checkoutScreen =
        ModalRoute.of(context!)!.settings.arguments as CheckoutScreen?;
    return _routeHandler(
      child: checkoutScreen ??
          CheckoutScreen(
            orderType: params['type'][0],
            discount: double.parse(params['discount'][0]),
            amount: double.parse(params['amount'][0]),
            couponCode: utf8.decode(base64Decode(params['code'][0])),
            freeDeliveryType: utf8.decode(base64Decode(params['c-type'][0])),
          ),
    );
  });

  static final Handler _notificationHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const NotificationScreen()));

  static final Handler _trackOrderHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    TrackOrderScreen? trackOrderScreen =
        ModalRoute.of(context!)!.settings.arguments as TrackOrderScreen?;
    return _routeHandler(
        child: trackOrderScreen ?? TrackOrderScreen(orderID: params['id'][0]));
  });

  static final Handler _categoryProductsHandlerNew = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String decoded = utf8.decode(base64Url.decode(params['category'][0]));
    String sub;
    try {
      sub = utf8.decode(base64Url.decode(params['subcategory'][0]));
    } catch (error) {
      sub = '';
    }
    return _routeHandler(
      child: CategoryProductScreenNew(
        categoryModel: CategoryModel.fromJson(jsonDecode(decoded)),
        subCategoryName: sub,
      ),
    );
  });

  static final Handler _productDescriptionHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    DescriptionScreen? descriptionScreen =
        ModalRoute.of(context!)!.settings.arguments as DescriptionScreen?;
    List<int> decode =
        base64Decode(params['description'][0].replaceAll('-', '+'));
    String data = utf8.decode(decode);
    return _routeHandler(
        child: descriptionScreen ?? DescriptionScreen(description: data));
  });

  static final Handler _productDetailsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    Product product = Product.fromJson(jsonDecode(params['product'][0]));
    bool? fromSearch = jsonDecode(params['search'][0]);
    return _routeHandler(
        child: ProductDetailsScreen(product: product, fromSearch: fromSearch));
  });

  static final Handler _filterHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const FilterScreen());
  });

  ///...............
  static final Handler _productImagesHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    ProductImageScreen? productImageScreen =
        ModalRoute.of(context!)!.settings.arguments as ProductImageScreen?;
    return _routeHandler(
      child: productImageScreen ??
          ProductImageScreen(
            title: params['name'][0],
            imageList: jsonDecode(params['images'][0]),
          ),
    );
  });

  static final Handler _profileHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const ProfileScreen()));

  static final Handler _searchProductHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const SearchScreen()));

  static final Handler _profileEditHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String decoded = utf8.decode(base64Url.decode(params['user'][0]));
    return _routeHandler(
        child: ProfileEditScreen(
            userInfoModel: UserInfoModel.fromJson(jsonDecode(decoded))));
  });

  static final Handler _searchResultHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['text'][0]);
    String data = utf8.decode(decode);
    return _routeHandler(child: SearchResultScreen(searchString: data));
  });
  static final Handler _cartHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const CartScreen()));
  static final Handler _categoriesHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const Allcategoriescreen());
  });
  static final Handler _profileMenusHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const MenuWidget()));
  static final Handler _myOrderHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const MyOrderScreen()));
  static final Handler _cancelOrderHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const CancelOrderScreen()));
  static final Handler _addressHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const AddressScreen()));
  static final Handler _couponHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const CouponScreen()));
  static final Handler _chatHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final orderModel = jsonDecode(
        utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return _routeHandler(
        child: ChatScreen(
            orderModel:
                orderModel != null ? OrderModel.fromJson(orderModel) : null));
  });
  static final Handler _settingsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          _routeHandler(child: const SettingsScreen()));
  static final Handler _termsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
          child: const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition)));

  static final Handler _policyHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
          child: const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy)));

  static final Handler _aboutUsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
          child: const HtmlViewerScreen(htmlType: HtmlType.aboutUs)));
  static final Handler _faqHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.faq)));

  static final Handler _homeItemHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
        String decodedJson = utf8.decode(base64Decode(params['item'][0]));
        NewFlashDealModal decodedProduct = newFlashDealModalFromJson(decodedJson);
    return _routeHandler(child: HomeItemScreen(productType: decodedProduct.productType,productImage: decodedProduct.productImage));
  });
  static final Handler _maintenanceHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(child: const MaintenanceScreen()));
  static final Handler _contactHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(child: const ContactScreen()));

  static final Handler _updateHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(child: const UpdateScreen()));
  static final Handler _newAddressHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool isUpdate = params['action'][0] == 'update';
    AddressModel? addressModel;
    if (isUpdate) {
      String decoded = utf8
          .decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      addressModel = AddressModel.fromJson(jsonDecode(decoded));
    }
    return _routeHandler(
        child: AddNewAddressScreen(
            fromCheckout: params['page'][0] == 'checkout',
            isEnableUpdate: isUpdate,
            address: isUpdate ? addressModel : null));
  });
  static final Handler _favoriteHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(child: const WishListScreen()));

  static final Handler _walletHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
        child: WalletScreen(fromWallet: params['page'][0] == 'wallet')),
  );

  static final Handler _walletHistoryHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(child: const WalletTransactions()));

  static final Handler _referAndEarnHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
            child: const ReferAndEarnScreen(),
          ));

  static final Handler _returnPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
        child: const HtmlViewerScreen(htmlType: HtmlType.returnPolicy)),
  );

  static final Handler _refundPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
        child: const HtmlViewerScreen(htmlType: HtmlType.refundPolicy)),
  );

  static final Handler _cancellationPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
        child: const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy)),
  );

  static void setupRouter() {
    router.define(splash,
        handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(orderDetails,
        handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(onBoarding,
        handler: _onBoardingHandler, transitionType: TransitionType.fadeIn);
    router.define(main,
        handler: _mainHandler, transitionType: TransitionType.fadeIn);
    router.define(otp,
        handler: _loginOTPHandler, transitionType: TransitionType.fadeIn);
    router.define(login,
        handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(forgetPassword,
        handler: _forgetPassHandler, transitionType: TransitionType.fadeIn);
    router.define(signUp,
        handler: _signUpHandler, transitionType: TransitionType.fadeIn);
    router.define(verification,
        handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(createAccount,
        handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(resetPassword,
        handler: _resetPassHandler, transitionType: TransitionType.fadeIn);
    router.define(updateAddress,
        handler: _updateAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(selectLocation,
        handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    router.define(setAddress,
        handler: _setAddressHandler, transitionType: TransitionType.fadeIn);
    router.define('$orderSuccessful/:id/:status',
        handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define('$orderWebPayment/:status?:token',
        handler: _orderWebPaymentHandler,
        transitionType: TransitionType.fadeIn);
    router.define(payment,
        handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define(razorpayPayment,
        handler: _razorpayPaymentHandler,
        transitionType: TransitionType.fadeIn);
    router.define(checkout,
        handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(notification,
        handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(trackOrder,
        handler: _trackOrderHandler, transitionType: TransitionType.fadeIn);
    router.define(categoryProductsNew,
        handler: _categoryProductsHandlerNew,
        transitionType: TransitionType.fadeIn);
    router.define(productDescription,
        handler: _productDescriptionHandler,
        transitionType: TransitionType.fadeIn);
    router.define(productDetails,
        handler: _productDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(filter,
        handler: _filterHandler, transitionType: TransitionType.fadeIn);
    router.define(submitReview,
        handler: _submitReviewHandler, transitionType: TransitionType.fadeIn);
    router.define(productImages,
        handler: _productImagesHandler, transitionType: TransitionType.fadeIn);
    router.define(profile,
        handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(searchProduct,
        handler: _searchProductHandler, transitionType: TransitionType.fadeIn);
    router.define(profileEdit,
        handler: _profileEditHandler, transitionType: TransitionType.fadeIn);
    router.define(searchResult,
        handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(cart,
        handler: _cartHandler, transitionType: TransitionType.fadeIn);
    router.define(categories,
        handler: _categoriesHandler, transitionType: TransitionType.fadeIn);
    router.define(profileMenus,
        handler: _profileMenusHandler, transitionType: TransitionType.fadeIn);
    router.define(myOrder,
        handler: _myOrderHandler, transitionType: TransitionType.fadeIn);
    router.define(cancelOrder,
        handler: _cancelOrderHandler, transitionType: TransitionType.fadeIn);
    router.define(address,
        handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(coupon,
        handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(chatScreen,
        handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(settings,
        handler: _settingsHandler, transitionType: TransitionType.fadeIn);
    router.define(termsScreen,
        handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(policyScreen,
        handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(aboutUsScreen,
        handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(faqScreen,
        handler: _faqHandler, transitionType: TransitionType.fadeIn);
    router.define(homeItem,
        handler: _homeItemHandler, transitionType: TransitionType.fadeIn);
    router.define(maintenance,
        handler: _maintenanceHandler, transitionType: TransitionType.fadeIn);
    router.define(contactScreen,
        handler: _contactHandler, transitionType: TransitionType.fadeIn);
    router.define(update,
        handler: _updateHandler, transitionType: TransitionType.fadeIn);
    router.define(addAddressScreen,
        handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(favorite,
        handler: _favoriteHandler, transitionType: TransitionType.fadeIn);
    router.define(wallet,
        handler: _walletHandler, transitionType: TransitionType.fadeIn);
    router.define(walletHistory,
        handler: _walletHistoryHandler, transitionType: TransitionType.fadeIn);
    router.define(referAndEarn,
        handler: _referAndEarnHandler, transitionType: TransitionType.material);
    router.define(returnPolicyScreen,
        handler: _returnPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(refundPolicyScreen,
        handler: _refundPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(cancellationPolicyScreen,
        handler: _cancellationPolicyHandler,
        transitionType: TransitionType.fadeIn);
  }

  static Widget _routeHandler({required Widget child}) {
    return Provider.of<SplashProvider>(Get.context!, listen: false)
                    .configModel !=
                null &&
            Provider.of<SplashProvider>(Get.context!, listen: false)
                .configModel!
                .maintenanceMode!
        ? const MaintenanceScreen()
        : child;
  }
}
