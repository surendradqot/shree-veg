// class OrderDetailsModel {
//   int? id;
//   int? productId;
//   int? orderId;
//   double? price;
//   ProductDetails? productDetails;
//   double? discountOnProduct;
//   String? discountType;
//   int? quantity;
//   double? taxAmount;
//   String? createdAt;
//   String? updatedAt;
//   String? variant;
//   int? timeSlotId;
//   String? variation;
//   bool? isVatInclude;
//   String? name;
//   List<dynamic>? image;
//
//   OrderDetailsModel(
//       {this.id,
//       this.productId,
//       this.orderId,
//       this.price,
//       this.productDetails,
//       this.discountOnProduct,
//       this.discountType,
//       this.quantity,
//       this.taxAmount,
//       this.createdAt,
//       this.updatedAt,
//       this.variant,
//         this.timeSlotId,
//         this.variation,
//         this.isVatInclude,
//         this.name,
//         this.image
//       });
//
//   OrderDetailsModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     orderId = json['order_id'];
//     price = json['price'].toDouble();
//     productDetails = json['product_details'] != null && json['product_details'] != "" ? ProductDetails.fromJson(json['product_details']) : null;
//     variation = json['variation'];
//     discountOnProduct = json['discount_on_product']?.toDouble();
//     discountType = json['discount_type'];
//     quantity = json['quantity'];
//     taxAmount = json['tax_amount'].toDouble();
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     isVatInclude = '${json['vat_status']}' == 'included';
//     if(json['variant'] != null){
//       variant = json['variant'];
//     }
//     try{
//       timeSlotId = json['time_slot_id'];
//     }catch(e){
//       timeSlotId = int.parse(json['time_slot_id']);
//     }
//     name = json['name'];
//     image = json['image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['order_id'] = orderId;
//     data['price'] = price;
//     if (productDetails != null) {
//       data['product_details'] = productDetails!.toJson();
//     }
//     data['discount_on_product'] = discountOnProduct;
//     data['discount_type'] = discountType;
//     data['quantity'] = quantity;
//     data['tax_amount'] = taxAmount;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['variant'] = variant;
//     data['time_slot_id'] = timeSlotId;
//     data['variation'] = variation;
//     data['vat_status'] = variation;
//     data['name'] = name;
//     data['image'] = image;
//     return data;
//   }
// }
//
// class ProductDetails {
//   int? id;
//   String? name;
//   String? description;
//   List<dynamic>? image;
//   double? price;
//   List<CategoryIds>? categoryIds;
//   double? capacity;
//   String? unit;
//   double? tax;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   double? discount;
//   String? discountType;
//   String? taxType;
//
//   ProductDetails(
//       {this.id,
//       this.name,
//       this.description,
//       this.image,
//       this.price,
//       this.categoryIds,
//       this.capacity,
//       this.unit,
//       this.tax,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.discount,
//       this.discountType,
//       this.taxType});
//
//   ProductDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     image = json['image'];
//     price = double.parse(json['customer_price']);
//     if (json['category_ids'] != null) {
//       categoryIds = [];
//       json['category_ids'].forEach((v) {
//         categoryIds!.add(CategoryIds.fromJson(v));
//       });
//     }
//     capacity = json['capacity']?.toDouble();
//     unit = json['unit']['title'];
//     tax = json['tax']?.toDouble();
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     discount = double.parse(json['discount']);
//     discountType = json['discount_type'];
//     taxType = json['tax_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['description'] = description;
//     data['image'] = image;
//     data['customer_price'] = price;
//     if (categoryIds != null) {
//       data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
//     }
//     data['capacity'] = capacity;
//     data['unit'] = unit;
//     data['tax']['title'] = tax;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['discount'] = discount;
//     data['discount_type'] = discountType;
//     data['tax_type'] = taxType;
//     return data;
//   }
// }
//
// class CategoryIds {
//   String? id;
//
//   CategoryIds({this.id});
//
//   CategoryIds.fromJson(Map<String, dynamic> json) {
//     id = json['id'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     return data;
//   }
// }

class OrderDetailsModel {
  int? id;
  int? productId;
  int? userWarehouseOrderId;
  double? price;
  ProductDetails? productDetails;
  String? variation;
  dynamic discountOnProduct;
  String? discountType;
  int? quantity;
  int? taxAmount;
  dynamic variant;
  String? unit;
  int? isStockDecreased;
  dynamic timeSlotId;
  String? deliveryTimeSlot;
  DateTime? deliveryDate;
  String? vatStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  List<String>? image;

  OrderDetailsModel({
    this.id,
    this.productId,
    this.userWarehouseOrderId,
    this.price,
    this.productDetails,
    this.variation,
    this.discountOnProduct,
    this.discountType,
    this.quantity,
    this.taxAmount,
    this.variant,
    this.unit,
    this.isStockDecreased,
    this.timeSlotId,
    this.deliveryTimeSlot,
    this.deliveryDate,
    this.vatStatus,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.image,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    id: json["id"],
    productId: json["product_id"],
    userWarehouseOrderId: json["user_warehouse_order_id"],
    price: json["price"]?.toDouble(),
    productDetails: json["product_details"] == null ? null : ProductDetails.fromJson(json["product_details"]),
    variation: json["variation"],
    discountOnProduct: json["discount_on_product"],
    discountType: json["discount_type"],
    quantity: json["quantity"],
    taxAmount: json["tax_amount"],
    variant: json["variant"],
    unit: json["unit"],
    isStockDecreased: json["is_stock_decreased"],
    timeSlotId: json["time_slot_id"],
    deliveryTimeSlot: json["delivery_time_slot"],
    deliveryDate: json["delivery_date"] == null ? null : DateTime.parse(json["delivery_date"]),
    vatStatus: json["vat_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    name: json["name"],
    image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "user_warehouse_order_id": userWarehouseOrderId,
    "price": price,
    "product_details": productDetails?.toJson(),
    "variation": variation,
    "discount_on_product": discountOnProduct,
    "discount_type": discountType,
    "quantity": quantity,
    "tax_amount": taxAmount,
    "variant": variant,
    "unit": unit,
    "is_stock_decreased": isStockDecreased,
    "time_slot_id": timeSlotId,
    "delivery_time_slot": deliveryTimeSlot,
    "delivery_date": "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
    "vat_status": vatStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "name": name,
    "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
  };
}

class ProductDetails {
  int? id;
  int? warehouseId;
  int? productId;
  String? avgPrice;
  DateTime? avgPriceUpdatedDate;
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
  dynamic lastUpdatedPrices;
  int? discountUpto;
  dynamic capacity;
  int? dailyNeeds;
  int? isOfferOrderby;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Unit? unit;

  ProductDetails({
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
    this.unit,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    id: json["id"],
    warehouseId: json["warehouse_id"],
    productId: json["product_id"],
    avgPrice: json["avg_price"],
    avgPriceUpdatedDate: json["avg_price_updated_date"] == null ? null : DateTime.parse(json["avg_price_updated_date"]),
    customerPrice: json["customer_price"],
    storePrice: json["store_price"],
    storePriceUpdatedDate: json["store_price_updated_date"] == null ? null : DateTime.parse(json["store_price_updated_date"]),
    marketPrice: json["market_price"],
    discount: json["discount"],
    discountType: json["discount_type"],
    maximumOrderQuantity: json["maximum_order_quantity"],
    sequence: json["sequence"],
    defaultUnit: json["default_unit"],
    totalStock: json["total_stock"],
    productDetails: json["product_details"],
    productRateUpdatedDate: json["product_rate_updated_date"] == null ? null : DateTime.parse(json["product_rate_updated_date"]),
    lastUpdatedPrices: json["last_updated_prices"],
    discountUpto: json["discount_upto"],
    capacity: json["capacity"],
    dailyNeeds: json["daily_needs"],
    isOfferOrderby: json["is_offer_orderby"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "warehouse_id": warehouseId,
    "product_id": productId,
    "avg_price": avgPrice,
    "avg_price_updated_date": avgPriceUpdatedDate?.toIso8601String(),
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
    "unit": unit?.toJson(),
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "position": position,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "translations": translations == null ? [] : List<dynamic>.from(translations!.map((x) => x)),
  };
}
