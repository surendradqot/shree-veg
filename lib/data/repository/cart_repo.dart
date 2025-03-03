import 'dart:convert';
import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/cart_model.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../model/response/product_model.dart';

class CartRepo {
  final SharedPreferences? sharedPreferences;
  CartRepo({required this.sharedPreferences});

  Future<List<CartModel>> getCartList() async {
    List<String>? carts = [];
    if (sharedPreferences!.containsKey(AppConstants.cartList)) {
      carts = sharedPreferences!.getStringList(AppConstants.cartList);
    }
    List<CartModel> cartList = [];
    for (var cart in carts!) {
      double? cartPrice = CartModel.fromJson(jsonDecode(cart)).price;
      String? cartProductId =
          CartModel.fromJson(jsonDecode(cart)).product!.productId.toString();

      print('cart price is:: $cartPrice');

      Variations? cartVariation =
          CartModel.fromJson(jsonDecode(cart)).variation;

      Product? actualProduct =
          await Provider.of<ProductProvider>(Get.context!, listen: false)
              .getProductDetail(
        // Get.context!,
        cartProductId,
        // 'en'
      );

      if (actualProduct != null) {
        print('actual product is: $actualProduct');

        // Using `await` directly on the Future returned by `getProductDetail`
        var variations = await actualProduct.variations;
        variations?.forEach((variation) {
          print('variation iiis: $variation');
          if (variation.quantity == cartVariation?.quantity) {
            if (variation.price == cartVariation?.price) {
              cartList.add(CartModel.fromJson(jsonDecode(cart)));
            } else {
              var cartItem = CartModel.fromJson(jsonDecode(cart));
              cartItem.price =
                  double.parse(variation.offerPrice ?? actualProduct.price!);
              cartItem.variation = variation;
              cartItem.product = actualProduct;
              cartList.add(cartItem); // Add the updated cart item
            }
          }
        });
      }

      addToCartList(cartList);
    }
    return cartList;
  }

  void addToCartList(List<CartModel> cartProductList) {
    List<String> carts = [];
    for (var cartModel in cartProductList) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferences!.setStringList(AppConstants.cartList, carts);
    print('cart updated');
  }
}
