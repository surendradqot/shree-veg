import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/cart_model.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/coupon_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/product/widget/product_title_only_view.dart';

import '../../product/widget/prices_view.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int index;
  const CartProductWidget({Key? key, required this.cart, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? variationText = '';
    // if (cart.variation != null) {
    //   List<String> variationTypes = cart.variation!.type!.split('-');
    //   if (variationTypes.length == cart.product!.choiceOptions!.length) {
    //     int index = 0;
    //     for (var choice in cart.product!.choiceOptions!) {
    //       variationText =
    //           '${variationText!}${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
    //       index = index + 1;
    //     }
    //   } else {
    //     variationText = cart.product!.variations![0].type;
    //   }
    // }

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteHelper.getProductDetailsRoute(product: cart.product!),
          );
        },
        child: Stack(children: [
          const Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Provider.of<ProductProvider>(context, listen: false)
                  .setExistData(null);
              Provider.of<CouponProvider>(context, listen: false)
                  .removeCouponData(false);
              Provider.of<CartProvider>(context, listen: false)
                  .removeFromCart(index, context);
            },
            child: Container(
              height: 110,
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall,
                  horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? 900
                            : 300]!,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder(context),
                    image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${cart.image}',
                    height: 70,
                    width: 85,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder(context),
                        height: 70,
                        width: 85,
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: ProductTitleOnlyView(
                                product: cart.product!,
                                fontSize: Dimensions.fontSizeSmall)),
                        CustomDirectionality(
                            child: Text(
                          PriceConverter.convertPrice(
                              context, (cart.price! * cart.quantity!)),
                          style: poppinsSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                        )),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                          child: Row(
                        children: [
                          Text('${cart.quantity} x ',
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall)),
                          Text('${(cart.capacity)?.toInt()}${cart.unit}',
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall)),
                        ],
                      )),
                      InkWell(
                        onTap: () {
                          Provider.of<CouponProvider>(context, listen: false)
                              .removeCouponData(false);
                          if (cart.quantity! > 1) {
                            Provider.of<CartProvider>(context, listen: false)
                                .setQuantity(false, index,
                                    showMessage: true, context: context);
                          } else if (cart.quantity == 1) {
                            Provider.of<CartProvider>(context, listen: false)
                                .removeFromCart(index, context);
                            Provider.of<ProductProvider>(context, listen: false)
                                .setExistData(null);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeExtraSmall),
                          child: Icon(Icons.remove,
                              size: 20, color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Text(cart.quantity.toString(),
                          style: poppinsSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge,
                              color: Theme.of(context).primaryColor)),
                      InkWell(
                        onTap: () {
                          if (cart.product!.maximumOrderQuantity == null ||
                              cart.quantity! <
                                  cart.product!.maximumOrderQuantity!) {
                            if (cart.quantity! < cart.stock!) {
                              Provider.of<CouponProvider>(context,
                                      listen: false)
                                  .removeCouponData(false);
                              Provider.of<CartProvider>(context, listen: false)
                                  .setQuantity(true, index,
                                      showMessage: true, context: context);
                            } else {
                              showCustomSnackBar(
                                  getTranslated('out_of_stock', context)!);
                            }
                          } else {
                            showCustomSnackBar(
                                '${getTranslated('you_can_add_max', context)} ${cart.product!.maximumOrderQuantity} ${getTranslated(cart.product!.maximumOrderQuantity! > 1 ? 'items' : 'item', context)} ${getTranslated('only', context)}');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeExtraSmall),
                          child: Icon(Icons.add,
                              size: 20, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ]),
                    //prices row
                    Row(
                      children: [
                        PricesView(
                            marketPrice:
                                (cart.variation!.marketPrice! * cart.quantity!),
                            marketColor: const Color(0xFF8B8B8B),
                            offerPrice:
                                (double.parse(cart.variation!.offerPrice!) *
                                    cart.quantity!),
                            offerColor: const Color(0xFF000000),
                            firstCut: false),
                      ],
                    ),
                  ],
                )),
                !ResponsiveHelper.isMobile()
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: IconButton(
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .removeFromCart(index, context);
                            Provider.of<ProductProvider>(context, listen: false)
                                .setExistData(null);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class CartProductListView extends StatelessWidget {
  const CartProductListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cartProvider.cartList.length,
        itemBuilder: (context, index) {
          return CartProductWidget(
            cart: cartProvider.cartList[index],
            index: index,
          );
        },
      );
    });
  }
}
