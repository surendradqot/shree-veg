import 'package:flutter/material.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/onboarding_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/screens/auth/login_screen.dart';
import 'package:shreeveg/view/screens/onboarding/widget/on_boarding_widget.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/splash/splash_screen.dart';

import '../../../main.dart';
import '../../../provider/auth_provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false)
        .getBoardingList(context);

    return Scaffold(
      body: SafeArea(
        child: Consumer<OnBoardingProvider>(
          builder: (context, onBoarding, child) {
            return onBoarding.onBoardingList.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .disableIntro();
                              Navigator.of(context).pushReplacementNamed(
                                  RouteHelper.login,
                                  arguments: const LoginScreen());
                            },
                            child: Text(
                              onBoarding.selectedIndex !=
                                      onBoarding.onBoardingList.length - 1
                                  ? getTranslated('skip', context)!
                                  : '',
                              style: poppinsSemiBold.copyWith(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: PageView.builder(
                          itemCount: onBoarding.onBoardingList.length,
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraLarge),
                              child: OnBoardingWidget(
                                  onBoardingModel:
                                      onBoarding.onBoardingList[index]),
                            );
                          },
                          onPageChanged: (index) =>
                              onBoarding.setSelectIndex(index),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _pageIndicators(
                              onBoarding.onBoardingList, context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraLarge),
                        child: Stack(children: [
                          onBoarding.selectedIndex ==
                                  onBoarding.onBoardingList.length - 1
                              ? Container()
                              : Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                      value: (onBoarding.selectedIndex + 1) /
                                          onBoarding.onBoardingList.length,
                                    ),
                                  ),
                                ),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                if (onBoarding.selectedIndex ==
                                    onBoarding.onBoardingList.length - 1) {
                                  // Provider.of<SplashProvider>(context,
                                  //         listen: false)
                                  //     .disableIntro();
                                  // Navigator.of(context).pushReplacementNamed(
                                  //     RouteHelper.login,
                                  //     arguments: const LoginScreen());
                                } else {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeIn);
                                }
                              },
                              child: onBoarding.selectedIndex ==
                                      onBoarding.onBoardingList.length - 1
                                  ? Column(
                                      children: [
                                        CustomButton(
                                          buttonText: getTranslated(
                                              'login_signup', context),
                                          onPressed: () {
                                            Provider.of<SplashProvider>(context,
                                                    listen: false)
                                                .disableIntro();
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    RouteHelper.login,
                                                    arguments:
                                                        const LoginScreen());
                                          },
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await Provider.of<AuthProvider>(
                                                    Get.context!,
                                                    listen: false)
                                                .loginGuest();
                                            Navigator.of(Get.context!)
                                                .pushReplacementNamed(
                                                    RouteHelper.splash,
                                                    arguments:
                                                        const SplashScreen());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeDefault),
                                            child: Text(
                                                getTranslated(
                                                    'as_a_guest', context)!,
                                                style: poppinsMedium.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(
                                                        0xFF002C9D))),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: Icon(
                                        onBoarding.selectedIndex ==
                                                onBoarding
                                                        .onBoardingList.length -
                                                    1
                                            ? Icons.check
                                            : Icons.navigate_next,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context).selectedIndex
              ? 25
              : 10,
          height: 10,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: i == Provider.of<OnBoardingProvider>(context).selectedIndex
                ? Theme.of(context).primaryColor
                : ColorResources.getGreyColor(context),
            borderRadius:
                i == Provider.of<OnBoardingProvider>(context).selectedIndex
                    ? BorderRadius.circular(50)
                    : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return indicators;
  }
}
