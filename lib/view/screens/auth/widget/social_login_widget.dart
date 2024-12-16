import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shreeveg/data/model/social_login_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/screens/menu/main_screen.dart';
import 'package:shreeveg/view/screens/menu/menu_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();

  void route(
    bool isRoute,
    String? token,
    String? errorMessage,
  ) async {
    if (isRoute) {
      if (token != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteHelper.main, (route) => false,
            arguments: const MainScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage ?? ''), backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage ?? ''), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Column(children: [
        Center(
            child: Text('${getTranslated('sign_in_with', context)}',
                style: poppinsRegular.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.6),
                    fontSize: Dimensions.fontSizeSmall))),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .socialLoginStatus!
              .isGoogle!)
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      const List<String> scopes = <String>[
                        'email',
                        'https://www.googleapis.com/auth/contacts.readonly',
                      ];

                      GoogleSignIn _googleSignIn = GoogleSignIn(
                        scopes: scopes,
                      );

                      print('google sign in: ${_googleSignIn}');
                      if (_googleSignIn.currentUser == null) {
                        final GoogleSignInAccount? googleUser =
                            await _googleSignIn.signIn();

                        print('google account is: $googleUser');

                        if (googleUser != null) {
                          // Signed in successfully
                          // You can now obtain the user's information such as email, display name, etc.
                          final GoogleSignInAuthentication
                              googleSignInAuthentication =
                              await googleUser.authentication;

                          print('gogleauth is: $googleSignInAuthentication');

                          Provider.of<AuthProvider>(Get.context!, listen: false)
                              .socialLogin(
                                  SocialLoginModel(
                                    email: googleUser.email,
                                    token: googleSignInAuthentication.idToken,
                                    uniqueId: googleUser.id,
                                    medium: 'google',
                                  ),
                                  route);
                        }
                      }
                    } catch (error) {
                      print(error);
                    }

                    //
                    //   // Use the credential to authenticate with your backend server or Firebase
                    //   // FirebaseAuthentication.signInWithCredential(credential);
                    // } else {
                    //   print('user cancelled');
                    //   // User cancelled the sign-in process
                    //   // Handle accordingly
                    // }
                  },
                  child: Container(
                    height: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                    width: ResponsiveHelper.isDesktop(context)
                        ? 130
                        : ResponsiveHelper.isTab(context)
                            ? 110
                            : 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.1),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Dimensions.radiusSizeTen)),
                    ),
                    child: Image.asset(
                      Images.google,
                      height: ResponsiveHelper.isDesktop(context)
                          ? 30
                          : ResponsiveHelper.isTab(context)
                              ? 25
                              : 20,
                      width: ResponsiveHelper.isDesktop(context)
                          ? 30
                          : ResponsiveHelper.isTab(context)
                              ? 25
                              : 20,
                    ),
                  ),
                ),
                if (Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .socialLoginStatus!
                    .isFacebook!)
                  const SizedBox(
                    width: Dimensions.paddingSizeDefault,
                  ),
              ],
            ),
          if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .socialLoginStatus!
              .isFacebook!)
            InkWell(
              onTap: () async {
                LoginResult result = await FacebookAuth.instance.login();

                if (result.status == LoginStatus.success) {
                  Map userData = await FacebookAuth.instance.getUserData();

                  authProvider.socialLogin(
                    SocialLoginModel(
                      email: userData['email'],
                      token: result.accessToken!.token,
                      uniqueId: result.accessToken!.userId,
                      medium: 'facebook',
                    ),
                    route,
                  );
                }
              },
              child: Container(
                height: ResponsiveHelper.isDesktop(context)
                    ? 50
                    : ResponsiveHelper.isTab(context)
                        ? 40
                        : 40,
                width: ResponsiveHelper.isDesktop(context)
                    ? 130
                    : ResponsiveHelper.isTab(context)
                        ? 110
                        : 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.1),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Dimensions.radiusSizeTen)),
                ),
                child: Image.asset(
                  Images.facebook,
                  height: ResponsiveHelper.isDesktop(context)
                      ? 30
                      : ResponsiveHelper.isTab(context)
                          ? 25
                          : 20,
                  width: ResponsiveHelper.isDesktop(context)
                      ? 30
                      : ResponsiveHelper.isTab(context)
                          ? 25
                          : 20,
                ),
              ),
            ),
        ]),
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
      ]);
    });
  }
}
