import 'dart:convert';

class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  int? isPhoneVerified;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? cmFirebaseToken;
  String? loginMedium;
  String? referCode;
  double? walletBalance;
  int? warehouseId;
  double? point;
  List<DeliveryTime>? deliveryTime;
  List<Store>? stores;

  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.cmFirebaseToken,
        this.loginMedium,
        this.referCode,
        this.walletBalance,
        this.warehouseId,
        this.point,
        this.deliveryTime,
        this.stores
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    loginMedium = '${json['login_medium'] ?? ''}';
    referCode = json['referral_code'];
    walletBalance = double.tryParse('${json['wallet_balance']}');
    point = double.tryParse('${json['loyalty_point']}');
    warehouseId = json['warehouse_id'];
    // deliveryTime = List<DeliveryTime>.from(json["delivery_time"].map((x) => DeliveryTime.fromJson(x)));
    deliveryTime = json["delivery_time"] == null ? [] : List<DeliveryTime>.from(json["delivery_time"]!.map((x) => DeliveryTime.fromJson(x)));
    stores = json["stores"] == null ? [] : List<Store>.from(json["stores"].map((x) => Store.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['is_phone_verified'] = isPhoneVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email_verification_token'] = emailVerificationToken;
    data['phone'] = phone;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['login_medium'] = loginMedium;
    data['referral_code'] = referCode;
    data['wallet_balance'] = walletBalance;
    data['point'] = point;
    data['warehouse_id'] = warehouseId;
    data['delivery_time'] = deliveryTime;
    data['stores'] = stores;
    return data;
  }
}

class DeliveryTime {
  String open;
  String close;
  String hideOptionBefore;

  DeliveryTime({
    required this.open,
    required this.close,
    required this.hideOptionBefore,
  });

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
    open: json["open"],
    close: json["close"],
    hideOptionBefore: json["hide_option_before"],
  );

  Map<String, dynamic> toJson() => {
    "open": open,
    "close": close,
    "hide_option_before": hideOptionBefore,
  };
}

class Store {
  int id;
  String name;
  String code;
  String warehouseId;
  String brnNumber;
  String msmeNumber;
  String shopLicence;
  String document;
  dynamic coverage;
  dynamic mapLocation;
  dynamic latitude;
  dynamic longitude;
  String address;
  dynamic gstNumber;
  int cityId;
  int areaId;
  dynamic openTime;
  dynamic closeTime;
  int status;
  String adminRating;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic deletedBy;

  Store({
    required this.id,
    required this.name,
    required this.code,
    required this.warehouseId,
    required this.brnNumber,
    required this.msmeNumber,
    required this.shopLicence,
    required this.document,
    required this.coverage,
    required this.mapLocation,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.gstNumber,
    required this.cityId,
    required this.areaId,
    required this.openTime,
    required this.closeTime,
    required this.status,
    required this.adminRating,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.deletedBy,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    warehouseId: json["warehouse_id"],
    brnNumber: json["brn_number"],
    msmeNumber: json["msme_number"],
    shopLicence: json["shop_licence"],
    document: json["document"],
    coverage: json["coverage"],
    mapLocation: json["map_location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    address: json["address"],
    gstNumber: json["gst_number"],
    cityId: json["city_id"],
    areaId: json["area_id"],
    openTime: json["open_time"],
    closeTime: json["close_time"],
    status: json["status"],
    adminRating: json["admin_rating"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    deletedBy: json["deleted_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "warehouse_id": warehouseId,
    "brn_number": brnNumber,
    "msme_number": msmeNumber,
    "shop_licence": shopLicence,
    "document": document,
    "coverage": coverage,
    "map_location": mapLocation,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "gst_number": gstNumber,
    "city_id": cityId,
    "area_id": areaId,
    "open_time": openTime,
    "close_time": closeTime,
    "status": status,
    "admin_rating": adminRating,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "deleted_by": deletedBy,
  };
}


List<WarehouseCityList> warehouseCityListFromJson(String str) => List<WarehouseCityList>.from(json.decode(str).map((x) => WarehouseCityList.fromJson(x)));

String warehouseCityListToJson(List<WarehouseCityList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WarehouseCityList {
  int? warehousesId;
  String? warehousesCity;
  int? cityId;

  WarehouseCityList({
    this.warehousesId,
    this.warehousesCity,
    this.cityId,
  });

  factory WarehouseCityList.fromJson(Map<String, dynamic> json) => WarehouseCityList(
    warehousesId: json["warehouses_id"],
    warehousesCity: json["warehouses_city"],
    cityId: json["city_id"],
  );

  Map<String, dynamic> toJson() => {
    "warehouses_id": warehousesId,
    "warehouses_city": warehousesCity,
    "city_id": cityId,
  };
}

