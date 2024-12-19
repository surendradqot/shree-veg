// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/base/error_response.dart';
import 'package:shreeveg/data/model/response/response_model.dart';
import 'package:shreeveg/data/model/response/signup_model.dart';
import 'package:shreeveg/data/model/response/user_log_data.dart';
import 'package:shreeveg/data/model/social_login_model.dart';
import 'package:shreeveg/data/repository/auth_repo.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/menu/main_screen.dart';

import '../helper/api_checker.dart';
import '../helper/route_helper.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/otp_screen.dart';
import '../view/screens/menu/menu_screen.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({required this.authRepo});

  // for registration section
  bool _isLoading = false;

  bool _isLoginWithPhone = true;
  String _otpCode = '000000';
  String _verificationId = 'verificationid';

  TextEditingController phoneEmailController = TextEditingController();

  bool get isLoading => _isLoading;
  bool get isLoginWithPhone => _isLoginWithPhone;
  String? _registrationErrorMessage = '';

  String? get registrationErrorMessage => _registrationErrorMessage;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  // GoogleSignInAccount googleAccount;

  updateRegistrationErrorMessage(String message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  setLoginWithPhone(bool isPhone) {
    _isLoginWithPhone = isPhone;
    notifyListeners();
  }

  setOtpCode(String code) {
    _otpCode = code;
    notifyListeners();
  }

  setVerificationId(String id) {
    _verificationId = id;
    notifyListeners();
  }

  Future<ResponseModel> registration(SignUpModel signUpModel) async {
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.registration(signUpModel);
    ResponseModel responseModel;
    String? token;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      try {
        if (map["token"] == null || map["token"] == 'null') {
          token = map["temporary_token"];
        } else {
          token = map["token"];
        }
      } catch (e) {
        token = map["temporary_token"];
      }

      // login(signUpModel.email, signUpModel.password);

      authRepo!.saveUserToken(token!);
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _registrationErrorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _registrationErrorMessage);
      ToastService().show(_registrationErrorMessage!);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> registrationNew(SignUpModel signUpModel) async {
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.registrationNew(signUpModel);
    ResponseModel responseModel;
    String? token;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      /*Map map = apiResponse.response!.data;
      try {
        if (map["token"] == null || map["token"] == 'null') {
          token = map["temporary_token"];
        } else {
          token = map["token"];
        }
      } catch (e) {
        token = map["temporary_token"];
      }

      // login(signUpModel.email, signUpModel.password);

      authRepo!.saveUserToken(token!);
      await authRepo!.updateToken();*/
      responseModel = ResponseModel(true, 'successful');
    } else {
      _registrationErrorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _registrationErrorMessage);
      ToastService().show(_registrationErrorMessage!);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> logoutNewMethod() async {
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.logoutNew();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Provider.of<AuthProvider>(Get.context!, listen: false)
          .clearSharedData();
      Provider.of<SplashProvider>(Get.context!, listen: false)
          .setPageIndex(0);
      Navigator.pushNamedAndRemoveUntil(
          Get.context!, RouteHelper.splash, (route) => false);
      responseModel = ResponseModel(true, 'successful');
    } else {
      _registrationErrorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _registrationErrorMessage);
      ToastService().show(_registrationErrorMessage!);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  // for login section
  String? _loginErrorMessage = '';

  String? get loginErrorMessage => _loginErrorMessage;

  Future<Map<String, String>?> verifyPhoneNumber(
      BuildContext context, String number) async {
    _isLoading = true;
    String phone = '+91${number.toString().trim()}';
    if (kDebugMode) {
      print('verifying phone number please wait..........$phone');
    }

    setLoginWithPhone(true);

    Completer<Map<String, String>> completer = Completer();

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        authRepo!.saveUserOTP(credential.smsCode!);
        authRepo!.saveUserVerificationId(credential.verificationId!);
        completer.complete({
          'smsCode': credential.smsCode!,
          'verificationId': credential.verificationId!,
        });
        _isLoading = false;
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          // Show toast message for invalid phone number format
          ToastService().show(
              'Invalid phone number format. Please enter a valid phone number.');
        }
        _isLoading = false;
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        authRepo!.saveUserVerificationId(verificationId);
        completer.complete({
          'smsCode': '',
          'verificationId': verificationId,
        });

        _isLoading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 120),
    );

    try {
      return await completer.future;
    } catch (e) {
      print('Error verifying phone number: $e');
      return null;
    }
  }

  Future<Map<String, String>?> loginPhoneNumber(
      BuildContext context, String number) async {
    _isLoading = true;
    String phone = '+91${number.toString().trim()}';
    if (kDebugMode) {
      print('verifying phone number please wait..........$phone');
    }

    setLoginWithPhone(true);
    try{
      Map<String, String>? responseData;
      await sendLoginOtp(number.trim())
          .then((loginOtpStatus) async {
        print('login otp resp status is: $loginOtpStatus');
        if (loginOtpStatus.isSuccess) {
          responseData = {"success": "true"};
          return {"success": "true"};
        } else {
          print('login otp failed');
          responseData = {"success": "false"};
          return {"success": "false"};
        }
      });
      return responseData;
    }catch(error){
      return {"success": "false"};
    }
  }

  Future<void> signInWithPhoneNumber(BuildContext context) async {
    // Create a PhoneAuthCredential with the code
    String smsCode = _otpCode;
    String verificationId = getVerificationId();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      try {
        await loginOtp(phoneEmailController.text.toString().trim())
            .then((loginOtpStatus) async {
          print(
              'phone login successful in firebase authentication:::::::: $value');
          print('login otp resp status is: $loginOtpStatus');
          if (loginOtpStatus.isSuccess) {
            String email = getUserEmailOrPhone();
            String otp = getUserOtp();
            await login(email, otp).then((loginStatus) async {
              print('login status is: $loginStatus');
              if (loginStatus.isSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteHelper.main, (route) => false,
                    arguments: const MainScreen());
              }
            });
          } else {
            print('login otp failed');
          }
        });

        await loginOtp(phoneEmailController.text.toString().trim())
            .then((loginOtpStatus) async {
          print(
              'phone login successful in firebase authentication:::::::: $value');
          print('login otp resp status is: $loginOtpStatus');
          if (loginOtpStatus.isSuccess) {
            String email = getUserEmailOrPhone();
            String otp = getUserOtp();
            await login(email, otp).then((loginStatus) async {
              print('login status is: $loginStatus');
              if (loginStatus.isSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteHelper.main, (route) => false,
                    arguments: const MainScreen());
              }
            });
          } else {
            print('login otp failed');
          }
        });
      } catch (err) {
        print('####err $err');
      }
    }).catchError((onError) {
      ToastService().show('Invalid otp or phone');
      // Navigator.pushNamedAndRemoveUntil(
      //     context, RouteHelper.main, (route) => false,
      //     arguments: const MainScreen());
      return null;
    });
    //   print('resp status is: $status');
    //   if (status.isSuccess) {);
  }

  Future<void> verificationMethod(BuildContext context) async {
    // Create a PhoneAuthCredential with the code
    // String smsCode = _otpCode;
    // String verificationId = getVerificationId();
    // PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //     verificationId: verificationId, smsCode: smsCode);
    try {
      await verifyLoginOtp(phoneEmailController.text.toString().trim(),_otpCode)
          .then((loginOtpStatus) async {
        print('login otp resp status is: $loginOtpStatus');
        if (loginOtpStatus.isSuccess) {
          String email = getUserEmailOrPhone();
          String otp = getUserOtp();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteHelper.main, (route) => false,
              arguments: const MainScreen());
          // await login(email, otp).then((loginStatus) async {
          //   print('login status is: $loginStatus');
          //   if (loginStatus.isSuccess) {
          //     Navigator.pushNamedAndRemoveUntil(
          //         context, RouteHelper.main, (route) => false,
          //         arguments: const MainScreen());
          //   }
          // });
        } else {
          print('login otp failed');
        }
      });
    } catch (err) {
      print('####err $err');
    }
    // Sign the user in (or link) with the credential
    /*await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      try {
        await loginOtp(phoneEmailController.text.toString().trim())
            .then((loginOtpStatus) async {
          print(
              'phone login successful in firebase authentication:::::::: $value');
          print('login otp resp status is: $loginOtpStatus');
          if (loginOtpStatus.isSuccess) {
            String email = getUserEmailOrPhone();
            String otp = getUserOtp();
            await login(email, otp).then((loginStatus) async {
              print('login status is: $loginStatus');
              if (loginStatus.isSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteHelper.main, (route) => false,
                    arguments: const MainScreen());
              }
            });
          } else {
            print('login otp failed');
          }
        });

        await loginOtp(phoneEmailController.text.toString().trim())
            .then((loginOtpStatus) async {
          print(
              'phone login successful in firebase authentication:::::::: $value');
          print('login otp resp status is: $loginOtpStatus');
          if (loginOtpStatus.isSuccess) {
            String email = getUserEmailOrPhone();
            String otp = getUserOtp();
            await login(email, otp).then((loginStatus) async {
              print('login status is: $loginStatus');
              if (loginStatus.isSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteHelper.main, (route) => false,
                    arguments: const MainScreen());
              }
            });
          } else {
            print('login otp failed');
          }
        });
      } catch (err) {
        print('####err $err');
      }
    }).catchError((onError) {
      ToastService().show('Invalid otp or phone');
      // Navigator.pushNamedAndRemoveUntil(
      //     context, RouteHelper.main, (route) => false,
      //     arguments: const MainScreen());
      return null;
    });*/
    //   print('resp status is: $status');
    //   if (status.isSuccess) {);
  }

  Future<void> firebaseLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<ResponseModel> loginOtp(String? emailOrPhone) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.loginOtp(emailOrPhone: emailOrPhone);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String otp = map["otp"].toString();
      authRepo!.saveUserOTP(otp);
      authRepo!.saveUserEmailOrPhone(emailOrPhone!);
      // showCustomSnackBar(otp);
      responseModel = ResponseModel(true, 'successful');
    } else {
      _loginErrorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> sendLoginOtp(String? emailOrPhone) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse =
    await authRepo!.loginOtpSend(emailOrPhone: emailOrPhone);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      // Map map = apiResponse.response!.data;
      // String otp = map["otp"].toString();
      // authRepo!.saveUserOTP(otp);
      // authRepo!.saveUserEmailOrPhone(emailOrPhone!);
      // showCustomSnackBar(otp);
      responseModel = ResponseModel(true, 'successful');
    } else {
      _loginErrorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyLoginOtp(String? emailOrPhone,String? otp) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.otpVerification(emailOrPhone: emailOrPhone,otp: otp );
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String otp = map['data']["otp"].toString();
      authRepo!.saveUserOTP(otp);
      authRepo!.saveUserEmailOrPhone(emailOrPhone!);
      String token = map['data']["token"];
      authRepo!.saveUserToken(token);
      await authRepo!.updateToken();
      // showCustomSnackBar(otp);
      _isLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
      return responseModel;
    } else {
      // _loginErrorMessage =
      //     ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      // responseModel = ResponseModel(false, _loginErrorMessage);
      _isLoading = false;
      notifyListeners();
      Map map = apiResponse.response!.data;
      ToastService().show(map['message']);
      responseModel = ResponseModel(false, map['message']);
      return responseModel;
    }

  }

  Future<ResponseModel> login(String? email, String? otp) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.login(email: email, otp: otp);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String token = map["token"];
      authRepo!.saveUserToken(token);
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _loginErrorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future deleteUser(BuildContext context) async {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await authRepo!.deleteUser();
    _isLoading = false;
    if (response.response!.statusCode == 200) {
      splashProvider.removeSharedData();
      showCustomSnackBar('your_account_remove_successfully'.tr);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    } else {
      Navigator.of(Get.context!).pop();
      ApiChecker.checkApi(response);
    }
  }

  // for forgot password
  bool _isForgotPasswordLoading = false;

  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  Future<ResponseModel> forgetPassword(String? email) async {
    _isForgotPasswordLoading = true;
    resendButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.forgetPassword(email);
    ResponseModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ErrorResponse.fromJson(apiResponse.error).errors![0].message);
    }
    _isForgotPasswordLoading = false;
    resendButtonLoading = false;

    notifyListeners();

    return responseModel;
  }

  Timer? _timer;
  int? currentTime;

  void startVerifyTimer() {
    _timer?.cancel();
    currentTime = Provider.of<SplashProvider>(Get.context!, listen: false)
            .configModel!
            .otpResendTime ??
        0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (currentTime! > 0) {
        currentTime = currentTime! - 1;
      } else {
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  Future<ResponseModel> resetPassword(String? mail, String? resetToken,
      String password, String confirmPassword) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!
        .resetPassword(mail, resetToken, password, confirmPassword);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ErrorResponse.fromJson(apiResponse.error).errors![0].message);
    }
    return responseModel;
  }

  Future<void> updateToken() async {
    ApiResponse apiResponse = await authRepo!.updateToken();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      //ErrorResponse.fromJson(apiResponse.error).errors[0].message;
    }
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool resendButtonLoading = false;

  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String? _verificationMsg = '';

  String? get verificationMessage => _verificationMsg;
  String _email = '';

  String get email => _email;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  Future<ResponseModel> checkEmail(String? email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    resendButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.checkEmail(email);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    print("response is::->>>>>>>>>> ${apiResponse.response}");
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      // startVerifyTimer();

      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);
    } else {
      String? errorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;

      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    resendButtonLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String? email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyToken(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ErrorResponse.fromJson(apiResponse.error).errors![0].message);
    }
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String? email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyEmail(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    print("verifyEmail: ${apiResponse.response}");
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;

      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  //phone

  Future<ResponseModel> checkPhone(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.checkPhone(phone);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);
    } else {
      String errorMessage =
          ApiChecker.getError(apiResponse).errors![0].message ?? '';

      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyPhone(phone, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      // startVerifyTimer();
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for Remember Me Section

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  clearRememberMe() {
    _isActiveRememberMe = false;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<ResponseModel> loginGuest() async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.loginGuest();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String token = map["token"];
      authRepo!.saveUserToken(token);
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _loginErrorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<bool> clearSharedData() async {
    return await authRepo!.clearSharedData();
  }

  void saveUserNumberAndPassword(UserLogData userLogData) {
    authRepo!.saveUserNumberAndPassword(jsonEncode(userLogData.toJson()));
  }

  UserLogData? getUserData() {
    UserLogData? userData;
    try {
      userData = UserLogData.fromJson(jsonDecode(authRepo!.getUserLogData()));
    } catch (error) {
      debugPrint('error ====> $error');
    }
    return userData;
  }

  Future<bool> clearUserLogData() async {
    return authRepo!.clearUserLog();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

  String getUserEmailOrPhone() {
    return authRepo!.getUserEmailOrPhone();
  }

  String getUserOtp() {
    return authRepo!.getUserOTP();
  }

  String getVerificationId() {
    return authRepo!.getVerificationId();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  Future<GoogleSignInAuthentication> googleLogin() async {
    GoogleSignInAuthentication auth;
    googleAccount = await _googleSignIn.signIn();
    auth = await googleAccount!.authentication;
    return auth;
  }

  Future socialLogin(SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.socialLogin(socialLogin);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = '';
      String? token = '';
      try {
        message = map['error_message'] ?? '';
      } catch (e) {}
      try {
        token = map['token'];
      } catch (e) {}

      if (token != null) {
        authRepo!.saveUserToken(token);
        await updateFirebaseToken();
      }

      callback(true, token, message);
      notifyListeners();
    } else {
      String? errorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors![0].message;
      callback(false, '', errorMessage);
      notifyListeners();
    }
  }

  Future<void> socialLogout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FacebookAuth.instance.logOut();
  }

  Future updateFirebaseToken() async {
    if (await authRepo!.getDeviceToken() != '@') {
      await authRepo!.updateToken();
    }
  }
}
