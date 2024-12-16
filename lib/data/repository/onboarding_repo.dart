import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/datasource/remote/dio/dio_client.dart';
import 'package:shreeveg/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/onboarding_model.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/utill/images.dart';

class OnBoardingRepo {
  final DioClient? dioClient;

  OnBoardingRepo({required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onBoarding1,
            'order_your_groceries_from_your_phone'.tr, 'onboarding_1_text'.tr),
        OnBoardingModel(Images.onBoarding2,
            'delivering_groceries_under_15_minutes'.tr, 'onboarding_2_text'.tr),
        OnBoardingModel(Images.onBoarding3,
            'our_system_delivery_item_to_you'.tr, 'onboarding_3_text'.tr),
      ];

      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: onBoardingList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
