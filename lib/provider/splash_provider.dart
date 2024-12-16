import 'package:flutter/foundation.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/config_model.dart';
import 'package:shreeveg/data/repository/splash_repo.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  int _pageIndex = 0;
  int _currentPageIndex = 0;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _cookiesShow = true;
  DateTime _backPressedAt = DateTime.now();

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  int get pageIndex => _pageIndex;
  int get currentPageIndex => _currentPageIndex;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get cookiesShow => _cookiesShow;
  DateTime get backPressedAt => _backPressedAt;

  Future<bool> initConfig() async {
    ApiResponse apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;

      if (!kIsWeb) {
        if (!Provider.of<AuthProvider>(Get.context!, listen: false)
            .isLoggedIn()) {
          print('is not login');
        } else {
          print('is login');
          await Provider.of<AuthProvider>(Get.context!, listen: false)
              .updateFirebaseToken();
        }
      }

      notifyListeners();
    } else {
      isSuccess = false;
      showCustomSnackBar(apiResponse.error.toString(), isError: true);
    }
    return isSuccess;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  setBackPressedTime(DateTime pressTime) {
    _backPressedAt = pressTime;
    notifyListeners();
  }

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  String? getLanguageCode() {
    return splashRepo!.sharedPreferences!.getString(AppConstants.languageCode);
  }

  bool showIntro() {
    return splashRepo!.showIntro();
  }

  void disableIntro() {
    splashRepo!.disableIntro();
  }

  void cookiesStatusChange(String? data) {
    if (data != null) {
      splashRepo!.sharedPreferences!
          .setString(AppConstants.cookingManagement, data);
    }
    _cookiesShow = false;
    notifyListeners();
  }

  bool getAcceptCookiesStatus(String? data) =>
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) !=
          null &&
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) ==
          data;
}
