import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/signup_model.dart';
import 'package:shreeveg/helper/email_checker.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/screens/auth/login_screen.dart';
import 'package:shreeveg/view/screens/auth/otp_screen.dart';
import 'package:shreeveg/view/screens/auth/widget/country_code_picker_widget.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/auth/widget/terms_conditions_widget.dart';
import 'package:shreeveg/view/screens/menu/menu_screen.dart';
import 'package:provider/provider.dart';

const List<Map<String, String>> genders = [
  {'Male': Images.male},
  {'Female': Images.female},
  {'Other': Images.other}
];

const List<String> languages = ['हिन्दी', 'English'];

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _fullNameFocus = FocusNode();

  // final FocusNode _firstNameFocus = FocusNode();
  //
  // final FocusNode _lastNameFocus = FocusNode();

  final FocusNode _emailFocus = FocusNode();

  final FocusNode _numberFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  final FocusNode _referTextFocus = FocusNode();

  final TextEditingController _fullNameController = TextEditingController();

  // final TextEditingController _firstNameController = TextEditingController();
  //
  // final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _numberController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  // final TextEditingController _passwordController = TextEditingController();
  //
  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();

  final TextEditingController _referTextController = TextEditingController();

  String? selectedGender;
  String? selectedLanguage;

  bool acceptTerms = false;

  void updateTerms() {
    setState(() {
      acceptTerms = !acceptTerms;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final config =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    String? countryDialCode = CountryCode.fromCountryCode(config.country!).code;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Center(
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            physics: const BouncingScrollPhysics(),
            child: Center(
                child: Column(children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height - 560
                        : MediaQuery.of(context).size.height),
                child: Container(
                  width: width > 700 ? 700 : width,
                  padding: ResponsiveHelper.isDesktop(context)
                      ? const EdgeInsets.symmetric(horizontal: 50, vertical: 50)
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          Images.loginLogo,
                          height: ResponsiveHelper.isDesktop(context)
                              ? MediaQuery.of(context).size.height * 0.15
                              : MediaQuery.of(context).size.height / 9.5,
                          fit: BoxFit.scaleDown,
                        ),
                      )),
                      // const SizedBox(height: 30),

                      Center(
                          child: Text(
                        getTranslated('create_account', context)!,
                        style: poppinsMedium.copyWith(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )),
                      const SizedBox(height: 30),

                      // for gender section
                      Text(
                        getTranslated('gender', context)!,
                        style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          genders
                              .length, // Replace this with the number of items you want in the row
                          (index) => InkWell(
                            onTap: () => _isLoading
                                ? () {}
                                : setState(() => selectedGender =
                                    genders[index].entries.elementAt(0).key),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue,
                                          width: selectedGender != null &&
                                                  selectedGender ==
                                                      genders[index]
                                                          .entries
                                                          .elementAt(0)
                                                          .key
                                              ? 2
                                              : 0),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.asset(
                                    genders[index].entries.elementAt(0).value,
                                    height: ResponsiveHelper.isDesktop(context)
                                        ? MediaQuery.of(context).size.height *
                                            0.15
                                        : MediaQuery.of(context).size.height /
                                            11.0,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                Text(
                                  getTranslated(
                                      genders[index].entries.elementAt(0).key,
                                      context)!,
                                  style: poppinsRegular.copyWith(
                                      color: Theme.of(context)
                                          .hintColor
                                          .withOpacity(selectedGender != null &&
                                                  selectedGender ==
                                                      genders[index]
                                                          .entries
                                                          .elementAt(0)
                                                          .key
                                              ? 1.0
                                              : 0.5)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      //for full name section
                      Text(
                        getTranslated('full_name', context)!,
                        style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      CustomTextField(
                        isEnabled: !_isLoading,
                        hintText: 'John Doe',
                        isShowBorder: true,
                        controller: _fullNameController,
                        focusNode: _fullNameFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      //
                      // // for last name section
                      // Text(
                      //   getTranslated('last_name', context)!,
                      //   style: poppinsRegular.copyWith(
                      //       color:
                      //           Theme.of(context).hintColor.withOpacity(0.6)),
                      // ),
                      // const SizedBox(height: Dimensions.paddingSizeSmall),
                      //
                      // CustomTextField(
                      //   hintText: 'Doe',
                      //   isShowBorder: true,
                      //   controller: _lastNameController,
                      //   focusNode: _lastNameFocus,
                      //   nextFocus: _emailFocus,
                      //   inputType: TextInputType.name,
                      //   capitalization: TextCapitalization.words,
                      // ),
                      // const SizedBox(height: Dimensions.paddingSizeLarge),

                      //~~~Email Section Added

                      (config.emailVerification!)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated('email', context)!,
                                  style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                CustomTextField(
                                  isEnabled: !_isLoading,
                                  hintText:
                                      getTranslated('demo_gmail', context),
                                  isShowBorder: true,
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  nextFocus: config.referEarnStatus!
                                      ? _referTextFocus
                                      : _passwordFocus,
                                  inputType: TextInputType.emailAddress,
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                              ],
                            )
                          : Container(),

                      // // for email section
                      // config.emailVerification!
                      //     ? Text(
                      //         getTranslated('mobile_number', context)!,
                      //         style: poppinsRegular.copyWith(
                      //             color: Theme.of(context)
                      //                 .hintColor
                      //                 .withOpacity(0.6)),
                      //       )
                      //     : Text(
                      //         getTranslated('email', context)!,
                      //         style: poppinsRegular.copyWith(
                      //             color: Theme.of(context)
                      //                 .hintColor
                      //                 .withOpacity(0.6)),
                      //       ),
                      // const SizedBox(height: Dimensions.paddingSizeSmall),

                      // config.emailVerification!
                      //     ? Row(children: [
                      //         CountryCodePickerWidget(
                      //           onChanged: (CountryCode countryCode) {
                      //             countryDialCode = countryCode.dialCode;
                      //           },
                      //           initialSelection: countryDialCode,
                      //           favorite: [countryDialCode!],
                      //           showDropDownButton: true,
                      //           padding: EdgeInsets.zero,
                      //           showFlagMain: true,
                      //           textStyle: TextStyle(
                      //               color: Theme.of(context)
                      //                   .textTheme
                      //                   .displayLarge!
                      //                   .color),
                      //         ),
                      //         Expanded(
                      //           child: CustomTextField(
                      //             hintText:
                      //                 getTranslated('number_hint', context),
                      //             isShowBorder: true,
                      //             controller: _numberController,
                      //             focusNode: _numberFocus,
                      //             nextFocus: config.referEarnStatus!
                      //                 ? _referTextFocus
                      //                 : _passwordFocus,
                      //             inputType: TextInputType.phone,
                      //           ),
                      //         ),
                      //       ])
                      //     : CustomTextField(
                      //         hintText: getTranslated('demo_gmail', context),
                      //         isShowBorder: true,
                      //         controller: _emailController,
                      //         focusNode: _emailFocus,
                      //         nextFocus: config.referEarnStatus!
                      //             ? _referTextFocus
                      //             : _passwordFocus,
                      //         inputType: TextInputType.emailAddress,
                      //       ),
                      // const SizedBox(height: Dimensions.paddingSizeLarge),

                      //for language section

                      Text(
                        getTranslated('language', context)!,
                        style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Row(
                        children: List.generate(
                          languages
                              .length, // Replace this with the number of items you want in the row
                          (index) => InkWell(
                            onTap: _isLoading
                                ? () {}
                                : () => setState(
                                    () => selectedLanguage = languages[index]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppConstants.textFormFieldColor,
                                        border: Border.all(
                                            color: Colors.blue,
                                            width: selectedLanguage != null &&
                                                    selectedLanguage ==
                                                        languages[index]
                                                ? 2
                                                : 0),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 30.0),
                                      child: Text(
                                        getTranslated(
                                            languages[index], context)!,
                                        style: poppinsRegular.copyWith(
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(
                                                    selectedLanguage != null &&
                                                            selectedLanguage ==
                                                                languages[index]
                                                        ? 1.0
                                                        : 0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // for phone section
                      Text(
                        getTranslated('phone_number', context)!,
                        style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      CustomTextField(
                        isEnabled: !_isLoading,
                        hintText: getTranslated('number_hint', context),
                        isShowBorder: true,
                        controller: _numberController,
                        focusNode: _numberFocus,
                        nextFocus: config.referEarnStatus!
                            ? _referTextFocus
                            : _passwordFocus,
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // // for password section
                      // Text(
                      //   getTranslated('password', context)!,
                      //   style: poppinsRegular.copyWith(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: 12),
                      // ),
                      // const SizedBox(height: Dimensions.paddingSizeSmall),
                      //
                      // CustomTextField(
                      //   hintText: getTranslated('password_hint', context),
                      //   isShowBorder: true,
                      //   isPassword: true,
                      //   controller: _passwordController,
                      //   focusNode: _passwordFocus,
                      //   nextFocus: _confirmPasswordFocus,
                      //   isShowSuffixIcon: true,
                      // ),
                      //
                      // const SizedBox(height: 22),
                      //
                      // // for confirm password section
                      // Text(
                      //   getTranslated('confirm_password', context)!,
                      //   style: poppinsRegular.copyWith(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: 12),
                      // ),
                      // const SizedBox(height: Dimensions.paddingSizeSmall),
                      //
                      // CustomTextField(
                      //   hintText: getTranslated('password_hint', context),
                      //   isShowBorder: true,
                      //   isPassword: true,
                      //   controller: _confirmPasswordController,
                      //   focusNode: _confirmPasswordFocus,
                      //   isShowSuffixIcon: true,
                      //   inputAction: TextInputAction.done,
                      // ),
                      // const SizedBox(height: 22),

                      //refer code
                      if (config.referEarnStatus!)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDirectionality(
                                child: Text(
                              '${getTranslated('refer_code', context)} (${getTranslated('optional', context)})',
                              style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            )),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextField(
                              isEnabled: !_isLoading,
                              hintText: '',
                              isShowBorder: true,
                              controller: _referTextController,
                              focusNode: _referTextFocus,
                              nextFocus: _passwordFocus,
                              inputType: TextInputType.text,
                            ),
                            // const SizedBox(height: Dimensions.paddingSizeLarge),
                          ],
                        ),

                      //tnc
                      TermsAndConditionsCheckbox(
                          callback: _isLoading ? () {} : updateTerms,
                          acceptTerms: acceptTerms),

                      // const SizedBox(height: 22),

                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     authProvider.registrationErrorMessage!.isNotEmpty
                      //         ? CircleAvatar(
                      //             backgroundColor:
                      //                 Theme.of(context).primaryColor,
                      //             radius: 5)
                      //         : const SizedBox.shrink(),
                      //     const SizedBox(width: 8),
                      //   ],
                      // ),

                      // for signup button
                      const SizedBox(height: 10),

                      !_isLoading
                          ? CustomButton(
                              buttonText: getTranslated('signup', context),
                              onPressed: () async {
                                String fullName =
                                    _fullNameController.text.trim();
                                String gender = selectedGender ?? '';
                                String number = _numberController.text.trim();
                                String email = _emailController.text.trim();
                                // String password =
                                //     _passwordController.text.trim();
                                // String confirmPassword =
                                //     _confirmPasswordController.text.trim();
                                // if (config.emailVerification!) {
                                if (selectedGender?.isEmpty ?? true) {
                                  showCustomSnackBar(
                                      getTranslated('select_gender', context)!);
                                } else if (fullName.isEmpty) {
                                  showCustomSnackBar(getTranslated(
                                      'enter_full_name', context)!);
                                } else if (email.isEmpty) {
                                  showCustomSnackBar(getTranslated(
                                      'enter_email_address', context)!);
                                } else if (EmailChecker.isNotValid(email)) {
                                  showCustomSnackBar(getTranslated(
                                      'enter_valid_email', context)!);
                                } else if (selectedLanguage == null) {
                                  showCustomSnackBar(getTranslated(
                                      'select_language', context)!);
                                } else if (number.isEmpty) {
                                  showCustomSnackBar(getTranslated(
                                      'enter_phone_number', context)!);
                                } else if (number.length < 10) {
                                  showCustomSnackBar(
                                      'Enter complete phone number');
                                } else {
                                  SignUpModel signUpModel = SignUpModel(
                                    gender: gender,
                                    fullName: fullName,
                                    email: email,
                                    language: selectedLanguage == 'English'
                                        ? 'en'
                                        : 'hi',
                                    phone: number,
                                    referralCode:
                                        _referTextController.text.trim(),
                                  );
                                  print("signUpModel:${signUpModel.toJson()}");

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  if (Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .phoneEmailController
                                          .text
                                          .isEmpty ||
                                      Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .phoneEmailController
                                              .text ==
                                          '') {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .phoneEmailController
                                        .text = number;
                                  }

                                  authProvider
                                      .verifyPhoneNumber(context, number)
                                      .then((value) async {
                                    print(
                                        'verification result is::::::::::: $value');
                                    if (value != null) {
                                      authProvider.authRepo!
                                          .saveSignupModel(signUpModel);
                                      await authProvider
                                          .registration(signUpModel)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          Navigator.pushNamed(
                                              context, RouteHelper.otp);
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  });

                                  // await authProvider.registration(signUpModel).then((status) async {
                                  //   if (status.isSuccess) {
                                  //
                                  //   }
                                  // });
                                }
                                // }
                                // else {
                                //   if (selectedGender == null) {
                                //     showCustomSnackBar(getTranslated(
                                //         'select_gender', context)!);
                                //   } else if (fullName.isEmpty) {
                                //     showCustomSnackBar(getTranslated(
                                //         'enter_full_name', context)!);
                                //   } else if (email.isEmpty) {
                                //     showCustomSnackBar(getTranslated(
                                //         'enter_email_address', context)!);
                                //   } else if (EmailChecker.isNotValid(email)) {
                                //     showCustomSnackBar(getTranslated(
                                //         'enter_valid_email', context)!);
                                //   } else if (selectedLanguage == null) {
                                //     showCustomSnackBar(getTranslated(
                                //         'select_language', context)!);
                                //   } else if (password.isEmpty) {
                                //     showCustomSnackBar(getTranslated(
                                //         'enter_password', context)!);
                                //   } else if (password.length < 6) {
                                //     showCustomSnackBar(getTranslated(
                                //         'password_should_be', context)!);
                                //   } else if (confirmPassword.isEmpty) {
                                //     showCustomSnackBar(getTranslated(
                                //         'enter_confirm_password', context)!);
                                //   } else if (password != confirmPassword) {
                                //     showCustomSnackBar(getTranslated(
                                //         'password_did_not_match', context)!);
                                //   } else {
                                //     SignUpModel signUpModel = SignUpModel(
                                //       gender: selectedGender,
                                //       fullName: fullName,
                                //       email: email,
                                //       language: selectedLanguage,
                                //       password: password,
                                //       phone: authProvider.email.trim(),
                                //       referralCode:
                                //           _referTextController.text.trim(),
                                //     );
                                //     authProvider
                                //         .registration(signUpModel)
                                //         .then((status) async {
                                //       if (status.isSuccess) {
                                //         Navigator.pushNamedAndRemoveUntil(
                                //             context,
                                //             RouteHelper.menu,
                                //             (route) => false,
                                //             arguments: const MenuScreen());
                                //       }
                                //     });
                                //   }
                                // }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )),

                      // for already an account
                      const SizedBox(height: 11),

                      // Row(
                      //   children: [
                      //     Expanded(
                      //         child: Text(
                      //       authProvider.registrationErrorMessage ?? "",
                      //       style: poppinsRegular.copyWith(
                      //           fontSize: Dimensions.fontSizeSmall,
                      //           color: Theme.of(context).primaryColor),
                      //     )),
                      //   ],
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              RouteHelper.login,
                              arguments: const LoginScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated(
                                      'already_have_account', context)!,
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.6)),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Text(
                                  getTranslated('login', context)!,
                                  style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.withOpacity(0.6)),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ResponsiveHelper.isDesktop(context)
                  ? const SizedBox(
                      height: 50,
                    )
                  : const SizedBox(),
              ResponsiveHelper.isDesktop(context)
                  ? const FooterView()
                  : const SizedBox(),
            ])),
          )),
        ),
      ),
    );
  }
}
