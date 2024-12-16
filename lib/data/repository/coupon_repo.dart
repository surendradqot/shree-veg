import 'package:shreeveg/data/datasource/remote/dio/dio_client.dart';
import 'package:shreeveg/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/utill/app_constants.dart';

class CouponRepo {
  final DioClient? dioClient;

  CouponRepo({required this.dioClient});

  Future<ApiResponse> getCouponList() async {
    try {
      final response = await dioClient!.get(AppConstants.couponUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> applyCoupon(String couponCode) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.couponApplyUri}$couponCode');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
