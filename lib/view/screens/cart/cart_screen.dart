import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/config_model.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/coupon_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/app_bar_base.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/cart/widget/cart_product_widget.dart';
import 'package:provider/provider.dart';
import '../../../data/model/body/place_order_body.dart';
import '../../../main.dart';
import '../../../provider/location_provider.dart';
import '../../../utill/images.dart';
import '../../../utill/modify_date_times.dart';
import '../../base/custom_dialog.dart';
import '../checkout/checkout_screen.dart';
import '../checkout/order_successful_screen.dart';
import '../checkout/widget/digital_payment_view.dart';
import '../checkout/widget/offline_payment_dialog.dart';
import '../home/widget/location_view.dart';
import 'widget/cart_details_view.dart';
import 'dart:developer';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    _couponController.clear();
    // Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);

    Provider.of<OrderProvider>(context, listen: false)
        .setAddressIndex(0, notify: false);

    // if (Provider.of<SplashProvider>(context, listen: false)
    //         .configModel!
    //         .cashOnDelivery ==
    //     'true') {
    //   _paymentList.add('cash_on_delivery');
    // }
    //
    // if (Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .offlinePayment!) {
    //   _paymentList.add('offline_payment');
    // }
    //
    // if (Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .walletStatus!) {
    //   _paymentList.add('wallet_payment');
    // }
    //
    // for (var method in Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .activePaymentMethodList!) {
    //   if (!_paymentList.contains(method)) {
    //     _paymentList.add(method);
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    bool isSelfPickupActive = configModel.selfPickup == 1;
    bool kmWiseCharge = configModel.deliveryManagement!.status!;

    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? AppBar(
        title: Text(getTranslated('my_cart', context)!,style: poppinsMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color:
            Colors.white)),
      )
          : (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : const AppBarBase()) as PreferredSizeWidget?,
      body: Center(
        child: Consumer<CouponProvider>(builder: (context, couponProvider, _) {
          return Consumer<CartProvider>(
            builder: (context, cart, child) {
              double? deliveryCharge = 0;
              (Provider.of<OrderProvider>(context).orderType == 'delivery' &&
                      !kmWiseCharge)
                  ? deliveryCharge = configModel.deliveryCharge
                  : deliveryCharge = 0;

              if (couponProvider.couponType == 'free_delivery') {
                deliveryCharge = 0;
              }

              double itemPrice = 0;
              double marketPrice = 0;
              double shreePrice = 0;
              double discount = 0;
              double tax = 0;
              String? unit = '';
              double totalWeight = 0;
              for (var cartModel in cart.cartList) {
                itemPrice =
                    itemPrice + (cartModel.price! * cartModel.quantity!);
                marketPrice = marketPrice +
                    (cartModel.variation!.marketPrice! * cartModel.quantity!);
                shreePrice = shreePrice +
                    (double.parse(cartModel.variation!.offerPrice!) *
                        cartModel.quantity!);
                discount =
                    discount + (cartModel.discount! * cartModel.quantity!);
                tax = tax + (cartModel.tax! * cartModel.quantity!);
                unit = cartModel.product!.unit;
                totalWeight = totalWeight +
                    (cartModel.quantity! *
                        int.parse((cartModel.variation?.quantity!)!));
              }

              double subTotal =
                  itemPrice + (configModel.isVatTexInclude! ? 0 : tax);
              bool isFreeDelivery =
                  subTotal >= configModel.freeDeliveryOverAmount! &&
                          configModel.freeDeliveryStatus! ||
                      couponProvider.couponType == 'free_delivery';

              double total = subTotal -
                  discount -
                  Provider.of<CouponProvider>(context).discount! +
                  (isFreeDelivery ? 0 : deliveryCharge!);

              return cart.cartList.isNotEmpty
                  ? !ResponsiveHelper.isDesktop(context)
                      ? Column(children: [
                          const LocationView(locationColor: Colors.black54),
                          Expanded(
                              child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall,
                            ),
                            child: Center(
                                child: SizedBox(
                              width: Dimensions.webScreenWidth,
                              child: Column(children: [
                                // Product
                                const CartProductListView(),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),

                                CartDetailsView(
                                  couponController: _couponController,
                                  total: total,
                                  unit: unit!,
                                  totalWeight: totalWeight,
                                  isSelfPickupActive: isSelfPickupActive,
                                  kmWiseCharge: kmWiseCharge,
                                  isFreeDelivery: isFreeDelivery,
                                  itemPrice: itemPrice,
                                  totalMarketPrice: marketPrice,
                                  totalShreePrice: shreePrice,
                                  tax: tax,
                                  discount: discount,
                                  deliveryCharge: deliveryCharge!,
                                ),
                                const SizedBox(height: 40),
                                const CartDeliveryTimeSlot(),
                                // PaymentOptions(paymentList: _paymentList),
                                const DeliveryLocationView(
                                    locationColor: Colors.black54),
                              ]),
                            )),
                          )),
                          CartButtonView(
                            subTotal: subTotal,
                            configModel: configModel,
                            itemPrice: itemPrice,
                            total: total,
                            isFreeDelivery: isFreeDelivery,
                          ),
                        ])
                      : SingleChildScrollView(
                          child: Column(children: [
                          Center(
                              child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: ResponsiveHelper.isDesktop(context)
                                  ? MediaQuery.of(context).size.height - 560
                                  : MediaQuery.of(context).size.height,
                            ),
                            child: SizedBox(
                                width: 1170,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeLarge),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: CartProductListView()),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey[
                                                        Provider.of<ThemeProvider>(
                                                                    context)
                                                                .darkTheme
                                                            ? 900
                                                            : 300]!,
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  )
                                                ],
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeSmall,
                                              ).copyWith(
                                                      bottom: Dimensions
                                                          .paddingSizeLarge),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeLarge,
                                                vertical:
                                                    Dimensions.paddingSizeLarge,
                                              ),
                                              child: CartDetailsView(
                                                couponController:
                                                    _couponController,
                                                total: total,
                                                isSelfPickupActive:
                                                    isSelfPickupActive,
                                                kmWiseCharge: kmWiseCharge,
                                                isFreeDelivery: isFreeDelivery,
                                                itemPrice: itemPrice,
                                                totalMarketPrice: marketPrice,
                                                totalShreePrice: shreePrice,
                                                tax: tax,
                                                unit: unit!,
                                                totalWeight: totalWeight,
                                                discount: discount,
                                                deliveryCharge: deliveryCharge!,
                                              ),
                                            ),
                                            const CartDeliveryTimeSlot(),
                                            // PaymentOptions(
                                            //     paymentList: _paymentList),
                                            const DeliveryLocationView(
                                                locationColor: Colors.black54),
                                            CartButtonView(
                                              subTotal: subTotal,
                                              configModel: configModel,
                                              itemPrice: itemPrice,
                                              total: total,
                                              isFreeDelivery: isFreeDelivery,
                                            ),
                                          ]))
                                    ],
                                  ),
                                )),
                          )),
                          const FooterView(),
                        ]))
                  : const NoDataScreen(isCart: true);
            },
          );
        }),
      ),
    );
  }
}

class CartDeliveryTimeSlot extends StatelessWidget {
  const CartDeliveryTimeSlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      int deliverySlotRows = 0;
      return Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          int timeSlotsLength = 0;
          if(profileProvider.userInfoModel!=null && profileProvider.userInfoModel!.deliveryTime!.isNotEmpty){
            int timeSlotsLength =
                profileProvider.userInfoModel!.deliveryTime!.length;
            print('time slots length is: $timeSlotsLength');
            if (timeSlotsLength.isEven) {
              deliverySlotRows = timeSlotsLength ~/ 2;
            } else {
              deliverySlotRows = (timeSlotsLength ~/ 2) + 1;
            }
          }
          return profileProvider.userInfoModel!=null && profileProvider.userInfoModel!.deliveryTime!.isNotEmpty?Column(
            children: [
              Row(
                children: [
                  Image.asset(Images.deliveryVan,
                      height: 20, width: 24, fit: BoxFit.fill),
                  const SizedBox(
                    width: Dimensions.paddingSizeExtraSmall,
                  ),
                  Text(
                    getTranslated('select_delivery_slot', context)!,
                    style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              const SizedBox(
                height: Dimensions.paddingSizeSmall,
              ),
              SizedBox(
                height: (70 * deliverySlotRows).toDouble(),
                child: Wrap(
                    children: List.generate(
                        timeSlotsLength,
                        (index) => InkWell(
                              onTap: () {
                                if (isSlotEnabled(profileProvider.userInfoModel!
                                    .deliveryTime![index].open!)) {
                                  cartProvider.updateSelectedDeliveryTimeSlot(
                                      '${profileProvider.userInfoModel!.deliveryTime![index].open} - ${profileProvider.userInfoModel!.deliveryTime![index].close}');
                                } else {
                                  ToastService().show(
                                      'Time slot closed at: ${getFormattedTimes(profileProvider.userInfoModel!.deliveryTime![index].open!, profileProvider.userInfoModel!.deliveryTime![index].close!, true, int.parse(profileProvider.userInfoModel!.deliveryTime![index].hideOptionBefore!))}');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: cartProvider
                                                      .selectedDeliveryTimeSlot !=
                                                  null &&
                                              cartProvider
                                                      .selectedDeliveryTimeSlot ==
                                                  '${profileProvider.userInfoModel!.deliveryTime![index].open} - ${profileProvider.userInfoModel!.deliveryTime![index].close}' &&
                                              isSlotEnabled(profileProvider
                                                  .userInfoModel!
                                                  .deliveryTime![index]
                                                  .open!)
                                          ? const Color(
                                              0xFFF1FFF4) // Color if the slot is both selected and enabled
                                          : isSlotEnabled(profileProvider
                                                  .userInfoModel!
                                                  .deliveryTime![index]
                                                  .open!)
                                              ? Colors
                                                  .grey // Color if the slot is enabled but not selected
                                              : Colors.grey.shade200,
                                      border: Border.all(
                                        width: 1,
                                        color: cartProvider
                                                        .selectedDeliveryTimeSlot !=
                                                    null &&
                                                cartProvider
                                                        .selectedDeliveryTimeSlot ==
                                                    '${profileProvider.userInfoModel!.deliveryTime![index].open} - ${profileProvider.userInfoModel!.deliveryTime![index].close}' &&
                                                isSlotEnabled(profileProvider
                                                    .userInfoModel!
                                                    .deliveryTime![index]
                                                    .open!)
                                            ? const Color(
                                                0xFF039800) // Color if the slot is both selected and enabled
                                            : isSlotEnabled(profileProvider
                                                    .userInfoModel!
                                                    .deliveryTime![index]
                                                    .open!)
                                                ? Colors
                                                    .grey // Color if the slot is enabled but not selected
                                                : Colors.grey.shade300,
                                      )), // Default color (blue) if the slot is not enabled),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    child: Column(
                                      children: [
                                        Text(
                                            getTimePeriod(profileProvider
                                                .userInfoModel!
                                                .deliveryTime![index]
                                                .open!),
                                            style: poppinsRegular.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                        Text(
                                            getFormattedTimes(
                                                profileProvider.userInfoModel!
                                                    .deliveryTime![index].open!,
                                                profileProvider.userInfoModel!
                                                    .deliveryTime![index].close!,
                                                false,
                                                0),
                                            style: poppinsRegular.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))),
              ),
              const SizedBox(
                height: Dimensions.paddingSizeSmall,
              ),
            ],
          ):SizedBox();
        },
      );
    });
  }
}

// class PaymentOptions extends StatelessWidget {
//   final List<String> paymentList;
//   const PaymentOptions({Key? key, required this.paymentList}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           getTranslated('select_payment_mode', context)!,
//           style: poppinsRegular.copyWith(
//               fontSize: Dimensions.fontSizeLarge,
//               fontWeight: FontWeight.w500,
//               color: Colors.black),
//         ),
//         DigitalPaymentView(paymentList: paymentList),
//       ],
//     );
//   }
// }

class CartButtonView extends StatelessWidget {
  const CartButtonView({
    Key? key,
    required double subTotal,
    required ConfigModel configModel,
    required double itemPrice,
    required double total,
    required bool isFreeDelivery,
  })  : _subTotal = subTotal,
        _configModel = configModel,
        _isFreeDelivery = isFreeDelivery,
        _itemPrice = itemPrice,
        _total = total,
        super(key: key);

  final double _subTotal;
  final ConfigModel _configModel;
  final double _itemPrice;
  final double _total;
  final bool _isFreeDelivery;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: 1170,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(children: [
        Consumer<CouponProvider>(builder: (context, couponProvider, _) {
          return couponProvider.couponType == 'free_delivery'
              ? const SizedBox()
              : FreeDeliveryProgressBar(
                  subTotal: _subTotal, configModel: _configModel);
        }),
        Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
            return CustomCartButton(
              buttonText1:
                  '${PriceConverter.convertPrice(context, _total)} total',
              buttonText2: getTranslated('place_order', context),
              onPressed: () {
                bool isLoggedIn =
                Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
                if(isLoggedIn){
                  if (_itemPrice < _configModel.minimumOrderValue!) {
                    showCustomSnackBar(
                        ' ${getTranslated('minimum_order_amount_is', context)} ${PriceConverter.convertPrice(context, _configModel.minimumOrderValue)}, ${getTranslated('you_have', context)} ${PriceConverter.convertPrice(context, _itemPrice)} ${getTranslated('in_your_cart_please_add_more_item', context)}',
                        isError: true);
                  } else {
                    if (orderProvider.orderType == 'self_pickup' &&
                        cartProvider.selectedStoreId == null) {
                      return ToastService()
                          .show('Please select store to pickup');
                    }

                    if (orderProvider.orderType == 'delivery' &&
                        cartProvider.selectedDeliveryTimeSlot == null) {
                      return ToastService()
                          .show('Please select upcoming delivery time slot');
                    }

                    if (orderProvider.orderType == 'delivery' &&
                        Provider.of<LocationProvider>(context, listen: false)
                            .addressList!
                            .isEmpty) {
                      return ToastService().show('Please add delivery address');
                    }

                    if (orderProvider.orderType == 'delivery' &&
                        orderProvider.addressIndex == -1) {
                      return ToastService().show(
                          getTranslated('select_delivery_address', context)!);
                    }

                    if (kDebugMode) {
                      print(
                          'navigate to payment options================================================');
                      print('total amount to pay: $_total');
                      print('type of order: ${orderProvider.orderType}');
                      print(
                          'time slot: ${cartProvider.selectedDeliveryTimeSlot}');
                      print('payment method: ${orderProvider.paymentMethod}');
                      print('is delivery free: $_isFreeDelivery');
                      print(
                          'slected store id: ${cartProvider.selectedStoreId}');
                      print(
                          'selected address id: ${Provider.of<LocationProvider>(context, listen: false).addressList![0].id}');
                      print(
                          'navigate to payment options================================================');
                    }

                    //  To navigate to payment options
                    Navigator.pushNamed(
                      context,
                      RouteHelper.getCheckoutRoute(
                        _total,
                        0,
                        orderProvider.orderType,
                        Provider.of<CouponProvider>(context, listen: false)
                            .code!,
                        _isFreeDelivery ? 'free_delivery' : '',
                      ),
                      arguments: CheckoutScreen(
                        amount: _total,
                        orderType: orderProvider.orderType,
                        discount: 0,
                        couponCode:
                            Provider.of<CouponProvider>(context, listen: false)
                                .code,
                        freeDeliveryType:
                            _isFreeDelivery ? 'free_delivery' : '',
                      ),
                    );
                  }

                  // String? orderType =
                  //     Provider.of<OrderProvider>(context, listen: false).orderType;
                  // double? discount =
                  //     Provider.of<CouponProvider>(context, listen: false).discount;

                  // PlaceOrderBody placeOrderBody = PlaceOrderBody(
                  //   cart: jsonEncode(cartProvider.cartList),
                  //   orderAmount: _total,
                  //   paymentMethod: orderProvider.paymentMethod,
                  //   orderType: orderProvider.orderType,
                  //   storeId: cartProvider.selectedStoreId,
                  //   branchId:
                  //       Provider.of<ProfileProvider>(context, listen: false)
                  //           .userInfoModel!
                  //           .warehouseId,
                  //   deliveryAddressId:
                  //       Provider.of<LocationProvider>(context, listen: false)
                  //           .addressList![0]
                  //           .id,
                  //   couponDiscountAmount:
                  //       Provider.of<CouponProvider>(context, listen: false)
                  //           .discount,
                  //   deliveryTimeSlot: cartProvider.selectedDeliveryTimeSlot,
                  //   deliveryDate: DateTime.now().toString(),
                  // );
                  //
                  // if (directPaymentList.contains(orderProvider.paymentMethod)) {
                  //   print(
                  //       'place order body order type is: ${placeOrderBody.orderType}');
                  //   print('payment method is: ${placeOrderBody.paymentMethod}');
                  //   print('store id is: ${placeOrderBody.storeId}');
                  //   print('order amount is: ${placeOrderBody.orderAmount}');
                  //   print('address id is: ${placeOrderBody.deliveryAddressId}');
                  //
                  //   log('place order:::::${placeOrderBody.cart}');
                  //
                  //   if (orderProvider.paymentMethod != 'offline_payment') {
                  //     // if (placeOrderBody.paymentMethod == 'cash_on_delivery' &&
                  //     //     configModel.maxAmountCodStatus! &&
                  //     //     placeOrderBody.orderAmount! >
                  //     //         configModel.maxOrderForCODAmount!) {
                  //     //   showCustomSnackBar(
                  //     //       '${getTranslated('for_cod_order_must_be', context)} ${configModel.maxOrderForCODAmount}');
                  //     // } else
                  //     if (orderProvider.paymentMethod == 'wallet_payment' &&
                  //         Provider.of<ProfileProvider>(context, listen: false)
                  //                 .userInfoModel!
                  //                 .walletBalance! <
                  //             placeOrderBody.orderAmount!) {
                  //       showCustomSnackBar(getTranslated(
                  //           'wallet_balance_is_insufficient', context)!);
                  //     } else {
                  //       orderProvider.placeOrder(placeOrderBody, _callback);
                  //     }
                  //   }
                  //   else {
                  //     showAnimatedDialog(
                  //         context,
                  //         OfflinePaymentDialog(
                  //           placeOrderBody: placeOrderBody,
                  //           callBack: (placeOrder) =>
                  //               orderProvider.placeOrder(placeOrder, _callback),
                  //         ),
                  //         dismissible: false,
                  //         isFlip: true);
                  //   }
                  // }
                }
                else{
                  ToastService().show("Please login for place orders");
                }
              },
            );
          });
        })
      ]),
    ));
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Provider.of<CartProvider>(Get.context!, listen: false).clearCartList();
      Provider.of<OrderProvider>(Get.context!, listen: false).stopLoader();
      if (Provider.of<OrderProvider>(Get.context!, listen: false)
              .paymentMethod !=
          'cash_on_delivery') {
        Navigator.pushReplacementNamed(
          Get.context!,
          '${'${RouteHelper.orderSuccessful}/'}$orderID/success',
          arguments: OrderSuccessfulScreen(
            orderID: orderID,
            status: 0,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(
            Get.context!, '${RouteHelper.orderSuccessful}/$orderID/success');
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
            content: Text(message),
            duration: const Duration(milliseconds: 600),
            backgroundColor: Colors.red),
      );
    }
  }
}

class FreeDeliveryProgressBar extends StatelessWidget {
  const FreeDeliveryProgressBar({
    Key? key,
    required double subTotal,
    required ConfigModel configModel,
  })  : _subTotal = subTotal,
        super(key: key);

  final double _subTotal;

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    return configModel.freeDeliveryStatus!
        ? Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Column(children: [
              Row(children: [
                Icon(Icons.discount_outlined,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                (_subTotal / configModel.freeDeliveryOverAmount!) < 1
                    ? CustomDirectionality(
                        child: Text(
                        '${PriceConverter.convertPrice(context, configModel.freeDeliveryOverAmount! - _subTotal)} ${getTranslated('more_to_free_delivery', context)}',
                      ))
                    : Text(getTranslated('enjoy_free_delivery', context)!),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              LinearProgressIndicator(
                value: (_subTotal / configModel.freeDeliveryOverAmount!),
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ]),
          )
        : const SizedBox();
  }
}
