import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/data/model/response/notification_model.dart';
import 'package:shreeveg/data/repository/notification_repo.dart';
import 'package:shreeveg/helper/api_checker.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo? notificationRepo;
  NotificationProvider({required this.notificationRepo});

  List<NotificationModel>? _notificationListAlert;
  List<NotificationModel>? get notificationListAlert => _notificationListAlert;
  List<NotificationModel>? _notificationListOffer;
  List<NotificationModel>? get notificationListOffer => _notificationListOffer;
  List<NotificationModel>? _allNotificationList;
  List<NotificationModel>? get allNotificationList => _allNotificationList;

  bool _isAlertSelected = false;

  bool get isAlertSelected => _isAlertSelected;

  setAlertSelected(bool isSelected) {
    _isAlertSelected = isSelected;
    notifyListeners();
  }

  Future<void> initNotificationList(BuildContext context) async {
    ApiResponse apiResponse = await notificationRepo!.getNotificationList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print('response data isSSS: ${apiResponse.response!.data}');
      _allNotificationList = [];
      if(apiResponse.response!.data!=null && apiResponse.response!.data!=[] && apiResponse.response!.data['data']!=null){
        apiResponse.response!.data['data'].forEach((notificatioModel) =>
            _allNotificationList!
                .add(NotificationModel.fromJson(notificatioModel)));
        _notificationListAlert = [];
        _notificationListOffer = [];
        _notificationListAlert = _allNotificationList
            ?.where((element) => element.type == 'alert')
            .toList();
        _notificationListOffer = _allNotificationList
            ?.where((element) => element.type == 'offer')
            .toList();
      }
      else{
        _allNotificationList = [];
        _notificationListAlert = [];
        _notificationListOffer = [];
        notifyListeners();
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _allNotificationList = [];
    _notificationListAlert = [];
    _notificationListOffer = [];
    setAlertSelected(true);
    notifyListeners();
  }
}
