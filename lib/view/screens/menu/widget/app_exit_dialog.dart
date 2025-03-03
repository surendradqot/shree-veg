import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';

class AppExitDialog extends StatelessWidget {
  const AppExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(Images.shreeLogo)),
          ),
          //SizedBox(height: Dimensions.paddingSizeLarge),

          // fromCheckout ? Text(
          //   getTranslated('order_placed_successfully', context),
          //   style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
          // ) : SizedBox(),
          // SizedBox(height: fromCheckout ? Dimensions.paddingSizeSmall : 0),

          const SizedBox(height: 30),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor),
            Text(
              getTranslated('exit_alert', context)!,
              style:
                  poppinsMedium.copyWith(color: Theme.of(context).primaryColor),
            ),
          ]),
          const SizedBox(height: 10),

          Text(
            getTranslated('exit_app', context)!,
            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          Row(children: [
            Expanded(
                child: CustomButton(
                    buttonText: 'Exit',
                    onPressed: () {
                      Navigator.pop(context, true);
                    })),
            const SizedBox(width: 10),
            Expanded(
                child: CustomButton(
                    buttonText: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context, false);
                    })),
          ]),
        ]),
      ),
    );
  }
}
