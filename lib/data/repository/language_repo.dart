import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/language_model.dart';
import 'package:shreeveg/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
