import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../model/response/base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioException.requestCancelled:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioException.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioException.connectionError:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              break;
            case DioException.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioException.badResponse:
              switch (error.response!.statusCode) {
                case 500:
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  ErrorResponse? errorResponse;
                  try {
                    errorResponse =
                        ErrorResponse.fromJson(error.response!.data);
                  } catch (e) {
                    if (kDebugMode) {
                      print('error is -> ${e.toString()}');
                    }
                  }

                  if (errorResponse != null &&
                      errorResponse.errors != null &&
                      errorResponse.errors!.isNotEmpty) {
                    if (kDebugMode) {
                      print(
                          'error----------------== ${errorResponse.errors![0].message} || error: ${error.response!.requestOptions.uri}');
                    }
                    errorDescription = errorResponse.toJson();
                  } else {
                    errorDescription =
                        "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioException.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            default:
              errorDescription = "Unhandled DioExceptionType: ${error.type}";
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
