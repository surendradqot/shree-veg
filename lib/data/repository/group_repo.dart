import 'package:shreeveg/data/datasource/remote/dio/dio_client.dart';
import 'package:shreeveg/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/utill/app_constants.dart';

class GroupRepo {
  final DioClient? dioClient;
  GroupRepo({required this.dioClient});

  Future<ApiResponse> getGroupList() async {
    try {
      final response = await dioClient!.get(AppConstants.groupsUri);
      print('group resp is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Future<ApiResponse> getProductDetails(String productID) async {
  //   try {
  //     final response =
  //     await dioClient!.get('${AppConstants.productDetailsUri}$productID');
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
}
