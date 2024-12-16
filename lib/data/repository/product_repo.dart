import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/datasource/remote/dio/dio_client.dart';
import 'package:shreeveg/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/view/screens/home/home_screens.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({required this.dioClient});

  Future<ApiResponse> getPopularProductList(
      String offset, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.popularProductURI}?limit=10&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );
      print('popular products resp is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLatestProductList(String offset) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.latestProductURI}?limit=10&&offset=$offset');
      print('latest products resp is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getItemList(
      String offset, String? languageCode, String? productType) async {
    print('prod type is: $productType');
    try {
      String? apiUrl;
      if (productType == ProductType.featuredItem) {
        apiUrl = AppConstants.featuredProduct;
      } else if (productType == ProductType.dailyItem) {
        apiUrl = AppConstants.dailyItemUri;
        print(apiUrl);
      } else if (productType == ProductType.popularProduct) {
        apiUrl = AppConstants.popularProductURI;
      } else if (productType == ProductType.mostReviewed) {
        apiUrl = AppConstants.mostReviewedProduct;
      } else if (productType == ProductType.recommendProduct) {
        apiUrl = AppConstants.recommendProduct;
      } else if (productType == ProductType.trendingProduct) {
        apiUrl = AppConstants.trendingProduct;
      }
      //_apiUrl = AppConstants.popularProductURI;

      final response = await dioClient!.get(
        '$apiUrl?limit=10&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );

      print('reeesppp $apiUrl is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(
      String productID, String? languageCode, bool? searchQuery) async {
    try {
      String params = productID;
      if (searchQuery == true) {
        params = productID;
      }
      final response = await dioClient!.get(
        '${AppConstants.productDetailsUri}$params',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(
      String productId, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.searchProductUri}$productId',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandOrCategoryProductList(
      String id, String languageCode) async {
    try {
      SharedPreferences? sharedPreferences  = await SharedPreferences.getInstance();
      int? whId = sharedPreferences.getInt(AppConstants.selectedCityId);
      String uri = '${AppConstants.categoryProductUri}$id/$whId/all';

      final response = await dioClient!.get(uri,
          options: Options(headers: {'X-localization': languageCode}));
      print('category products resp is: $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
