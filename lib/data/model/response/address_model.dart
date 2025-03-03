class AddressModel {
  int? id;
  String? addressType;
  String? contactPersonNumber;
  String? address;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? method;
  String? contactPersonName;
  String? houseNumber;
  String? area;
  String? landmark;
  String? city;
  int? pincode;

  AddressModel(
      {this.id,
      this.addressType,
      this.contactPersonNumber,
      this.address,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.method,
      this.contactPersonName,
      this.houseNumber,
        this.area,
        this.landmark,
        this.city,
        this.pincode,
      });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    method = json['_method'];
    contactPersonName = json['contact_person_name'];
    houseNumber = json['house'];
    area = json['area'];
    landmark = json['landmark'];
    city = json['city'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['contact_person_number'] = contactPersonNumber;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['_method'] = method;
    data['contact_person_name'] = contactPersonName;
    data['house'] = houseNumber;
    data['area'] = area;
    data['landmark'] = landmark;
    data['city'] = city;
    data['pincode'] = pincode;
    return data;
  }
}
