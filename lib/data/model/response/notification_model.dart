class NotificationModel {
  int? _id;
  String? _type;
  int? _orderId;
  String? _title;
  String? _description;
  String? _image;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  NotificationModel(
      {int? id,
      String? type,
      int? orderId,
      String? title,
      String? description,
      String? image,
      int? status,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _type = type;
    _orderId = orderId;
    _title = title;
    _description = description;
    _image = image;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get type => _type;
  int? get orderId => _orderId;
  String? get title => _title;
  String? get description => _description;
  String? get image => _image;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _type = json['type'];
    _orderId = json['order_id'];
    _title = json['title'];
    _description = json['message'];
    _image = json['image'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['type'] = _type;
    data['order_id'] = _orderId;
    data['title'] = _title;
    data['message'] = _description;
    data['image'] = _image;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
