import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:provider/provider.dart';

import 'footer_view.dart';

class NoDataScreen extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isProfile;
  final bool isSearch;
  final String? title;
  const NoDataScreen(
      {super.key,
      this.isCart = false,
      this.isOrder = false,
      this.isProfile = false,
      this.isSearch = false,
      this.title});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ResponsiveHelper.isDesktop(context)
        ? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: height * 0.7,
                    width: double.infinity,
                    child: view(context, height)),
                !isSearch ? const FooterView() : const SizedBox(),
              ],
            ),
          )
        : view(context, height);
  }

  Widget view(BuildContext context, double height) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            isOrder
                ? Images.box
                : isCart
                    ? Images.shoppingCart
                    : Images.notFound,
            width: height * 0.17,
            height: height * 0.17,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: height * 0.03),
          Text(
            title != null
                ? title!
                : isOrder
                    ? 'no_order_history'.tr
                    : isCart
                        ? 'empty_shopping_bag'.tr
                        : isProfile
                            ? 'no_address_found'.tr
                            : 'no_result_found'.tr,
            style: poppinsMedium.copyWith(
                color: Theme.of(context).primaryColor, fontSize: height * 0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.01),
          Text(
            isOrder
                ? 'buy_something_to_see'.tr
                : isCart
                    ? 'look_like_you_have_not_added'.tr
                    : '',
            style: poppinsRegular.copyWith(fontSize: height * 0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.01),
          // SizedBox(
          //   height: 40,
          //   width: 150,
          //   child: CustomButton(
          //     buttonText: 'lets_shop'.tr,
          //     onPressed: () {
          //       Provider.of<SplashProvider>(context, listen: false)
          //           .setCurrentPageIndex(0);
          //       // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MenuScreen()), (route) => false);
          //       Navigator.pushNamedAndRemoveUntil(
          //           context, RouteHelper.main, (route) => false);
          //     },
          //   ),
          // ),
        ]),
      ),
    );
  }
}
