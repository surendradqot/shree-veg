import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/view/base/app_bar_base.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/not_login_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/order/widget/order_button.dart';
import 'package:shreeveg/view/screens/order/widget/order_view.dart';
import 'package:provider/provider.dart';

class CancelOrderScreen extends StatelessWidget {
  const CancelOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
    Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? CustomAppBar(title: 'Cancel Order', backgroundColor: Theme.of(context).primaryColor, buttonTextColor: Colors.white)
          : (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
          preferredSize: Size.fromHeight(120), child: WebAppBar())
          : const AppBarBase()) as PreferredSizeWidget?,
      body: SafeArea(
        child: isLoggedIn
            ? Scrollbar(
          child: Center(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) =>
              orderProvider.runningOrderList != null
                  ? Column(
                children: [
                  SizedBox(
                    width: 1170,
                    child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeSmall),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          OrderButton(
                              title: 'cancel_me'.tr,
                              isCancelled: true, isActive: null),
                          const SizedBox(
                              width:
                              Dimensions.paddingSizeSmall),
                          OrderButton(
                              title: 'cancel_by'.tr,
                              isCancelled: false, isActive: null),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: OrderView(
                          isRunning: null, isCancelMe: orderProvider.isCancelByMe
                          ? true
                          : false))
                ],
              )
                  : Center(
                  child: CustomLoader(
                      color: Theme.of(context).primaryColor)),
            ),
          ),
        )
            : const NotLoggedInScreen(),
      ),
    );
  }
}
// Provider.of<OrderProvider>(context, listen: false).runningOrderList != null ? ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox() : SizedBox(),