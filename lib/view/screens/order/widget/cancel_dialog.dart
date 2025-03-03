import 'package:flutter/material.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:provider/provider.dart';

class OrderCancelDialog extends StatelessWidget {
  final String orderID;
  final Function callback;
  final bool fromOrder;
  const OrderCancelDialog(
      {Key? key,
      required this.orderID,
      required this.callback,
      required this.fromOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
        builder: (context, order, child) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeLarge,
                            vertical: 20),
                        child: Text(
                            getTranslated('are_you_sure_to_cancel', context)!,
                            style: poppinsRegular.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16),
                            textAlign: TextAlign.center),
                      ),
                      !order.isLoading
                          ? Row(children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                        getTranslated('cancel', context)!,
                                        style: poppinsRegular.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Dimensions.fontSizeDefault)),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .cancelOrder(orderID, fromOrder,
                                            (String message, bool isSuccess,
                                                String orderID) {
                                      Navigator.pop(context);
                                      callback(message, isSuccess, orderID);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(getTranslated('yes', context)!,
                                        style: poppinsRegular.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Dimensions.fontSizeDefault)),
                                  ),
                                ),
                              )),
                            ])
                          : SizedBox(
                              height: 50,
                              child: Center(
                                  child: CustomLoader(
                                      color: Theme.of(context).primaryColor))),
                    ]),
              ),
            )));
  }
}
