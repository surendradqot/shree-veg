import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/data/model/response/wishlist_model.dart';
import 'package:shreeveg/data/repository/wishlist_repo.dart';
import 'package:shreeveg/helper/api_checker.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;

  WishListProvider({required this.wishListRepo});

  List<dynamic>? _wishList;
  List<dynamic>? get wishList => _wishList;
  Product? _product;
  Product? get product => _product;
  List<int?> _wishIdList = [];
  List<int?> get wishIdList => _wishIdList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addToWishList(Product product, BuildContext context) async {
    _wishIdList.add(product.productId);
    notifyListeners();
    ApiResponse apiResponse =
        await wishListRepo!.addWishList([product.productId]);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar('item_added_to'.tr, isError: false);
    } else {
      _wishIdList.remove(product.productId);
      ApiChecker.checkApi(apiResponse);
    }
    await getWishList();
  }

  void removeFromWishList(Product product, BuildContext context) async {
    _wishIdList.remove(product.productId);
    notifyListeners();
    ApiResponse apiResponse =
        await wishListRepo!.removeWishList([product.productId]);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar('item_removed_from'.tr, isError: false);
    } else {
      _wishIdList.add(product.productId);
      ApiChecker.checkApi(apiResponse);
    }
    await getWishList();
  }

  Future<void> getWishList() async {
    _isLoading = true;
    _wishList = [];
    _wishIdList = [];
    ApiResponse apiResponse = await wishListRepo!.getWishList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print('api response is--==>>>: $apiResponse');
      _wishList = [];
      if (apiResponse.response!.data != []) {
        _wishList = apiResponse.response!.data
            .map((item) => WishListModel.fromJson(item))
            .toList();
      }

      for (int i = 0; i < _wishList!.length; i++) {
        _wishIdList.add(_wishList![i].productId);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }
}
