// To parse this JSON data, do
//
//     final categoryProductModal = categoryProductModalFromJson(jsonString);

import 'dart:convert';

CategoryProductModal categoryProductModalFromJson(String str) =>
    CategoryProductModal.fromJson(json.decode(str));

String categoryProductModalToJson(CategoryProductModal data) =>
    json.encode(data.toJson());

class CategoryProductModal {
  Data? data;
  List<ProductData>? result;

  CategoryProductModal({
    this.data,
    this.result,
  });

  factory CategoryProductModal.fromJson(Map<String, dynamic> json) =>
      CategoryProductModal(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"] == null
            ? []
            : List<ProductData>.from(
                json["result"]!.map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
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

class ProductData {
  int? id;
  int? warehouseId;
  int? productId;
  String? avgPrice;
  dynamic avgPriceUpdatedDate;
  String? customerPrice;
  String? storePrice;
  DateTime? storePriceUpdatedDate;
  int? marketPrice;
  String? discount;
  String? discountType;
  int? maximumOrderQuantity;
  int? sequence;
  int? defaultUnit;
  int? totalStock;
  String? productDetails;
  DateTime? productRateUpdatedDate;
  String? lastUpdatedPrices;
  int? discountUpto;
  dynamic capacity;
  int? dailyNeeds;
  int? isOfferOrderby;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? titleSilver;
  String? leftTitle;
  String? rightTile;
  dynamic minimumOrderLimit;
  int? oneRsOfferEnable;
  int? bulkOfferEnable;
  String? offerTimeLimit;
  dynamic minPurchaseAmount;
  String? quantity;
  String? amount;
  int? categoryId;
  String? name;
  String? hnName;
  String? productCode;
  String? price;
  List<dynamic>? rating;
  int? tax;
  String? taxType;
  String? description;
  String? hnDescription;
  String? unit;
  List<String>? image;
  List<String>? singleImage;
  dynamic choiceOptions;
  dynamic groupIds;
  int? catParentId;
  String? catName;
  String? catCategoryCode;
  double? totalAddedWeight = 0.0;
  bool? appliedOneRupee = false;
  bool? appliedBulkRupee = false;
  int? appliedBulkRupeeCount = 0;
  String? appliedUnit = "";
  List<Variation>? variations;
  ProductDetail? productDetail;

  ProductData({
    this.totalAddedWeight = 0.0,
    this.appliedBulkRupee = false,
    this.appliedBulkRupeeCount = 0,
    this.appliedOneRupee = false,
    this.appliedUnit = "",
    this.id,
    this.warehouseId,
    this.productId,
    this.avgPrice,
    this.avgPriceUpdatedDate,
    this.customerPrice,
    this.storePrice,
    this.storePriceUpdatedDate,
    this.marketPrice,
    this.discount,
    this.discountType,
    this.maximumOrderQuantity,
    this.sequence,
    this.defaultUnit,
    this.totalStock,
    this.productDetails,
    this.productRateUpdatedDate,
    this.lastUpdatedPrices,
    this.discountUpto,
    this.capacity,
    this.dailyNeeds,
    this.isOfferOrderby,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.titleSilver,
    this.leftTitle,
    this.rightTile,
    this.minimumOrderLimit,
    this.oneRsOfferEnable,
    this.bulkOfferEnable,
    this.offerTimeLimit,
    this.minPurchaseAmount,
    this.quantity,
    this.amount,
    this.categoryId,
    this.name,
    this.hnName,
    this.productCode,
    this.price,
    this.rating,
    this.tax,
    this.taxType,
    this.description,
    this.hnDescription,
    this.unit,
    this.image,
    this.singleImage,
    this.choiceOptions,
    this.groupIds,
    this.catParentId,
    this.catName,
    this.catCategoryCode,
    this.variations,
    this.productDetail,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"],
        warehouseId: json["warehouse_id"],
        productId: json["product_id"],
        avgPrice: json["avg_price"],
        avgPriceUpdatedDate: json["avg_price_updated_date"],
        customerPrice: json["customer_price"],
        storePrice: json["store_price"],
        storePriceUpdatedDate: json["store_price_updated_date"] == null
            ? null
            : DateTime.parse(json["store_price_updated_date"]),
        marketPrice: json["market_price"],
        discount: json["discount"],
        discountType: json["discount_type"],
        maximumOrderQuantity: json["maximum_order_quantity"],
        sequence: json["sequence"],
        defaultUnit: json["default_unit"],
        totalStock: json["total_stock"],
        productDetails: json["product_details"],
        productRateUpdatedDate: json["product_rate_updated_date"] == null
            ? null
            : DateTime.parse(json["product_rate_updated_date"]),
        lastUpdatedPrices: json["last_updated_prices"],
        discountUpto: json["discount_upto"],
        capacity: json["capacity"],
        dailyNeeds: json["daily_needs"],
        isOfferOrderby: json["is_offer_orderby"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        titleSilver: json["title_silver"],
        leftTitle: json["left_title"],
        rightTile: json["right_tile"],
        minimumOrderLimit: json["minimum_order_limit"],
        oneRsOfferEnable: json["one_rs_offer_enable"],
        bulkOfferEnable: json["bulk_offer_enable"],
        offerTimeLimit: json["offer_time_limit"],
        minPurchaseAmount: json["min_purchase_amount"],
        quantity: json["quantity"],
        amount: json["amount"],
        categoryId: json["category_id"],
        name: json["name"],
        hnName: json["hn_name"],
        productCode: json["product_code"],
        price: json["price"],
        rating: json["rating"] == null
            ? []
            : List<dynamic>.from(json["rating"]!.map((x) => x)),
        tax: json["tax"],
        taxType: json["tax_type"],
        description: json["description"],
        hnDescription: json["hn_description"],
        unit: json["unit"],
        image: json["image"] == null
            ? []
            : List<String>.from(json["image"]!.map((x) => x)),
        singleImage: json["single_image"] == null
            ? []
            : List<String>.from(json["single_image"]!.map((x) => x)),
        choiceOptions: json["choice_options"],
        groupIds: json["group_ids"],
        catParentId: json["cat_parent_id"],
        catName: json["cat_name"],
        catCategoryCode: json["cat_category_code"],
        variations: json["variations"] == null
            ? []
            : List<Variation>.from(
                json["variations"]!.map((x) => Variation.fromJson(x))),
        productDetail: json["product_detail"] == null
            ? null
            : ProductDetail.fromJson(json["product_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "warehouse_id": warehouseId,
        "product_id": productId,
        "avg_price": avgPrice,
        "avg_price_updated_date": avgPriceUpdatedDate,
        "customer_price": customerPrice,
        "store_price": storePrice,
        "store_price_updated_date": storePriceUpdatedDate?.toIso8601String(),
        "market_price": marketPrice,
        "discount": discount,
        "discount_type": discountType,
        "maximum_order_quantity": maximumOrderQuantity,
        "sequence": sequence,
        "default_unit": defaultUnit,
        "total_stock": totalStock,
        "product_details": productDetails,
        "product_rate_updated_date": productRateUpdatedDate?.toIso8601String(),
        "last_updated_prices": lastUpdatedPrices,
        "discount_upto": discountUpto,
        "capacity": capacity,
        "daily_needs": dailyNeeds,
        "is_offer_orderby": isOfferOrderby,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "title_silver": titleSilver,
        "left_title": leftTitle,
        "right_tile": rightTile,
        "minimum_order_limit": minimumOrderLimit,
        "one_rs_offer_enable": oneRsOfferEnable,
        "bulk_offer_enable": bulkOfferEnable,
        "offer_time_limit": offerTimeLimit,
        "min_purchase_amount": minPurchaseAmount,
        "quantity": quantity,
        "amount": amount,
        "category_id": categoryId,
        "name": name,
        "hn_name": hnName,
        "product_code": productCode,
        "price": price,
        "rating":
            rating == null ? [] : List<dynamic>.from(rating!.map((x) => x)),
        "tax": tax,
        "tax_type": taxType,
        "description": description,
        "hn_description": hnDescription,
        "unit": unit,
        "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
        "single_image": singleImage == null
            ? []
            : List<dynamic>.from(singleImage!.map((x) => x)),
        "choice_options": choiceOptions,
        "group_ids": groupIds,
        "cat_parent_id": catParentId,
        "cat_name": catName,
        "cat_category_code": catCategoryCode,
        "variations": variations == null
            ? []
            : List<dynamic>.from(variations!.map((x) => x.toJson())),
        "product_detail": productDetail?.toJson(),
      };
}

class ProductDetail {
  int? id;
  String? name;
  int? parentId;
  String? productCode;
  String? description;
  String? hnName;
  String? hnDescription;
  String? image;
  String? singleImage;
  int? price;
  int? offerPrice;
  int? status;
  int? sequence;
  int? categoryId;
  dynamic titleSilver;
  dynamic titleGold;
  dynamic titlePlatinum;
  int? unitId;
  int? viewCount;
  int? discount;
  String? discountType;
  int? tax;
  dynamic choiceOptions;
  String? taxType;
  int? maximumOrderQuantity;
  int? minimumOrderLimit;
  dynamic stock;
  int? popularityCount;
  dynamic variations;
  int? totalStock;
  dynamic productDetails;
  dynamic capacity;
  int? dailyNeeds;
  dynamic groupIds;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? translations;
  Category? category;
  List<dynamic>? rating;
  Unit? unit;

  ProductDetail({
    this.id,
    this.name,
    this.parentId,
    this.productCode,
    this.description,
    this.hnName,
    this.hnDescription,
    this.image,
    this.singleImage,
    this.price,
    this.offerPrice,
    this.status,
    this.sequence,
    this.categoryId,
    this.titleSilver,
    this.titleGold,
    this.titlePlatinum,
    this.unitId,
    this.viewCount,
    this.discount,
    this.discountType,
    this.tax,
    this.choiceOptions,
    this.taxType,
    this.maximumOrderQuantity,
    this.minimumOrderLimit,
    this.stock,
    this.popularityCount,
    this.variations,
    this.totalStock,
    this.productDetails,
    this.capacity,
    this.dailyNeeds,
    this.groupIds,
    this.createdAt,
    this.updatedAt,
    this.translations,
    this.category,
    this.rating,
    this.unit,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json["id"],
        name: json["name"],
        parentId: json["parent_id"],
        productCode: json["product_code"],
        description: json["description"],
        hnName: json["hn_name"],
        hnDescription: json["hn_description"],
        image: json["image"],
        singleImage: json["single_image"],
        price: json["price"],
        offerPrice: json["offer_price"],
        status: json["status"],
        sequence: json["sequence"],
        categoryId: json["category_id"],
        titleSilver: json["title_silver"],
        titleGold: json["title_gold"],
        titlePlatinum: json["title_platinum"],
        unitId: json["unit_id"],
        viewCount: json["view_count"],
        discount: json["discount"],
        discountType: json["discount_type"],
        tax: json["tax"],
        choiceOptions: json["choice_options"],
        taxType: json["tax_type"],
        maximumOrderQuantity: json["maximum_order_quantity"],
        minimumOrderLimit: json["minimum_order_limit"],
        stock: json["stock"],
        popularityCount: json["popularity_count"],
        variations: json["variations"],
        totalStock: json["total_stock"],
        productDetails: json["product_details"],
        capacity: json["capacity"],
        dailyNeeds: json["daily_needs"],
        groupIds: json["group_ids"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        rating: json["rating"] == null
            ? []
            : List<dynamic>.from(json["rating"]!.map((x) => x)),
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parent_id": parentId,
        "product_code": productCode,
        "description": description,
        "hn_name": hnName,
        "hn_description": hnDescription,
        "image": image,
        "single_image": singleImage,
        "price": price,
        "offer_price": offerPrice,
        "status": status,
        "sequence": sequence,
        "category_id": categoryId,
        "title_silver": titleSilver,
        "title_gold": titleGold,
        "title_platinum": titlePlatinum,
        "unit_id": unitId,
        "view_count": viewCount,
        "discount": discount,
        "discount_type": discountType,
        "tax": tax,
        "choice_options": choiceOptions,
        "tax_type": taxType,
        "maximum_order_quantity": maximumOrderQuantity,
        "minimum_order_limit": minimumOrderLimit,
        "stock": stock,
        "popularity_count": popularityCount,
        "variations": variations,
        "total_stock": totalStock,
        "product_details": productDetails,
        "capacity": capacity,
        "daily_needs": dailyNeeds,
        "group_ids": groupIds,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
        "category": category?.toJson(),
        "rating":
            rating == null ? [] : List<dynamic>.from(rating!.map((x) => x)),
        "unit": unit?.toJson(),
      };
}

class Category {
  int? id;
  int? parentId;
  String? name;
  String? hnName;
  String? categoryCode;
  String? titleSilver;
  dynamic titleGold;
  dynamic titlePlatinum;
  String? image;
  int? position;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic deletedBy;
  List<dynamic>? translations;

  Category({
    this.id,
    this.parentId,
    this.name,
    this.hnName,
    this.categoryCode,
    this.titleSilver,
    this.titleGold,
    this.titlePlatinum,
    this.image,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.deletedBy,
    this.translations,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        parentId: json["parent_id"],
        name: json["name"],
        hnName: json["hn_name"],
        categoryCode: json["category_code"],
        titleSilver: json["title_silver"],
        titleGold: json["title_gold"],
        titlePlatinum: json["title_platinum"],
        image: json["image"],
        position: json["position"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        deletedBy: json["deleted_by"],
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "name": name,
        "hn_name": hnName,
        "category_code": categoryCode,
        "title_silver": titleSilver,
        "title_gold": titleGold,
        "title_platinum": titlePlatinum,
        "image": image,
        "position": position,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "deleted_by": deletedBy,
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class Unit {
  int? id;
  String? title;
  String? description;
  int? position;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? translations;

  Unit({
    this.id,
    this.title,
    this.description,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.translations,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        position: json["position"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "position": position,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class Variation {
  String? quantity;
  String? discount;
  String? approxPiece;
  String? approxWeight;
  String? title;
  bool? isSelected = false;
  int? addCount = 0;
  String? offerPrice;
  int? marketPrice;

  Variation({
    this.quantity,
    this.discount,
    this.approxPiece,
    this.approxWeight,
    this.title,
    this.offerPrice,
    this.marketPrice,
    this.isSelected = false,
    this.addCount = 0,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        quantity: json["quantity"],
        discount: json["discount"],
        approxPiece: json["approx_piece"],
        approxWeight: json["approx_weight"],
        title: json["title"],
        offerPrice: json["offer_price"],
        marketPrice: json["market_price"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "discount": discount,
        "approx_piece": approxPiece,
        "approx_weight": approxWeight,
        "title": title,
        "offer_price": offerPrice,
        "market_price": marketPrice,
      };
}
