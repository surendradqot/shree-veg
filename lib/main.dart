import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/banner_provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/provider/chat_provider.dart';
import 'package:shreeveg/provider/coupon_provider.dart';
import 'package:shreeveg/provider/flash_deal_provider.dart';
import 'package:shreeveg/provider/group_provider.dart';
import 'package:shreeveg/provider/language_provider.dart';
import 'package:shreeveg/provider/localization_provider.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/news_letter_provider.dart';
import 'package:shreeveg/provider/notification_provider.dart';
import 'package:shreeveg/provider/onboarding_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/search_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/provider/wallet_provider.dart';
import 'package:shreeveg/provider/wishlist_provider.dart';
import 'package:shreeveg/theme/dark_theme.dart';
import 'package:shreeveg/theme/light_theme.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/view/base/third_party_chat_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'di_container.dart' as di;
import 'firebase_options.dart';
import 'helper/notification_helper.dart';
import 'localization/app_localization.dart';
import 'view/base/cookies_view.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

AndroidNotificationChannel? channel;
Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android) {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.debug,
  );

  // if (!kIsWeb) {
  //   await Firebase.initializeApp();
  // } else {
  //   await Firebase.initializeApp(
  //       options: const FirebaseOptions(
  //           apiKey: "AIzaSyDuBlqmsh9xw17osLOuEn7iqHtDlpkulcM",
  //           authDomain: "grofresh-3986f.firebaseapp.com",
  //           projectId: "grofresh-3986f",
  //           storageBucket: "grofresh-3986f.appspot.com",
  //           messagingSenderId: "250728969979",
  //           appId: "1:250728969979:web:b79642a7b2d2400b75a25e",
  //           measurementId: "G-X1HCG4K8HJ"));

  //   await FacebookAuth.instance.webAndDesktopInitialize(
  //     appId: "YOUR_FACEBOOK_KEY_HERE",
  //     cookie: true,
  //     xfbml: true,
  //     version: "v13.0",
  //   );
  // }
  await di.init();
  int? orderID;
  try {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
      );
    }
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      orderID = remoteMessage.notification!.titleLocKey != null
          ? int.parse(remoteMessage.notification!.titleLocKey!)
          : null;
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {
    if (kDebugMode) {
      print('error---> ${e.toString()}');
    }
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<GroupProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NewsLetterProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WalletProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashDealProvider>()),
    ],
    child: GestureDetector(
      onTap: (){
        FocusScope.of(Get.context!).requestFocus(FocusNode());
      },
        child: MyApp(orderID: orderID, isWeb: !kIsWeb)),
  ));
}

class MyApp extends StatefulWidget {
  final int? orderID;
  final bool? isWeb;
  const MyApp({Key? key, this.orderID, this.isWeb}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouteHelper.setupRouter();

    if (kIsWeb) {
      Provider.of<SplashProvider>(context, listen: false).initSharedData();
      Provider.of<CartProvider>(context, listen: false).getCartData();
      _route();
    }
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig()
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false).updateToken();
            // Navigator.of(context).pushReplacementNamed(RouteHelper.menu, arguments: MenuScreen());
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
          } else {
            // Navigator.of(context).pushReplacementNamed(RouteHelper.onBoarding, arguments: OnBoardingScreen());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return (kIsWeb && splashProvider.configModel == null)
            ? const SizedBox()
            : MaterialApp(
                title: splashProvider.configModel != null
                    ? splashProvider.configModel!.ecommerceName ?? ''
                    : AppConstants.appName,
                initialRoute: ResponsiveHelper.isMobilePhone()
                    ? widget.orderID == null
                        ? RouteHelper.splash
                        : RouteHelper.getOrderDetailsRoute(widget.orderID)
                    : splashProvider.configModel!.maintenanceMode!
                        ? RouteHelper.getmaintenanceRoute()
                        : RouteHelper.main,
                onGenerateRoute: RouteHelper.router.generator,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                theme: Provider.of<ThemeProvider>(context).darkTheme
                    ? dark
                    : light,
                locale: Provider.of<LocalizationProvider>(context).locale,
                localizationsDelegates: const [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: locals,
                scrollBehavior:
                    const MaterialScrollBehavior().copyWith(dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                }),
                builder: (context, widget) => Material(
                    child: Stack(children: [
                  widget!,
                  if (ResponsiveHelper.isDesktop(context))
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 20),
                            child: ThirdPartyChatWidget(
                                configModel: splashProvider.configModel!),
                          )),
                    ),
                  if (kIsWeb &&
                      splashProvider.configModel!.cookiesManagement != null &&
                      splashProvider.configModel!.cookiesManagement!.status! &&
                      !splashProvider.getAcceptCookiesStatus(splashProvider
                          .configModel!.cookiesManagement!.content) &&
                      splashProvider.cookiesShow)
                    const Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: CookiesView())),
                ])),
              );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
