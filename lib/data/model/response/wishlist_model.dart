class WishListModel {
  int? _wishId;
  int? _userId;
  int? _productId;

  WishListModel({int? wishId, int? userId, int? productId}) {
    if (wishId != null) {
      _wishId = wishId;
    }
    if (wishId != null) {
      _userId = userId;
    }
    if (wishId != null) {
      _productId = productId;
    }
  }

  int? get wishId => _wishId;
  int? get userId => _userId;
  int? get productId => _productId;

  set wishId(int? wishId) => _wishId = wishId;
  set userId(int? userId) => _userId = userId;
  set productId(int? productId) => _productId = productId;

  WishListModel.fromJson(Map<String, dynamic> json) {
    _wishId = int.tryParse('${json['id']}');
    _userId = int.tryParse('${json['user_id']}');
    _productId = int.tryParse('${json['product_id']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _wishId;
    data['user_id'] = _userId;
    data['product_id'] = _productId;
    return data;
  }
}
