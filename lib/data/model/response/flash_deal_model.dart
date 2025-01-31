    class FlashDealModel {
  int? _id;
  String? _title;
  String? _startDate;
  String? _endDate;
  int? _status;
  int? _featured;
  String? _backgroundColor;
  String? _textColor;
  String? _banner;
  String? _slug;
  String? _createdAt;
  String? _updatedAt;
  int? _productId;
  String? _dealType;
  int? _categoryId;
  String? _categoryName;
  String? _categoryHnName;

  FlashDealModel(
      {int? id,
        String? title,
        String? startDate,
        String? endDate,
        int? status,
        int? featured,
        String? backgroundColor,
        String? textColor,
        String? banner,
        String? slug,
        String? createdAt,
        String? updatedAt,
        int? productId,
        String? dealType,
        int? categoryId,
        String? categoryName,
        String? categoryHnName,
      }) {
    _id = id;
    _title = title;
    _startDate = startDate;
    _endDate = endDate;
    _status = status;
    _featured = featured;
    _backgroundColor = backgroundColor;
    _textColor = textColor;
    _banner = banner;
    _slug = slug;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _productId = productId;
    _dealType = dealType;
    _categoryId = categoryId;
    _categoryName = categoryName;
    _categoryHnName = categoryHnName;
  }

  int? get id => _id;
  String? get title => _title;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  int? get status => _status;
  int? get featured => _featured;
  String? get backgroundColor => _backgroundColor;
  String? get textColor => _textColor;
  String? get banner => _banner;
  String? get slug => _slug;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get productId => _productId;
  String? get dealType => _dealType;
  int? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get categoryHnName => _categoryHnName;


  FlashDealModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _status = json['status'];
    _featured = json['featured'];
    _backgroundColor = json['background_color'];
    _textColor = json['text_color'];
    _banner = json['image'];
    _slug = json['slug'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _productId = json['product_id'];
    _dealType = json['offer_type'];
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _categoryHnName = json['category_hindi_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['start_date'] = _startDate;
    data['end_date'] = _endDate;
    data['status'] = _status;
    data['featured'] = _featured;
    data['background_color'] = _backgroundColor;
    data['text_color'] = _textColor;
    data['image'] = _banner;
    data['slug'] = _slug;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['product_id'] = _productId;
    data['offer_type'] = _dealType;
    data['category_id'] = _categoryId;
    data['category_name'] = _categoryName;
    data['category_hindi_name'] = _categoryHnName;
    return data;
  }
}
