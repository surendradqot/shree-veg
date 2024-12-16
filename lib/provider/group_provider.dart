import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/base/api_response.dart';
import 'package:shreeveg/helper/api_checker.dart';
import '../data/model/response/group_model.dart';
import '../data/repository/group_repo.dart';

class GroupProvider extends ChangeNotifier {
  final GroupRepo? groupRepo;

  GroupProvider({required this.groupRepo});

  List<GroupModel>? _groupsList;
  int _currentIndex = -1;

  List<GroupModel>? get groupsList => _groupsList;
  int get currentIndex => _currentIndex;

  Future<void> getGroupsList(BuildContext context, bool reload) async {
    if (groupsList == null || reload) {
      ApiResponse apiResponse = await groupRepo!.getGroupList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _groupsList = [];
        print('group res: ${apiResponse.response!.data}');
        apiResponse.response!.data.forEach((group) {
          GroupModel groupModel = GroupModel.fromJson(group);
          _groupsList!.add(groupModel);
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
}