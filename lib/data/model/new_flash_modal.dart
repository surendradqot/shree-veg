// To parse this JSON data, do
//
//     final newFlashDealModal = newFlashDealModalFromJson(jsonString);

import 'dart:convert';

NewFlashDealModal newFlashDealModalFromJson(String str) => NewFlashDealModal.fromJson(json.decode(str));

String newFlashDealModalToJson(NewFlashDealModal data) => json.encode(data.toJson());

class NewFlashDealModal {
  String? productType;
  String? productImage;

  NewFlashDealModal({
    this.productType,
    this.productImage,
  });

  factory NewFlashDealModal.fromJson(Map<String, dynamic> json) => NewFlashDealModal(
    productType: json["product_type"],
    productImage: json["product_image"],
  );

  Map<String, dynamic> toJson() => {
    "product_type": productType,
    "product_image": productImage,
  };
}
