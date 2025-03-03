import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/order_model.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/order/widget/custom_stepper.dart';
import 'package:shreeveg/view/screens/order/widget/delivery_man_widget.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/order/widget/tracking_map_widget.dart';

class TrackOrderScreen extends StatelessWidget {
  final String? orderID;
  final bool isBackButton;
  final OrderModel? orderModel;
  const TrackOrderScreen(
      {Key? key,
      required this.orderID,
      this.isBackButton = false,
      this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).initAddressList();
    Provider.of<OrderProvider>(context, listen: false)
        .getDeliveryManData(orderID, context);
    Provider.of<OrderProvider>(context, listen: false)
        .trackOrder(orderID, orderModel, context, true);
    final List<String> statusList = [
      'pending',
      'confirmed',
      'processing',
      'out_for_delivery',
      'delivered',
      'returned',
      'failed',
      'canceled'
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: getTranslated('track_order', context),
              isCenter: false,
              onBackPressed: () {
                if (isBackButton) {
                  Provider.of<SplashProvider>(context, listen: false)
                      .setPageIndex(0);
                  Navigator.pushNamed(context, RouteHelper.main);
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MenuScreen()));
                } else {
                  Navigator.of(context).pop();
                }
              },
              backgroundColor: AppConstants.primaryColor,
              buttonTextColor: Colors.white,
            )) as PreferredSizeWidget?,
      body: Center(
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            String? status;
            if (orderProvider.trackModel != null) {
              status = orderProvider.trackModel!.orderStatus;
            }

            return orderProvider.trackModel != null
                ? ListView(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 1170,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.isDesktop(context)
                                    ? 50
                                    : 5,
                                horizontal: ResponsiveHelper.isDesktop(context)
                                    ? 200
                                    : 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.paddingSizeExtraSmall),
                                    color: Theme.of(context).cardColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[
                                              Provider.of<ThemeProvider>(
                                                          context)
                                                      .darkTheme
                                                  ? 700
                                                  : 200]!,
                                          spreadRadius: 0.5,
                                          blurRadius: 0.5)
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            '${getTranslated('order_id', context)} #${orderProvider.trackModel!.id}',
                                            style: poppinsMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge)),
                                      ),
                                      CustomDirectionality(
                                          child: Text(
                                        '${getTranslated('amount', context)}${PriceConverter.convertPrice(context, orderProvider.trackModel!.orderAmount)}',
                                        style: poppinsRegular,
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                CustomStepper(
                                    title:
                                        getTranslated('order_placed', context),
                                    isActive: true,
                                    time: orderProvider.trackModel!.placedAt,
                                    haveTopBar: false),
                                status == statusList[0]
                                    ? CustomStepper(
                                        title: getTranslated(
                                            'order_pending', context),
                                        time: orderProvider
                                            .trackModel!.pendingTime,
                                        isActive: status != statusList[0])
                                    : const SizedBox(),
                                CustomStepper(
                                    title: getTranslated(
                                        'order_accepted', context),
                                    time:
                                        orderProvider.trackModel!.confirmedTime,
                                    isActive: status != statusList[0]),
                                CustomStepper(
                                    title: getTranslated(
                                        'preparing_items', context),
                                    time: orderProvider
                                        .trackModel!.processingTime,
                                    isActive: status != statusList[0] &&
                                        status != statusList[1]),
                                CustomStepper(
                                  title: getTranslated(
                                      'order_in_the_way', context),
                                  time:
                                      orderProvider.trackModel!.deliveryOutTime,
                                  isActive: status != statusList[0] &&
                                      status != statusList[1] &&
                                      status != statusList[2],
                                ),
                                (orderProvider.trackModel != null &&
                                        orderProvider
                                                .trackModel!.deliveryAddress !=
                                            null)
                                    ? CustomStepper(
                                        title: getTranslated(
                                            'delivered_the_order', context),
                                        isActive: status == statusList[4],
                                        time: orderProvider
                                            .trackModel!.deliveredTime,
                                        height:
                                            status == statusList[3] ? 170 : 30,
                                        child: status == statusList[3]
                                            ? Flexible(
                                                child: TrackingMapWidget(
                                                    deliveryManModel:
                                                        orderProvider
                                                            .deliveryManModel,
                                                    orderID: orderID,
                                                    branchID: orderProvider
                                                        .trackModel!.branchId,
                                                    addressModel: orderProvider
                                                            .trackModel!
                                                            .deliveryAddress ??
                                                        '' as DeliveryAddress),
                                              )
                                            : null,
                                      )
                                    : CustomStepper(
                                        title: getTranslated(
                                            'delivered_the_order', context),
                                        isActive: status == statusList[4],
                                        time: orderProvider
                                            .trackModel!.deliveredTime,
                                        height:
                                            status == statusList[3] ? 30 : 30,
                                      ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                orderProvider.orderType != 'self_pickup'
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeLarge,
                                            horizontal:
                                                Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeExtraSmall),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[
                                                    Provider.of<ThemeProvider>(
                                                                context)
                                                            .darkTheme
                                                        ? 700
                                                        : 200]!,
                                                spreadRadius: 0.5,
                                                blurRadius: 0.5)
                                          ],
                                        ),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.location_on,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: Text(
                                                  orderProvider.trackModel!
                                                              .deliveryAddress !=
                                                          null
                                                      ? orderProvider
                                                          .trackModel!
                                                          .deliveryAddress!
                                                          .address!
                                                      : getTranslated(
                                                          'address_was_deleted',
                                                          context)!,
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color
                                                                  ?.withOpacity(
                                                                      0.6)),
                                                ),
                                              ),
                                            ]),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                orderProvider.trackModel!.deliveryMan != null
                                    ? DeliveryManWidget(
                                        deliveryMan: orderProvider
                                            .trackModel!.deliveryMan)
                                    : const SizedBox(),
                                orderProvider.trackModel!.deliveryMan != null
                                    ? const SizedBox(height: 30)
                                    : const SizedBox(),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                ResponsiveHelper.isDesktop(context)
                                    ? const SizedBox(height: 100)
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ResponsiveHelper.isDesktop(context)
                          ? const FooterView()
                          : const SizedBox(),
                    ],
                  )
                : Center(
                    child: CustomLoader(color: Theme.of(context).primaryColor));
          },
        ),
      ),
    );
  }
}
