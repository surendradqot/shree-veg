import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/not_login_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'widget/refer_hint_view.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final List<String> shareItem = [
    'messenger',
    'whatsapp',
    'gmail',
    'viber',
    'share'
  ];
  final List<String?> hintList = [
    getTranslated('invite_your_friends', Get.context!),
    '${getTranslated('they_register', Get.context!)} ${AppConstants.appName} ${getTranslated('with_special_offer', Get.context!)}',
    getTranslated('you_made_your_earning', Get.context!),
  ];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(
              title: 'Invite Friends',
              backgroundColor: Theme.of(context).primaryColor,
              buttonTextColor: Colors.white) as PreferredSizeWidget,
      body: _isLoggedIn
          ? Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
              return profileProvider.userInfoModel != null
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          child: Image.asset(Images.referTopBanner,
                              height: size.height * 0.35),
                        ),
                        Expanded(
                          child: DetailsView(
                              size: size,
                              shareItem: shareItem,
                              hintList: hintList),
                        ),
                      ],
                    )
                  : CustomLoader(color: Theme.of(context).primaryColor);
            })
          : const NotLoggedInScreen(),
    );
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({
    Key? key,
    required Size size,
    required this.shareItem,
    required this.hintList,
  })  : _size = size,
        super(key: key);

  final Size _size;
  final List<String> shareItem;
  final List<String?> hintList;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return profileProvider.userInfoModel != null
          ? Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    Text(
                      getTranslated('invite_friend_and_businesses', context)!,
                      textAlign: TextAlign.center,
                      style: poppinsMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    ),
                    Text(
                      getTranslated('copy_your_code', context)!,
                      textAlign: TextAlign.center,
                      style: poppinsRegular.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeExtraLarge,
                    ),
                    DottedBorder(
                      padding: const EdgeInsets.all(4),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(25),
                      dashPattern: const [5, 5],
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      strokeWidth: 2,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Text(
                                profileProvider.userInfoModel!.userInfo!.referralCode
                                        ?.toUpperCase() ??
                                    '',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                if (profileProvider.userInfoModel!.userInfo!.referralCode !=
                                        null &&
                                    profileProvider.userInfoModel!.userInfo!.referralCode !=
                                        '') {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.userInfo!.referralCode : ''}'));
                                  ToastService().show(getTranslated(
                                      'referral_code_copied', context)!);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.copy,
                                    color: const Color(0xFF636363)),
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeExtraLarge,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child:
                          Text(getTranslated('invite_phone_contacts', context)!,
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge,
                                color: Colors.white.withOpacity(0.9),
                              )),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeExtraLarge,
                    ),
                    Text(
                      getTranslated('or_share', context)!,
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: shareItem
                          .map((item) => InkWell(
                                onTap: () {
                                  String shareText =
                                      'Hey, I\'m using ShreeVeg App to purchase daily fresh fruits and vegetables at cheaper prices than market and earn lot of referral money to purchase again. Please use my referral code and get bonus: ${profileProvider.userInfoModel!.userInfo!.referralCode!}';
                                  Share.share(shareText);
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                    child: Image.asset(
                                      Images.getShareIcon(item),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            )
          : const SizedBox();
    });
  }
}
