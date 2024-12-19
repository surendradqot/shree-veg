import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/category_model.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/data/repository/product_repo.dart';
import 'package:shreeveg/data/repository/search_repo.dart';
import 'package:shreeveg/helper/api_checker.dart';
import 'package:shreeveg/helper/product_type.dart';
import '../data/model/body/review_body.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/product_details_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? productRepo;
  final ProductDetailsRepo? productDetailsRepo;
  final SearchRepo? searchRepo;

  ProductProvider(
      {this.productDetailsRepo, required this.productRepo, this.searchRepo});

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
  int _quantity = 1;
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
  List<Product> _categoryProductList = [];
  List<Product> _categoryAllProductList = [];
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

  List<Product> get categoryProductList => _categoryProductList;

  List<Product> get categoryAllProductList => _categoryAllProductList;

  bool? get hasData => _hasData;

  void setSelectedVariation(Product product, int index) {
    product.updateSelectedVariation(index);
    notifyListeners();
  }

  void initCategoryProductList(
      String id, BuildContext context, String languageCode) async {
    _categoryProductList = [];
    _categoryAllProductList = [];
    _hasData = true;
    ApiResponse apiResponse =
        await productRepo!.getBrandOrCategoryProductList(id, languageCode);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _categoryProductList = [];
      _categoryAllProductList = [];
      print("lenth:- ${apiResponse.response!.data}");
      apiResponse.response!.data.forEach((product) {
        var prod = Product.fromJson(product);

        prod.updateSelectedVariation(0);

        _categoryProductList.add(prod);
        _categoryAllProductList.add(prod);
      });
      _hasData = _categoryProductList.length > 1;
      List<Product> products = [];
      products.addAll(_categoryProductList);
      List<double> prices = [];
      for (var product in products) {
        prices.add(double.parse(product.price.toString()));
      }
      prices.sort();
      if (categoryProductList.isNotEmpty) {
        _minValue = prices[0];
        _maxValue = prices[prices.length - 1];
        _maxFilterRange = ((_maxValue + 99) / 100) * 100;
      }

      clearRefineFilters();
      clearSortingFilters();
    } else {
      ApiChecker.checkApi(apiResponse);
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
              categoryProduct.categoryName!.toLowerCase() ==
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
      _categoryProductList = iterable.toList() as List<Product>;
    } else if (filterIndex == 2) {
      _categoryProductList.sort((product1, product2) =>
          product1.name!.toLowerCase().compareTo(product2.name!.toLowerCase()));
    } else if (filterIndex == 3) {
      _categoryProductList.sort((product1, product2) =>
          product1.name!.toLowerCase().compareTo(product2.name!.toLowerCase()));
      Iterable iterable = _categoryProductList.reversed;
      _categoryProductList = iterable.toList() as List<Product>;
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
      _categoryProductList = _categoryProductList
          .where((categoryProduct) =>
              categoryProduct.variations![0].discount != null &&
              double.parse(categoryProduct.variations![0].discount!) >=
                  minDiscounts[0])
          .toList();
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
          _categoryProductList = iterable.toList() as List<Product>;
          break;
        case 'Rupee Saving - Low to High':
          _categoryProductList.sort((product1, product2) =>
              product1.price!.compareTo(product2.price!));
          break;
        case 'Rupee Saving - High to Low':
          _categoryProductList.sort((product1, product2) =>
              product1.price!.compareTo(product2.price!));
          Iterable iterable = _categoryProductList.reversed;
          _categoryProductList = iterable.toList() as List<Product>;
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
          _categoryProductList = iterable.toList() as List<Product>;
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
          _categoryProductList = iterable.toList() as List<Product>;
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
      _categoryProductList = iterable.toList() as List<Product>;
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
