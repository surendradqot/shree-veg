import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/view/base/quantity_selector.dart';
import 'package:shreeveg/view/base/rating_bar.dart';
import 'package:shreeveg/view/base/wish_button.dart';
import 'package:shreeveg/view/screens/product/widget/prices_view.dart';
import '../../data/model/response/cart_model.dart';
import '../../data/model/response/product_model.dart';
import '../../helper/price_converter.dart';
import '../../helper/product_type.dart';
import '../../helper/route_helper.dart';
import '../../provider/cart_provider.dart';
import '../../provider/splash_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/dimensions.dart';
import '../../utill/images.dart';
import '../../utill/styles.dart';
import 'custom_snackbar.dart';

class CategoryListingProduct extends StatelessWidget {
  final Product product;
  final String productType;
  const CategoryListingProduct(
      {Key? key, required this.product, required this.productType})
      : super(key: key);

  void updateSelectedVariation(BuildContext context, int variationIndex) {
    Provider.of<ProductProvider>(context, listen: false)
        .setSelectedVariation(product, variationIndex);
  }

  @override
  Widget build(BuildContext context) {
    Variations? variation;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        double? price = 0;
        int? stock = 0;
        // double? priceWithQuantity = 0;
        CartModel? cartModel;
        bool isExistInCart = false;
        int? cardIndex;

        if (product.variations!.isNotEmpty) {
          price = double.parse(
              product.variations![product.selectedVariation ?? 0].price!);
          stock = product.totalStock;

          if (product.variations != null) {
            for (int index = 0; index < product.variations!.length; index++) {
              Variations variationData = product.variations![index];
              if (index == (product.selectedVariation ?? 0)) {
                price = double.parse(variationData.price!);
                variation = variationData;
                break;
              }
            }
          }

          double? priceWithDiscount = 0;
          double? categoryDiscountAmount;

          if (product.categoryDiscount != null) {
            categoryDiscountAmount = PriceConverter.convertWithDiscount(
              price,
              product.categoryDiscount!.discountAmount,
              product.categoryDiscount!.discountType,
              maxDiscount: product.categoryDiscount!.maximumAmount,
            );
          }
          priceWithDiscount = PriceConverter.convertWithDiscount(
              price, double.parse(product.discount!), product.discountType);

          if (categoryDiscountAmount != null &&
              categoryDiscountAmount > 0 &&
              categoryDiscountAmount < priceWithDiscount!) {
            priceWithDiscount = categoryDiscountAmount;
          }

          cartModel = CartModel(
              product.id,
              product.image!.isNotEmpty ? product.image![0] : '',
              product.name,
              price,
              priceWithDiscount,
              1,
              variation,
              (price! - priceWithDiscount!),
              (price -
                  PriceConverter.convertWithDiscount(
                      price, product.tax, product.taxType)!),
              double.parse(product
                  .variations![product.selectedVariation ?? 0].quantity!),
              product.unit,
              stock,
              product);

          isExistInCart = Provider.of<CartProvider>(context, listen: false)
                  .isExistInCart(cartModel) !=
              null;
          cardIndex = Provider.of<CartProvider>(context, listen: false)
              .isExistInCart(cartModel);
        } else {
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
              price,
              double.parse(product.discount!),
              product.discountType,
            ),
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
            product,
          );
          isExistInCart = Provider.of<CartProvider>(context, listen: false)
                  .isExistInCart(cartModel) !=
              null;
          cardIndex = Provider.of<CartProvider>(context, listen: false)
              .isExistInCart(cartModel);
        }

        return InkWell(
          onTap: () {
            if (product.variations == null || product.variations!.isEmpty) {
              if (!isExistInCart && stock! > 0) {
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(cartModel!);
                showCustomSnackBar('added_to_cart'.tr, isError: false);
              } else {
                showCustomSnackBar(
                    isExistInCart ? 'already_added'.tr : 'out_of_stock'.tr);
              }
            } else {
              Navigator.of(context).pushNamed(
                RouteHelper.getProductDetailsRoute(
                  product: product,
                  formSearch: productType == ProductType.searchItem,
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: ColorResources.getGreyColor(context)),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:  product.variations!.isNotEmpty?Banner(
                          message:'${product.variations![0].discount}% off',
                          location: BannerLocation.topStart,
                          color: const Color(0xFF0B4619),
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 180,
                            fit: BoxFit.contain,
                            imageUrl:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                            placeholder: (context, url) =>
                                Image.asset(Images.placeholder(context)),
                            errorWidget: (context, url, error) =>
                                Image.asset(Images.placeholder(context)),
                          ),
                        ):CachedNetworkImage(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 180,
                          fit: BoxFit.contain,
                          imageUrl:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                          placeholder: (context, url) =>
                              Image.asset(Images.placeholder(context)),
                          errorWidget: (context, url, error) =>
                              Image.asset(Images.placeholder(context)),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: WishButton(
                          product: product,
                          edgeInset: const EdgeInsets.all(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            product.name!.toCapitalized(),
                            style: poppinsMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        product.hindiName != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Text(
                                  '(${product.hindiName!})',
                                  style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : const SizedBox.shrink(),
                        product
                            .variations!.isNotEmpty?PricesView(
                            firstCut: false,
                            marketPrice: product
                                .variations![product.selectedVariation ?? 0]
                                .marketPrice!,
                            offerPrice: double.parse(product
                                .variations![product.selectedVariation ?? 0]
                                .offerPrice!)):PricesView(
                            firstCut: false,
                            marketPrice: product
                                .marketPrice!.toInt(),
                            offerPrice: double.parse(product.price!),
                        ),
                        // Row(
                        //   children: [
                        //     FittedBox(
                        //       child: Text(
                        //         PriceConverter.convertPrice(
                        //             context,
                        //             double.parse(widget
                        //                 .product
                        //                 .variations![selectedVariation]
                        //                 .offerPrice!)),
                        //         style: poppinsBold.copyWith(
                        //             fontSize: Dimensions.fontSizeSmall,
                        //             color: const Color(0xFF0B4619)),
                        //         overflow: TextOverflow.ellipsis,
                        //         maxLines: 1,
                        //       ),
                        //     ),
                        //     const SizedBox(
                        //         width: Dimensions.paddingSizeExtraSmall),
                        //     FittedBox(
                        //       child: Text(
                        //         PriceConverter.convertPrice(context, product.variations![selectedVariation].marketPrice!.toDouble()),
                        //         style: poppinsRegular.copyWith(
                        //           fontSize: Dimensions.fontSizeSmall,
                        //           color: Theme.of(context)
                        //               .textTheme
                        //               .bodyLarge
                        //               ?.color
                        //               ?.withOpacity(0.6),
                        //           overflow: TextOverflow.ellipsis,
                        //           decoration: TextDecoration.lineThrough,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        ParticularProductQuantitySelector(
                            product: product,
                            callback: updateSelectedVariation,
                            selectedVariation: product.selectedVariation ?? 0),
                        product.rating != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: RatingBar(
                                  rating: product.rating!.isNotEmpty
                                      ? double.parse(
                                          product.rating![0].average!)
                                      : 0.0,
                                  size: 10,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !isExistInCart
                        ? InkWell(
                            onTap: () {
                              if (product.variations == null ||
                                  product.variations!.isEmpty) {
                                Navigator.of(context).pushNamed(
                                  RouteHelper.getProductDetailsRoute(
                                    product: product,
                                    formSearch:
                                        productType == ProductType.searchItem,
                                  ),
                                );
                              } else {
                                if (!isExistInCart && stock! > 0) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .addToCart(cartModel!);
                                  showCustomSnackBar('added_to_cart'.tr,
                                      isError: false);
                                } else {
                                  showCustomSnackBar(isExistInCart
                                      ? 'already_added'.tr
                                      : 'out_of_stock'.tr);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              margin: const EdgeInsets.all(2),
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                'ADD',
                                style: poppinsRegular.copyWith(
                                    color: Colors.white),
                              ),
                            ),
                          )
                        : Consumer<CartProvider>(
                            builder: (context, cart, child) => Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (cart.cartList[cardIndex!].quantity! >
                                        1) {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .setQuantity(false, cardIndex,
                                              context: context,
                                              showMessage: true);
                                    } else {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .removeFromCart(cardIndex, context);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall),
                                    child: Icon(Icons.remove,
                                        size: 24,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                Text(
                                  cart.cartList[cardIndex!].quantity.toString(),
                                  style: poppinsSemiBold.copyWith(
                                      fontSize: Dimensions.fontSizeExtraLarge,
                                      color: Theme.of(context).primaryColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (cart.cartList[cardIndex!].quantity! <
                                        cart.cartList[cardIndex].stock!) {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .setQuantity(true, cardIndex,
                                              context: context,
                                              showMessage: true);
                                    } else {
                                      showCustomSnackBar('out_of_stock'.tr);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall),
                                    child: Icon(Icons.add,
                                        size: 24,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
