import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/flash_deal_model.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/data/repository/flash_deal_repo.dart';
import 'package:shreeveg/helper/api_checker.dart';
import 'package:intl/intl.dart';

import '../helper/product_type.dart';

class FlashDealProvider extends ChangeNotifier {
  final FlashDealRepo? flashDealRepo;
  FlashDealProvider({required this.flashDealRepo});

  FlashDealModel? _flashDeal;
  List<FlashDealModel> _flashResponseList = [];
  List<Product> _specialFlashDealList = [];
  List<Product> _dailyFlashDealList = [];
  Duration? _duration;
  Timer? _timer;
  FlashDealModel? get flashDeal => _flashDeal;
  List<FlashDealModel> get flashResponseList => _flashResponseList;
  List<Product> get specialFlashDealList => _specialFlashDealList;
  List<Product> get dailyFlashDealList => _dailyFlashDealList;
  Duration? get duration => _duration;
  int? _currentIndex;
  int? get currentIndex => _currentIndex;

  Future<void> getFlashDealList(bool reload, bool notify) async {
    if (_specialFlashDealList.isEmpty || reload) {
      ApiResponse apiResponse = await flashDealRepo!.getFlashDeal();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        if (apiResponse.response!.data != null &&
            apiResponse.response!.data != '[]') {
          List<dynamic> _flashResponse = apiResponse.response!.data;

          _flashResponseList = [];

          for (int i = 0; i < _flashResponse.length; i++) {
            _flashDeal = FlashDealModel.fromJson(_flashResponse[i]);
            print('flashDeal isss: $_flashDeal');
            _flashResponseList.add(_flashDeal!);

            if (_flashDeal!.id != null) {
              if (_flashDeal?.dealType == ProductType.flashSaleDaily) {
                DateTime endTime = DateFormat("yyyy-MM-dd")
                    .parse(_flashDeal!.endDate!)
                    .add(const Duration(days: 1));

                print('end isss: $endTime');

                _duration = endTime.difference(DateTime.now());

                print('end diff is: $_duration');

                _timer?.cancel();
                _timer = null;
                _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  _duration = _duration! - const Duration(seconds: 1);
                  notifyListeners();
                });

                ApiResponse megaDealResponse = await flashDealRepo!
                    .getFlashDealList(_flashDeal!.id.toString());

                if (megaDealResponse.response != null &&
                    megaDealResponse.response?.data != '[]' &&
                    megaDealResponse.response!.statusCode == 200) {
                  _dailyFlashDealList = [];
                  _dailyFlashDealList.addAll(
                      ProductModel.fromJson(megaDealResponse.response?.data)
                          .products!);

                  print('daily flash lisssttt is: $_dailyFlashDealList');

                  _currentIndex = 0;
                  notifyListeners();
                } else {
                  ApiChecker.checkApi(megaDealResponse);
                }
              } else {
                // if (_flashDeal!.id != null) {
                DateTime endTime = DateFormat("yyyy-MM-dd")
                    .parse(_flashDeal!.endDate!)
                    .add(const Duration(days: 1));

                print('end isss: $endTime');

                _duration = endTime.difference(DateTime.now());

                print('end difff isss: $_duration');

                _timer?.cancel();
                _timer = null;
                _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  _duration = _duration! - const Duration(seconds: 1);
                  notifyListeners();
                });

                ApiResponse megaDealResponse = await flashDealRepo!
                    .getFlashDealList(_flashDeal!.id.toString());

                if (megaDealResponse.response != null &&
                    megaDealResponse.response?.data != '[]' &&
                    megaDealResponse.response!.statusCode == 200) {
                  _specialFlashDealList = [];
                  _specialFlashDealList.addAll(
                      ProductModel.fromJson(megaDealResponse.response?.data)
                          .products!);

                  print('special flash lisssttt is: $_specialFlashDealList');

                  _currentIndex = 0;
                  notifyListeners();
                } else {
                  ApiChecker.checkApi(megaDealResponse);
                }
                // }
                // else {
                // }
              }
              notifyListeners();
            }
          }

          print('flashhhhhhhhhhhhhhhhhhhhhhhhh: $_flashResponseList');
        }

        // _flashDeal = FlashDealModel.fromJson(apiResponse.response!.data[1]);
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
