import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/signup_model.dart';
import 'package:shreeveg/view/screens/menu/main_screen.dart';
import '../../../helper/email_checker.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../localization/language_constraints.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/footer_view.dart';
import '../../base/web_app_bar/web_app_bar.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late Timer _timer;
  int _secondsRemaining = 120;

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  GlobalKey<FormState>? _formKeyLoginOtp;

  @override
  void initState() {
    super.initState();
    startTimer();
    _formKeyLoginOtp = GlobalKey<FormState>();
    if (Provider.of<AuthProvider>(context, listen: false).isLoginWithPhone ==
        false) {
      pinController.text =
          Provider.of<AuthProvider>(context, listen: false).getUserOtp();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel(); // Stop the timer when it reaches 0.
        }
      });
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer.cancel(); // Cancel the timer to avoid memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0.2);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );

    double width = MediaQuery.of(context).size.width;

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
                  : SizedBox(height: MediaQuery.of(context).size.height * 0.25),
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
                      key: _formKeyLoginOtp,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Text(
                              getTranslated('login_using_otp', context)!,
                              style: poppinsRegular.copyWith(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            FittedBox(
                              child: Text(
                                getTranslated('check_mobile_otp', context)!,
                                style: poppinsRegular.copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${authProvider.isLoginWithPhone ? '+91 xxxxxxx' : ''}${authProvider.isLoginWithPhone ? authProvider.phoneEmailController.text.substring(7) : authProvider.phoneEmailController.text}',
                                  style: poppinsRegular.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                // const SizedBox(
                                //   width: 20,
                                // ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20),
                                //       border: Border.all(
                                //           color: const Color(0xFFFD4F4F),
                                //           width: 2.0)),
                                //   child: Padding(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 8.0, vertical: 3.0),
                                //     child: Text(
                                //       getTranslated('Change', context)!,
                                //       style: poppinsRegular.copyWith(
                                //           color: const Color(0xFFFD4F4F),
                                //           fontSize: 10,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Pinput(
                              length: authProvider.isLoginWithPhone ? 6 : 4,
                              controller: pinController,
                              focusNode: focusNode,
                              // androidSmsAutofillMethod:
                              //     AndroidSmsAutofillMethod.smsUserConsentApi,
                              // listenForMultipleSmsOnAndroid: true,
                              defaultPinTheme: defaultPinTheme,
                              separatorBuilder: (index) =>
                                  const SizedBox(width: 4),
                              // validator: (value) {
                              //   return value ==
                              //           (authProvider.isLoginWithPhone
                              //               ? authProvider.otpCode
                              //               : authProvider.getUserOtp())
                              //       ? null
                              //       : 'Pin is incorrect';
                              // },
                              // onClipboardFound: (value) {
                              //   debugPrint('onClipboardFound: $value');
                              //   pinController.setText(value);
                              // },
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
                              onCompleted: (pin) {
                                debugPrint('onCompleted: $pin');
                              },
                              onChanged: (value) {
                                debugPrint('onChanged: $value');
                              },
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 9),
                                    width: 22,
                                    height: 1,
                                    color: focusedBorderColor,
                                  ),
                                ],
                              ),
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: focusedBorderColor),
                                ),
                              ),
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  color: fillColor,
                                  borderRadius: BorderRadius.circular(19),
                                  border: Border.all(color: focusedBorderColor),
                                ),
                              ),
                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                border: Border.all(color: Colors.redAccent),
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${getTranslated('confirm_within', context)!} ',
                                    style: poppinsRegular.copyWith(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: '$_secondsRemaining s',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFFD4F4F),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            InkWell(
                              onTap: () => print('resend code'),
                              child: Text(
                                getTranslated('resend_code', context)!,
                                style: poppinsRegular.copyWith(
                                    color: const Color(0xFF0B4619),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),

                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.loginErrorMessage!.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                  )),
                                ]),
                            const SizedBox(height: 10),

                            // for login button
                            !authProvider.isLoading
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: CustomButton(
                                      buttonText:
                                          getTranslated('login', context),
                                      onPressed: () async {
                                        var otp = pinController.text;
                                        var veri =
                                            authProvider.getVerificationId();
                                        print(otp);
                                        print(veri);

                                        if (authProvider.isLoginWithPhone) {
                                          authProvider
                                              .setOtpCode(pinController.text);
                                          await authProvider
                                              .signInWithPhoneNumber(context);
                                        } else {
                                          String email = authProvider
                                              .getUserEmailOrPhone();
                                          String otp =
                                              pinController.text.length == 6
                                                  ? pinController.text
                                                  : authProvider.getUserOtp();
                                          await authProvider
                                              .login(email, otp)
                                              .then((loginStatus) async {
                                            print(
                                                'login status is: $loginStatus');
                                            if (loginStatus.isSuccess) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  RouteHelper.main,
                                                  (route) => false,
                                                  arguments:
                                                      const MainScreen());
                                            }
                                          });
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

                            // // for create an account
                            // InkWell(
                            //   onTap: () {
                            //     // Navigator.of(context).pushNamed(RouteHelper.signUp,
                            //     //     arguments: const SignUpScreen());
                            //     Navigator.of(context).pushNamed(
                            //         RouteHelper.createAccount,
                            //         arguments: const CreateAccountScreen());
                            //   },
                            //   child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           children: [
                            //             Text(
                            //               getTranslated(
                            //                   'create_an_account', context)!,
                            //               style: poppinsRegular.copyWith(
                            //                   fontSize: Dimensions.fontSizeSmall,
                            //                   color: Theme.of(context)
                            //                       .hintColor
                            //                       .withOpacity(0.6)),
                            //             ),
                            //             const SizedBox(
                            //                 width: Dimensions.paddingSizeSmall),
                            //             Text(
                            //               getTranslated('signup', context)!,
                            //               style: poppinsMedium.copyWith(
                            //                   fontSize: Dimensions.fontSizeSmall,
                            //                   color: Theme.of(context)
                            //                       .textTheme
                            //                       .bodyLarge
                            //                       ?.color
                            //                       ?.withOpacity(0.6)),
                            //             ),
                            //           ])),
                            // ),

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
                            // Center(
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(15.0),
                            //       child: Image.asset(
                            //         Images.loginLogo,
                            //         height: ResponsiveHelper.isDesktop(context)
                            //             ? MediaQuery.of(context).size.height * 0.15
                            //             : MediaQuery.of(context).size.height / 4.5,
                            //         fit: BoxFit.scaleDown,
                            //       ),
                            //     )),
                            //SizedBox(height: 20),

                            // Center(
                            //     child: Text(
                            //       getTranslated('login_signup', context)!,
                            //       style: poppinsMedium.copyWith(
                            //         fontSize: 24,
                            //         // color: Theme.of(context)
                            //         //     .textTheme
                            //         //     .bodyLarge
                            //         //     ?.color
                            //         //     ?.withOpacity(0.6)
                            //       ),
                            //     )),

                            // const SizedBox(height: 20),
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

                            // !loginWithPhone
                            //     ? Text(
                            //   getTranslated('email', context)!,
                            //   style: poppinsRegular.copyWith(
                            //       color: Theme.of(context)
                            //           .hintColor
                            //           .withOpacity(0.6)),
                            // )
                            //     : Text(
                            //   getTranslated('mobile_number', context)!,
                            //   style: poppinsRegular.copyWith(
                            //       color: Theme.of(context)
                            //           .hintColor
                            //           .withOpacity(0.6)),
                            // ),
                            // const SizedBox(height: Dimensions.paddingSizeSmall),

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

                            // CustomTextField(
                            //   controller: _emailController,
                            //   hintText: getTranslated(
                            //       loginWithPhone ? 'number_hint' : 'demo_gmail',
                            //       context),
                            //   isShowPrefixIcon: loginWithPhone,
                            //   prefixAssetUrl: Images.flag,
                            //   isShowSuffixIcon: true,
                            //   isloginWithPhone: loginWithPhone,
                            //   islogin: true,
                            //   inputType: !loginWithPhone
                            //       ? TextInputType.emailAddress
                            //       : TextInputType.emailAddress,
                            //   onSuffixTap: () => setState(() => loginWithPhone = !loginWithPhone),
                            // ),

                            // const SizedBox(height: Dimensions.paddingSizeLarge),

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

                            // const TermsAndConditionsText(),

                            // if (socialStatus!.isFacebook! || socialStatus.isGoogle!)
                            //   const Center(child: SocialLoginWidget()),
                            //
                            // Center(
                            //     child: Text(getTranslated('OR', context)!,
                            //         style: poppinsRegular.copyWith(fontSize: 12))),
                            //
                            // Center(
                            //     child: TextButton(
                            //       style: TextButton.styleFrom(
                            //         minimumSize: const Size(1, 40),
                            //       ),
                            //       onPressed: () {
                            //         Navigator.pushReplacementNamed(
                            //             context, RouteHelper.menu,
                            //             arguments: const MenuScreen());
                            //       },
                            //       child: RichText(
                            //           text: TextSpan(children: [
                            //             TextSpan(
                            //                 text:
                            //                 '${getTranslated('continue_as_a', context)} ',
                            //                 style: poppinsRegular.copyWith(
                            //                     fontSize: Dimensions.fontSizeSmall,
                            //                     color: Theme.of(context)
                            //                         .hintColor
                            //                         .withOpacity(0.6))),
                            //             TextSpan(
                            //                 text: getTranslated('guest', context),
                            //                 style: poppinsRegular.copyWith(
                            //                     color: Theme.of(context)
                            //                         .textTheme
                            //                         .bodyLarge!
                            //                         .color)),
                            //           ])),
                            //     )),
                          ],
                        ),
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
        ))));
  }
}
