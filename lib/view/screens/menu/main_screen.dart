import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/model/response/userinfo_model.dart';
import 'package:shreeveg/helper/html_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/third_party_chat_widget.dart';
import 'package:shreeveg/view/screens/address/address_screen.dart';
import 'package:shreeveg/view/screens/cart/cart_screen.dart';
import 'package:shreeveg/view/screens/category/all_category_screen.dart';
import 'package:shreeveg/view/screens/chat/chat_screen.dart';
import 'package:shreeveg/view/screens/coupon/coupon_screen.dart';
import 'package:shreeveg/view/screens/home/home_screens.dart';
import 'package:shreeveg/view/screens/html/html_viewer_screen.dart';
import 'package:shreeveg/view/screens/menu/menu_screen.dart';
import 'package:shreeveg/view/screens/menu/widget/app_exit_dialog.dart';
import 'package:shreeveg/view/screens/menu/widget/custom_drawer.dart';
import 'package:shreeveg/view/screens/notification/notification_screen.dart';
import 'package:shreeveg/view/screens/order/my_order_screen.dart';
import 'package:shreeveg/view/screens/refer_and_earn/refer_and_earn_screen.dart';
import 'package:shreeveg/view/screens/settings/setting_screen.dart';
import 'package:shreeveg/view/screens/wallet/wallet_screen.dart';
import 'package:shreeveg/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';
import '../checkout/widget/cancel_dialog.dart';
import '../profile/profile_screen.dart';

List<MainScreenModel> menuScreenList = [
  MainScreenModel(const HomeScreen(), 'home', null),
  MainScreenModel(const ProfileScreen(), 'my_account', Images.plus),
  MainScreenModel(const WishListScreen(), 'my_wishlist', null),
  MainScreenModel(const Allcategoriescreen(), 'shop_by_category', null),
  MainScreenModel(const ProfileScreen(), 'offers', null),
  MainScreenModel(const ProfileScreen(), 'rate_review', null),
  MainScreenModel(const NotificationScreen(), 'notifications', null),
];

List<MainScreenModel> screenList = [
  MainScreenModel(const HomeScreen(), 'home', null),
  // MainScreenModel(const ProfileScreen(), 'my_account', Images.plus),
  // MainScreenModel(const WishListScreen(), 'my_wishlist', null),
  MainScreenModel(const Allcategoriescreen(), 'shop_by_category', null),
  // MainScreenModel(const ProfileScreen(), 'offers', null),
  // MainScreenModel(const ProfileScreen(), 'rate_review', null),
  // MainScreenModel(const NotificationScreen(), 'notifications', null),
  // MainScreenModel(const HomeScreen(), 'log_out', null),
  // MainScreenModel(const Allcategoriescreen(), 'all_categories', Images.list),
  MainScreenModel(const CartScreen(), 'shopping_bag', Images.orderBag),
  // MainScreenModel(const WishListScreen(), 'favourite', Images.favouriteIcon),
  // MainScreenModel(const MyOrderScreen(), 'my_order', Images.orderList),
  // MainScreenModel(const AddressScreen(), 'address', Images.location),
  // MainScreenModel(const CouponScreen(), 'coupon', Images.coupon),
  // MainScreenModel(
  //     const ChatScreen(
  //       orderModel: null,
  //     ),
  //     'live_chat',
  //     Images.chat),
  // MainScreenModel(const SettingsScreen(), 'settings', Images.settings),
  // if (Provider.of<SplashProvider>(Get.context!, listen: false)
  //     .configModel!
  //     .walletStatus!)
  //   MainScreenModel(
  //       const WalletScreen(fromWallet: true), 'wallet', Images.wallet),
  // if (Provider.of<SplashProvider>(Get.context!, listen: false)
  //     .configModel!
  //     .loyaltyPointStatus!)
  //   MainScreenModel(const WalletScreen(fromWallet: false), 'loyalty_point',
  //       Images.loyaltyIcon),
  // MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition),
  //     'terms_and_condition', Images.termsAndConditions),
  // MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy),
  //     'privacy_policy', Images.privacy),
  // MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.aboutUs),
  //     'about_us', Images.aboutUs),
  // if (Provider.of<SplashProvider>(Get.context!, listen: false)
  //     .configModel!
  //     .returnPolicyStatus!)
  //   MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.returnPolicy),
  //       'return_policy', Images.returnPolicy),
  // if (Provider.of<SplashProvider>(Get.context!, listen: false)
  //     .configModel!
  //     .refundPolicyStatus!)
  //   MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.refundPolicy),
  //       'refund_policy', Images.refundPolicy),
  // if (Provider.of<SplashProvider>(Get.context!, listen: false)
  //     .configModel!
  //     .cancellationPolicyStatus!)
  //   MainScreenModel(
  //       const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy),
  //       'cancellation_policy',
  //       Images.cancellationPolicy),
  // MainScreenModel(
  //     const HtmlViewerScreen(htmlType: HtmlType.faq), 'faq', Images.faq),
];

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future apiCall()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("showPopup", true);
  }

  @override
  void initState() {
    super.initState();
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
      Provider.of<LocationProvider>(context, listen: false).initAddressList();
    } else {
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }
    apiCall();
    // HomeScreen.loadData(true, Get.context!);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
          // final referMenu = MainScreenModel(const ReferAndEarnScreen(),
          //     'referAndEarn', Images.referralIcon);
          // if (splash.configModel!.referEarnStatus! &&
          //     profileProvider.userInfoModel != null &&
          //     profileProvider.userInfoModel!.referCode != null &&
          //     screenList[9].title != 'referAndEarn') {
          //   screenList.removeWhere((menu) => menu.screen == referMenu.screen);
          //   screenList.insert(9, referMenu);
          // }

          // canPop: Provider.of<SplashProvider>(context, listen: true).popApp,

          return Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => WillPopScope(
              onWillPop: () async {
                if (kDebugMode) {
                  print('closing main route');
                }
                if (_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.closeDrawer();
                  return false;
                }
                if (splash.currentPageIndex != 0) {
                  splash.setCurrentPageIndex(0);
                  return false;
                }
                if (splash.currentPageIndex == 0) {
                  return await showDialog(
                    context: context,
                    builder: (context) => const AppExitDialog(),
                  );
                }
                return false;
              },
              child: Scaffold(
                  key: _scaffoldKey,
                  // floatingActionButton: !ResponsiveHelper.isDesktop(context)
                  //     ? Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 50.0),
                  //         child: ThirdPartyChatWidget(
                  //           configModel: splash.configModel!,
                  //         ),
                  //       )
                  //     : null,
                  // appBar: ResponsiveHelper.isDesktop(context)
                  //     ? null
                  //     : AppBar(
                  //         backgroundColor: Theme.of(context).cardColor,
                  //         // leading: IconButton(
                  //         //     icon: Image.asset(Images.moreIcon,
                  //         //         color: Theme.of(context).primaryColor,
                  //         //         height: 30,
                  //         //         width: 30),
                  //         //     onPressed: () {
                  //         //       widget.drawerController.toggle();
                  //         //     }),
                  //         title: splash.pageIndex == 0
                  //             ? Row(children: [
                  //                 Image.asset(Images.appLogo, width: 25),
                  //                 const SizedBox(
                  //                     width: Dimensions.paddingSizeSmall),
                  //                 Expanded(
                  //                     child: Text(
                  //                   AppConstants.appName,
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   style: poppinsMedium.copyWith(
                  //                       color: Theme.of(context).primaryColor),
                  //                 )),
                  //               ])
                  //             : Text(
                  //                 getTranslated(
                  //                     screenList[splash.pageIndex].title,
                  //                     context)!,
                  //                 style: poppinsMedium.copyWith(
                  //                     fontSize: Dimensions.fontSizeLarge,
                  //                     color: Theme.of(context).primaryColor),
                  //               ),
                  //         actions: splash.pageIndex == 0
                  //             ? [
                  //                 IconButton(
                  //                     icon: Stack(
                  //                         clipBehavior: Clip.none,
                  //                         children: [
                  //                           Image.asset(Images.cartIcon,
                  //                               color: Theme.of(context)
                  //                                   .textTheme
                  //                                   .bodyLarge!
                  //                                   .color,
                  //                               width: 25),
                  //                           Positioned(
                  //                             top: -7,
                  //                             right: -2,
                  //                             child: Container(
                  //                               padding: const EdgeInsets.all(3),
                  //                               decoration: BoxDecoration(
                  //                                   shape: BoxShape.circle,
                  //                                   color: Theme.of(context)
                  //                                       .primaryColor),
                  //                               child: Text(
                  //                                   '${Provider.of<CartProvider>(context).cartList.length}',
                  //                                   style: TextStyle(
                  //                                       color: Theme.of(context)
                  //                                           .cardColor,
                  //                                       fontSize: 10)),
                  //                             ),
                  //                           ),
                  //                         ]),
                  //                     onPressed: () {
                  //                       ResponsiveHelper.isMobilePhone()
                  //                           ? splash.setPageIndex(2)
                  //                           : Navigator.pushNamed(
                  //                               context, RouteHelper.cart);
                  //                     }),
                  //                 // IconButton(
                  //                 //     icon: Icon(Icons.search,
                  //                 //         size: 30,
                  //                 //         color: Theme.of(context)
                  //                 //             .textTheme
                  //                 //             .bodyLarge!
                  //                 //             .color),
                  //                 //     onPressed: () {
                  //                 //       Navigator.pushNamed(
                  //                 //           context, RouteHelper.searchProduct);
                  //                 //     }),
                  //               ]
                  //             : splash.pageIndex == 2
                  //                 ? [
                  //                     Center(child: Consumer<CartProvider>(
                  //                         builder: (context, cartProvider, _) {
                  //                       return Text(
                  //                           '${cartProvider.cartList.length} ${getTranslated('items', context)}',
                  //                           style: poppinsMedium.copyWith(
                  //                               color: Theme.of(context)
                  //                                   .primaryColor));
                  //                     })),
                  //                     const SizedBox(width: 20)
                  //                   ]
                  //                 : null,
                  //       ),
                  drawer: MyDrawer(),
                  body: screenList[splash.currentPageIndex].screen,
                  bottomNavigationBar: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        4,
                        (index) => InkWell(
                          onTap: () {
                            index == 3
                                ? _scaffoldKey.currentState!.openDrawer()
                                : splash.setCurrentPageIndex(index);
                          },
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: index == splash.currentPageIndex
                                  ? const Color(0xFF0B4619)
                                  : Colors.transparent,
                              child: index == 2
                                  ? Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          color:
                                              splash.currentPageIndex == index
                                                  ? Colors.white
                                                  : const Color(0xFF0B4619),
                                        ),
                                        Positioned(
                                          bottom: -2,
                                          right: -4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 14,
                                              // minHeight: 10,
                                            ),
                                            child: Text(
                                              '${Provider.of<CartProvider>(context).cartList.length}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Icon(
                                      index == 0
                                          ? Icons.home_outlined
                                          : index == 1
                                              ? Icons.dashboard_outlined
                                              : index == 2
                                                  ? Icons.shopping_bag_outlined
                                                  : Icons.menu_outlined,
                                      color: splash.currentPageIndex == index
                                          ? Colors.white
                                          : const Color(0xFF0B4619),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          );
        });
      },
    );
  }
}

class MainScreenModel {
  final Widget screen;
  final String title;
  String? icon;
  MainScreenModel(this.screen, this.title, this.icon);
}
