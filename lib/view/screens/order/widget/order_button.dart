import 'package:flutter/material.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatelessWidget {
  final String? title;
  final bool? isActive;
  final bool? isCancelled;
  const OrderButton(
      {Key? key, required this.title, this.isActive, this.isCancelled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return InkWell(
            onTap: () {
              if (isActive != null && isCancelled == null) {
                orderProvider.changeActiveOrderStatus(isActive!);
              }
              if (isActive == null && isCancelled != null) {
                orderProvider.changeCancelledOrderStatus(isCancelled!);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: orderProvider.isActiveOrder == isActive || orderProvider.isCancelByMe == isCancelled
                      ? Theme.of(context).primaryColor
                      : ColorResources.getGreyColor(context),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$title',
                    style: poppinsRegular.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: orderProvider.isActiveOrder == isActive || orderProvider.isCancelByMe == isCancelled
                            ? Theme.of(context).cardColor
                            : Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  CustomDirectionality(
                    child: Text(
                      '(${isCancelled == null && isActive != null && isActive == true ? orderProvider.runningOrderList!.length : isCancelled == null && isActive != null && isActive == false ? orderProvider.historyOrderList!.length : isActive == null && isCancelled != null && isCancelled == true ? orderProvider.cancelOrderListMe!.length : orderProvider.cancelOrderListDeliveryBoy!.length})',
                      style: poppinsRegular.copyWith(
                          color: orderProvider.isActiveOrder == isActive || orderProvider.isCancelByMe == isCancelled
                              ? Theme.of(context).cardColor
                              : Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
