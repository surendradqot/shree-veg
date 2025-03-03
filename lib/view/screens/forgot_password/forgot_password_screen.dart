import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/config_model.dart';
import 'package:shreeveg/helper/email_checker.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/auth/widget/country_code_picker_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .country!)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBar()): CustomAppBar(title: getTranslated('forgot_password', context))) as PreferredSizeWidget?,
      body: Center(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Center(
              child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: ResponsiveHelper.isDesktop(context)
                    ? MediaQuery.of(context).size.height - 560
                    : MediaQuery.of(context).size.height),
            child: Container(
              width: width > 1170 ? 700 : width,
              padding: width > 1170
                  ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                  : null,
              margin: width > 1170
                  ? const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeLarge)
                  : null,
              decoration: width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300]!,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    )
                  : null,
              child: Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 55),
                      Center(
                        child: Image.asset(
                          Images.lockGuard,
                          width: MediaQuery.of(context).size.height / 3,
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('forgot_password', context)!,
                              style: poppinsMedium.copyWith(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Enter the email address with your account and we will send ana email with confirmation to reset your password",
                              style: poppinsRegular.copyWith(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.6)),
                            ),
                            // Text(
                            //   getTranslated(
                            //       configModel.phoneVerification!
                            //           ? 'please_enter_your_number'
                            //           : 'please_enter_your_email',
                            //       context)!,
                            //   textAlign: TextAlign.center,
                            //   style: poppinsRegular.copyWith(
                            //       color: Theme.of(context)
                            //           .hintColor
                            //           .withOpacity(0.6)),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 15),
                            configModel.phoneVerification!
                                ? Text(
                                    getTranslated('mobile_number', context)!,
                                    style: poppinsRegular.copyWith(
                                        // color: Theme.of(context)
                                        //     .hintColor
                                        //     .withOpacity(0.6)
                                        ),
                                  )
                                : Text(
                                    getTranslated('email', context)!,
                                    style: poppinsRegular.copyWith(
                                        // color: Theme.of(context)
                                        //     .hintColor
                                        //     .withOpacity(0.6)
                                        ),
                                  ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            configModel.phoneVerification!
                                ? Row(children: [
                                    CountryCodePickerWidget(
                                      onChanged: (CountryCode countryCode) {
                                        _countryDialCode = countryCode.dialCode;
                                      },
                                      initialSelection: _countryDialCode,
                                      favorite: [_countryDialCode!],
                                      showDropDownButton: true,
                                      padding: EdgeInsets.zero,
                                      showFlagMain: true,
                                      textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color),
                                    ),
                                    Expanded(
                                        child: CustomTextField(
                                      hintText:
                                          getTranslated('number_hint', context),
                                      // isShowBorder: true,
                                      controller: _emailController,
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.phone,
                                    )),
                                  ])
                                : CustomTextField(
                                    hintText:
                                        getTranslated('demo_gmail', context),
                                    // isShowBorder: true,
                                    controller: _emailController,
                                    inputType: TextInputType.emailAddress,
                                    inputAction: TextInputAction.done,
                                  ),
                            const SizedBox(height: 40),
                            !auth.isForgotPasswordLoading
                                ? SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      buttonText:
                                          getTranslated('continue', context),
                                      onPressed: () {
                                        String email =
                                            _emailController.text.trim();
                                        // if (configModel.phoneVerification!) {
                                        String phone =
                                            _countryDialCode! + email;
                                        //   if (email.isEmpty) {
                                        //     showCustomSnackBar(getTranslated(
                                        //         'enter_phone_number',
                                        //         context)!);
                                        //   } else {
                                        //     Provider.of<AuthProvider>(context,
                                        //             listen: false)
                                        //         .forgetPassword(phone)
                                        //         .then((value) {
                                        //       if (value.isSuccess) {
                                        //         Navigator.of(context).pushNamed(
                                        //           RouteHelper.getVerifyRoute(
                                        //               'forget-password', phone),
                                        //         );
                                        //       } else {
                                        //         showCustomSnackBar(
                                        //             value.message!);
                                        //       }
                                        //     });
                                        //   }
                                        // } else {
                                        //   if (email.isEmpty) {
                                        //     showCustomSnackBar(getTranslated(
                                        //         'enter_email_address',
                                        //         context)!);
                                        //   } else if (EmailChecker.isNotValid(
                                        //       email)) {
                                        //     showCustomSnackBar(getTranslated(
                                        //         'enter_valid_email', context)!);
                                        //   } else {
                                        //     Provider.of<AuthProvider>(context,
                                        //             listen: false)
                                        //         .forgetPassword(email)
                                        //         .then((value) {
                                        //       if (value.isSuccess) {
                                        //         Navigator.of(context).pushNamed(
                                        //           RouteHelper.getVerifyRoute(
                                        //               'forget-password', email),
                                        //         );
                                        //       } else {
                                        //         showCustomSnackBar(
                                        //             value.message!);
                                        //       }
                                        //     });
                                        //   }
                                        // }
                                        Navigator.of(context).pushNamed(
                                          RouteHelper.getVerifyRoute(
                                              'forget-password', phone),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: CustomLoader(
                                        color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )),
          ResponsiveHelper.isDesktop(context)
              ? const FooterView()
              : const SizedBox.shrink(),
        ]),
      )),
    );
  }
}
