import 'package:flutter/material.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/wallet_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:provider/provider.dart';

import '../../../../helper/route_helper.dart';

class LowWalletDialog extends StatelessWidget {
  final Function callback;
  const LowWalletDialog({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        horizontal: Dimensions.paddingSizeLarge, vertical: 20),
                    child: Text(getTranslated('low_wallet_add_money', context)!,
                        style: poppinsRegular.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(getTranslated('cancel', context)!,
                            style: poppinsRegular.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.fontSizeSmall)),
                      ),
                    )),
                    const SizedBox(
                      width: Dimensions.paddingSizeDefault,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        Future.delayed(
                            Duration.zero,
                            () => Navigator.pushNamed(
                                    context, RouteHelper.getWalletRoute(true))
                                .then((value) => Navigator.pop(context, true)));
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(getTranslated('add_money', context)!,
                            style: poppinsRegular.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.fontSizeSmall)),
                      ),
                    )),
                  ]),
                ]),
          ),
        ));
  }
}
