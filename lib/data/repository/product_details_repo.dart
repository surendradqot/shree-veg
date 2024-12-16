import 'dart:io';

import 'package:shreeveg/data/datasource/remote/dio/dio_client.dart';
import 'package:shreeveg/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shreeveg/data/model/body/review_body.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class ProductDetailsRepo {
  final DioClient? dioClient;

  ProductDetailsRepo({required this.dioClient});

  Future<ApiResponse> getProduct(String productID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.productDetailsUri + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response =
          await dioClient!.post(AppConstants.reviewUri, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> submitReviewProduct(
      ReviewBody reviewBody, File? file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.submitReviewUri}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (file != null) {
      request.files.add(http.MultipartFile(
          'fileUpload[0]', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    request.fields.addAll(<String, String>{
      'product_id': reviewBody.productId!,
      'comment': reviewBody.comment!,
      'rating': reviewBody.rating!
    });
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponse> getActiveReviews(String productID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.activeReviewUri + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMyAllActiveReviews() async {
    try {
      final response = await dioClient!.get(AppConstants.allActiveReviewUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
