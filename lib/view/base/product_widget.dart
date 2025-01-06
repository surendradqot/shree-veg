import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/cart_model.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/on_hover.dart';
import 'package:shreeveg/view/base/quantity_selector.dart';
import 'package:shreeveg/view/base/rating_bar.dart';
import 'package:provider/provider.dart';

import 'category_listing_product.dart';
import 'wish_button.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final String productType;
  final bool isGrid;
  ProductWidget(
      {Key? key,
      required this.product,
      this.productType = ProductType.dailyItem,
      this.isGrid = false})
      : super(key: key);

  final oneSideShadow = Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
    child: Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    double? priceWithDiscount = 0;
    double? categoryDiscountAmount;
    if (product.categoryDiscount != null) {
      categoryDiscountAmount = PriceConverter.convertWithDiscount(
        double.parse(product.price!),
        product.categoryDiscount!.discountAmount,
        product.categoryDiscount!.discountType,
        maxDiscount: product.categoryDiscount!.maximumAmount,
      );
    }

    priceWithDiscount = PriceConverter.convertWithDiscount(
        double.parse(product.price!),
        double.parse(product.discount!),
        product.discountType);

    if (categoryDiscountAmount != null &&
        categoryDiscountAmount > 0 &&
        categoryDiscountAmount < priceWithDiscount!) {
      priceWithDiscount = categoryDiscountAmount;
    }

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        double? price = 0;
        int? stock = 0;
        bool isExistInCart = false;
        int? cardIndex;
        CartModel? cartModel;
        if (product.variations!.isNotEmpty) {
          for (int index = 0; index < product.variations!.length; index++) {
            price = double.parse(product.variations!.isNotEmpty
                ? product.variations![index].offerPrice??"0.0"
                : product.price!);
            stock = product.variations!.isNotEmpty
                ? product.variations![index].stock
                : product.totalStock;
            cartModel = CartModel(
                product.id,
                product.image!.isNotEmpty ? product.image![0] : '',
                product.name,
                price,
                PriceConverter.convertWithDiscount(price,
                    double.parse(product.discount!), product.discountType),
                1,
                product.variations!.isNotEmpty
                    ? product.variations![index]
                    : null,
                (price -
                    PriceConverter.convertWithDiscount(
                        price,
                        double.parse(product.discount!),
                        product.discountType)!),
                (price -
                    PriceConverter.convertWithDiscount(
                        price, product.tax, product.taxType)!),
                product.capacity,
                product.unit,
                stock,
                product);
            isExistInCart = Provider.of<CartProvider>(context, listen: false)
                    .isExistInCart(cartModel) !=
                null;
            cardIndex = Provider.of<CartProvider>(context, listen: false)
                .isExistInCart(cartModel);
            if (isExistInCart) {
              break;
            }
          }
        }
        else {
          price = double.parse(product.variations!.isNotEmpty
              ? product.variations![0].price!
              : product.price!);
          stock = product.variations!.isNotEmpty
              ? product.variations![0].stock!
              : product.totalStock!;
          cartModel = CartModel(
              product.id,
              product.image!.isNotEmpty ? product.image![0] : '',
              product.name,
              price,
              PriceConverter.convertWithDiscount(
                  price, double.parse(product.discount!), product.discountType),
              1,
              product.variations!.isNotEmpty ? product.variations![0] : null,
              (price! -
                  PriceConverter.convertWithDiscount(price,
                      double.parse(product.discount!), product.discountType)!),
              (price -
                  PriceConverter.convertWithDiscount(
                      price, product.tax, product.taxType)!),
              product.capacity,
              product.unit,
              stock,
              product);
          isExistInCart = Provider.of<CartProvider>(context, listen: false)
                  .isExistInCart(cartModel) !=
              null;
          cardIndex = Provider.of<CartProvider>(context, listen: false)
              .isExistInCart(cartModel);
        }

        return ResponsiveHelper.isDesktop(context)
            ? OnHover(
                isItem: true,
                child: _productGridView(context, isExistInCart, stock,
                    cartModel, cardIndex, priceWithDiscount!),
              )
            : isGrid
                ? _productGridView(context, isExistInCart, stock, cartModel,
                    cardIndex, priceWithDiscount!)
                : CategoryListingProduct(
                    product: product, productType: productType);
      },
    );
  }

  InkWell _productGridView(BuildContext context, bool isExistInCart, int? stock,
      CartModel? cartModel, int? cardIndex, double priceWithDiscount) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
      onTap: () {
        Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(
            product: product,
            formSearch: productType == ProductType.searchItem));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 7,
                spreadRadius: 0.1,
              ),
            ]),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Stack(
                    children: [
                      oneSideShadow,
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusSizeTen),
                            topRight: Radius.circular(Dimensions.radiusSizeTen),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusSizeTen),
                            topRight: Radius.circular(Dimensions.radiusSizeTen),
                          ),
                          child: Banner(
                            message: '10% Off',
                            location: BannerLocation.topStart,
                            color: const Color(0xFF0B4619),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder(context),
                              height: 150,
                              fit: BoxFit.fill,
                              image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                  Images.placeholder(context),
                                  width: 80,
                                  height: 130,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                          product.name!,
                          style: poppinsMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Text(
                      //   '${product.capacity} ${product.unit}',
                      //   style: poppinsRegular.copyWith(
                      //       fontSize: Dimensions.fontSizeExtraSmall),
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          product.rating != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: RatingBar(
                                      color: Colors.orange,
                                      rating: product.rating!.isNotEmpty
                                          ? double.parse(
                                              product.rating![0].average!)
                                          : 4.0,
                                      size: 10),
                                )
                              : const SizedBox(),
                          CustomDirectionality(
                              child: Text(
                            PriceConverter.convertPrice(
                                context, double.parse(product.price!)),
                            style: poppinsBold.copyWith(
                                color: AppConstants.primaryColor,
                                fontSize: Dimensions.fontSizeDefault),
                          )),
                          CustomDirectionality(
                              child: Text(
                            PriceConverter.convertPrice(
                                context, product.marketPrice),
                            style: poppinsBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          )),
                        ],
                      ),

                      double.parse(product.price!) > priceWithDiscount
                          ? CustomDirectionality(
                              child: Text(
                                  PriceConverter.convertPrice(
                                      context, double.parse(product.price!)),
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).colorScheme.error,
                                    decoration: TextDecoration.lineThrough,
                                  )),
                            )
                          : const SizedBox(),
                      if (productType == ProductType.latestProduct)
                        Column(
                          children: [
                            !isExistInCart
                                ? InkWell(
                                    onTap: () {
                                      if (product.variations == null ||
                                          product.variations!.isEmpty) {
                                        if (isExistInCart) {
                                          showCustomSnackBar(
                                              'already_added'.tr);
                                        } else if (stock! < 1) {
                                          showCustomSnackBar('out_of_stock'.tr);
                                        } else {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .addToCart(cartModel!);
                                          showCustomSnackBar('added_to_cart'.tr,
                                              isError: false);
                                        }
                                      } else {
                                        Navigator.of(context).pushNamed(
                                          RouteHelper.getProductDetailsRoute(
                                            product: product,
                                            formSearch: productType ==
                                                ProductType.searchItem,
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'add_to_cart'.tr,
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: Image.asset(
                                              Images.shoppingCartBold),
                                        ),
                                      ],
                                    ),
                                  )
                                : Consumer<CartProvider>(
                                    builder: (context, cart, child) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (cart.cartList[cardIndex!]
                                                    .quantity! >
                                                1) {
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .setQuantity(
                                                      false, cardIndex);
                                            } else {
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .removeFromCart(
                                                      cardIndex, context);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall,
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          cart.cartList[cardIndex!].quantity
                                              .toString(),
                                          style: poppinsSemiBold.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (cart.cartList[cardIndex]
                                                    .quantity! <
                                                cart.cartList[cardIndex]
                                                    .stock!) {
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .setQuantity(true, cardIndex);
                                            } else {
                                              showCustomSnackBar(
                                                  'out_of_stock'.tr);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall,
                                            ),
                                            child: Icon(Icons.add,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.topRight,
              child: WishButton(
                product: product,
                edgeInset: const EdgeInsets.all(8.0),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
