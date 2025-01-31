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
  String? _categoryName;
      String? _categoryHnName;

  BannerModel(
      {int? id,
        String? title,
        String? banner,
        int? productId,
        String? itemType,
        int? status,
        String? createdAt,
        String? updatedAt,
        int? categoryId,
        String? categoryName,
        String? categoryHnName,
      }) {
    _id = id;
    _title = title;
    _banner = banner;
    _productId = productId;
    _itemType = itemType;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryId = categoryId;
    _categoryName = categoryName;
    _categoryHnName = categoryHnName;
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
  String? get categoryName => _categoryName;
  String? get categoryHnName => _categoryHnName;

  // _id = 10
  // _title = "one rupees"
  // _startDate = "2025-01-24 11:59:00"
  // _endDate = "2025-01-24 17:59:00"
  // _status = 1
  // _featured = 0
  // _backgroundColor = null
  // _textColor = null
  // _banner = "2025-01-24-6793337b369d6.png"
  // _slug = null
  // _createdAt = "2025-01-24 12:00:19"
  // _updatedAt = "2025-01-24 12:00:41"
  // _productId = 30
  // _dealType = "one_rupee"


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
    _categoryName = json['category_name'];
    _categoryHnName = json['category_hindi_name'];
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
    data['category_name'] = _categoryName;
    data['category_hindi_name'] = _categoryHnName;
    return data;
  }
}
