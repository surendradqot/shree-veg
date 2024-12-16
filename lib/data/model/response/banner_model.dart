class BannerModel {
  int? _id;
  String? _title;
  String? _banner;
  int? _productId;
  String? _itemType;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _categoryId;

  BannerModel(
      {int? id,
        String? title,
        String? banner,
        int? productId,
        String? itemType,
        int? status,
        String? createdAt,
        String? updatedAt,
        int? categoryId}) {
    _id = id;
    _title = title;
    _banner = banner;
    _productId = productId;
    _itemType = itemType;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryId = categoryId;
  }

  int? get id => _id;
  String? get title => _title;
  String? get banner => _banner;
  int? get productId => _productId;
  String? get itemType => _itemType;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get categoryId => _categoryId;


  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _banner = json['image'];
    _productId = json['product_id'];
    _itemType = json['item_type'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['image'] = _banner;
    data['product_id'] = _productId;
    data['item_type'] = _itemType;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['category_id'] = _categoryId;
    return data;
  }
}
