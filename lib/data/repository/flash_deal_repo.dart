import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/datasource/remote/dio/dio_client.dart';
import 'package:shreeveg/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/utill/app_constants.dart';

class FlashDealRepo {
  final DioClient? dioClient;
  FlashDealRepo({required this.dioClient});

  Future<ApiResponse> getFlashDeal() async {
    try {
      SharedPreferences? sharedPreferences  = await SharedPreferences.getInstance();
      int? whId = sharedPreferences.getInt(AppConstants.selectedCityId);
      final response = await dioClient!.get("${AppConstants.flashDealUri}?warehouse_id=$whId");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getFlashDealList(String productID) async {
    try {
      SharedPreferences? sharedPreferences  = await SharedPreferences.getInstance();
      int? whId = sharedPreferences.getInt(AppConstants.selectedCityId);
      final response = await dioClient!.get(
          '${AppConstants.flashDealProductUri}$productID?limit=100&&offset=1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}