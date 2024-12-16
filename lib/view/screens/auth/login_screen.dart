import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/helper/email_checker.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/screens/auth/create_account_screen.dart';
import 'package:shreeveg/view/screens/auth/widget/terms_conditions_widget.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../main.dart';
import '../splash/splash_screen.dart';
import 'otp_screen.dart';
import 'widget/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // GlobalKey<FormState>? _formKeyLogin = GlobalKey<FormState>();

    double width = MediaQuery.of(context).size.width;
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final socialStatus = configModel.socialLoginStatus;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : null,
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: ResponsiveHelper.isDesktop(context)
                ? MediaQuery.of(context).size.height - 560
                : MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
              ? 0
              : Dimensions.paddingSizeLarge),
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            ResponsiveHelper.isDesktop(context)
                ? const SizedBox(
                    height: 30,
                  )
                : const SizedBox(),
            Center(
                child: Container(
              width: width > 700 ? 700 : width,
              padding: ResponsiveHelper.isDesktop(context)
                  ? const EdgeInsets.symmetric(horizontal: 100, vertical: 50)
                  : width > 700
                      ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
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
                builder: (context, authProvider, child) => Form(
                    // key: _formKeyLogin,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center(
                    //     child: Padding(
                    //   padding: const EdgeInsets.all(15.0),
                    //   child: Image.asset(
                    //     Images.appLogo,
                    //     height: ResponsiveHelper.isDesktop(context)
                    //         ? MediaQuery.of(context).size.height * 0.15
                    //         : MediaQuery.of(context).size.height / 4.5,
                    //     fit: BoxFit.scaleDown,
                    //   ),
                    // )),
                    // Center(
                    //     child: Text(
                    //   getTranslated('Welcome!', context)!,
                    //   style: poppinsMedium.copyWith(
                    //     fontSize: 24,
                    //     // color: Theme.of(context)
                    //     //     .textTheme
                    //     //     .bodyLarge
                    //     //     ?.color
                    //     //     ?.withOpacity(0.6)
                    //   ),
                    // )),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        Images.loginLogo,
                        height: ResponsiveHelper.isDesktop(context)
                            ? MediaQuery.of(context).size.height * 0.15
                            : MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.scaleDown,
                      ),
                    )),
                    //SizedBox(height: 20),

                    Center(
                        child: Text(
                      getTranslated('login_signup', context)!,
                      style: poppinsMedium.copyWith(fontSize: 24),
                    )),

                    const SizedBox(height: 20),
                    // Center(
                    //     child: Text(
                    //   getTranslated('login_to_your_account', context)!,
                    //   style: poppinsMedium.copyWith(
                    //       fontSize: 16,
                    //       color: Theme.of(context)
                    //           .textTheme
                    //           .bodyLarge
                    //           ?.color
                    //           ?.withOpacity(0.6)),
                    // )),
                    // const SizedBox(height: 20),

                    // !(Provider.of<SplashProvider>(context, listen: false)
                    //         .configModel!
                    //         .emailVerification!)

                    !authProvider.isLoginWithPhone
                        ? Text(
                            getTranslated('email', context)!,
                            style: poppinsRegular.copyWith(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.6)),
                          )
                        : Text(
                            getTranslated('mobile_number', context)!,
                            style: poppinsRegular.copyWith(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.6)),
                          ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    // !(Provider.of<SplashProvider>(context, listen: false)
                    //         .configModel!
                    //         .emailVerification!)
// ? CustomTextField(
//                                 hintText: getTranslated('demo_gmail', context),
//                                 isShowBorder: true,
//                                 focusNode: _emailFocus,
//                                 nextFocus: _passwordFocus,
//                                 controller: _emailController,
//                                 inputType: TextInputType.emailAddress,
//                               )
//                             : Row(children: [
//                                 CountryCodePickerWidget(
//                                   onChanged: (CountryCode value) {
//                                     countryCode = value.code;
//                                   },
//                                   initialSelection: countryCode,
//                                   favorite: [countryCode!],
//                                   showDropDownButton: true,
//                                   padding: EdgeInsets.zero,
//                                   showFlagMain: true,
//                                   textStyle: TextStyle(
//                                       color: Theme.of(context)
//                                           .textTheme
//                                           .displayLarge!
//                                           .color),
//                                 ),
//                                 Expanded(
//                                     child: CustomTextField(
//                                   hintText:
//                                       getTranslated('number_hint', context),
//                                   // fillColor: Colors.transparent,
//                                   // islogin: true,
//                                   focusNode: _numberFocus,
//                                   nextFocus: _passwordFocus,
//                                   controller: _emailController,
//                                   inputType: TextInputType.phone,
//                                 )),
//                               ]),

                    // const PhoneFieldHint(),

                    CustomTextField(
                      isEnabled: !_isLoading,
                      controller: authProvider.phoneEmailController,
                      hintText: getTranslated(
                          authProvider.isLoginWithPhone
                              ? 'number_hint'
                              : 'demo_gmail',
                          context),
                      isShowPrefixIcon: authProvider.isLoginWithPhone,
                      prefixAssetUrl: Images.flag,
                      isShowSuffixIcon: true,
                      isloginWithPhone: authProvider.isLoginWithPhone,
                      islogin: true,
                      inputType: !authProvider.isLoginWithPhone
                          ? TextInputType.emailAddress
                          : TextInputType.emailAddress,
                      onSuffixTap: () async {
                        authProvider.phoneEmailController.clear();
                        if (authProvider.isLoginWithPhone) {
                          final SmsAutoFill _autoFill = SmsAutoFill();
                          String? hint = await _autoFill.hint;

                          print('hint is: $hint');
                          authProvider.phoneEmailController.text = hint ?? '';
                        }
                        authProvider
                            .setLoginWithPhone(!authProvider.isLoginWithPhone);
                      },
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // Text(
                    //   getTranslated('password', context)!,
                    //   style: poppinsRegular.copyWith(
                    //       color:
                    //           Theme.of(context).hintColor.withOpacity(0.6)),
                    // ),
                    // const SizedBox(height: Dimensions.paddingSizeSmall),
                    //
                    // CustomTextField(
                    //   hintText: getTranslated('password_hint', context),
                    //   // islogin: true,
                    //   isPassword: true,
                    //   isShowSuffixIcon: true,
                    //   focusNode: _passwordFocus,
                    //   controller: _passwordController,
                    //   inputAction: TextInputAction.done,
                    // ),
                    // const SizedBox(height: 20),
                    //
                    // // for remember me section
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       InkWell(
                    //         onTap: () => authProvider.toggleRememberMe(),
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(
                    //               Dimensions.paddingSizeExtraSmall),
                    //           child: Row(children: [
                    //             Container(
                    //               width: 18,
                    //               height: 18,
                    //               decoration: BoxDecoration(
                    //                 color: authProvider.isActiveRememberMe
                    //                     ? Theme.of(context).primaryColor
                    //                     : Theme.of(context).cardColor,
                    //                 border: Border.all(
                    //                     color:
                    //                         authProvider.isActiveRememberMe
                    //                             ? Colors.transparent
                    //                             : Theme.of(context)
                    //                                 .primaryColor),
                    //                 borderRadius: BorderRadius.circular(3),
                    //               ),
                    //               child: authProvider.isActiveRememberMe
                    //                   ? const Icon(Icons.done,
                    //                       color: Colors.white, size: 17)
                    //                   : const SizedBox.shrink(),
                    //             ),
                    //             const SizedBox(
                    //                 width: Dimensions.paddingSizeSmall),
                    //             Text(
                    //               getTranslated('remember_me', context)!,
                    //               style: Theme.of(context)
                    //                   .textTheme
                    //                   .displayMedium!
                    //                   .copyWith(
                    //                       fontSize:
                    //                           Dimensions.fontSizeExtraSmall,
                    //                       color: Theme.of(context)
                    //                           .hintColor
                    //                           .withOpacity(0.6)),
                    //             ),
                    //           ]),
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: () {
                    //           Navigator.of(context).pushNamed(
                    //               RouteHelper.forgetPassword,
                    //               arguments: const ForgotPasswordScreen());
                    //         },
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             getTranslated('forgot_password', context)!,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .displayMedium!
                    //                 .copyWith(
                    //                     fontSize: Dimensions.fontSizeSmall,
                    //                     color: Theme.of(context)
                    //                         .hintColor
                    //                         .withOpacity(0.6)),
                    //           ),
                    //         ),
                    //       ),
                    //     ]),
                    // const SizedBox(height: 10),

                    !_isLoading
                        ? const TermsAndConditionsText()
                        : const SizedBox(),

                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.loginErrorMessage!.isNotEmpty
                              ? CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  radius: 5)
                              : const SizedBox.shrink(),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                            authProvider.loginErrorMessage ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          )),
                        ]),
                    const SizedBox(height: 10),

                    // for login button

                    !_isLoading
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: CustomButton(
                              // backgroundColor: const Color(0xFFF9B233),
                              buttonText: getTranslated('continue', context),
                              onPressed: () async {
                                String email = authProvider
                                    .phoneEmailController.text
                                    .trim()
                                    .toString();
                                // String? dialCode =
                                //     CountryCode.fromCountryCode(
                                //             countryCode!)
                                //         .dialCode;
                                if (!Provider.of<SplashProvider>(context,
                                        listen: false)
                                    .configModel!
                                    .emailVerification!) {
                                  // email = dialCode! +
                                  //     _emailController!.text.trim();
                                }
                                // String password =
                                //     _passwordController!.text.trim();
                                if (email.isEmpty) {
                                  if (!authProvider.isLoginWithPhone) {
                                    showCustomSnackBar(getTranslated(
                                        'enter_email_address', context)!);
                                  } else {
                                    showCustomSnackBar(getTranslated(
                                        'enter_phone_number', context)!);
                                  }
                                } else if ((!authProvider.isLoginWithPhone) &&
                                    EmailChecker.isNotValid(email)) {
                                  showCustomSnackBar(getTranslated(
                                      'enter_valid_email', context)!);
                                } else if (authProvider.isLoginWithPhone &&
                                    authProvider
                                            .phoneEmailController.text.length !=
                                        10) {
                                  showCustomSnackBar(getTranslated(
                                      'enter_complete_phone_number', context)!);
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  showNumberConfirmPopup(context)
                                      .then((value) async {
                                    if (kDebugMode) {
                                      print('confirm value is: $value');
                                    }
                                    if (value == true) {
                                      if (authProvider.isLoginWithPhone) {
                                        await authProvider
                                            .verifyPhoneNumber(context, email)
                                            .then((val) {
                                          if (kDebugMode) {
                                            print(
                                                'phone verification vallllll is: $val');
                                          }
                                          if (val != null) {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouteHelper.otp,
                                                (route) => false,
                                                arguments: const OTPScreen());
                                          }
                                        });
                                      } else {
                                        authProvider
                                            .loginOtp(email.toString())
                                            .then((status) async {
                                          print('resp status is: $status');
                                          if (status.isSuccess) {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouteHelper.otp,
                                                (route) => false,
                                                arguments: const OTPScreen());
                                          } else {
                                            print('login failed');
                                          }
                                        });
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  });

                                  // authProvider
                                  //     .login(email, password)
                                  //     .then((status) async {
                                  //   if (status.isSuccess) {
                                  //     if (authProvider.isActiveRememberMe) {
                                  //       authProvider
                                  //           .saveUserNumberAndPassword(
                                  //               UserLogData(
                                  //         countryCode: dialCode,
                                  //         phoneNumber:
                                  //             configModel.emailVerification!
                                  //                 ? null
                                  //                 : _emailController!.text,
                                  //         email:
                                  //             configModel.emailVerification!
                                  //                 ? _emailController!.text
                                  //                 : null,
                                  //         password: password,
                                  //       ));
                                  //     } else {
                                  //       authProvider.clearUserLogData();
                                  //     }
                                  //
                                  //     Navigator.pushNamedAndRemoveUntil(
                                  //         context,
                                  //         RouteHelper.menu,
                                  //         (route) => false,
                                  //         arguments: const MenuScreen());
                                  //   }
                                  // });
                                }
                              },
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          )),
                    const SizedBox(height: 20),

                    // for create an account
                    !_isLoading
                        ? InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  RouteHelper.createAccount,
                                  arguments: const CreateAccountScreen());
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated(
                                            'create_an_account', context)!,
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(0.6)),
                                      ),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeSmall),
                                      Text(
                                        getTranslated('signup', context)!,
                                        style: poppinsMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color
                                                ?.withOpacity(0.6)),
                                      ),
                                    ])),
                          )
                        : const SizedBox(),

                    !_isLoading &&
                            (socialStatus!.isFacebook! ||
                                socialStatus.isGoogle!)
                        ? const Center(child: SocialLoginWidget())
                        : const SizedBox(),

                    !_isLoading
                        ? Center(
                            child: Text(getTranslated('OR', context)!,
                                style: poppinsRegular.copyWith(fontSize: 12)))
                        : const SizedBox(),

                    !_isLoading
                        ? Center(
                            child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(1, 40),
                            ),
                            onPressed: () async {
                              await Provider.of<AuthProvider>(Get.context!,
                                      listen: false)
                                  .loginGuest();
                              Navigator.of(Get.context!).pushReplacementNamed(
                                  RouteHelper.splash,
                                  arguments: const SplashScreen());
                            },
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      '${getTranslated('continue_as_a', context)} ',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.6))),
                              TextSpan(
                                  text: getTranslated('guest', context),
                                  style: poppinsRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color)),
                            ])),
                          ))
                        : const SizedBox(),
                  ],
                )),
              ),
            )),
            ResponsiveHelper.isDesktop(context)
                ? const SizedBox(
                    height: 50,
                  )
                : const SizedBox(),
            ResponsiveHelper.isDesktop(context)
                ? const FooterView()
                : const SizedBox(),
          ]),
        ),
      ))),
    );
  }

  Future<bool?> showNumberConfirmPopup(BuildContext context) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child:
                Consumer<AuthProvider>(builder: (context, authProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSizeDefault)),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'We will be verifying the ${authProvider.isLoginWithPhone ? 'phone number' : 'email'}:',
                          style: poppinsRegular.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Text(
                            '${authProvider.isLoginWithPhone ? '+91 ' : ''}${authProvider.phoneEmailController.text}'),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Text(
                            'Is this OK, or would you like to edit the ${authProvider.isLoginWithPhone ? 'phone number' : 'email'}.'),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(false),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSizeDefault)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeSmall,
                                      horizontal:
                                          Dimensions.paddingSizeDefault),
                                  child: Text(
                                    'EDIT',
                                    style: poppinsRegular.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.of(context).pop(true);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSizeDefault)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeSmall,
                                      horizontal:
                                          Dimensions.paddingSizeDefault),
                                  child: Text(
                                    'CONFIRM',
                                    style: poppinsRegular.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
