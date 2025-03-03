class PlaceOrderBody {
  // List<CartModel>? _cart;
  String? _cart;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  double? _orderAmount;
  String? _orderType;
  String? _storeId;
  int? _branchId;
  int? _deliveryAddressId;
  String? _deliveryTimeSlot;
  String? _deliveryDate;
  String? _paymentMethod;
  String? _orderNote;
  String? _couponCode;
  double? _distance;
  String? _transactionReference;
  String? _paymentBy;
  String? _paymentNote;
  String? _paymentId;

  PlaceOrderBody copyWith(
      {String? paymentMethod, String? transactionReference}) {
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    return this;
  }

  PlaceOrderBody setOfflinePayment({
    required String paymentBy,
    required String transactionReference,
    required String paymentNote,
  }) {
    _transactionReference = transactionReference;
    _paymentBy = paymentBy;
    _paymentNote = paymentNote;
    return this;
  }

  PlaceOrderBody({
    // List<CartModel>? cart,
    String? cart,
    double? couponDiscountAmount,
    String? couponDiscountTitle,
    double? orderAmount,
    String? orderType,
    String? storeId,
    int? branchId,
    int? deliveryAddressId,
    String? deliveryTimeSlot,
    String? deliveryDate,
    String? paymentMethod,
    String? orderNote,
    String? couponCode,
    double? distance,
    String? transactionReference,
    String? paymentBy,
    String? paymentNote,
    String? paymentId,
  }) {
    _cart = cart;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _orderAmount = orderAmount;
    _orderType = orderType;
    _storeId = storeId;
    _branchId = branchId;
    _deliveryAddressId = deliveryAddressId;
    _deliveryTimeSlot = deliveryTimeSlot;
    _deliveryDate = deliveryDate;
    _paymentMethod = paymentMethod;
    _orderNote = orderNote;
    _couponCode = couponCode;
    _distance = distance;
    _transactionReference = transactionReference;
    _paymentBy = paymentBy;
    _paymentNote = paymentNote;
    _paymentId = paymentId;
  }

  String? get cart => _cart;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  double? get orderAmount => _orderAmount;
  String? get orderType => _orderType;
  String? get storeId => _storeId;
  int? get branchId => _branchId;
  int? get deliveryAddressId => _deliveryAddressId;
  String? get deliveryTimeSlot => _deliveryTimeSlot;
  String? get deliveryDate => _deliveryDate;
  String? get paymentMethod => _paymentMethod;
  String? get orderNote => _orderNote;
  String? get couponCode => _couponCode;
  double? get distance => _distance;
  String? get transactionReference => _transactionReference;
  String? get paymentBy => _paymentBy;
  String? get paymentNote => _paymentNote;
  String? get paymentId => _paymentId;

  void setPaymentId(String paymentId) {
    _paymentId = paymentId;
  }

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    // if (json['cart'] != null) {
    //   _cart = [];
    //   json['cart'].forEach((v) {
    //     _cart!.add(CartModel.fromJson(v));
    //   });
    // }
    _cart = json['cart'];
    _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'].toDouble();
    _orderType = json['order_type'];
    _storeId = json['store_id'];
    _branchId = json['warehouse_id'];
    _deliveryAddressId = json['delivery_address_id'];
    _deliveryTimeSlot = json['delivery_time_slot'];
    _deliveryDate = json['delivery_date'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _distance = json['distance'];
    _paymentId = json['payment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (_cart != null) {
    //   data['cart'] = _cart!.map((v) => v.toJson()).toList();
    // }
    data['cart'] = _cart;
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['order_amount'] = _orderAmount;
    data['order_type'] = _orderType;
    data['store_id'] = _storeId;
    data['warehouse_id'] = _branchId;
    data['delivery_address_id'] = _deliveryAddressId;
    data['delivery_time_slot'] = _deliveryTimeSlot;
    data['delivery_date'] = _deliveryDate;
    data['payment_method'] = _paymentMethod;
    data['order_note'] = _orderNote;
    data['coupon_code'] = _couponCode;
    data['distance'] = _distance;
    if (_transactionReference != null) {
      data['transaction_reference'] = _transactionReference;
    }
    if (_paymentBy != null) {
      data['payment_by'] = _paymentBy;
    }
    if (_paymentNote != null) {
      data['payment_note'] = _paymentNote;
    }
    data['payment_id'] = _paymentId;
    return data;
  }
}

class Cart {
  int? _productId;
  double? _price;
  String? _variant;
  List<Variation>? _variation;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;

  Cart(
      {int? productId,
      double? price,
      String? variant,
      List<Variation>? variation,
      double? discountAmount,
      int? quantity,
      double? taxAmount}) {
    _productId = productId;
    _price = price;
    _variant = variant;
    _variation = variation;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
  }

  int? get productId => _productId;
  double? get price => _price;
  String? get variant => _variant;
  List<Variation>? get variation => _variation;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'].toDouble();
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = _productId;
    data['price'] = _price;
    data['variant'] = _variant;
    if (_variation != null) {
      data['variation'] = _variation!.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    return data;
  }
}

class Variation {
  String? _type;

  Variation({String? type}) {
    _type = type;
  }

  String? get type => _type;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    return data;
  }
}
