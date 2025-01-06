import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/not_login_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';

import '../../base/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: getTranslated('my_account', context),
              backgroundColor: const Color(0xFF0B4619),
              buttonTextColor: Colors.white)) as PreferredSizeWidget?,
      // backgroundColor: ResponsiveHelper.isDesktop(context)? ColorResources.getTryBgColor(context) : Theme.of(context).cardColor,
      // appBar: ResponsiveHelper.isDesktop(context)
      //     ? const PreferredSize(
      //         preferredSize: Size.fromHeight(120), child: WebAppBar())
      //     : AppBar(
      //         backgroundColor: Theme.of(context).cardColor,
      //         leading: IconButton(
      //             icon: Image.asset(Images.moreIcon,
      //                 color: Theme.of(context).primaryColor),
      //             onPressed: () {
      //               Provider.of<SplashProvider>(context, listen: false)
      //                   .setPageIndex(0);
      //               Navigator.of(context).pop();
      //             }),
      //         title: Text(getTranslated('profile', context)!,
      //             style: poppinsMedium.copyWith(
      //               fontSize: Dimensions.fontSizeSmall,
      //               color: Theme.of(context).textTheme.bodyLarge!.color,
      //             )),
      //       ),
      body: SafeArea(
          child: _isLoggedIn
              ? Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ResponsiveHelper.isDesktop(context)
                            ? Center(
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7),
                                      child: SizedBox(
                                        width: 1170,
                                        child: Column(
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  height: 150,
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.5),
                                                ),
                                                Positioned(
                                                  left: 30,
                                                  top: 45,
                                                  child: Container(
                                                    height: 180,
                                                    width: 180,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.1),
                                                              blurRadius: 22,
                                                              offset:
                                                                  const Offset(
                                                                      0, 8.8))
                                                        ]),
                                                    child: ClipOval(
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            Images.placeholder(
                                                                context),
                                                        height: 170,
                                                        width: 170,
                                                        fit: BoxFit.cover,
                                                        image:
                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                                                            '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.userInfo!.image : ''}',
                                                        imageErrorBuilder: (c,
                                                                o, s) =>
                                                            Image.asset(
                                                                Images
                                                                    .placeholder(
                                                                        context),
                                                                height: 170,
                                                                width: 170,
                                                                fit: BoxFit
                                                                    .cover),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: -10,
                                                    right: 10,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          RouteHelper
                                                              .getProfileEditRoute(
                                                                  profileProvider
                                                                      .userInfoModel),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.edit,
                                                                size: 16,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                              getTranslated(
                                                                  'edit',
                                                                  context)!,
                                                              style: poppinsMedium.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),

                                            /*Center(
                                  child: Text(
                                    '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                    style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                  )),*/

                                            //mobileNumber,email,gender
                                            const SizedBox(height: 100),
                                            profileProvider.isLoading
                                                ? CustomLoader(
                                                    color: Theme.of(context)
                                                        .primaryColor)
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          getTranslated(
                                                              'mobile_number',
                                                              context)!,
                                                          style: poppinsRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Text(
                                                          '${profileProvider.userInfoModel!.userInfo!.fName ?? ''} ${profileProvider.userInfoModel!.userInfo!.lName ?? ''}',
                                                          style: poppinsRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault),
                                                        ),
                                                        const Divider(),
                                                        const SizedBox(
                                                            height: 25),
                                                        // for first name section
                                                        Text(
                                                          getTranslated(
                                                              'mobile_number',
                                                              context)!,
                                                          style: poppinsRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Text(
                                                          profileProvider
                                                                  .userInfoModel!.userInfo!
                                                                  .phone ??
                                                              '',
                                                          style: poppinsRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault),
                                                        ),
                                                        const Divider(),
                                                        const SizedBox(
                                                            height: 25),

                                                        // for email section
                                                        Text(
                                                          getTranslated('email',
                                                              context)!,
                                                          style: poppinsRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Text(
                                                          profileProvider
                                                                  .userInfoModel!.userInfo!
                                                                  .email ??
                                                              '',
                                                          style: poppinsRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault),
                                                        ),
                                                        const Divider(),
                                                        const SizedBox(
                                                            height: 25),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const FooterView(),
                                  ],
                                ),
                              )
                            : Center(
                                child: SizedBox(
                                  width: 1170,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 12, bottom: 12),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorResources
                                                        .getGreyColor(context),
                                                    width: 2),
                                                shape: BoxShape.circle),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: profileProvider.file ==
                                                      null ? profileProvider.userInfoModel!=null
                                                  ?FadeInImage.assetNetwork(
                                                      placeholder:
                                                          Images.placeholder(
                                                              context),
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.userInfo!.image}',
                                                      imageErrorBuilder: (c, o,
                                                              s) =>
                                                          Image.asset(
                                                              Images.placeholder(
                                                                  context),
                                                              height: 100,
                                                              width: 100,
                                                              fit:
                                                                  BoxFit.cover)):Image.asset(
                                                  Images.placeholder(
                                                      context),
                                                  height: 100,
                                                  width: 100,
                                                  fit:
                                                  BoxFit.cover)
                                                  : Image.file(
                                                      profileProvider.file!,
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.fill),
                                            )),

                                        // for name
                                        Center(
                                            child: Text(
                                          '${profileProvider.userInfoModel!.userInfo!.fName ?? ''} ${profileProvider.userInfoModel!.userInfo!.lName ?? ''}',
                                          style: poppinsMedium.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  Dimensions.fontSizeLarge),
                                        )),

                                        // for email
                                        Center(
                                            child: Text(
                                          profileProvider
                                                  .userInfoModel!.userInfo!.email ??
                                              '',
                                          style: poppinsMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF7C7C7C)),
                                        )),

                                        const SizedBox(
                                            height: Dimensions
                                                .paddingSizeExtraLarge),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              RouteHelper.getProfileEditRoute(
                                                  profileProvider
                                                      .userInfoModel),
                                            );
                                          },
                                          child: profileTile(
                                              Images.profileIcon,
                                              getTranslated(
                                                  'my_profile', context)!),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, RouteHelper.myOrder);
                                          },
                                          child: profileTile(
                                              Images.orderIcon,
                                              getTranslated(
                                                  'orders', context)!),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RouteHelper.cancelOrder);
                                          },
                                          child: profileTile(
                                              Images.cancelOrderIcon,
                                              getTranslated(
                                                  'cancel_orders', context)!),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                RouteHelper.getWalletRoute(
                                                    true));
                                            // Navigator.pushNamed(context, RouteHelper.getWalletRoute(false));
                                          },
                                          child: profileTile(
                                              Images.shreeWalletIcon,
                                              getTranslated(
                                                  'shree_wallet', context)!),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, RouteHelper.address);
                                          },
                                          child: profileTile(
                                              Images.addressIcon,
                                              getTranslated(
                                                  'addresses', context)!),
                                        ),

                                        // InkWell(
                                        //   onTap: () {
                                        //     // Navigator.pushNamed(context, RouteHelper.ratingReviews);
                                        //   },
                                        //   child: profileTile(
                                        //       Images.rateReviewIcon,
                                        //       getTranslated(
                                        //           'rating_review', context)!),
                                        // ),

                                        // InkWell(
                                        //   onTap: () => Navigator.pushNamed(
                                        //       context,
                                        //       RouteHelper.getChatRoute(
                                        //           orderModel: null)),
                                        //   child: profileTile(
                                        //       Images.supportIcon,
                                        //       getTranslated(
                                        //           'support', context)!),
                                        // ),

                                        // InkWell(
                                        //   onTap: () {
                                        //     // Navigator.pushNamed(context, RouteHelper.savedPayments);
                                        //   },
                                        //   child: profileTile(
                                        //       Images.savedPaymentsIcon,
                                        //       getTranslated(
                                        //           'saved_payments', context)!),
                                        // ),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RouteHelper.notification);
                                          },
                                          child: profileTile(
                                              Images.notificationsIcon,
                                              getTranslated(
                                                  'notifications', context)!),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RouteHelper.referAndEarn);
                                          },
                                          child: profileTile(
                                              Images.referEarnIcon,
                                              getTranslated(
                                                  'refer_earn', context)!),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                )
              : const NotLoggedInScreen()),
    );
  }

  Widget profileTile(String tileIcon, String tileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE3F1CD),
            minRadius: 25,
            child: Image.asset(tileIcon,
                height: 24, width: 24, fit: BoxFit.contain),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(tileName,
              style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.w500, fontSize: 16)),
        ],
      ),
    );
  }
}
