//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  int id;
  int parentId;
  String name;
  String categoryCode;
  String? titleSilver;
  String? titleGold;
  String? titlePlatinum;
  String image;
  int position;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic deletedBy;
  List<dynamic> translations;

  CategoryModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.categoryCode,
    required this.titleSilver,
    required this.titleGold,
    required this.titlePlatinum,
    required this.image,
    required this.position,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.deletedBy,
    required this.translations,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    parentId: json["parent_id"],
    name: json["name"],
    categoryCode: json["category_code"],
    titleSilver: json["title_silver"],
    titleGold: json["title_gold"],
    titlePlatinum: json["title_platinum"],
    image: json["image"],
    position: json["position"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    deletedBy: json["deleted_by"],
    translations: List<dynamic>.from(json["translations"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "name": name,
    "category_code": categoryCode,
    "title_silver": titleSilver,
    "title_gold": titleGold,
    "title_platinum": titlePlatinum,
    "image": image,
    "position": position,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "deleted_by": deletedBy,
    "translations": List<dynamic>.from(translations.map((x) => x)),
  };
}