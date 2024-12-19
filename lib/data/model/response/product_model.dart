import 'dart:convert';

class ProductModel {
  int? _totalSize;
  String? _limit;
  String? _offset;
  List<Product>? _products;

  ProductModel(
      {int? totalSize, String? limit, String? offset, List<Product>? products}) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _products = products;
  }

  int? get totalSize => _totalSize;

  String? get limit => _limit;

  String? get offset => _offset;

  List<Product>? get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_products != null) {
      data['products'] = _products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? _id;
  int? _productId;
  String? _name;
  String? _categoryName;
  String? _hindiName;
  String? _productCode;
  String? _description;
  String? _hindiDescription;
  List<String>? _image;
  String? _price;
  double? _marketPrice;
  List<String>? _groupIds;
  int? _selectedVariation;
  List<Variations>? _variations;
  double? _tax;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  List<String>? _attributes;
  List<CategoryIds>? _categoryIds;
  List<ChoiceOptions>? _choiceOptions;
  String? _discount;
  String? _discountType;
  String? _taxType;
  String? _unit;
  double? _capacity;
  int? _totalStock;
  List<Rating>? _rating;
  List<ActiveReview>? _activeReviews;
  int? _maximumOrderQuantity;
  CategoryDiscount? _categoryDiscount;

  Product(
      {int? id,
        int? productId,
        String? name,
        String? categoryName,
        String? hindiName,
        String? productCode,
        String? description,
        String? hindiDescription,
        List<String>? image,
        String? price,
        double? marketPrice,
        List<String>? groupIds,
        int? selectedVariation,
        List<Variations>? variations,
        double? tax,
        int? status,
        String? createdAt,
        String? updatedAt,
        List<String>? attributes,
        List<CategoryIds>? categoryIds,
        List<ChoiceOptions>? choiceOptions,
        String? discount,
        String? discountType,
        String? taxType,
        String? unit,
        double? capacity,
        int? totalStock,
        List<void>? rating,
        int? maximumOrderQuantity,
        CategoryDiscount? categoryDiscount,
      }) {
    _id = id;
    _productId = productId;
    _name = name;
    _categoryName = categoryName;
    _hindiName = hindiName;
    _productCode = productCode;
    _description = description;
    _hindiDescription = hindiDescription;
    _image = image;
    _price = price;
    _marketPrice = marketPrice;
    _groupIds = groupIds;
    _selectedVariation = selectedVariation;
    _variations = variations;
    _tax = tax;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _attributes = attributes;
    _categoryIds = categoryIds;
    _choiceOptions = choiceOptions;
    _discount = discount;
    _discountType = discountType;
    _taxType = taxType;
    _unit = unit;
    _capacity = capacity;
    _totalStock = totalStock;
    _rating = rating as List<Rating>?;
    _maximumOrderQuantity = maximumOrderQuantity;
    _categoryDiscount = categoryDiscount;
  }

  int? get id => _id;
  int? get productId => _productId;
  String? get name => _name;
  String? get categoryName => _categoryName;
  String? get hindiName => _hindiName;
  String? get productCode => _productCode;
  String? get description => _description;
  String? get hindiDescription => _hindiDescription;
  List<String>? get image => _image;
  String? get price => _price;
  double? get marketPrice => _marketPrice;
  List<String>? get groupIds => _groupIds;
  int? get selectedVariation => _selectedVariation;
  void updateSelectedVariation(int index) {
    _selectedVariation = index;
  }
  List<Variations>? get variations => _variations;
  double? get tax => _tax;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<String>? get attributes => _attributes;
  List<CategoryIds>? get categoryIds => _categoryIds;
  List<ChoiceOptions>? get choiceOptions => _choiceOptions;
  String? get discount => _discount;
  String? get discountType => _discountType;
  String? get taxType => _taxType;
  String? get unit => _unit;
  double? get capacity => _capacity;
  int? get totalStock => _totalStock;
  List<Rating>? get rating => _rating;
  List<ActiveReview>? get activeReviews => _activeReviews;
  int? get maximumOrderQuantity => _maximumOrderQuantity;
  CategoryDiscount? get categoryDiscount => _categoryDiscount;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _name = json['name'];
    _categoryName = json['cat_name'];
    _hindiName = json['hn_name'];
    _productCode = json['product_code'];
    _description = json['description'];
    _hindiDescription = json['hn_description'];
    _image = json['image']!=null?json['image'].cast<String>():[];
    _price = json['price'];
    _marketPrice = json['market_price']!=null?json['market_price'].toDouble():0.0;
    _groupIds = (json['group_ids'] as List?)?.cast<String>() ?? [];
    _selectedVariation = json['selected_variation'];
    if (json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        _variations!.add(Variations.fromJson(v));
      });
    }
    _tax = json['tax'].toDouble();
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    _discount = json['discount'];
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];
    _unit = json['unit'];
    _capacity = json['capacity'] != null ? json['capacity'].toDouble() : json['capacity'];
    _totalStock = json['total_stock'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating!.add(Rating.fromJson(v));
      });
    }

    if (json['active_reviews'] != null) {

      _activeReviews =  [];
      json['active_reviews'].forEach((v) {
        _activeReviews!.add(ActiveReview.fromJson(v));
      });
    }
    _maximumOrderQuantity = int.tryParse('${json['maximum_order_quantity']}');
    _categoryDiscount = json['category_discount'] != null
        ?  CategoryDiscount.fromJson(json['category_discount'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['name'] = _name;
    data['cat_name'] = _categoryName;
    data['hn_name'] = _hindiName;
    data['product_code'] = _productCode;
    data['description'] = _description;
    data['hn_description'] = _hindiDescription;
    data['image'] = _image;
    data['price'] = _price;
    data['market_price'] = _marketPrice;
    data['group_ids'] = _groupIds;
    data['selected_variation'] = _selectedVariation;
    if (_variations != null) {
      data['variations'] = _variations!.map((v) => v.toJson()).toList();
    }
    data['tax'] = _tax;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['attributes'] = _attributes;
    if (_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }
    if (_choiceOptions != null) {
      data['choice_options'] =
          _choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['discount'] = _discount;
    data['discount_type'] = _discountType;
    data['tax_type'] = _taxType;
    data['unit'] = _unit;
    data['capacity'] = _capacity;
    data['total_stock'] = _totalStock;
     if (_rating != null) {
      data['rating'] = _rating!.map((v) => v.toJson()).toList();
    }
    data['maximum_order_quantity'] = _maximumOrderQuantity;
    if (_categoryDiscount != null) {
      data['category_discount'] = _categoryDiscount!.toJson();
    }

    return data;
  }
}

class Variations {
  String? _type;
  String? _price;
  int? _stock;
  String? _quantity;
  String? _discount;
  String? _offerPrice;
  int? _marketPrice;

  Variations({String? type, String? price, int? stock, String? quantity, String? discount, String? offerPrice, int? marketPrice}) {
    _type = type;
    _price = price;
    _stock = stock;
    _quantity = quantity;
    _discount = discount;
    _offerPrice = offerPrice;
    _marketPrice = marketPrice;
  }

  String? get type => _type;
  String? get price => _price;
  int? get stock => _stock;
  String? get quantity => _quantity;
  String? get discount => _discount;
  String? get offerPrice => _offerPrice;
  int? get marketPrice => _marketPrice;

  Variations.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _price = json['offer_price'];
    _stock = json['stock'];
    _quantity = json['quantity'];
    _discount = json['discount'];
    _offerPrice = json['offer_price'];
    _marketPrice = json['market_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    data['offer_price'] = _price;
    data['stock'] = _stock;
    data['quantity'] = _quantity;
    data['discount'] = _discount;
    data['offer_price'] = _offerPrice;
    data['market_price'] = _marketPrice;
    return data;
  }
}

class CategoryIds {
  String? _id;

  CategoryIds({String? id}) {
    _id = id;
  }

  String? get id => _id;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    return data;
  }
}

class ChoiceOptions {
  String? _name;
  String? _title;
  List<String>? _options;

  ChoiceOptions({String? name, String? title, List<String>? options}) {
    _name = name;
    _title = title;
    _options = options;
  }

  String? get name => _name;
  String? get title => _title;
  List<String>? get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['title'] = _title;
    data['options'] = _options;
    return data;
  }
}

class Rating {
  String? _average;

  Rating({String? average}) {
    _average = average;
  }

  String? get average => _average;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = _average;
    return data;
  }
}

class ActiveReview {
  ActiveReview({
    this.id,
    this.productId,
    this.userId,
    this.comment,
    this.attachment,
    this.rating,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.customer,
  });

  int? id;
  int? productId;
  int? userId;
  String? comment;
  String? attachment;
  int? rating;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? orderId;
  Customer? customer;

  factory ActiveReview.fromRawJson(String str) => ActiveReview.fromJson(json.decode(str));


  factory ActiveReview.fromJson(Map<String, dynamic> json) => ActiveReview(
    id: json["id"],
    productId: json["product_id"],
    userId: json["user_id"],
    comment: json["comment"],
    attachment: json["attachment"],
    rating: json["rating"],
    isActive: json["is_active"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    orderId: json["order_id"],
    customer:json['customer'] != null
        ? Customer.fromJson(json['customer']) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "user_id": userId,
    "comment": comment,
    "attachment": attachment,
    "rating": rating,
    "is_active": isActive,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "order_id": orderId,
    "customer": customer,
  };
}



class Customer {
  String? fName;
  String? lName;
  String? email;
  String? image;

  Customer(
      {
        this.fName,
        this.lName,
        this.email,
        this.image,
      });

  Customer.fromJson(Map<String, dynamic> json) {

    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}

class CategoryDiscount {
  String? id;
  String? categoryId;
  String? discountType;
  double? discountAmount;
  double? maximumAmount;

  CategoryDiscount({
    this.id,
    this.categoryId,
    this.discountType,
    this.discountAmount,
    this.maximumAmount,
  });

  CategoryDiscount.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    categoryId = json['category_id'].toString();
    discountType = json['discount_type'].toString();
    discountAmount = double.tryParse('${json['discount_amount']}');
    maximumAmount = double.tryParse('${json['maximum_amount']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['maximum_amount'] = maximumAmount;
    return data;
  }
}