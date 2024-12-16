import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/menu/main_screen.dart';
import 'package:shreeveg/view/screens/menu/web_menu/menu_screen_web.dart';
import 'package:shreeveg/view/screens/menu/widget/custom_drawer.dart';
import 'package:shreeveg/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:shreeveg/view/screens/notification/notification_screen.dart';
import 'package:shreeveg/view/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/wishlist/wishlist_screen.dart';
import '../../../helper/product_type.dart';
import '../../../utill/app_constants.dart';
import '../home/widget/location_view.dart';
import '../product/all_product_rate_review_screen.dart';
import '../review/rate_review_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CustomDrawerController _drawerController = CustomDrawerController();

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
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen();
    // return CustomDrawer(
    //     controller: _drawerController,
    //     mainScreen: MainScreen(drawerController: _drawerController),
    //     menuScreen: MenuWidget(drawerController: _drawerController),
    //     showShadow: false,
    //     angle: 0.0,
    //     borderRadius: 30,
    //     slideWidth: -MediaQuery.of(context).size.width
    //     // *
    //     // -(CustomDrawer.isRTL(context) ? 0.1 : 0.1),
    //     );
  }
}

class MenuWidget extends StatelessWidget {
  final CustomDrawerController? drawerController;

  const MenuWidget({Key? key, this.drawerController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Padding(
      padding: const EdgeInsets.only(right: 80.0),
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
                preferredSize: Size.fromHeight(120), child: WebAppBar())
            : null,
        body: const SafeArea(child: Text('')
            // child: ResponsiveHelper.isDesktop(context)
            //     ? MenuScreenWeb(isLoggedIn: isLoggedIn)
            //     : SingleChildScrollView(
            //         child: Center(
            //           child: SizedBox(
            //             width: 1170,
            //             child: Consumer<SplashProvider>(
            //               builder: (context, splash, child) {
            //                 return Column(children: [
            //                   const SizedBox(
            //                       height: Dimensions.paddingSizeLarge),
            //                   // !ResponsiveHelper.isDesktop(context)
            //                   //     ? Align(
            //                   //         alignment: Alignment.centerLeft,
            //                   //         child: IconButton(
            //                   //           icon: Icon(Icons.close,
            //                   //               color: Provider.of<ThemeProvider>(
            //                   //                           context)
            //                   //                       .darkTheme
            //                   //                   ? Theme.of(context)
            //                   //                       .textTheme
            //                   //                       .bodyLarge
            //                   //                       ?.color
            //                   //                       ?.withOpacity(0.6)
            //                   //                   : ResponsiveHelper.isDesktop(
            //                   //                           context)
            //                   //                       ? Theme.of(context)
            //                   //                           .canvasColor
            //                   //                       : Theme.of(context)
            //                   //                           .canvasColor),
            //                   //           onPressed: () =>
            //                   //               drawerController!.toggle(),
            //                   //         ),
            //                   //       )
            //                   //     : const SizedBox(),
            //                   Consumer<ProfileProvider>(
            //                     builder: (context, profileProvider, child) =>
            //                         Row(
            //                       mainAxisSize: MainAxisSize.max,
            //                       children: [
            //                         Expanded(
            //                           child: ListTile(
            //                             tileColor:
            //                                 Provider.of<ThemeProvider>(context)
            //                                             .darkTheme ||
            //                                         ResponsiveHelper.isDesktop(
            //                                             context)
            //                                     ? Theme.of(context)
            //                                         .hintColor
            //                                         .withOpacity(0.1)
            //                                     : Theme.of(context)
            //                                         .primaryColor,
            //                             onTap: () {
            //                               Navigator.of(context).pushNamed(
            //                                   RouteHelper.profile,
            //                                   arguments: const ProfileScreen());
            //                             },
            //                             leading: ClipOval(
            //                               child: isLoggedIn
            //                                   ? Provider.of<SplashProvider>(
            //                                                   context,
            //                                                   listen: false)
            //                                               .baseUrls !=
            //                                           null
            //                                       ? Builder(builder: (context) {
            //                                           return FadeInImage
            //                                               .assetNetwork(
            //                                             placeholder:
            //                                                 Images.placeholder(
            //                                                     context),
            //                                             image:
            //                                                 '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
            //                                                 '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
            //                                             height: 50,
            //                                             width: 50,
            //                                             fit: BoxFit.cover,
            //                                             imageErrorBuilder: (c,
            //                                                     o, s) =>
            //                                                 Image.asset(
            //                                                     Images
            //                                                         .placeholder(
            //                                                             context),
            //                                                     height: 50,
            //                                                     width: 50,
            //                                                     fit: BoxFit
            //                                                         .cover),
            //                                           );
            //                                         })
            //                                       : const SizedBox()
            //                                   : Image.asset(
            //                                       Images.placeholder(context),
            //                                       height: 50,
            //                                       width: 50,
            //                                       fit: BoxFit.cover),
            //                             ),
            //                             title: Column(
            //                                 crossAxisAlignment:
            //                                     CrossAxisAlignment.start,
            //                                 children: [
            //                                   isLoggedIn
            //                                       ? profileProvider
            //                                                   .userInfoModel !=
            //                                               null
            //                                           ? Text(
            //                                               '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
            //                                               style: poppinsRegular
            //                                                   .copyWith(
            //                                                 color: Provider.of<
            //                                                                 ThemeProvider>(
            //                                                             context)
            //                                                         .darkTheme
            //                                                     ? Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .bodyLarge
            //                                                         ?.color
            //                                                         ?.withOpacity(
            //                                                             0.6)
            //                                                     : ResponsiveHelper
            //                                                             .isDesktop(
            //                                                                 context)
            //                                                         ? ColorResources
            //                                                             .getDarkColor(
            //                                                                 context)
            //                                                         : Theme.of(
            //                                                                 context)
            //                                                             .canvasColor,
            //                                               ),
            //                                             )
            //                                           : Container(
            //                                               height: 10,
            //                                               width: 150,
            //                                               color: ResponsiveHelper
            //                                                       .isDesktop(
            //                                                           context)
            //                                                   ? ColorResources
            //                                                       .getDarkColor(
            //                                                           context)
            //                                                   : Theme.of(
            //                                                           context)
            //                                                       .canvasColor)
            //                                       : Text(
            //                                           getTranslated(
            //                                               'guest', context)!,
            //                                           style: poppinsRegular
            //                                               .copyWith(
            //                                             color: Provider.of<
            //                                                             ThemeProvider>(
            //                                                         context)
            //                                                     .darkTheme
            //                                                 ? Theme.of(
            //                                                         context)
            //                                                     .textTheme
            //                                                     .bodyLarge
            //                                                     ?.color
            //                                                     ?.withOpacity(
            //                                                         0.6)
            //                                                 : ResponsiveHelper
            //                                                         .isDesktop(
            //                                                             context)
            //                                                     ? ColorResources
            //                                                         .getDarkColor(
            //                                                             context)
            //                                                     : Theme.of(
            //                                                             context)
            //                                                         .canvasColor,
            //                                           ),
            //                                         ),
            //                                   if (isLoggedIn)
            //                                     const SizedBox(
            //                                         height: Dimensions
            //                                             .paddingSizeSmall),
            //                                   if (isLoggedIn &&
            //                                       profileProvider
            //                                               .userInfoModel !=
            //                                           null)
            //                                     Text(
            //                                         profileProvider
            //                                                 .userInfoModel!
            //                                                 .phone ??
            //                                             '',
            //                                         style:
            //                                             poppinsRegular.copyWith(
            //                                           color: Provider.of<
            //                                                           ThemeProvider>(
            //                                                       context)
            //                                                   .darkTheme
            //                                               ? Theme.of(context)
            //                                                   .textTheme
            //                                                   .bodyLarge
            //                                                   ?.color
            //                                                   ?.withOpacity(0.6)
            //                                               : ResponsiveHelper
            //                                                       .isDesktop(
            //                                                           context)
            //                                                   ? ColorResources
            //                                                       .getDarkColor(
            //                                                           context)
            //                                                   : Theme.of(
            //                                                           context)
            //                                                       .canvasColor,
            //                                         )),
            //                                 ]),
            //                             trailing: IconButton(
            //                               icon: Icon(Icons.notifications,
            //                                   color: Provider.of<ThemeProvider>(
            //                                               context)
            //                                           .darkTheme
            //                                       ? Theme.of(context)
            //                                           .textTheme
            //                                           .bodyLarge
            //                                           ?.color
            //                                           ?.withOpacity(0.6)
            //                                       : ResponsiveHelper.isDesktop(
            //                                               context)
            //                                           ? ColorResources
            //                                               .getDarkColor(context)
            //                                           : Theme.of(context)
            //                                               .canvasColor),
            //                               onPressed: () {
            //                                 Navigator.pushNamed(context,
            //                                     RouteHelper.notification,
            //                                     arguments:
            //                                         const NotificationScreen());
            //                               },
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   const SizedBox(height: 50),
            //                   if (!ResponsiveHelper.isDesktop(context))
            //                     Column(
            //                         children: screenList
            //                             .map((model) => ListTile(
            //                                   onTap: () {
            //                                     if (!ResponsiveHelper.isDesktop(
            //                                         context)) {
            //                                       splash.setPageIndex(screenList
            //                                           .indexOf(model));
            //                                     }
            //                                     drawerController!.close!();
            //                                   },
            //                                   selected: splash.pageIndex ==
            //                                       screenList.indexOf(model),
            //                                   selectedTileColor:
            //                                       Colors.black.withAlpha(30),
            //                                   trailing: model.icon != null
            //                                       ? Image.asset(
            //                                           model.icon!,
            //                                           color:
            //                                               ResponsiveHelper
            //                                                       .isDesktop(
            //                                                           context)
            //                                                   ? ColorResources
            //                                                       .getDarkColor(
            //                                                           context)
            //                                                   : Colors.black,
            //                                           width: 20,
            //                                           height: 20,
            //                                         )
            //                                       : null,
            //                                   title: Text(
            //                                       getTranslated(
            //                                           model.title, context)!,
            //                                       style:
            //                                           poppinsRegular.copyWith(
            //                                         fontSize: Dimensions
            //                                             .fontSizeLarge,
            //                                         color: Colors.black,
            //                                         // color: Provider.of<
            //                                         //                 ThemeProvider>(
            //                                         //             context)
            //                                         //         .darkTheme
            //                                         //     ? Theme.of(context)
            //                                         //         .textTheme
            //                                         //         .bodyLarge
            //                                         //         ?.color
            //                                         //         ?.withOpacity(0.6)
            //                                         //     : ResponsiveHelper
            //                                         //             .isDesktop(
            //                                         //                 context)
            //                                         //         ? ColorResources
            //                                         //             .getDarkColor(
            //                                         //                 context)
            //                                         //         : Theme.of(context)
            //                                         //             .canvasColor,
            //                                       )),
            //                                 ))
            //                             .toList()),
            //                   ListTile(
            //                     onTap: () {
            //                       if (isLoggedIn) {
            //                         showDialog(
            //                             context: context,
            //                             barrierDismissible: false,
            //                             builder: (context) =>
            //                                 const SignOutConfirmationDialog());
            //                       } else {
            //                         Provider.of<SplashProvider>(context,
            //                                 listen: false)
            //                             .setPageIndex(0);
            //                         Navigator.pushNamedAndRemoveUntil(
            //                             context,
            //                             RouteHelper.getLoginRoute(),
            //                             (route) => false);
            //                       }
            //                     },
            //                     // leading: Image.asset(
            //                     //   isLoggedIn ? Images.logOut : Images.appLogo,
            //                     //   color: ResponsiveHelper.isDesktop(context)
            //                     //       ? ColorResources.getDarkColor(context)
            //                     //       : Colors.white,
            //                     //   width: 25,
            //                     //   height: 25,
            //                     // ),
            //                     title: Text(
            //                       getTranslated(
            //                           isLoggedIn ? 'log_out' : 'login',
            //                           context)!,
            //                       style: poppinsRegular.copyWith(
            //                         fontSize: Dimensions.fontSizeLarge,
            //                         color: Colors.black,
            //                         // color: Provider.of<ThemeProvider>(context)
            //                         //         .darkTheme
            //                         //     ? Theme.of(context)
            //                         //         .textTheme
            //                         //         .bodyLarge
            //                         //         ?.color
            //                         //         ?.withOpacity(0.6)
            //                         //     : ResponsiveHelper.isDesktop(context)
            //                         //         ? ColorResources.getDarkColor(
            //                         //             context)
            //                         //         : Theme.of(context).canvasColor,
            //                       ),
            //                     ),
            //                   ),
            //                 ]);
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            ),
      ),
    );
  }
}

class MenuButton {
  final String routeName;
  final String icon;
  final String title;
  final IconData? iconData;
  MenuButton(
      {required this.routeName,
      required this.icon,
      required this.title,
      this.iconData});
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Padding(
      padding: const EdgeInsets.only(right: 80.0),
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
                preferredSize: Size.fromHeight(120), child: WebAppBar())
            : null,
        body: SafeArea(
          child: ResponsiveHelper.isDesktop(context)
              ? MenuScreenWeb(isLoggedIn: isLoggedIn)
              : SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Consumer<SplashProvider>(
                        builder: (context, splash, child) {
                          return Column(children: [
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            // !ResponsiveHelper.isDesktop(context)
                            //     ? Align(
                            //         alignment: Alignment.centerLeft,
                            //         child: IconButton(
                            //           icon: Icon(Icons.close,
                            //               color: Provider.of<ThemeProvider>(
                            //                           context)
                            //                       .darkTheme
                            //                   ? Theme.of(context)
                            //                       .textTheme
                            //                       .bodyLarge
                            //                       ?.color
                            //                       ?.withOpacity(0.6)
                            //                   : ResponsiveHelper.isDesktop(
                            //                           context)
                            //                       ? Theme.of(context)
                            //                           .canvasColor
                            //                       : Theme.of(context)
                            //                           .canvasColor),
                            //           onPressed: () =>
                            //               drawerController!.toggle(),
                            //         ),
                            //       )
                            //     : const SizedBox(),

                            Container(
                                color: AppConstants.primaryColor,
                                child: const LocationView(
                                    locationColor: Colors.white)),

                            const SizedBox(height: 30),
                            if (!ResponsiveHelper.isDesktop(context))
                              Column(
                                  children: menuScreenList
                                      .map((model) => ListTile(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              if (!ResponsiveHelper.isDesktop(
                                                  context)) {
                                                int menuIndex = menuScreenList
                                                    .indexOf(model);
                                                splash.setPageIndex(menuIndex);

                                                String menuTitle =
                                                    (menuScreenList[menuIndex]
                                                        .title);

                                                print(menuTitle);

                                                bool isMainRoute = false;

                                                screenList.forEach((screen) {
                                                  if (menuTitle ==
                                                      screen.title) {
                                                    splash.setCurrentPageIndex(
                                                        screenList
                                                            .indexOf(screen));
                                                    isMainRoute = true;
                                                    return;
                                                  }
                                                });

                                                if (!isMainRoute) {
                                                  switch (menuTitle) {
                                                    case 'my_account':
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ProfileScreen()));
                                                      break;
                                                    case 'my_wishlist':
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const WishListScreen()));
                                                      break;
                                                    case 'offers':
                                                      Navigator.pushNamed(
                                                          context,
                                                          RouteHelper
                                                              .getHomeItemRoute(
                                                                  ProductType
                                                                      .flashSale));
                                                      break;
                                                    case 'rate_review':
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const AllProductsRateReviewScreen()));
                                                      break;
                                                    case 'notifications':
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const NotificationScreen()));
                                                      break;
                                                    default:
                                                      break;
                                                  }
                                                }
                                              }
                                            },
                                            selected: splash.pageIndex ==
                                                menuScreenList.indexOf(model),
                                            selectedTileColor:
                                                Colors.black.withAlpha(30),
                                            trailing: model.icon != null
                                                ? Image.asset(
                                                    model.icon!,
                                                    color: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? ColorResources
                                                            .getDarkColor(
                                                                context)
                                                        : Colors.black,
                                                    width: 20,
                                                    height: 20,
                                                  )
                                                : null,
                                            title: Text(
                                                getTranslated(
                                                    model.title, context)!,
                                                style: poppinsRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  // color: Provider.of<
                                                  //                 ThemeProvider>(
                                                  //             context)
                                                  //         .darkTheme
                                                  //     ? Theme.of(context)
                                                  //         .textTheme
                                                  //         .bodyLarge
                                                  //         ?.color
                                                  //         ?.withOpacity(0.6)
                                                  //     : ResponsiveHelper
                                                  //             .isDesktop(
                                                  //                 context)
                                                  //         ? ColorResources
                                                  //             .getDarkColor(
                                                  //                 context)
                                                  //         : Theme.of(context)
                                                  //             .canvasColor,
                                                )),
                                          ))
                                      .toList()),
                            ListTile(
                              onTap: () {
                                if (isLoggedIn) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          const SignOutConfirmationDialog());
                                } else {
                                  Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .setPageIndex(0);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteHelper.getLoginRoute(),
                                      (route) => false);
                                }
                              },
                              // leading: Image.asset(
                              //   isLoggedIn ? Images.logOut : Images.appLogo,
                              //   color: ResponsiveHelper.isDesktop(context)
                              //       ? ColorResources.getDarkColor(context)
                              //       : Colors.white,
                              //   width: 25,
                              //   height: 25,
                              // ),
                              title: Text(
                                getTranslated(
                                    isLoggedIn ? 'log_out' : 'login', context)!,
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Colors.black,
                                  // color: Provider.of<ThemeProvider>(context)
                                  //         .darkTheme
                                  //     ? Theme.of(context)
                                  //         .textTheme
                                  //         .bodyLarge
                                  //         ?.color
                                  //         ?.withOpacity(0.6)
                                  //     : ResponsiveHelper.isDesktop(context)
                                  //         ? ColorResources.getDarkColor(
                                  //             context)
                                  //         : Theme.of(context).canvasColor,
                                ),
                              ),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
