import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';

import 'footer_view.dart';

class NotLoggedInScreen extends StatelessWidget {
  const NotLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.orderPlaced,
            width: MediaQuery.of(context).size.height * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text(
            'guest_mode'.tr,
            style: poppinsRegular.copyWith(
                fontSize: MediaQuery.of(context).size.height * 0.023),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            'now_you_are_in_guest_mode'.tr,
            style: poppinsRegular.copyWith(
                fontSize:
                    MediaQuery.of(context).size.height * 0.0175),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          SizedBox(
            width: 100,
            height: 45,
            child: CustomButton(
                buttonText: 'login'.tr,
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                  Navigator.pushNamed(context, RouteHelper.login);
                }),
          ),
        ],
      ),
    );
  }
}
