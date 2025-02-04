import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/category_model.dart';
import 'package:shreeveg/data/model/response/new_category_product_modal.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/data/repository/product_repo.dart';
import 'package:shreeveg/data/repository/search_repo.dart';
import 'package:shreeveg/helper/api_checker.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import '../data/model/body/review_body.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/product_details_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? productRepo;
  final ProductDetailsRepo? productDetailsRepo;
  final SearchRepo? searchRepo;

  ProductProvider({
    this.productDetailsRepo,
    required this.productRepo,
    this.searchRepo,
  });

  // Latest products
  Product? _product;
  List<Product>? _popularProductList;
  List<Product>? _dailyItemList;
  List<Product>? _latestProductList;
  List<Product>? _featuredProductList;
  List<Product>? _mostViewedProductList;
  List<Product>? _recommendProduct;
  List<Product>? _trendingProduct;
  List<ActiveReview>? _activeReviews;
  List<ActiveReview>? _allActiveReviews;
  bool _isLoading = false;
  int? _popularPageSize;
  int? _latestPageSize;
  List<String> _offsetList = [];
  List<String> _popularOffsetList = [];
  int _quantity = 0;
  List<int>? _variationIndex;
  int? _imageSliderIndex;
  int? _cartIndex;
  int offset = 1;
  int popularOffset = 1;

  Product? get product => _product;

  int? get cartIndex => _cartIndex;

  List<Product>? get popularProductList => _popularProductList;

  List<Product>? get dailyItemList => _dailyItemList;

  List<Product>? get featuredProductList => _featuredProductList;

  List<Product>? get mostViewedProductList => _mostViewedProductList;

  List<Product>? get latestProductList => _latestProductList;

  List<Product>? get recommendProduct => _recommendProduct;

  List<Product>? get trendingProduct => _trendingProduct;

  List<ActiveReview>? get activeReviews => _activeReviews;

  List<ActiveReview>? get allActiveReviews => _allActiveReviews;

  bool get isLoading => _isLoading;

  int? get popularPageSize => _popularPageSize;

  int? get latestPageSize => _latestPageSize;

  int get quantity => _quantity;

  List<int>? get variationIndex => _variationIndex;

  int? get imageSliderIndex => _imageSliderIndex;

  Future<void> getItemList(String offset, bool reload, String? languageCode,
      String? productType) async {
    if (reload || offset == '1') {
      popularOffset = 1;
      _popularOffsetList = [];
    }

    if (!_popularOffsetList.contains(offset)) {
      _popularOffsetList.add(offset);
      _isLoading = true;
      ApiResponse apiResponse =
          await productRepo!.getItemList(offset, languageCode, productType);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        if (reload || offset == '1') {
          if (productType == ProductType.dailyItem) {
            _dailyItemList = [];
          } else if (productType == ProductType.featuredItem) {
            _featuredProductList = [];
          } else if (productType == ProductType.popularProduct) {
            _popularProductList = [];
          } else if (productType == ProductType.mostReviewed) {
            _mostViewedProductList = [];
          } else if (productType == ProductType.trendingProduct) {
            _trendingProduct = [];
          } else if (productType == ProductType.recommendProduct) {
            _recommendProduct = [];
          }
        }

        if (productType == ProductType.dailyItem) {
          _dailyItemList!.addAll(
              ProductModel.fromJson(apiResponse.response!.data).products!);
        } else if (productType == ProductType.featuredItem) {
          _featuredProductList!.addAll(
              ProductModel.fromJson(apiResponse.response!.data).products!);
        } else if (productType == ProductType.popularProduct) {
          _popularProductList!.addAll(
              ProductModel.fromJson(apiResponse.response!.data).products!);
        } else if (productType == ProductType.mostReviewed) {
          _mostViewedProductList!.addAll(
              ProductModel.fromJson(apiResponse.response!.data).products!);
        } else if (productType == ProductType.recommendProduct) {
          _recommendProduct!.addAll(
              ProductModel.fromJson(apiResponse.response!.data).products!);
        } else if (productType == ProductType.trendingProduct) {
          _trendingProduct!.addAll(
              ProductModel.fromJson(apiResponse.response!.data).products!);
        }

        _popularPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
      } else {
        _isLoading = false;
        ApiChecker.checkApi(apiResponse);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
      }
    }
    notifyListeners();
  }

  Future<void> getLatestProductList(String offset, bool reload) async {
    if (reload || offset == '1') {
      offset = '1';
      _offsetList = [];
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getLatestProductList(offset);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        if (reload || offset == '1') {
          _latestProductList = [];
        }
        _latestProductList!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _latestPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
      } else {
        _isLoading = false;
        ApiChecker.checkApi(apiResponse);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
      }
    }
    notifyListeners();
  }

  //To check update in product in cart
  Future<Product?> getProductDetail(String productID) async {
    _product = null;
    ApiResponse apiResponse =
        await productRepo!.getProductDetails(productID, null, null);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _product = Product.fromJson(apiResponse.response!.data[0]);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    return _product;
  }

  //To get product details
  Future<Product?> getProductDetails(
      BuildContext context, String productID, String languageCode,
      {bool searchQuery = false}) async {
    _product = null;
    ApiResponse apiResponse = await productRepo!
        .getProductDetails(productID, languageCode, searchQuery);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _product = Product.fromJson(apiResponse.response!.data[0]);
      initData(_product!);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();

    return _product;
  }

  Future<List<ActiveReview>?> getProductReviews(
      BuildContext context, String productID) async {
    _activeReviews = [];
    ApiResponse apiResponse =
        await productDetailsRepo!.getActiveReviews(productID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      for (int i = 0; i < apiResponse.response?.data.length; i++) {
        print('$i data is: ${apiResponse.response?.data[i]}');
        _activeReviews
            ?.add(ActiveReview.fromJson(apiResponse.response!.data[i]));
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();

    return _activeReviews;
  }

  Future<List<ActiveReview>?> getMyAllActiveReviews() async {
    _allActiveReviews = [];
    ApiResponse apiResponse = await productDetailsRepo!.getMyAllActiveReviews();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      for (int i = 0; i < apiResponse.response?.data.length; i++) {
        print('$i data is: ${apiResponse.response?.data[i]}');
        _allActiveReviews
            ?.add(ActiveReview.fromJson(apiResponse.response!.data[i]));
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();

    return _allActiveReviews;
  }

  Future<ResponseModel> submitProductReview(
      ReviewBody reviewBody, File? file) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse response = await productDetailsRepo!.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String? errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void setExistData(int? cartIndex) {
    _cartIndex = cartIndex;
  }

  void initData(Product product) {
    _variationIndex = [];
    _cartIndex = null;
    _quantity = 1;
    if (product.choiceOptions != null) {
      for (int i = 0; i < product.choiceOptions!.length; i++) {
        _variationIndex!.add(0);
      }
    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex![index] = i;
    _quantity = 1;
    notifyListeners();
  }

  int _rating = 0;

  int get rating => _rating;

  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }

  String? _errorText;

  String? get errorText => _errorText;

  void setErrorText(String error) {
    _errorText = error;
    notifyListeners();
  }

  void removeData() {
    _errorText = null;
    _rating = 0;
    notifyListeners();
  }

  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }

  // Brand and category products
  List<ProductData> _categoryProductList = [];
  List<ProductData> _categoryAllProductList = [];
  bool? _hasData;

  double _minValue = 0;
  double _maxValue = 0;
  double _maxFilterRange = 10000;
  List<double> _filterSelectedPriceRange = [];
  List<double> _filterSelectedRatings = [];
  List<double> _filterSelectedDiscounts = [];
  String? _selectedPriceSort;
  String? _selectedRatingSort;
  String? _selectedDiscountSort;

  double get maxValue => _maxValue;

  double get minValue => _minValue;

  double get maxFilterRange => _maxFilterRange;

  List<double> get filterSelectedPriceRange => _filterSelectedPriceRange;

  List<double> get filterSelectedRatings => _filterSelectedRatings;

  List<double> get filterSelectedDiscounts => _filterSelectedDiscounts;

  String? get selectedPriceSort => _selectedPriceSort;

  String? get selectedRatingSort => _selectedRatingSort;

  String? get selectedDiscountSort => _selectedDiscountSort;

  List<ProductData> get categoryProductList => _categoryProductList;
  List<ProductData> oneRupeeProductList = [];
  List<ProductData> bulkOfferProductList = [];
  String? marqueeText = '';
  List<String> tabList = [];
  bool? loader = false;

  List<ProductData> get categoryAllProductList => _categoryAllProductList;

  bool? get hasData => _hasData;

  void setSelectedVariation(Product product, int index) {
    product.updateSelectedVariation(index);
    notifyListeners();
  }

  int? selectedVariation = 0;

  updateVariation(int? index){
    selectedVariation = index;
    notifyListeners();
  }

  void initCategoryProductList(String id, BuildContext context,
      String languageCode, String catName, bool? whereFrom) async {
    _categoryProductList = [];
    _categoryAllProductList = [];
    oneRupeeProductList = [];
    bulkOfferProductList = [];
    tabList = [];
    _hasData = true;
    loader = false;
    ApiResponse apiResponse =
        await productRepo!.getBrandOrCategoryProductList(id, languageCode);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _categoryProductList = [];
      _categoryAllProductList = [];
      oneRupeeProductList = [];
      bulkOfferProductList = [];
      tabList = [];
      print(apiResponse.response!.data.toString());
      print(apiResponse.response!.data.runtimeType);
      CategoryProductModal? categoryProductModal =
          categoryProductModalFromJson(jsonEncode(apiResponse.response!.data));
      if (!whereFrom!) {
        tabList.add(catName);
      }
      marqueeText = categoryProductModal.data!.warehouseTime ?? "";
      if (categoryProductModal.data!.is1RsOffer == 1) {
        tabList.add("1₹ Offer");
      }
      if (categoryProductModal.data!.isBulkOffer == 1) {
        tabList.add("Bulk Order\nLimited Time");
      }
      CartProvider? cartProvider =
          Provider.of<CartProvider>(Get.context!, listen: false);
      categoryProductModal.result!.forEach((product) {
        if (!whereFrom) {
          tabList.add(product.name!);
        }
        if (product.oneRsOfferEnable == 0 && product.bulkOfferEnable == 0) {
          if (cartProvider.newCartList.isNotEmpty) {
            CartModalNew? cartItem = cartProvider.newCartList.firstWhere(
              (item) => item.productData!.id == product.id,
              orElse: () => CartModalNew(),
            );
            if (cartItem.productData != null) {
              _categoryProductList.add(cartItem.productData!);
              _categoryAllProductList.add(cartItem.productData!);
            } else {
              _categoryProductList.add(product);
              _categoryAllProductList.add(product);
            }
          } else {
            _categoryProductList.add(product);
            _categoryAllProductList.add(product);
          }
        }
        if (product.oneRsOfferEnable == 1) {
          if (cartProvider.newOfferCartList.isNotEmpty) {
            CartModalNew? cartItem = cartProvider.newOfferCartList.firstWhere(
              (item) => item.productData!.id == product.id,
              orElse: () => CartModalNew(),
            );
            if (cartItem.productData != null) {
              oneRupeeProductList.add(cartItem.productData!);
            } else {
              oneRupeeProductList.add(product);
            }
          } else {
            oneRupeeProductList.add(product);
          }
        }
        if (product.bulkOfferEnable == 1) {
          if (cartProvider.newOfferCartList.isNotEmpty) {
            CartModalNew? cartItem = cartProvider.newOfferCartList.firstWhere(
              (item) => item.productData!.id == product.id,
              orElse: () => CartModalNew(),
            );
            if (cartItem.productData != null) {
              bulkOfferProductList.add(cartItem.productData!);
            } else {
              bulkOfferProductList.add(product);
            }
          } else {
            bulkOfferProductList.add(product);
          }
        }
      });
      _hasData = _categoryProductList.length > 1;
      List<ProductData> products = [];
      products.addAll(_categoryProductList);
      List<double> prices = [];
      for (var product in products) {
        if (product.price != null) {
          prices.add(double.parse(product.price.toString()));
        }
      }
      prices.sort();
      if (categoryProductList.isNotEmpty) {
        _minValue = prices[0];
        _maxValue = prices[prices.length - 1];
        _maxFilterRange = ((_maxValue + 99) / 100) * 100;
      }
      loader = true;
      clearRefineFilters();
      clearSortingFilters();
      notifyListeners();
    } else {
      loader = true;
      ApiChecker.checkApi(apiResponse);
      notifyListeners();
    }
    loader = true;
    notifyListeners();
  }

  List<String> addCart = [];

  addToCart(ProductData product, int? totalCount, String? type, String? unit,
      {int? index}) {

    if (type!.isNotEmpty) {
      if (!addCart.contains("oneRupeeOffer") && type == "oneRupeeOffer") {
        if (!addCart.contains("bulkOffer")) {
          if (product.oneRsOfferEnable == 1) {
            for (ProductData listProduct in oneRupeeProductList) {
              if (listProduct.id == product.id) {
                listProduct.appliedOneRupee = true;
                listProduct.appliedUnit = unit;
                listProduct.totalAddedWeight = totalCount!.toDouble();
                addCart.add("oneRupeeOffer");
                Provider.of<CartProvider>(Get.context!, listen: false)
                    .addOfferCartItem(
                  product: product,
                  totalUnit: 1.0,
                  totalPrice: 1.0,
                  totalDiscount: double.parse(product.discount!),
                  itemPrice:
                  double.parse(product.marketPrice!.toStringAsFixed(1)),
                  gstPrice: product.tax!.toDouble(),
                  deliveryCharge: 0.0,
                  offerPrice: double.parse(product.price!),
                );
              }
            }
          }
        } else {
          ToastService().show(
              "आप बल्क ऑर्डर ऑफर का फायदा पहले ही ले चुके हैं. एक रुपए ऑफर अब आपके लिए मान्य नहीं होगा.");
        }
      } else if (type == "bulkOffer") {
        if (!addCart.contains("oneRupeeOffer")) {
          if (product.bulkOfferEnable == 1) {
            for (ProductData listProduct in bulkOfferProductList) {
              if (listProduct.id == product.id) {
                listProduct.appliedBulkRupee = true;
                listProduct.appliedUnit = unit;
                listProduct.appliedBulkRupeeCount = totalCount;
                listProduct.totalAddedWeight =
                    double.parse(product.quantity!) * totalCount!.toDouble();
                addCart.add("bulkOffer");
                Provider.of<CartProvider>(Get.context!, listen: false)
                    .addOfferCartItem(
                  product: product,
                  totalUnit:
                  double.parse(product.quantity!) * totalCount.toDouble(),
                  totalPrice: totalCount * double.parse(product.price!),
                  totalDiscount: double.parse(product.discount!),
                  itemPrice: totalCount *
                      double.parse(product.marketPrice!.toStringAsFixed(1)),
                  gstPrice: product.tax!.toDouble(),
                  deliveryCharge: 0.0,
                  offerPrice: double.parse(product.price!),
                );
              }
            }
          }
        } else {
          ToastService().show(
              "आप एक रुपए ऑफर का लाभ पहले ही ले चुके हैं. बल्क ऑर्डर ऑफर अब आपके लिए मान्य नहीं होगा.");
        }
      } else {
        ToastService().show("आप एक रुपए ऑफर का लाभ पहले ही ले चुके हैं.");
      }
    } else {
      for (ProductData listProduct in _categoryAllProductList) {
        if (listProduct.id == product.id) {
          if (totalCount! *
              double.parse(product.variations![index!].quantity!) <=
              listProduct.totalStock!.toDouble()) {
            listProduct.variations![index].addCount = totalCount;
            listProduct.variations![index].isSelected = true;
            listProduct.totalAddedWeight = totalCount *
                double.parse(product.variations![index].quantity!);
            listProduct.appliedUnit = unit;
            Provider.of<CartProvider>(Get.context!, listen: false)
                .addCartItem(
              product: product,
              totalUnit: totalCount *
                  double.parse(product.variations![index].quantity!),
              totalPrice: totalCount *
                  double.parse(product.variations![index].offerPrice!),
              totalDiscount:
              double.parse(product.variations![index].discount!),
              itemPrice: totalCount *
                  double.parse(product.variations![index].marketPrice!
                      .toStringAsFixed(2)),
              gstPrice: product.tax!.toDouble(),
              deliveryCharge: 0.0,
              offerPrice:
              double.parse(product.variations![index].offerPrice!),
            );
          } else {
            ToastService().show("Out of Stock");
          }
        }
      }
    }



    // bool? isLoggedIn = Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();
    //
    //
    // if(isLoggedIn){
    //   if (type!.isNotEmpty) {
    //     if (!addCart.contains("oneRupeeOffer") && type == "oneRupeeOffer") {
    //       if (!addCart.contains("bulkOffer")) {
    //         if (product.oneRsOfferEnable == 1) {
    //           for (ProductData listProduct in oneRupeeProductList) {
    //             if (listProduct.id == product.id) {
    //               listProduct.appliedOneRupee = true;
    //               listProduct.appliedUnit = unit;
    //               listProduct.totalAddedWeight = totalCount!.toDouble();
    //               addCart.add("oneRupeeOffer");
    //               Provider.of<CartProvider>(Get.context!, listen: false)
    //                   .addOfferCartItem(
    //                 product: product,
    //                 totalUnit: 1.0,
    //                 totalPrice: 1.0,
    //                 totalDiscount: double.parse(product.discount!),
    //                 itemPrice:
    //                 double.parse(product.marketPrice!.toStringAsFixed(1)),
    //                 gstPrice: product.tax!.toDouble(),
    //                 deliveryCharge: 0.0,
    //                 offerPrice: double.parse(product.price!),
    //               );
    //             }
    //           }
    //         }
    //       } else {
    //         ToastService().show(
    //             "आप बल्क ऑर्डर ऑफर का फायदा पहले ही ले चुके हैं. एक रुपए ऑफर अब आपके लिए मान्य नहीं होगा.");
    //       }
    //     } else if (type == "bulkOffer") {
    //       if (!addCart.contains("oneRupeeOffer")) {
    //         if (product.bulkOfferEnable == 1) {
    //           for (ProductData listProduct in bulkOfferProductList) {
    //             if (listProduct.id == product.id) {
    //               listProduct.appliedBulkRupee = true;
    //               listProduct.appliedUnit = unit;
    //               listProduct.appliedBulkRupeeCount = totalCount;
    //               listProduct.totalAddedWeight =
    //                   double.parse(product.quantity!) * totalCount!.toDouble();
    //               addCart.add("bulkOffer");
    //               Provider.of<CartProvider>(Get.context!, listen: false)
    //                   .addOfferCartItem(
    //                 product: product,
    //                 totalUnit:
    //                 double.parse(product.quantity!) * totalCount.toDouble(),
    //                 totalPrice: totalCount * double.parse(product.price!),
    //                 totalDiscount: double.parse(product.discount!),
    //                 itemPrice: totalCount *
    //                     double.parse(product.marketPrice!.toStringAsFixed(1)),
    //                 gstPrice: product.tax!.toDouble(),
    //                 deliveryCharge: 0.0,
    //                 offerPrice: double.parse(product.price!),
    //               );
    //             }
    //           }
    //         }
    //       } else {
    //         ToastService().show(
    //             "आप एक रुपए ऑफर का लाभ पहले ही ले चुके हैं. बल्क ऑर्डर ऑफर अब आपके लिए मान्य नहीं होगा.");
    //       }
    //     } else {
    //       ToastService().show("आप एक रुपए ऑफर का लाभ पहले ही ले चुके हैं.");
    //     }
    //   } else {
    //     for (ProductData listProduct in _categoryAllProductList) {
    //       if (listProduct.id == product.id) {
    //         if (totalCount! *
    //             double.parse(product.variations![index!].quantity!) <=
    //             listProduct.totalStock!.toDouble()) {
    //           listProduct.variations![index].addCount = totalCount;
    //           listProduct.variations![index].isSelected = true;
    //           listProduct.totalAddedWeight = totalCount *
    //               double.parse(product.variations![index].quantity!);
    //           listProduct.appliedUnit = unit;
    //           Provider.of<CartProvider>(Get.context!, listen: false)
    //               .addCartItem(
    //             product: product,
    //             totalUnit: totalCount *
    //                 double.parse(product.variations![index].quantity!),
    //             totalPrice: totalCount *
    //                 double.parse(product.variations![index].offerPrice!),
    //             totalDiscount:
    //             double.parse(product.variations![index].discount!),
    //             itemPrice: totalCount *
    //                 double.parse(product.variations![index].marketPrice!
    //                     .toStringAsFixed(2)),
    //             gstPrice: product.tax!.toDouble(),
    //             deliveryCharge: 0.0,
    //             offerPrice:
    //             double.parse(product.variations![index].offerPrice!),
    //           );
    //         } else {
    //           ToastService().show("Out of Stock");
    //         }
    //       }
    //     }
    //   }
    // }
    // else{
    //   ToastService().show("Please login for use this functionality");
    // }

    notifyListeners();
  }

  removeFromCart(ProductData product, String? type, {int? index}) {
    if (type == "oneRupeeOffer") {
      for (ProductData listProduct in oneRupeeProductList) {
        if (listProduct.id == product.id) {
          listProduct.appliedOneRupee = false;
          listProduct.appliedUnit = "";
          listProduct.totalAddedWeight = 0;
          addCart.remove("oneRupeeOffer");
          Provider.of<CartProvider>(Get.context!, listen: false)
              .removeOfferCartItem(product);
        }
      }
    } else if (type == "bulkOffer") {
      for (ProductData listProduct in bulkOfferProductList) {
        if (listProduct.id == product.id) {
          listProduct.appliedBulkRupee = false;
          listProduct.appliedUnit = "";
          listProduct.appliedBulkRupeeCount = 0;
          listProduct.totalAddedWeight = 0;
          addCart.remove("bulkOffer");
          Provider.of<CartProvider>(Get.context!, listen: false)
              .removeOfferCartItem(product);
        }
      }
    } else {
      for (ProductData listProduct in _categoryAllProductList) {
        if (listProduct.id == product.id) {
          listProduct.variations![index!].addCount = 0;
          listProduct.variations![index].isSelected = false;
          listProduct.totalAddedWeight = 0;
          listProduct.appliedUnit = "";
          Provider.of<CartProvider>(Get.context!, listen: false)
              .removeCartItem(product);
        }
      }
    }
    notifyListeners();
  }

  void filterGroupCategoryProductList(String groupId) {
    print('groupId is $groupId');
    if (groupId == '-1') {
      _categoryProductList = _categoryAllProductList;
    } else {
      _categoryProductList = _categoryAllProductList.where((categoryProduct) {
        print('Group IDs of categoryProduct: ${categoryProduct.groupIds}');
        if (categoryProduct.groupIds != null &&
            categoryProduct.groupIds!.contains(groupId.toString())) {
          return true; // Include in the filtered list
        }
        return false; // Exclude from the filtered list
      }).toList();
    }
    notifyListeners();
  }

  void filterSubCategoryWise(String subCategory) {
    if (subCategory == 'all') {
      _categoryProductList = _categoryAllProductList;
    } else {
      _categoryProductList = _categoryAllProductList
          .where((categoryProduct) =>
              categoryProduct.catName!.toLowerCase() ==
              subCategory.toLowerCase())
          .toList();
    }
    notifyListeners();
  }

  void applyRefines() {
    updatePriceRangeFilter(
        _filterSelectedPriceRange[0], _filterSelectedPriceRange[1]);
    applyRatingFilter(_filterSelectedRatings);
    applyDiscountFilter(_filterSelectedDiscounts);
  }

  void applySortings() {
    applyPriceSorting(selectedPriceSort);
    applyRatingSorting(selectedRatingSort);
    applyDiscountSorting(selectedDiscountSort);
  }

  void sortCategoryProduct(int filterIndex) {
    if (filterIndex == 0) {
      _categoryProductList.sort(
          (product1, product2) => product1.price!.compareTo(product2.price!));
    } else if (filterIndex == 1) {
      _categoryProductList.sort(
          (product1, product2) => product1.price!.compareTo(product2.price!));
      Iterable iterable = _categoryProductList.reversed;
      _categoryProductList = iterable.toList() as List<ProductData>;
    } else if (filterIndex == 2) {
      _categoryProductList.sort((product1, product2) =>
          product1.name!.toLowerCase().compareTo(product2.name!.toLowerCase()));
    } else if (filterIndex == 3) {
      _categoryProductList.sort((product1, product2) =>
          product1.name!.toLowerCase().compareTo(product2.name!.toLowerCase()));
      Iterable iterable = _categoryProductList.reversed;
      _categoryProductList = iterable.toList() as List<ProductData>;
    }
    notifyListeners();
  }

  void updatePriceRangeFilter(double min, double max) {
    _filterSelectedPriceRange = [min, max];
    _categoryProductList = _categoryAllProductList.where((categoryProduct) {
      if (categoryProduct.price != null) {
        if (double.parse(categoryProduct.price!) >= min &&
            double.parse(categoryProduct.price!) <= max) {
          return true;
        }
      }
      return false;
    }).toList();
    notifyListeners();
  }

  void applyRatingFilter(List<double> minRatings) {
    if (minRatings.isNotEmpty) {
      minRatings.sort();
      _categoryProductList = _categoryProductList
          .where((categoryProduct) =>
              categoryProduct.rating?.isNotEmpty == true &&
              categoryProduct.rating![0].average != null &&
              double.parse(categoryProduct.rating![0].average!) >=
                  minRatings[0])
          .toList();
    }
    notifyListeners();
  }

  void applyDiscountFilter(List<double> minDiscounts) {
    if (minDiscounts.isNotEmpty) {
      minDiscounts.sort();
      _categoryProductList = _categoryAllProductList.where((categoryProduct) {
        bool? value = false;
        if (categoryProduct.variations!.isNotEmpty) {
          if (categoryProduct.variations![0].discount != null &&
              double.parse(categoryProduct.variations![0].discount!
                      .replaceAll("-", "")) >=
                  minDiscounts[0]) {
            value = true;
          } else {
            value = false;
          }
        }
        return value;
      }).toList();
    } else {
      _categoryProductList = _categoryAllProductList;
    }
    notifyListeners();
  }

  void clearRefineFilters() {
    _categoryProductList = _categoryAllProductList;
    _filterSelectedPriceRange = [minValue, maxValue];
    _filterSelectedRatings = [];
    _filterSelectedDiscounts = [];
    notifyListeners();
  }

  void applyPriceSorting(String? sortingOption) {
    _selectedPriceSort = sortingOption;
    if (sortingOption != null) {
      switch (sortingOption) {
        case 'Low to High':
          _categoryProductList.sort((product1, product2) =>
              product1.price!.compareTo(product2.price!));
          break;
        case 'High to Low':
          _categoryProductList.sort((product1, product2) =>
              product1.price!.compareTo(product2.price!));
          Iterable iterable = _categoryProductList.reversed;
          _categoryProductList = iterable.toList() as List<ProductData>;
          break;
        case 'Rupee Saving - Low to High':
          _categoryProductList.sort((product1, product2) =>
              product1.price!.compareTo(product2.price!));
          break;
        case 'Rupee Saving - High to Low':
          _categoryProductList.sort((product1, product2) =>
              product1.price!.compareTo(product2.price!));
          Iterable iterable = _categoryProductList.reversed;
          _categoryProductList = iterable.toList() as List<ProductData>;
          break;
        default:
          break;
      }
    }
    notifyListeners();
  }

  void applyRatingSorting(String? sortingOption) {
    _selectedRatingSort = sortingOption;
    if (sortingOption != null) {
      switch (sortingOption) {
        case 'Low to High':
          _categoryProductList.sort((product1, product2) =>
              double.parse(product1.rating![0].average!)
                  .compareTo(double.parse(product2.rating![0].average!)));
          break;
        case 'High to Low':
          _categoryProductList.sort((product1, product2) =>
              double.parse(product1.rating![0].average!)
                  .compareTo(double.parse(product2.rating![0].average!)));
          Iterable iterable = _categoryProductList.reversed;
          _categoryProductList = iterable.toList() as List<ProductData>;
          break;
        default:
          break;
      }
    }
    notifyListeners();
  }

  void applyDiscountSorting(String? sortingOption) {
    _selectedDiscountSort = sortingOption;
    if (sortingOption != null) {
      switch (sortingOption) {
        case 'Low to High':
          _categoryProductList.sort((product1, product2) =>
              double.parse(product1.variations![0].discount!)
                  .compareTo(double.parse(product2.variations![0].discount!)));
          break;
        case 'High to Low':
          _categoryProductList.sort((product1, product2) =>
              double.parse(product1.variations![0].discount!)
                  .compareTo(double.parse(product2.variations![0].discount!)));
          Iterable iterable = _categoryProductList.reversed;
          _categoryProductList = iterable.toList() as List<ProductData>;
          break;
        default:
          break;
      }
    }
    notifyListeners();
  }

  void clearSortingFilters() {
    _categoryProductList = _categoryAllProductList;
    _selectedPriceSort = null;
    _selectedRatingSort = null;
    _selectedDiscountSort = null;
    notifyListeners();
  }

  void updateSelectedSortingOption(String tileName, String value) {
    switch (tileName) {
      case 'Price':
        applyPriceSorting(value);
        break;
      case 'Rating':
        applyRatingSorting(value);
        break;
      case 'Discount':
        applyDiscountSorting(value);
        break;
      default:
        break;
    }
  }

  searchProduct(String query) {
    if (query.isEmpty) {
      _categoryProductList.clear();
      _categoryProductList = categoryAllProductList;
      notifyListeners();
    } else {
      _categoryProductList = [];
      for (var product in categoryAllProductList) {
        if (product.name!.toLowerCase().contains(query.toLowerCase())) {
          _categoryProductList.add(product);
        }
      }
      _hasData = _categoryProductList.length > 1;
      notifyListeners();
    }
  }

  int _filterIndex = -1;
  double _lowerValue = 0;
  double _upperValue = 0;

  int get filterIndex => _filterIndex;

  double get lowerValue => _lowerValue;

  double get upperValue => _upperValue;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    notifyListeners();
  }

  void sortSearchList(int selectSortByIndex, List<CategoryModel> categoryList) {
    if (_upperValue > 0 && selectSortByIndex == 0) {
      _categoryProductList.clear();
      for (var product in _categoryAllProductList) {
        if (((double.parse(product.price.toString())) >= _lowerValue) &&
            ((double.parse(product.price.toString())) <= _upperValue)) {
          _categoryProductList.add(product);
        }
      }
    } else if (_upperValue == 0 && selectSortByIndex == 0) {
      _categoryProductList.clear();
      _categoryProductList = _categoryAllProductList;
    } else if (_upperValue == 0 && selectSortByIndex == 1) {
      _categoryProductList.clear();
      _categoryProductList = _categoryAllProductList;
      _categoryProductList.sort((a, b) {
        double aPrice = double.parse(a.price.toString());
        double bPrice = double.parse(b.price.toString());
        return aPrice.compareTo(bPrice);
      });
    } else if (_upperValue == 0 && selectSortByIndex == 2) {
      _categoryProductList.clear();
      _categoryProductList = _categoryAllProductList;
      _categoryProductList.sort((a, b) {
        double aPrice = double.parse(a.price.toString());
        double bPrice = double.parse(b.price.toString());
        return aPrice.compareTo(bPrice);
      });
      Iterable iterable = _categoryProductList.reversed;
      _categoryProductList = iterable.toList() as List<ProductData>;
    }
    notifyListeners();
  }

  bool _isClear = true;

  bool get isClear => _isClear;

  void cleanSearchProduct() {
    _isClear = true;
    notifyListeners();
  }

  List<String?> _allSortBy = [];

  List<String?> get allSortBy => _allSortBy;
  int _selectSortByIndex = 0;

  int get selectSortByIndex => _selectSortByIndex;

  updateSortBy(int index) {
    _selectSortByIndex = index;
    notifyListeners();
  }

  initializeAllSortBy(BuildContext context) {
    if (_allSortBy.isEmpty) {
      _allSortBy = [];
      _allSortBy = searchRepo!.getAllSortByList();
    }
    _filterIndex = -1;
  }
}
