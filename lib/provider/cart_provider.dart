import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/cart_model.dart';
import 'package:shreeveg/data/repository/cart_repo.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  CartProvider({required this.cartRepo});

  int _productSelect = 0;
  int get productSelect => _productSelect;

  void setSelect(int select, bool isNotify) {
    _productSelect = select;
    if (isNotify) {
      notifyListeners();
    }
  }

  List<CartModel> _cartList = [];
  List<int?> _cartAddedList = [];
  double _amount = 0.0;

  List<CartModel> get cartList => _cartList;
  List<int?> get cartAddedList => _cartAddedList;
  double get amount => _amount;

  Future<void> getCartData() async {
    _cartList = [];
    _amount = 0.0;
    _cartList = await cartRepo!.getCartList();
    for (var cart in _cartList) {
      _amount = _amount + (cart.discountedPrice! * cart.quantity!);
    }
    notifyListeners();
  }

  Future addedCartListMethod(int? addedId) async{
    _cartAddedList.add(addedId);
    notifyListeners();
  }

  void addToCart(CartModel cartModel) {
    _cartList.add(cartModel);
    cartRepo!.addToCartList(_cartList);
    _amount = _amount + (cartModel.discountedPrice! * cartModel.quantity!);
    notifyListeners();
  }

  void setQuantity(bool isIncrement, int? index,
      {bool showMessage = false, BuildContext? context}) {
    if (isIncrement) {
      _cartList[index!].quantity = _cartList[index].quantity! + 1;
      _amount = _amount + _cartList[index].discountedPrice!;
      if (showMessage) {
        showCustomSnackBar('quantity_increase_from_cart'.tr, isError: false);
      }
    } else {
      _cartList[index!].quantity = _cartList[index].quantity! - 1;
      _amount = _amount - _cartList[index].discountedPrice!;
      if (showMessage) {
        showCustomSnackBar('quantity_decreased_from_cart'.tr);
      }
    }
    cartRepo!.addToCartList(_cartList);

    notifyListeners();
  }

  removeCartAddedList(int? addedId){
    _cartAddedList.remove(addedId);
    notifyListeners();
  }

  void removeFromCart(int index, BuildContext context) {
    _amount = _amount -
        (cartList[index].discountedPrice! * cartList[index].quantity!);
    showCustomSnackBar('remove_from_cart'.tr);
    _cartList.removeAt(index);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  int? isExistInCart(CartModel? cartModel) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].id == cartModel!.id &&
          (_cartList[index].variation != null
              ? _cartList[index].variation!.quantity == cartModel.variation!.quantity
              : true)) {
        return index;
      }
    }
    return null;
  }

  final List<String> _cartDeliveryOptions = ['delivery', 'self_pickup'];

  List<String> get cartDeliveryOptions => _cartDeliveryOptions;

  String _selectedDeliveryOption = 'delivery';

  String get selectedDeliveryOption => _selectedDeliveryOption;

  void updateDeliveryOption(String option) {
    _selectedDeliveryOption = option;
    notifyListeners();
  }

  String? _selectedDeliveryTimeSlot;

  String? get selectedDeliveryTimeSlot => _selectedDeliveryTimeSlot;

  void updateSelectedDeliveryTimeSlot(String timeSlot) {
    _selectedDeliveryTimeSlot = timeSlot;
    notifyListeners();
  }

  String? _selectedStoreId;

  String? get selectedStoreId => _selectedStoreId;

  void updateSelectedStoreId(String? storeId) {
    _selectedStoreId = storeId;
    notifyListeners();
  }
}
