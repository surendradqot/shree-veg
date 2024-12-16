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

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? CustomAppBar(title: 'Order History', backgroundColor: Theme.of(context).primaryColor, buttonTextColor: Colors.white)
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
                                              title: 'active'.tr,
                                              isActive: true, isCancelled: null),
                                          const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeSmall),
                                          OrderButton(
                                              title: 'past_order'.tr,
                                              isActive: false, isCancelled: null),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: OrderView(
                                          isRunning: orderProvider.isActiveOrder
                                              ? true
                                              : false, isCancelMe: null))
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




