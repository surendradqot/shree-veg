import 'package:flutter/material.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/coupon_provider.dart';
import 'package:shreeveg/provider/localization_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_divider.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/screens/cart/widget/delivery_option_button.dart';
import 'package:provider/provider.dart';

import 'cart_stores_view.dart';

class CartDetailsView extends StatelessWidget {
  const CartDetailsView({
    Key? key,
    required TextEditingController couponController,
    required double total,
    required bool isSelfPickupActive,
    required bool kmWiseCharge,
    required bool isFreeDelivery,
    required double itemPrice,
    required double totalMarketPrice,
    required double totalShreePrice,
    required double tax,
    required String unit,
    required double totalWeight,
    required double discount,
    required this.deliveryCharge,
  })  : _couponController = couponController,
        _total = total,
        _isSelfPickupActive = isSelfPickupActive,
        _kmWiseCharge = kmWiseCharge,
        _isFreeDelivery = isFreeDelivery,
        _itemPrice = itemPrice,
        _totalMarketPrice = totalMarketPrice,
        _totalShreePrice = totalShreePrice,
        _tax = tax,
  _unit = unit,
  _totalWeight = totalWeight,
        _discount = discount,
        super(key: key);

  final TextEditingController _couponController;
  final double _total;
  final bool _isSelfPickupActive;
  final bool _kmWiseCharge;
  final bool _isFreeDelivery;
  final double _itemPrice;
  final double _totalMarketPrice;
  final double _totalShreePrice;
  final double _tax;
  final String _unit;
  final double _totalWeight;
  final double _discount;
  final double deliveryCharge;

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    return Column(children: [
      // Consumer<CouponProvider>(
      //   builder: (context, couponProvider, child) {
      //     return Row(children: [
      //       Expanded(
      //           child: TextField(
      //         controller: _couponController,
      //         style: poppinsMedium,
      //         decoration: InputDecoration(
      //           hintText: getTranslated('enter_promo_code', context),
      //           hintStyle:
      //               poppinsRegular.copyWith(color: Theme.of(context).hintColor),
      //           isDense: true,
      //           filled: true,
      //           enabled: couponProvider.discount == 0,
      //           fillColor: Theme.of(context).cardColor,
      //           border: const OutlineInputBorder(
      //             borderRadius:
      //                 BorderRadius.horizontal(left: Radius.circular(10)),
      //             borderSide: BorderSide.none,
      //           ),
      //         ),
      //       )),
      //       InkWell(
      //         onTap: () {
      //           if (_couponController.text.isNotEmpty &&
      //               !couponProvider.isLoading) {
      //             if (couponProvider.discount! < 1) {
      //               couponProvider.applyCoupon(
      //                   _couponController.text, (_total - deliveryCharge));
      //             } else {
      //               couponProvider.removeCouponData(true);
      //             }
      //           } else {
      //             showCustomSnackBar(
      //                 getTranslated('invalid_code_or_failed', context)!,
      //                 isError: true);
      //           }
      //         },
      //         child: Container(
      //           height: 50,
      //           width: 100,
      //           alignment: Alignment.center,
      //           decoration: BoxDecoration(
      //             color: Theme.of(context).primaryColor,
      //             borderRadius: BorderRadius.horizontal(
      //               right: Radius.circular(Provider.of<LocalizationProvider>(
      //                           context,
      //                           listen: false)
      //                       .isLtr
      //                   ? 10
      //                   : 0),
      //               left: Radius.circular(Provider.of<LocalizationProvider>(
      //                           context,
      //                           listen: false)
      //                       .isLtr
      //                   ? 0
      //                   : 10),
      //             ),
      //           ),
      //           child: couponProvider.discount! <= 0
      //               ? !couponProvider.isLoading
      //                   ? Text(
      //                       getTranslated('apply', context)!,
      //                       style: poppinsMedium.copyWith(color: Colors.white),
      //                     )
      //                   : const CircularProgressIndicator(
      //                       valueColor:
      //                           AlwaysStoppedAnimation<Color>(Colors.white))
      //               : const Icon(Icons.clear, color: Colors.white),
      //         ),
      //       ),
      //     ]);
      //   },
      // ),
      // const SizedBox(height: Dimensions.paddingSizeLarge),

      //Bill Details
      Row(
        children: [
          Text(getTranslated('bill_details', context)!,
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: const Color(0xFF000000))),
        ],
      ),
      const SizedBox(height: 10),

      // Total item in units
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${getTranslated('total_item_in', context)!} $_unit',
            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w400, color: const Color(0xFF4E4E4E))),
        CustomDirectionality(
            child: Text(
              '${_totalWeight.toStringAsFixed(0)} $_unit',
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w500, color: const Color(0xFF0B4619)),
            )),
      ]),
      const SizedBox(height: 10),

      // Market Price
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('market_price', context)!,
            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w400, color: const Color(0xFF4E4E4E))),
        CustomDirectionality(
            child: Text(
        PriceConverter.convertPrice(context, _totalMarketPrice),
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w500, color: const Color(0xFF0B4619)),
            )),
      ]),
      const SizedBox(height: 10),

      // ShreeVeg Price
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('shree_price', context)!,
            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w400, color: const Color(0xFF4E4E4E))),
        CustomDirectionality(
            child: Text(
              PriceConverter.convertPrice(context, _totalShreePrice),
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w500, color: const Color(0xFF0B4619)),
            )),
      ]),
      const SizedBox(height: 10),

      // Total
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('delivery_charge', context)!,
            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w400, color: const Color(0xFF4E4E4E))),
        CustomDirectionality(
            child: Text(
              '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w500, color: const Color(0xFF0B4619)),
            )),
      ]),
      const SizedBox(height: 10),

      // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //   CustomDirectionality(
      //       child: Text(
      //     '${getTranslated('tax', context)} ${configModel.isVatTexInclude! ? '(${getTranslated('include', context)})' : ''}',
      //     style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      //   )),
      //   CustomDirectionality(
      //       child: Text(
      //     '${configModel.isVatTexInclude! ? '' : '(+)'} ${PriceConverter.convertPrice(context, _tax)}',
      //     style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      //   )),
      // ]),
      // const SizedBox(height: 10),
      //
      // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //   Text(getTranslated('discount', context)!,
      //       style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      //   CustomDirectionality(
      //       child: Text(
      //     '(-) ${PriceConverter.convertPrice(context, _discount)}',
      //     style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      //   )),
      // ]),
      // const SizedBox(height: 10),
      //
      // Consumer<CouponProvider>(builder: (context, couponProvider, _) {
      //   return couponProvider.couponType != 'free_delivery' &&
      //           couponProvider.discount! > 0
      //       ? Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(getTranslated('coupon_discount', context)!,
      //                 style: poppinsRegular.copyWith(
      //                     fontSize: Dimensions.fontSizeLarge)),
      //             CustomDirectionality(
      //                 child: Text(
      //               '(-) ${PriceConverter.convertPrice(context, couponProvider.discount)}',
      //               style: poppinsRegular.copyWith(
      //                   fontSize: Dimensions.fontSizeLarge),
      //             )),
      //           ],
      //         )
      //       : const SizedBox();
      // }),
      // const SizedBox(height: 10),
      //
      // if (_kmWiseCharge || _isFreeDelivery)
      //   const SizedBox()
      // else
      //   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //     Text(
      //       getTranslated('delivery_charge', context)!,
      //       style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      //     ),
      //     CustomDirectionality(
      //         child: Text(
      //       '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
      //       style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      //     )),
      //   ]),

      const Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: CustomDivider(),
      ),

      Container(
        color: const Color(0xFFEBEBEB),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
                // getTranslated(
                //     _kmWiseCharge ? 'subtotal' : 'total_amount', context)!,
              getTranslated('grand_total', context)!,
                style: poppinsMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                  // color: Theme.of(context).primaryColor,
                  color: Colors.black,
                )),
            Column(
              children: [
                CustomDirectionality(
                    child: Text(
                  PriceConverter.convertPrice(context, _total),
                  style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    // color: Theme.of(context).primaryColor,
                    color: Colors.black,
                  ),
                )),
                Text(
                  '${getTranslated('rs_saved', context)!} ${PriceConverter.convertPrice(context, _totalMarketPrice-_totalShreePrice)}',
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, fontWeight: FontWeight.w500, color: const Color(0xFF0B4619)),
                ),
              ],
            ),
          ]),
        ),
      ),

      _isSelfPickupActive
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('delivery_option', context)!,
            style: poppinsMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge)),
        DeliveryOptionButton(
            total: _totalShreePrice,
            value: 'delivery',
            title: getTranslated('delivery', context),
            kmWiseFee: _kmWiseCharge,
            freeDelivery: _isFreeDelivery),
        DeliveryOptionButton(
            total: _totalShreePrice,
            value: 'self_pickup',
            title: getTranslated('self_pickup', context),
            kmWiseFee: _kmWiseCharge),
        const SizedBox(height: Dimensions.paddingSizeLarge),
      ])
          : const SizedBox(),


      // store options for self pickup
      Provider.of<OrderProvider>(context, listen: false).orderType == 'self_pickup' ? const CartStoreOptions() : const SizedBox(),

    ]);
  }
}
