import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/response_model.dart';
import 'package:shreeveg/data/model/response/userinfo_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/profile/web/profile_screen_web.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserInfoModel? userInfoModel;

  const ProfileEditScreen({Key? key, this.userInfoModel}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;

  FocusNode? firstNameFocus;
  FocusNode? lastNameFocus;
  FocusNode? emailFocus;
  FocusNode? phoneFocus;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    emailFocus = FocusNode();
    phoneFocus = FocusNode();

    _firstNameController!.text = widget.userInfoModel!.userInfo!.fName ?? '';
    _lastNameController!.text = widget.userInfoModel!.userInfo!.lName ?? '';
    _emailController!.text = widget.userInfoModel!.userInfo!.email ?? '';
    _phoneController!.text = widget.userInfoModel!.userInfo!.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: getTranslated('my_profile', context)!,
              backgroundColor: Theme.of(context).primaryColor,
              buttonTextColor: Colors.white) as PreferredSizeWidget,
      // AppBar(
      //         backgroundColor: Theme.of(context).cardColor,
      //         leading: IconButton(
      //             icon: Icon(Icons.arrow_back_ios,
      //                 color: Theme.of(context).primaryColor),
      //             onPressed: () {
      //               Provider.of<SplashProvider>(context, listen: false)
      //                   .setPageIndex(0);
      //               Navigator.of(context).pop();
      //             }),
      //         title: Text(getTranslated('update_profile', context) ?? '',
      //             style: poppinsMedium.copyWith(
      //               fontSize: Dimensions.fontSizeSmall,
      //               color: Theme.of(context).textTheme.bodyLarge!.color,
      //             )),
      //       ),
      body: ResponsiveHelper.isDesktop(context)
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
              return const Text('');
              // return ProfileScreenWeb(
              //   file: profileProvider.data,
              //   pickImage: profileProvider.pickImage,
              //   confirmPasswordController: _confirmPasswordController,
              //   confirmPasswordFocus: confirmPasswordFocus,
              //   emailController: _emailController,
              //   firstNameController: _firstNameController,
              //   firstNameFocus: firstNameFocus,
              //   lastNameController: _lastNameController,
              //   lastNameFocus: lastNameFocus,
              //   emailFocus: emailFocus,
              //   passwordController: _passwordController,
              //   passwordFocus: passwordFocus,
              //   phoneNumberController: _phoneController,
              //   phoneNumberFocus: phoneFocus,
              //   image: widget.userInfoModel!.image,
              //   userInfoModel: widget.userInfoModel,
              // );
            })
          : SafeArea(
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) => Scrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  // for profile image
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 25, bottom: 24),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorResources.getGreyColor(
                                              context),
                                          width: 3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (ResponsiveHelper.isMobilePhone()) {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SafeArea(
                                                child: Wrap(
                                                  children: <Widget>[
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.camera),
                                                      title: Text('Take Photo'),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        profileProvider
                                                            .choosePhoto(
                                                                fromCamera:
                                                                    true);
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.photo_library),
                                                      title: const Text(
                                                          'Choose from Gallery'),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        profileProvider
                                                            .choosePhoto(
                                                                fromCamera:
                                                                    false);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          profileProvider.pickImage();
                                        }
                                      },
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: profileProvider.file != null
                                                ? Image.file(
                                                    profileProvider.file!,
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.fill)
                                                : profileProvider.data != null
                                                    ? Image.network(
                                                        profileProvider
                                                            .data!.path,
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.fill)
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder: Images
                                                              .placeholder(
                                                                  context),
                                                          width: 80,
                                                          height: 80,
                                                          fit: BoxFit.cover,
                                                          image:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}'
                                                              '/${profileProvider.userInfoModel!.userInfo!.image}',
                                                          imageErrorBuilder: (c,
                                                                  o, s) =>
                                                              Image.asset(
                                                                  Images.placeholder(
                                                                      context),
                                                                  height: 80,
                                                                  width: 80,
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            right: 0,
                                            child: Image.asset(
                                              Images.camera,
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  //for name
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${profileProvider.userInfoModel!.userInfo!.fName ?? ''} ${profileProvider.userInfoModel!.userInfo!.lName ?? ''}',
                                        style: poppinsMedium.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge),
                                      ),
                                      Text(
                                        '${getTranslated('user_id', context)} ${profileProvider.userInfoModel!.userInfo!.id ?? ''}',
                                        style: poppinsMedium.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF989898),
                                            fontSize:
                                                Dimensions.fontSizeDefault),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            //name,email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // for first name section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        getTranslated('first_name', context)!,
                                        style: poppinsRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    CustomTextField(
                                      hintText: getTranslated(
                                          'enter_first_name', context),
                                      isElevation: false,
                                      showLabel: false,
                                      borderRadius: 0,
                                      isPadding: false,
                                      isShowBorder: true,
                                      controller: _firstNameController,
                                      focusNode: firstNameFocus,
                                      nextFocus: lastNameFocus,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // for Last name section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        getTranslated('last_name', context)!,
                                        style: poppinsRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    CustomTextField(
                                      hintText: getTranslated(
                                          'enter_last_name', context),
                                      isElevation: false,
                                      isPadding: false,
                                      controller: _lastNameController,
                                      focusNode: lastNameFocus,
                                      nextFocus: emailFocus,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // for email section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        getTranslated('email', context)!,
                                        style: poppinsRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    CustomTextField(
                                      hintText: getTranslated(
                                          'enter_email_address', context),
                                      isElevation: false,
                                      isPadding: false,
                                      controller: _emailController,
                                      focusNode: emailFocus,
                                      nextFocus: phoneFocus,
                                      inputType: TextInputType.emailAddress,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // for Phone Number section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        getTranslated(
                                                'phone_number', context) ??
                                            '',
                                        style: poppinsRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    CustomTextField(
                                      isEnabled: _phoneController?.text == '',
                                      hintText: getTranslated(
                                          'enter_phone_number', context),
                                      isElevation: false,
                                      isPadding: false,
                                      controller: _phoneController,
                                      inputType: TextInputType.phone,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // if (profileProvider
                                //         .userInfoModel!.loginMedium ==
                                //     'general')
                                //   Column(
                                //     children: [
                                //       Stack(
                                //         children: [
                                //           Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               Padding(
                                //                 padding:
                                //                     const EdgeInsets.symmetric(
                                //                         horizontal: 20),
                                //                 child: Text(
                                //                   getTranslated('password',
                                //                           context) ??
                                //                       '',
                                //                   style:
                                //                       poppinsRegular.copyWith(
                                //                     fontSize: Dimensions
                                //                         .fontSizeExtraSmall,
                                //                     color: Theme.of(context)
                                //                         .hintColor
                                //                         .withOpacity(0.6),
                                //                   ),
                                //                 ),
                                //               ),
                                //               CustomTextField(
                                //                 hintText: getTranslated(
                                //                     'password_hint', context),
                                //                 isElevation: false,
                                //                 isPadding: false,
                                //                 isPassword: true,
                                //                 isShowSuffixIcon: true,
                                //                 controller: _passwordController,
                                //                 focusNode: passwordFocus,
                                //                 nextFocus: confirmPasswordFocus,
                                //               ),
                                //             ],
                                //           ),
                                //           const Positioned(
                                //               bottom: 0,
                                //               left: 20,
                                //               right: 20,
                                //               child: Divider()),
                                //         ],
                                //       ),
                                //       const SizedBox(height: 15),
                                //       Stack(
                                //         children: [
                                //           Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               Padding(
                                //                 padding:
                                //                     const EdgeInsets.symmetric(
                                //                         horizontal: 20),
                                //                 child: Text(
                                //                   getTranslated(
                                //                           'confirm_password',
                                //                           context) ??
                                //                       '',
                                //                   style:
                                //                       poppinsRegular.copyWith(
                                //                     fontSize: Dimensions
                                //                         .fontSizeExtraSmall,
                                //                     color: Theme.of(context)
                                //                         .hintColor
                                //                         .withOpacity(0.6),
                                //                   ),
                                //                 ),
                                //               ),
                                //               CustomTextField(
                                //                 hintText: getTranslated(
                                //                     'password_hint', context),
                                //                 isElevation: false,
                                //                 isPadding: false,
                                //                 isPassword: true,
                                //                 isShowSuffixIcon: true,
                                //                 controller:
                                //                     _confirmPasswordController,
                                //                 focusNode: confirmPasswordFocus,
                                //                 inputAction:
                                //                     TextInputAction.done,
                                //               ),
                                //             ],
                                //           ),
                                //           const Positioned(
                                //               bottom: 0,
                                //               left: 20,
                                //               right: 20,
                                //               child: Divider()),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                              ],
                            ),

                            const SizedBox(height: 50),
                            !profileProvider.isLoading
                                ? TextButton(
                                    onPressed: () async {
                                      String firstName =
                                          _firstNameController!.text.trim();
                                      String lastName =
                                          _lastNameController!.text.trim();
                                      String phoneNumber =
                                          _phoneController!.text.trim();
                                      // String password =
                                      //     _passwordController!.text.trim();
                                      // String confirmPassword =
                                      //     _confirmPasswordController!.text
                                      //         .trim();
                                      if (profileProvider
                                                  .userInfoModel!.userInfo!.fName ==
                                              firstName &&
                                          profileProvider
                                                  .userInfoModel!.userInfo!.lName ==
                                              lastName &&
                                          profileProvider
                                                  .userInfoModel!.userInfo!.phone ==
                                              phoneNumber &&
                                          profileProvider
                                                  .userInfoModel!.userInfo!.email ==
                                              _emailController!.text &&
                                          profileProvider.file == null &&
                                          profileProvider.data == null) {
                                        showCustomSnackBar(getTranslated(
                                            'change_something_to_update',
                                            context)!);
                                      } else if (firstName.isEmpty) {
                                        showCustomSnackBar(getTranslated(
                                            'enter_first_name', context)!);
                                      } else if (lastName.isEmpty) {
                                        showCustomSnackBar(getTranslated(
                                            'enter_last_name', context)!);
                                      } else if (phoneNumber.isEmpty) {
                                        showCustomSnackBar(getTranslated(
                                            'enter_phone_number', context)!);
                                      }
                                      // else if ((password.isNotEmpty &&
                                      //         password.length < 6) ||
                                      //     (confirmPassword.isNotEmpty &&
                                      //         confirmPassword.length < 6)) {
                                      //   showCustomSnackBar(getTranslated(
                                      //       'password_should_be', context)!);
                                      // } else if (password != confirmPassword) {
                                      //   showCustomSnackBar(getTranslated(
                                      //       'password_did_not_match',
                                      //       context)!);
                                      // }
                                      else {
                                        UserInfoModel updateUserInfoModel =
                                            profileProvider.userInfoModel!;
                                        updateUserInfoModel.userInfo!.fName =
                                            _firstNameController!.text;
                                        updateUserInfoModel.userInfo!.lName =
                                            _lastNameController!.text;
                                        updateUserInfoModel.userInfo!.phone =
                                            _phoneController!.text;
                                        updateUserInfoModel.userInfo!.email =
                                            _emailController!.text;

                                        ResponseModel responseModel =
                                            await profileProvider
                                                .updateUserInfo(
                                          updateUserInfoModel,
                                          profileProvider.file,
                                          profileProvider.data,
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .getUserToken(),
                                        );
                                        if (responseModel.isSuccess) {
                                          profileProvider.getUserInfo();
                                          // _passwordController!.text = '';
                                          // _confirmPasswordController!.text = '';
                                          ToastService()
                                              .show('updated_successfully'.tr);
                                        } else {
                                          showCustomSnackBar(
                                              responseModel.message!,
                                              isError: true);
                                        }
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          getTranslated(
                                              'save_changes', context)!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CustomLoader(
                                        color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
