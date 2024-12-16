import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/banner_model.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/data/repository/banner_repo.dart';
import 'package:shreeveg/helper/api_checker.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo? bannerRepo;

  BannerProvider({required this.bannerRepo});

  List<BannerModel> _bannerList = [];
  final List<Product> _productList = [];
  int _currentIndex = 0;

  List<BannerModel> get bannerList => _bannerList;
  List<Product> get productList => _productList;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(BuildContext context, bool reload) async {
    if (bannerList.isEmpty || reload) {
      ApiResponse apiResponse = await bannerRepo!.getBannerList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bannerList = [];
        print('banner res: ${apiResponse.response!.data}');
        apiResponse.response!.data.forEach((banner) {
          BannerModel bannerModel = BannerModel.fromJson(banner);
          if (bannerModel.productId != null) {
            getProductDetails(context, bannerModel.productId.toString());
          }
          _bannerList.add(bannerModel);
        });
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void getProductDetails(BuildContext context, String productID) async {
    ApiResponse apiResponse = await bannerRepo!.getProductDetails(productID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productList.add(Product.fromJson(apiResponse.response!.data));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }
}
