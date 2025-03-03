class GroupModel {
  int? _id;
  String? _name;
  String? _image;
  String? _description;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  GroupModel(
      {int? id,
        String? name,
        String? image,
        String? description,
        int? status,
        String? createdAt,
        String? updatedAt,
       }) {
    _id = id;
    _name = name;
    _image = image;
    _description = description;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  String? get description => _description;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  GroupModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _description = json['description'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['image'] = _image;
    data['description'] = _description;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}