// To parse this JSON data, do
//
//     final searchProductProductModal = searchProductProductModalFromJson(jsonString);

import 'dart:convert';

import 'package:shreeveg/data/model/response/new_category_product_modal.dart';

SearchProductProductModal searchProductProductModalFromJson(String str) => SearchProductProductModal.fromJson(json.decode(str));

String searchProductProductModalToJson(SearchProductProductModal data) => json.encode(data.toJson());

class SearchProductProductModal {
  Data? data;
  Result? result;

  SearchProductProductModal({
    this.data,
    this.result,
  });

  factory SearchProductProductModal.fromJson(Map<String, dynamic> json) => SearchProductProductModal(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "result": result?.toJson(),
  };
}

class Data {
  int? is1RsOffer;
  int? isBulkOffer;
  String? warehouseTime;

  Data({
    this.is1RsOffer,
    this.isBulkOffer,
    this.warehouseTime,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    is1RsOffer: json["is_1rs_offer"],
    isBulkOffer: json["is_bulk_offer"],
    warehouseTime: json["warehouse_time"],
  );

  Map<String, dynamic> toJson() => {
    "is_1rs_offer": is1RsOffer,
    "is_bulk_offer": isBulkOffer,
    "warehouse_time": warehouseTime,
  };
}

class Result {
  int? totalSize;
  String? limit;
  String? offset;
  List<ProductData>? products;

  Result({
    this.totalSize,
    this.limit,
    this.offset,
    this.products,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    products: json["products"] == null ? [] : List<ProductData>.from(json["products"]!.map((x) => ProductData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}