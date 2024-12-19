import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shreeveg/data/datasource/remote/dio/dio_client.dart';
import 'package:shreeveg/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/signup_model.dart';
import 'package:shreeveg/data/model/social_login_model.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> registration(SignUpModel signUpModel) async {
    try {
      Response? response = await dioClient!.post(
        AppConstants.registerUri,
        data: signUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> registrationNew(SignUpModel signUpModel) async {
    try {
      Response? response = await dioClient!.post(
        AppConstants.registerUriNew,
        data: signUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> logoutNew() async {
    try {
      Response? response = await dioClient!.post(
        AppConstants.logoutUriNew,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> loginOtp({String? emailOrPhone}) async {
    print('emailOrPhone is: $emailOrPhone');
    try {
      Response response = await dioClient!.post(
        AppConstants.loginOtpUri,
        data: {"email_or_phone": emailOrPhone},
      );
      print('responseee is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('errroor: $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> loginOtpSend({String? emailOrPhone}) async {
    print('emailOrPhone is: $emailOrPhone');
    try {
      Response response = await dioClient!.post(
        AppConstants.loginOtpSendNew,
        data: {"mobile": emailOrPhone},
      );
      print('responseee is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('errroor: $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> otpVerification({String? emailOrPhone,String? otp}) async {
    print('emailOrPhone is: $emailOrPhone');
    try {
      Response response = await dioClient!.post(
        AppConstants.loginOtpUriNew,
        data: {
          "mobile": emailOrPhone,
          "otp":otp,
        },
      );
      print('responseee is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('errroor: $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({String? email, String? otp}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"email_or_phone": email, "otp": otp},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteUser() async {
    try {
      Response response = await dioClient!.delete(AppConstants.customerRemove);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String? email) async {
    try {
      Response response = await dioClient!.post(AppConstants.forgetPasswordUri,
          data: {"email": email, "email_or_phone": email});

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String? mail, String? resetToken,
      String password, String confirmPassword) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.resetPasswordUri,
        data: {
          "_method": "put",
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword,
          "email_or_phone": mail,
          "email": mail
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify phone number
  Future<ApiResponse> checkEmail(String? email) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.checkEmailUri, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String? email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyEmailUri,
          data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // phone
  //verify phone number

  Future<ApiResponse> checkPhone(String phone) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.checkPhoneUri + phone, data: {"phone": phone});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyPhone(String phone, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyPhoneUri,
          data: {"phone": phone.trim(), "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String? email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyTokenUri,
          data: {
            "email": email,
            "email_or_phone": email,
            "reset_token": token
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  // for user otp
  Future<void> saveUserOTP(String otp) async {
    try {
      await sharedPreferences!.setString(AppConstants.otp, otp);
    } catch (e) {
      rethrow;
    }
  }

  // for user signup
  Future<void> saveSignupModel(SignUpModel signUpModel) async {
    try {
      await sharedPreferences!
          .setString(AppConstants.signupModel, signUpModel.toString());
    } catch (e) {
      rethrow;
    }
  }

  // for user otp
  Future<void> saveUserVerificationId(String verificationId) async {
    try {
      await sharedPreferences!
          .setString(AppConstants.verificationId, verificationId);
    } catch (e) {
      rethrow;
    }
  }

  // for user email or phone
  Future<void> saveUserEmailOrPhone(String emailOrPhone) async {
    try {
      await sharedPreferences!
          .setString(AppConstants.emailOrPhone, emailOrPhone);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> updateToken() async {
    try {
      String? deviceToken = '@';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = (await getDeviceToken())!;
        }
      } else {
        deviceToken = (await getDeviceToken())!;
      }

      if (!kIsWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      }

      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: {"_method": "put", "cm_firebase_token": deviceToken},
      );

      print('token updated');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    } catch (error) {
      if (kDebugMode) {
        print('error is: $error');
      }
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }

    return deviceToken;
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  String getUserEmailOrPhone() {
    return sharedPreferences!.getString(AppConstants.emailOrPhone) ?? "";
  }

  String getUserOTP() {
    return sharedPreferences!.getString(AppConstants.otp) ?? "";
  }

  String getVerificationId() {
    return sharedPreferences!.getString(AppConstants.verificationId) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<ApiResponse> loginGuest() async {
    try {
      Response response = await dioClient!.post(AppConstants.guestLoginUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences!.remove(AppConstants.token);

    if (!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
    }

    await dioClient!.post(
      AppConstants.tokenUri,
      data: {"_method": "put", "cm_firebase_token": '@'},
    );

    await sharedPreferences!.remove(AppConstants.token);
    await sharedPreferences!.remove(AppConstants.cartList);
    await sharedPreferences!.remove(AppConstants.userAddress);
    await sharedPreferences!.remove(AppConstants.searchAddress);

    return true;
  }

  // for  Remember Email
  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String userData) async {
    try {
      await sharedPreferences!.setString(AppConstants.userLogData, userData);
    } catch (e) {
      rethrow;
    }
  }

  String getUserLogData() {
    return sharedPreferences!.getString(AppConstants.userLogData) ?? "";
  }

  Future<bool> clearUserLog() async {
    return await sharedPreferences!.remove(AppConstants.userLogData);
  }

  Future<ApiResponse> socialLogin(SocialLoginModel socialLogin) async {
    print('social login with: $socialLogin');
    try {
      Response response = await dioClient!.post(
        AppConstants.socialLogin,
        data: socialLogin.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
