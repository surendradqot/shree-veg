import 'package:flutter/material.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:provider/provider.dart';

class DeliveryOptionButton extends StatelessWidget {
  final double total;
  final String value;
  final String? title;
  final bool kmWiseFee;
  final bool freeDelivery;
  const DeliveryOptionButton(
      {Key? key,
        required this.total,
      required this.value,
      required this.title,
      required this.kmWiseFee,
      this.freeDelivery = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String? value) => order.setOrderType(value),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title!, style: poppinsRegular),
                      const SizedBox(width: 5),
                      freeDelivery
                          ? CustomDirectionality(
                          child: Text('(${getTranslated('free', context)})',
                              style: poppinsMedium))
                          : kmWiseFee
                          ? const SizedBox()
                          : Text(
                        '(${value == 'delivery' && !freeDelivery ? PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel!.deliveryCharge) : getTranslated('free', context)})',
                        style: poppinsMedium,
                      ),
                    ],
                  ),
                  total < Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue! &&
                      value == 'delivery'
                      ? FittedBox(
                    child: Text(
                      '${getTranslated(
                          'purchase_more_than', context)!} ${Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue!} ${getTranslated(
                          'for_home_delivery', context)!}',
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions
                              .fontSizeExtraExtraSmall,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFF2121)),
                    ),
                  )
                      : const SizedBox(),
                ],
              ),

            ],
          ),
        );
      },
    );
  }
}
