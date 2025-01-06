import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/model/body/place_order_body.dart';
import 'package:shreeveg/data/model/response/cart_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/coupon_provider.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_dialog.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/screens/checkout/order_successful_screen.dart';
import 'package:shreeveg/view/screens/checkout/widget/offline_payment_dialog.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert' as convert;

import '../../../../helper/price_converter.dart';
import '../../../../provider/auth_provider.dart';
import '../../wallet/widget/low_wallet_dialog.dart';

class PlaceOrderButtonView extends StatefulWidget {
  final double? amount;
  final TextEditingController? noteController;
  final bool? kmWiseCharge;
  final String? orderType;
  final double? deliveryCharge;
  final bool? selfPickUp;
  final String? couponCode;

  const PlaceOrderButtonView({
    Key? key,
    this.amount,
    this.noteController,
    this.kmWiseCharge,
    this.orderType,
    this.deliveryCharge,
    this.selfPickUp,
    this.couponCode,
  }) : super(key: key);

  @override
  State<PlaceOrderButtonView> createState() => _PlaceOrderButtonViewState();
}

class _PlaceOrderButtonViewState extends State<PlaceOrderButtonView> {
  TextEditingController paymentByController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController paymentNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel;
    final directPaymentList = [
      'wallet_payment',
      'online_payment',
      'cash_on_delivery'
    ];

    return SizedBox(
      width: 1170,
      child: Consumer<CartProvider>(builder: (context, cartProvider, child) {
        return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
          if (orderProvider.isLoading) {
            return Center(
                child: CustomLoader(color: Theme.of(context).primaryColor));
          }
          return CustomCartButton(
            margin: Dimensions.paddingSizeSmall,
            buttonText1:
                '${PriceConverter.convertPrice(context, widget.amount)} total',
            buttonText2: getTranslated('place_order', context),
            onPressed: () async {
              if (orderProvider.paymentOptionRadioGroupValue == null) {
                ToastService().show(
                  getTranslated('select_payment_method', context)!,
                );
              } else if (orderProvider.paymentMethod == '') {
                showCustomSnackBar(
                    getTranslated('select_payment_method', context)!,
                    isError: true);
              }
              // else if (!widget.selfPickUp! &&
              //     widget.kmWiseCharge! &&
              //     orderProvider.distance == -1) {
              //   showCustomSnackBar(
              //       getTranslated('delivery_fee_not_set_yet', context)!,
              //       isError: true);
              // }
              else {
                // List<CartModel> cartList =
                //     Provider.of<CartProvider>(context, listen: false).cartList;
                // List<Cart> carts = [];
                // for (int index = 0; index < cartProvider.cartList.length; index++) {
                //   Cart cart = Cart(
                //     productId: cartList[index].id,
                //     price: cartList[index].price,
                //     discountAmount: cartList[index].discountedPrice,
                //     quantity: cartList[index].quantity,
                //     taxAmount: cartList[index].tax,
                //     variant: '',
                //     variation: [
                //       Variation(
                //           type: cartList[index].variation != null
                //               ? cartList[index].variation!.type
                //               : null)
                //     ],
                //   );
                //   carts.add(cart);
                // }

                SharedPreferences? sharedPreferences  = await SharedPreferences.getInstance();
                int? whId = sharedPreferences.getInt(AppConstants.selectedCityId);
                PlaceOrderBody placeOrderBody = PlaceOrderBody(
                    cart: jsonEncode(cartProvider.cartList),
                    orderAmount: (widget.amount! + widget.deliveryCharge!)
                        .ceilToDouble(),
                    // paymentMethod: orderProvider.paymentMethod,
                    paymentMethod: orderProvider.paymentMethod,
                    orderType: orderProvider.orderType,
                    storeId: cartProvider.selectedStoreId,
                    // couponCode: widget.couponCode,
                    // orderNote: widget.noteController!.text,
                    branchId: whId,
                    deliveryAddressId: !widget.selfPickUp!
                        ? Provider.of<LocationProvider>(context, listen: false)
                            .addressList![0]
                            .id
                        : 0,
                    // distance: widget.selfPickUp! ? 0 : orderProvider.distance,
                    // couponDiscountAmount:
                    //     Provider.of<CouponProvider>(context, listen: false)
                    //         .discount,
                    deliveryTimeSlot: cartProvider.selectedDeliveryTimeSlot,
                    // deliveryTimeSlot: '16:00:00 - 18:00:00'
                    deliveryDate: DateTime.now().toString()
                    // deliveryDate: orderProvider
                    //     .getDates(context)[orderProvider.selectDateSlot],
                    // couponDiscountTitle: '',
                    );

                if (kDebugMode) {
                  print(
                      'Place order:============================================');
                  print('order type is: ${orderProvider.orderType}');
                  print('order amount is: ${widget.amount}');
                  print('delivery charge is: ${widget.deliveryCharge}');
                  print('is self pickup order: ${widget.selfPickUp}');
                  print('address index is: ${orderProvider.addressIndex}');
                  print('payment method is: ${orderProvider.paymentMethod}');
                  log('order is::::::::::::::::::::::::::::::::::::::::: ${placeOrderBody.toJson().toString()}');
                }

                if (directPaymentList.contains(orderProvider.paymentMethod)) {
                  print('going to place order');
                  if (orderProvider.paymentMethod == 'online_payment') {
                    print('first pay then place order on payment success');
                    Navigator.pushNamed(
                        context,
                        RouteHelper.getRazorpayPaymentRoute(
                          type: 'Prepaid Order',
                          userId: Provider.of<ProfileProvider>(context,
                                  listen: false)
                              .userInfoModel!
                              .userInfo!.id
                              .toString(),
                          amount: widget.amount!.ceil().toString(),
                          phone: Provider.of<ProfileProvider>(context,
                                  listen: false)
                              .userInfoModel!
                              .userInfo!.phone
                              .toString(),
                          email:
                              Provider.of<AuthProvider>(context, listen: false)
                                  .getUserEmailOrPhone(),
                        )).then((value) {
                      print('payment result is::::::::::: $value');
                      dynamic paymentResult = value;
                      String? paymentId;
                      if (paymentResult is Map<String, dynamic>) {
                        paymentId = paymentResult['paymentId'];
                      }
                      print('payment id is:: $paymentId');
                      if (paymentId != null) {
                        ToastService().show("Order payment successful");
                        placeOrderBody.setPaymentId(paymentId);

                        orderProvider.placeOrder(placeOrderBody, _callback);
                      }
                    });
                    // if (placeOrderBody.paymentMethod == 'cash_on_delivery' &&
                    //     configModel.maxAmountCodStatus! &&
                    //     placeOrderBody.orderAmount! >
                    //         configModel.maxOrderForCODAmount!) {
                    //   showCustomSnackBar(
                    //       '${getTranslated('for_cod_order_must_be', context)} ${configModel.maxOrderForCODAmount}');
                  } else if (orderProvider.paymentMethod == 'wallet_payment') {
                    if (Provider.of<ProfileProvider>(context, listen: false)
                            .userInfoModel!
                            .userInfo!.walletBalance! <
                        placeOrderBody.orderAmount!) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => LowWalletDialog(
                                callback: (String message, bool isSuccess,
                                    String orderID) {
                                  if (isSuccess) {
                                  } else {
                                    showCustomSnackBar(message, isError: false);
                                  }
                                },
                              ));
                    } else {
                      print('placing order with shree veg wallet');
                      orderProvider.placeOrder(placeOrderBody, _callback);
                    }
                  } else {
                    print('placing order with cash on delivery');
                    orderProvider.placeOrder(placeOrderBody, _callback);
                    // showAnimatedDialog(
                    //     context,
                    //     OfflinePaymentDialog(
                    //       placeOrderBody: placeOrderBody,
                    //       callBack: (placeOrder) =>
                    //           orderProvider.placeOrder(placeOrder, _callback),
                    //     ),
                    //     dismissible: false,
                    //     isFlip: true);
                  }
                }
                // else {
                //   String? hostname = html.window.location.hostname;
                //   String protocol = html.window.location.protocol;
                //   String port = html.window.location.port;
                //   final String placeOrder = convert.base64Url.encode(convert
                //       .utf8
                //       .encode(convert.jsonEncode(placeOrderBody.toJson())));
                //
                //   String url =
                //       "customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id}"
                //       "&&callback=${AppConstants.baseUrl}${RouteHelper.orderSuccessful}&&order_amount=${(widget.amount! + widget.deliveryCharge!).toStringAsFixed(2)}";
                //
                //   String webUrl =
                //       "customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id}"
                //       "&&callback=$protocol//$hostname${RouteHelper.orderWebPayment}&&order_amount=${(widget.amount! + widget.deliveryCharge!).toStringAsFixed(2)}&&status=";
                //
                //   String webUrlDebug =
                //       "customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id}"
                //       "&&callback=$protocol//$hostname:$port${RouteHelper.orderWebPayment}&&order_amount=${(widget.amount! + widget.deliveryCharge!).toStringAsFixed(2)}&&status=";
                //
                //   String tokenUrl = convert.base64Encode(convert.utf8.encode(
                //       ResponsiveHelper.isWeb()
                //           ? (kDebugMode ? webUrlDebug : webUrl)
                //           : url));
                //   String selectedUrl =
                //       '${AppConstants.baseUrl}/payment-mobile?token=$tokenUrl&&payment_method=${orderProvider.paymentMethod}';
                //
                //   orderProvider.clearPlaceOrder().then((_) =>
                //       orderProvider.setPlaceOrder(placeOrder).then((value) {
                //         if (ResponsiveHelper.isWeb()) {
                //           html.window.open(selectedUrl, "_self");
                //         } else {
                //           Navigator.pushReplacementNamed(
                //               context,
                //               RouteHelper.getPaymentRoute(
                //                 page: 'checkout',
                //                 selectAddress: tokenUrl,
                //                 placeOrderBody: placeOrderBody,
                //               ));
                //         }
                //       }));
                // }
              }
            },
          );
        });
      }),
    );
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
