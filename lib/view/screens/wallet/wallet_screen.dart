import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/wallet_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/not_login_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../helper/route_helper.dart';

class WalletScreen extends StatefulWidget {
  final bool fromWallet;
  const WalletScreen({Key? key, required this.fromWallet}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final bool _isLoggedIn =
      Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

  final List<int> radioValues = [100, 500, 1000, 5000, 10000];

  @override
  void initState() {
    super.initState();
  }

  TextStyle commonStyle = poppinsRegular.copyWith(
      fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeSmall);

  TextStyle headerStyle = poppinsRegular.copyWith(
      fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeExtraSmall);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context)
            .primaryColor
            .withOpacity(widget.fromWallet ? 1 : 0.2),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
                preferredSize: Size.fromHeight(100), child: WebAppBar())
            : CustomAppBar(
                title: 'ShreeVeg Wallet',
                backgroundColor: Theme.of(context).primaryColor,
                buttonTextColor: Colors.white,
                actions: [
                  IconButton(
                      onPressed: () => Navigator.pushNamed(
                          context, RouteHelper.walletHistory),
                      icon: const Icon(
                        Icons.watch_later_outlined,
                        color: Colors.white,
                      ))
                ],
              ) as PreferredSizeWidget,
        body: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
          return _isLoggedIn
              ? profileProvider.userInfoModel != null
                  ? SafeArea(
                      child: Consumer<WalletProvider>(
                          builder: (context, walletProvider, _) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            walletProvider.getLoyaltyTransactionList(
                                '1', true, widget.fromWallet,
                                isEarning:
                                    walletProvider.selectedTabButtonIndex == 1);
                            profileProvider.getUserInfo();
                          },
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeDefault),
                              child: Column(
                                children: [
                                  Center(
                                    child: Container(
                                      width: Dimensions.webScreenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSizeDefault),
                                        color: const Color(0xFFF2F2F2),
                                      ),
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeExtraLarge),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            widget.fromWallet
                                                ? Images.shreeWallet
                                                : Images.loyal,
                                            width: 60,
                                            height: 60,
                                          ),
                                          const SizedBox(
                                            width:
                                                Dimensions.paddingSizeDefault,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    widget.fromWallet
                                                        ? 'shree_balance'
                                                        : 'withdrawable_point',
                                                    context)!,
                                                style: poppinsBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Colors.black),
                                              ),
                                              CustomDirectionality(
                                                  child: Text(
                                                widget.fromWallet
                                                    ? PriceConverter.convertPrice(
                                                        context,
                                                        profileProvider
                                                                .userInfoModel!
                                                                .userInfo!.walletBalance!.toDouble() ??
                                                            0)
                                                    : '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.userInfo!.points ?? 0}',
                                                style: poppinsBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeOverLarge,
                                                    color: Colors.black),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  Text(
                                      getTranslated(
                                          'use_shree_wallet', context)!,
                                      style: poppinsRegular.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: const Color(0xFF5A5A5A))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.paddingSizeDefault),
                                    child: Row(
                                      children: [
                                        Text(
                                            getTranslated(
                                                'add_money', context)!,
                                            style: poppinsRegular.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: Dimensions.webScreenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSizeDefault),
                                        color: const Color(0xFFF2F2F2),
                                      ),
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeDefault),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          walletProvider.selectedMoneyTab !=
                                                  null
                                              ? Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        addMoney(walletProvider
                                                            .selectedMoneyTab!),
                                                        bonusMoney(walletProvider
                                                            .selectedMoneyTab!),
                                                        totalMoney(walletProvider
                                                            .selectedMoneyTab!)
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 2,
                                                      color: Colors.black,
                                                    )
                                                  ],
                                                )
                                              : const SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .paddingSizeDefault),
                                            child: Wrap(
                                                spacing: 15,
                                                children: List.generate(
                                                    3,
                                                    (index) => moneyTab(index,
                                                        walletProvider))),
                                          ),
                                          CustomButton(
                                              borderRadius: Dimensions
                                                  .radiusSizeExtraSmall,
                                              buttonText: getTranslated(
                                                  'add_money', context),
                                              onPressed: () {
                                                print('add money');
                                                if (walletProvider
                                                        .selectedMoneyTab !=
                                                    null) {
                                                  Navigator.pushNamed(
                                                      context,
                                                      RouteHelper
                                                          .getRazorpayPaymentRoute(
                                                        type: 'Wallet Topup',
                                                        userId: Provider.of<
                                                                    ProfileProvider>(
                                                                context,
                                                                listen: false)
                                                            .userInfoModel!
                                                            .userInfo!.id
                                                            .toString(),
                                                        amount: walletProvider
                                                            .selectedMoneyTab
                                                            .toString(),
                                                        phone: Provider.of<
                                                                    ProfileProvider>(
                                                                context,
                                                                listen: false)
                                                            .userInfoModel!
                                                            .userInfo!.phone
                                                            .toString(),
                                                        email: Provider.of<
                                                                    AuthProvider>(
                                                                context,
                                                                listen: false)
                                                            .getUserEmailOrPhone(),
                                                      )).then((value) {
                                                    print(
                                                        'payment result is::::::::::: $value');
                                                    dynamic paymentResult =
                                                        value;
                                                    String? paymentId;
                                                    if (paymentResult is Map<
                                                        String, dynamic>) {
                                                      paymentId = paymentResult[
                                                          'paymentId'];
                                                    }
                                                    print(
                                                        'payment id is:: $paymentId');
                                                    if (paymentId != null) {
                                                      ToastService().show(
                                                          "Wallet recharge successful");

                                                      Future.delayed(
                                                          Duration.zero,
                                                          () => Navigator.pushNamed(
                                                              context,
                                                              RouteHelper
                                                                  .walletHistory));
                                                    }
                                                  });
                                                } else {
                                                  ToastService().show(
                                                      'Please select money to add in wallet');
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Add Money', style: headerStyle),
                                      Row(
                                        children: [
                                          Text('Bonus   ', style: headerStyle),
                                          Text('Total Money  ',
                                              style: headerStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeExtraSmall),
                                  Center(
                                    child: Container(
                                      width: Dimensions.webScreenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSizeDefault),
                                        color: const Color(0xFFF2F2F2),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.paddingSizeDefault),
                                      child: Column(
                                        children: radioValues.map((value) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Radio<int>(
                                                    activeColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    value: value,
                                                    groupValue: walletProvider
                                                        .selectedMoneyTab,
                                                    onChanged: (int?
                                                            selected) =>
                                                        walletProvider
                                                            .setSelectedMoneyTab(
                                                                selected!),
                                                  ),
                                                  Text(
                                                      'Add $value and Get ${value.toInt() ~/ 10} Extra',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      '${value.toInt() ~/ 10}₹',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraLarge,
                                                  ),
                                                  Text(
                                                      '${(value.toInt() ~/ 10) + value.toInt()}₹',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  : Center(
                      child:
                          CustomLoader(color: Theme.of(context).primaryColor))
              : const NotLoggedInScreen();
        }),
      ),
    );
  }

  Widget addMoney(int? money) {
    return money != null
        ? Text('₹${money.toInt()}',
            style: poppinsRegular.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: Dimensions.fontSizeExtraLarge))
        : const SizedBox();
  }

  Widget bonusMoney(int? money) {
    return money != null
        ? Column(
            children: [
              Text('Bonus', style: commonStyle),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall,
                      vertical: 3),
                  child: Center(
                      child: Text('+${money ~/ 10}₹', style: commonStyle)),
                ),
              ),
              const SizedBox(
                height: 4,
              )
            ],
          )
        : const SizedBox();
  }

  Widget totalMoney(int? money) {
    return money != null
        ? Column(
            children: [
              Text('Total', style: commonStyle),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall,
                      vertical: 3),
                  child: Center(
                      child: Text('${(money + (money ~/ 10)).toInt()}₹',
                          style: commonStyle)),
                ),
              ),
              const SizedBox(
                height: 4,
              )
            ],
          )
        : const SizedBox();
  }

  Widget moneyTab(int index, WalletProvider walletProvider) {
    int fixedMoney = 2000;
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall),
      child: InkWell(
        onTap: () =>
            walletProvider.setSelectedMoneyTab(fixedMoney + (index * 1000)),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius:
                  BorderRadius.circular(Dimensions.radiusSizeExtraSmall)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
            child: Text(
              '+ ₹${(fixedMoney + (index * 1000)).toInt()}',
              style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.fontSizeDefault),
            ),
          ),
        ),
      ),
    );
  }
}

class TabButtonModel {
  final String? buttonText;
  final String buttonIcon;
  final Function onTap;

  TabButtonModel(this.buttonText, this.buttonIcon, this.onTap);
}

class WalletShimmer extends StatelessWidget {
  final WalletProvider walletProvider;
  const WalletShimmer({Key? key, required this.walletProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 50,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context)
            ? Dimensions.paddingSizeLarge
            : 0.01,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4.6 : 3.0,
        crossAxisCount: ResponsiveHelper.isMobile() ? 1 : 2,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      padding:
          EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 24),
      itemBuilder: (context, index) {
        return Container(
          margin:
              const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.08))),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeSmall,
              horizontal: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: walletProvider.transactionList == null,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 10,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 10),
                          Container(
                              height: 10,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 10),
                          Container(
                              height: 10,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 12,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 10),
                          Container(
                              height: 10,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                        ]),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeDefault),
                    child: Divider(color: Theme.of(context).disabledColor)),
              ],
            ),
          ),
        );
      },
    );
  }
}
