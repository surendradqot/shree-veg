import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/base/error_response.dart';
import 'package:shreeveg/data/model/response/response_model.dart';
import 'package:shreeveg/data/model/response/userinfo_model.dart';
import 'package:shreeveg/data/repository/profile_repo.dart';
import 'package:shreeveg/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;

  getUserInfo() async {
    try {
      _isLoading = true;
      ApiResponse apiResponse = await profileRepo!.getUserInfo();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
        print(_userInfoModel);
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  List<WarehouseCityList> _items = [];
  bool _isLoadingValue = true;
  String? _error;
  int? _selectedItemId;
  SharedPreferences? sharedPreferences;

  List<WarehouseCityList> get items => _items;

  bool get loadingValue => _isLoadingValue;

  String? get error => _error;

  int? get selectedItemId => _selectedItemId;

  Future<void> getCityWhereHouse() async {
    try {
      _isLoadingValue = true;
      _items = [];
      ApiResponse apiResponse = await profileRepo!.getCities();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        apiResponse.response!.data.forEach((banner) {
          WarehouseCityList bannerModel = WarehouseCityList.fromJson(banner);
          _items.add(bannerModel);
        });
        if (_items.isNotEmpty) {
          _selectedItemId = _items[0].cityId;
          sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences!.getInt(AppConstants.selectedCityId) == null ||
              sharedPreferences!
                  .getInt(AppConstants.selectedCityId)
                  .toString()
                  .isEmpty) {
            await sharedPreferences!
                .setInt(AppConstants.selectedCityId, _items[0].cityId!);
          }
          // await Provider.of<CategoryProvider>(Get.context!, listen: false).getCategoryList(
          //     Get.context!,
          //     "en",
          //     true,
          //     id: _selectedItemId,
          // );
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      _isLoadingValue = false;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void selectItem(int? value) async {
    _selectedItemId = value;
    print("************* Selected Warehouse id is:- $value { selected id = $_selectedItemId  and final value is:- $selectedItemId } ***************");
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!
        .setInt(AppConstants.selectedCityId, _selectedItemId!);
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  File? _file;
  PickedFile? _data;

  PickedFile? get data => _data;

  File? get file => _file;
  final picker = ImagePicker();

  void choosePhoto({required bool fromCamera}) async {
    final pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500,
      maxWidth: 500,
    );

    if (pickedFile != null) {
      CroppedFile? croppedFile = await _cropImage(File(pickedFile.path));
      if (croppedFile != null) {
        // Do something with the cropped file
        _file = File(croppedFile.path);
        notifyListeners();
      }
    }
  }

  void pickImage() async {
    _data = PickedFile(await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 80)
        .then((value) => value!.path));
    notifyListeners();
  }

  Future<CroppedFile?> _cropImage(File imageFile) async {
    final ImageCropper _imageCropper = ImageCropper();
    CroppedFile? croppedFile = await _imageCropper
        .cropImage(sourcePath: imageFile.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Profile Image',
        toolbarColor: AppConstants.primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    ]);
    return croppedFile;
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel,
      File? file, PickedFile? data, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    http.StreamedResponse response =
        await profileRepo!.updateProfile(updateUserModel, file, data, token);
    _isLoading = false;
    print('responseeeeee: ${response.statusCode}');
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
    } else {
      _isLoading = false;
      notifyListeners();
      responseModel = ResponseModel(
        false,
        ErrorResponse.fromJson(
                jsonDecode(await response.stream.bytesToString()))
            .errors![0]
            .message,
      );
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }
}
