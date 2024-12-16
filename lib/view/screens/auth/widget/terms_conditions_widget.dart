import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/utill/styles.dart';

import '../../../../helper/route_helper.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'By continuing, you agree to our ',
        style: poppinsRegular.copyWith(
            color: Colors.black, fontSize: 8), // Adjust styling as needed
        children: [
          TextSpan(
            text: 'Terms and Conditions',
            style: const TextStyle(
              color: Colors.blue,
              // decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle the tap for Terms and Conditions
                print('Terms and Conditions tapped!');
                Navigator.pushNamed(context, RouteHelper.getTermsRoute());
              },
          ),
          const TextSpan(
            text: ' and ',
            style: TextStyle(color: Colors.black), // Adjust styling as needed
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: const TextStyle(
              color: Colors.blue,
              // decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle the tap for Privacy Policy
                print('Privacy Policy tapped!');
                Navigator.pushNamed(context, RouteHelper.getPolicyRoute());
              },
          ),
        ],
      ),
    );
  }
}

class TermsAndConditionsCheckbox extends StatelessWidget {
  final bool acceptTerms;
  final void Function() callback;
  const TermsAndConditionsCheckbox(
      {Key? key, required this.callback, required this.acceptTerms})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: acceptTerms,
          onChanged: (value) {
            callback();
          },
        ),
        RichText(
          text: TextSpan(
            text: 'I accept the ',
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'Terms & Conditions',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                // Add your onTap handler for the terms and conditions link here
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Handle the onTap action for the terms and conditions link
                    print('Terms & Conditions tapped!');
                    Navigator.pushNamed(context, RouteHelper.getTermsRoute());
                  },
              ),
              const TextSpan(
                text: '.',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
