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
        double? minDiscount;

        if (product.variations!.isNotEmpty) {
          if (product.variations != null) {
            for (int index = 0; index < product.variations!.length; index++) {
              Variations variationData = product.variations![index];
              if (minDiscount == null) {
                minDiscount =
                    double.parse(variationData.discount!.replaceAll("-", ""));
              } else {
                if (minDiscount >=
                    double.parse(variationData.discount!.replaceAll("-", ""))) {
                  minDiscount =
                      double.parse(variationData.discount!.replaceAll("-", ""));
                }
              }
            }
          }
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
            (price -
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
            Navigator.of(context).pushNamed(
              RouteHelper.getProductDetailsRoute(
                product: product,
                formSearch: productType == ProductType.searchItem,
              ),
            );
            /*if (product.variations == null || product.variations!.isEmpty) {
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
            }*/
          },
          // child: Container(
          //   padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Theme.of(context).cardColor,
          //   ),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           border: Border.all(
          //               width: 2, color: ColorResources.getGreyColor(context)),
          //           borderRadius: BorderRadius.circular(10),
          //           color: Colors.white,
          //         ),
          //         child: Stack(
          //           children: [
          //             ClipRRect(
          //               borderRadius: BorderRadius.circular(10),
          //               child:  product.variations!.isNotEmpty?Banner(
          //                 message:'${minDiscount!}% off',
          //                 location: BannerLocation.topStart,
          //                 color: const Color(0xFF0B4619),
          //                 child: CachedNetworkImage(
          //                   width: MediaQuery.of(context).size.width * 0.3,
          //                   height: 180,
          //                   fit: BoxFit.contain,
          //                   imageUrl:
          //                   '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
          //                   placeholder: (context, url) =>
          //                       Image.asset(Images.placeholder(context)),
          //                   errorWidget: (context, url, error) =>
          //                       Image.asset(Images.placeholder(context)),
          //                 ),
          //               ):CachedNetworkImage(
          //                 width: MediaQuery.of(context).size.width * 0.3,
          //                 height: 180,
          //                 fit: BoxFit.contain,
          //                 imageUrl:
          //                 '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
          //                 placeholder: (context, url) =>
          //                     Image.asset(Images.placeholder(context)),
          //                 errorWidget: (context, url, error) =>
          //                     Image.asset(Images.placeholder(context)),
          //               ),
          //             ),
          //             Positioned(
          //               top: -5,
          //               right: -5,
          //               child: WishButton(
          //                 product: product,
          //                 edgeInset: const EdgeInsets.all(8.0),
          //               ),
          //             ),
          //             Positioned(
          //               bottom: 0,
          //               left: 0,
          //               right: 0,
          //               child: product.hindiName != null
          //                   ? Container(
          //                 padding: EdgeInsets.all(02),
          //                 decoration: BoxDecoration(
          //                   color: Theme.of(context).primaryColor,
          //                   borderRadius: BorderRadius.only(
          //                     bottomLeft: Radius.circular(10),
          //                     bottomRight: Radius.circular(10),
          //                   ),
          //                 ),
          //                 child: Text(
          //                   product.hindiName!,
          //                   style: poppinsMedium.copyWith(
          //                     fontSize: Dimensions.fontSizeSmall,
          //                     color: Colors.white,
          //                   ),
          //                   maxLines: 1,
          //                   textAlign: TextAlign.center,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               )
          //                   : const SizedBox.shrink(),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: Dimensions.paddingSizeSmall),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Expanded(
          //                     child: Text(
          //                       product.name!,
          //                       style: poppinsMedium.copyWith(
          //                         fontSize: Dimensions.fontSizeSmall,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                       maxLines: 2,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   Container(
          //                     padding: EdgeInsets.all(06),
          //                     decoration: BoxDecoration(
          //                         color: Colors.black,
          //                         borderRadius: BorderRadius.only(
          //                           topRight: Radius.circular(10),
          //                           bottomLeft: Radius.circular(10),
          //                         )),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         Text(
          //                           "Product Total ",
          //                           style: poppinsMedium.copyWith(
          //                               fontSize: 08, color: Colors.white),
          //                         ),
          //                         Container(
          //                           // width: 20,
          //                           // height: 15,
          //                           padding:
          //                           EdgeInsets.symmetric(horizontal: 08),
          //                           decoration: BoxDecoration(
          //                             color: Color(0XFFFFDE4D),
          //                             // shape: BoxShape.oval,
          //                             borderRadius: BorderRadius.only(
          //                               topRight: Radius.elliptical(15, 08),
          //                               topLeft: Radius.elliptical(15, 08),
          //                               bottomLeft: Radius.elliptical(15, 08),
          //                               bottomRight: Radius.elliptical(15, 08),
          //                             ),
          //                           ),
          //                           child: RichText(
          //                             text: TextSpan(
          //                               text: "12",
          //                               children: [
          //                                 TextSpan(
          //                                   text: "Kg",
          //                                   style: poppinsMedium.copyWith(
          //                                     fontSize: 06,
          //                                     color: Color(0XFF80150E),
          //                                   ),
          //                                 ),
          //                               ],
          //                               style: poppinsMedium.copyWith(
          //                                 fontSize: 10,
          //                                 color: Color(0XFF80150E),
          //                               ),
          //                             ),
          //                           ),
          //                           // child: Text(
          //                           //   "2Kg",
          //                           //   style: poppinsMedium.copyWith(
          //                           //       fontSize: 06, color: Color(0XFF80150E)),
          //                           // ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               product
          //                   .variations!.isNotEmpty?PricesView(
          //                   firstCut: false,
          //                   marketPrice: product
          //                       .variations![product.selectedVariation ?? 0]
          //                       .marketPrice!,
          //                   offerPrice: double.parse(product
          //                       .variations![product.selectedVariation ?? 0]
          //                       .offerPrice!)):PricesView(
          //                 firstCut: false,
          //                 marketPrice: product
          //                     .marketPrice!.toInt(),
          //                 offerPrice: double.parse(product.price!),
          //               ),
          //               Row(
          //                 children: [
          //                   Expanded(
          //                     child: ParticularProductQuantitySelector(
          //                         product: product,
          //                         callback: updateSelectedVariation,
          //                         selectedVariation: product.selectedVariation ?? 0),
          //                   ),
          //                   Expanded(
          //                     // width: MediaQuery.of(context).size.width,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.end,
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       children: [
          //                         !isExistInCart
          //                             ? InkWell(
          //                           onTap: () {
          //                             if (product.variations == null ||
          //                                 product.variations!.isEmpty) {
          //                               Navigator.of(context).pushNamed(
          //                                 RouteHelper.getProductDetailsRoute(
          //                                   product: product,
          //                                   formSearch:
          //                                   productType == ProductType.searchItem,
          //                                 ),
          //                               );
          //                             } else {
          //                               if (!isExistInCart && stock! > 0) {
          //                                 Provider.of<CartProvider>(context,
          //                                     listen: false)
          //                                     .addToCart(cartModel!);
          //                                 showCustomSnackBar('added_to_cart'.tr,
          //                                     isError: false);
          //                               } else {
          //                                 showCustomSnackBar(isExistInCart
          //                                     ? 'already_added'.tr
          //                                     : 'out_of_stock'.tr);
          //                               }
          //                             }
          //                           },
          //                           child: Container(
          //                             padding: const EdgeInsets.symmetric(
          //                                 horizontal: 10, vertical: 4),
          //                             margin: const EdgeInsets.all(2),
          //                             color: Theme.of(context).primaryColor,
          //                             child: Text(
          //                               'ADD',
          //                               style: poppinsRegular.copyWith(
          //                                   color: Colors.white),
          //                             ),
          //                           ),
          //                         )
          //                             : Consumer<CartProvider>(
          //                           builder: (context, cart, child) => Row(
          //                             mainAxisAlignment: MainAxisAlignment.end,
          //                             children: [
          //                               InkWell(
          //                                 onTap: () {
          //                                   if (cart.cartList[cardIndex!].quantity! >
          //                                       1) {
          //                                     Provider.of<CartProvider>(context,
          //                                         listen: false)
          //                                         .setQuantity(false, cardIndex,
          //                                         context: context,
          //                                         showMessage: true);
          //                                   } else {
          //                                     Provider.of<CartProvider>(context,
          //                                         listen: false)
          //                                         .removeFromCart(cardIndex, context);
          //                                   }
          //                                 },
          //                                 child: Padding(
          //                                   padding: const EdgeInsets.symmetric(
          //                                       horizontal: 5,
          //                                       vertical:
          //                                       Dimensions.paddingSizeExtraSmall),
          //                                   child: Icon(Icons.remove,
          //                                       size: 24,
          //                                       color: Theme.of(context).primaryColor),
          //                                 ),
          //                               ),
          //                               Text(
          //                                 cart.cartList[cardIndex!].quantity.toString(),
          //                                 style: poppinsSemiBold.copyWith(
          //                                     fontSize: Dimensions.fontSizeExtraLarge,
          //                                     color: Theme.of(context).primaryColor),
          //                               ),
          //                               InkWell(
          //                                 onTap: () {
          //                                   if (cart.cartList[cardIndex!].quantity! <
          //                                       cart.cartList[cardIndex].stock!) {
          //                                     Provider.of<CartProvider>(context,
          //                                         listen: false)
          //                                         .setQuantity(true, cardIndex,
          //                                         context: context,
          //                                         showMessage: true);
          //                                   } else {
          //                                     showCustomSnackBar('out_of_stock'.tr);
          //                                   }
          //                                 },
          //                                 child: Padding(
          //                                   padding: const EdgeInsets.symmetric(
          //                                       horizontal: 5,
          //                                       vertical:
          //                                       Dimensions.paddingSizeExtraSmall),
          //                                   child: Icon(Icons.add,
          //                                       size: 24,
          //                                       color: Theme.of(context).primaryColor),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Container(
          //                 height: 45,
          //                 width: MediaQuery.of(context).size.width,
          //                 decoration: BoxDecoration(
          //                   color:  Color(0XFF870C03),
          //                   borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(10),
          //                     topRight: Radius.circular(10),
          //                     bottomLeft: Radius.circular(10),
          //                     bottomRight: Radius.circular(10),
          //                   ),
          //                 ),
          //                 child: Stack(
          //                   fit: StackFit.expand,
          //                   children: [
          //                     Positioned(
          //                       top:04,
          //                       right: 04,
          //                       child: Transform.rotate(
          //                         angle: 0.78353,
          //                         child: const Text(
          //                           'Off',
          //                           style: TextStyle(
          //                               color: Colors.white,
          //                               fontSize: 06),
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       height: 45,
          //                       width: MediaQuery.of(context).size.width,
          //                       padding: EdgeInsets.all(10),
          //                       decoration: BoxDecoration(
          //                         color:Theme.of(context).primaryColor,
          //                         borderRadius: BorderRadius.only(
          //                           topRight: Radius.elliptical(50, 50),
          //                           topLeft: Radius.circular(10),
          //                           bottomRight: Radius.circular(10),
          //                           bottomLeft: Radius.circular(10),
          //                         ),
          //                       ),
          //                       alignment: Alignment.center,
          //                       child: Row(
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                         children: [
          //                           const Text(
          //                             "Applicable Discount",
          //                             maxLines: 1,
          //                             overflow:
          //                             TextOverflow.ellipsis,
          //                             style: TextStyle(
          //                                 color:
          //                                 Colors.yellow,
          //                                 fontWeight:
          //                                 FontWeight
          //                                     .w500,
          //                                 fontSize: 12),
          //                           ),
          //                           Center(
          //                             child: Text(
          //                               "${double.parse(product.variations![product.selectedVariation!].discount!).toStringAsFixed(1)}%",
          //                               maxLines: 1,
          //                               overflow:
          //                               TextOverflow.ellipsis,
          //                               style: TextStyle(
          //                                   color:
          //                                   Colors.white,
          //                                   fontWeight:
          //                                   FontWeight
          //                                       .w500,
          //                                   fontSize: 12),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //
          //     ],
          //   ),
          // ),
          child: Container(
            // padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
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
                        child: product.variations!.isNotEmpty
                            ? Banner(
                                message: '${minDiscount!}% off',
                                location: BannerLocation.topStart,
                                color: const Color(0xFF0B4619),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: CachedNetworkImage(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 150,
                                    fit: BoxFit.contain,
                                    imageUrl:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                                    placeholder: (context, url) => Image.asset(
                                        Images.placeholder(context)),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            Images.placeholder(context)),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: CachedNetworkImage(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 150,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                                  placeholder: (context, url) =>
                                      Image.asset(Images.placeholder(context)),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(Images.placeholder(context)),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Banner(
                            message: product.productCode!,
                            location: BannerLocation.topEnd,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 180,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: product.hindiName != null
                            ? Container(
                                padding: EdgeInsets.all(02),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  product.hindiName!,
                                  style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : const SizedBox.shrink(),
                      )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name!,
                                style: poppinsMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(06),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Product Total ",
                                    style: poppinsMedium.copyWith(
                                        fontSize: 08, color: Colors.white),
                                  ),
                                  Container(
                                    // width: 20,
                                    // height: 15,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 08),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFFFDE4D),
                                      // shape: BoxShape.oval,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.elliptical(15, 08),
                                        topLeft: Radius.elliptical(15, 08),
                                        bottomLeft: Radius.elliptical(15, 08),
                                        bottomRight: Radius.elliptical(15, 08),
                                      ),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "12",
                                        children: [
                                          TextSpan(
                                            text: "Kg",
                                            style: poppinsMedium.copyWith(
                                              fontSize: 06,
                                              color: Color(0XFF80150E),
                                            ),
                                          ),
                                        ],
                                        style: poppinsMedium.copyWith(
                                          fontSize: 10,
                                          color: Color(0XFF80150E),
                                        ),
                                      ),
                                    ),
                                    // child: Text(
                                    //   "2Kg",
                                    //   style: poppinsMedium.copyWith(
                                    //       fontSize: 06, color: Color(0XFF80150E)),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            // product.hindiName != null
                            //     ? Text(
                            //       '(${product.hindiName!})',
                            //       style: poppinsMedium.copyWith(
                            //           fontSize: Dimensions.fontSizeSmall),
                            //       maxLines: 1,
                            //       textAlign: TextAlign.left,
                            //       overflow: TextOverflow.ellipsis,
                            //     )
                            //     : const SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(
                          height: 05,
                        ),
                        product.variations!.isNotEmpty
                            ? Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                    itemCount: product.variations!.length,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          // text: product
                                                          //     .variations![index]
                                                          //     .quantity!,
                                                          text: product.variations![index].quantity!.contains(".") ? (double.parse(product.variations![index].quantity!).toStringAsFixed(3)).split(".").last : product.variations![index].quantity!,
                                                          // maxLines: 1,
                                                          // overflow: TextOverflow.ellipsis,
                                                          style:
                                                          poppinsRegular.copyWith(
                                                              color:
                                                              Color(0xFF0B4619),
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 12),
                                                          children: [
                                                            TextSpan(
                                                              text: "${product.variations![index].quantity!.contains(".") ?"gm":product.unit}",
                                                              style: poppinsRegular
                                                                  .copyWith(
                                                                  color: Color(
                                                                      0xFF0B4619),
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  fontSize: 08),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 08,),
                                                      Text(
                                                        "₹${product.variations![index].offerPrice!}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: poppinsRegular.copyWith(
                                                            color: Color(0xFF0B4619),
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),

                                                  index!=0?Text(
                                                    "(₹${(double.parse(
                                                        product.variations![index].offerPrice!)/double.parse(product.variations![index].quantity!)).toStringAsFixed(2)}/kg)",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: poppinsRegular.copyWith(
                                                        color: Color(0xFF0B4619),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 08),
                                                  ):SizedBox(),
                                                ],
                                              ),
                                              /*Container(
                                                height: 30,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  color: Color(0XFF226326),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  ),
                                                ),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Positioned(
                                                      top:03,
                                                      right: 02,
                                                      child: Transform.rotate(
                                                        angle: 0.78353,
                                                        child: const Text(
                                                          'Off',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 06),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      width: 50,
                                                      padding: EdgeInsets.all(06),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0XFF870C03),
                                                        borderRadius: BorderRadius.only(
                                                          // topRight: Radius.elliptical(50, 50),
                                                          topRight: Radius.circular(10),
                                                          topLeft: Radius.circular(10),
                                                          bottomRight: Radius.circular(10),
                                                          bottomLeft: Radius.circular(10),
                                                        ),
                                                      ),
                                                      // alignment: Alignment.center,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text(
                                                            "Discount",
                                                            maxLines: 1,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                Colors.yellow,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                fontSize: 05),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              "${double.parse(product.variations![index].discount!).toStringAsFixed(1)}%",
                                                              maxLines: 1,
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  fontSize: 08),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),*/
                                              // Text(
                                              //   "${product
                                              //     .variations![index].quantity!}${product.unit!.toCapitalized()}",
                                              //   maxLines: 1,
                                              //   overflow: TextOverflow.ellipsis,
                                              //   style: poppinsRegular.copyWith(
                                              //       color: Color(0xFF0B4619), fontWeight: FontWeight.w500, fontSize: 12),
                                              // ),




                                              Container(
                                                height: 30,
                                                width: 50,
                                                padding: EdgeInsets.all(06),
                                                decoration: const BoxDecoration(
                                                  color: Color(0XFF870C03),
                                                  borderRadius: BorderRadius.only(
                                                    // topRight: Radius.elliptical(50, 50),
                                                    topRight: Radius.circular(10),
                                                    topLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                  ),
                                                ),
                                                // alignment: Alignment.center,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Discount",
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                          Colors.yellow,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          fontSize: 05),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "${double.parse(product.variations![index].discount!).toStringAsFixed(1)}%",
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize: 08),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Stack(
                                              //   children: [
                                              //     Container(
                                              //       padding:
                                              //           const EdgeInsets.all(
                                              //               05),
                                              //       margin:
                                              //           const EdgeInsets.all(2),
                                              //       decoration: BoxDecoration(
                                              //         color: Colors.red,
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 06),
                                              //         // border: Border.all(
                                              //         //     color: Colors.red),
                                              //       ),
                                              //       child: Text(
                                              //         "${product.variations![index].discount!}%",
                                              //         maxLines: 1,
                                              //         overflow:
                                              //             TextOverflow.ellipsis,
                                              //         style: poppinsRegular
                                              //             .copyWith(
                                              //                 color:
                                              //                     Colors.white,
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .w500,
                                              //                 fontSize: 08),
                                              //       ),
                                              //     ),
                                              //     Positioned(
                                              //       top: 5,
                                              //       left: 3,
                                              //       child: Transform.rotate(
                                              //         angle: -0.785398,
                                              //         // 45 degrees in radians
                                              //         child: Text(
                                              //           'Off',
                                              //           style: TextStyle(
                                              //               color: Colors.white,
                                              //               fontSize: 05),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              !isExistInCart
                                                  ? InkWell(
                                                      onTap: () {
                                                        showCustomSnackBar(
                                                            "Not in scope");
                                                        /*if (product.variations ==
                                                                null ||
                                                            product.variations!
                                                                .isEmpty) {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                            RouteHelper
                                                                .getProductDetailsRoute(
                                                              product: product,
                                                              formSearch:
                                                                  productType ==
                                                                      ProductType
                                                                          .searchItem,
                                                            ),
                                                          );
                                                        } else {
                                                          *//*if(stock! > 0){
                                              cartModel = CartModel(
                                                product.id,    // product id
                                                product.image!.isNotEmpty ? product.image![0] : '',    // product image
                                                product.name,    // product name
                                                product.variations![index].marketPrice!.toDouble(),    // product price
                                                double.parse(product.variations![index].offerPrice!),    // product discount price
                                                int.parse(product.variations![index].quantity!),    // product quantity
                                                product.variations!.isNotEmpty ? product.variations![index] : null,    // product variation
                                                (price! -
                                                    PriceConverter.convertWithDiscount(price,
                                                        double.parse(product.discount!), product.discountType)!),    // product discount
                                                (price -
                                                    PriceConverter.convertWithDiscount(
                                                        price, product.tax, product.taxType)!),    // product tex
                                                product.capacity,    // product capacity
                                                product.unit,    // product unit
                                                stock,    // product stock
                                                product,    // product product
                                              );
                                              Provider.of<CartProvider>(context,
                                                  listen: false)
                                                  .addToCart(cartModel!);
                                              int? addedId = int.parse(product.id!.toString()+product.variations![index].quantity!);
                                              Provider.of<CartProvider>(context,
                                                  listen: false)
                                                  .addedCartListMethod(addedId);
                                              showCustomSnackBar('added_to_cart'.tr,
                                                  isError: false);
                                            }*//*
                                                          if (!isExistInCart &&
                                                              stock! > 0) {
                                                            Provider.of<CartProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addToCart(
                                                                    cartModel!);
                                                            showCustomSnackBar(
                                                                'added_to_cart'
                                                                    .tr,
                                                                isError: false);
                                                          } else {
                                                            showCustomSnackBar(
                                                                isExistInCart
                                                                    ? 'already_added'
                                                                        .tr
                                                                    : 'out_of_stock'
                                                                        .tr);
                                                          }
                                                        }*/
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4),
                                                        margin: const EdgeInsets
                                                            .all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(06),
                                                          // border: Border.all(
                                                          //     color: Colors.red),
                                                        ),
                                                        child: Text(
                                                          'ADD',
                                                          style: poppinsRegular
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Consumer<CartProvider>(
                                                      builder: (context, cart,
                                                              child) =>
                                                          Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              if (cart
                                                                      .cartList[
                                                                          cardIndex!]
                                                                      .quantity! >
                                                                  1) {
                                                                Provider.of<CartProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setQuantity(
                                                                        false,
                                                                        cardIndex,
                                                                        context:
                                                                            context,
                                                                        showMessage:
                                                                            true);
                                                              } else {
                                                                Provider.of<CartProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .removeFromCart(
                                                                        cardIndex,
                                                                        context);
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 5,
                                                                  vertical:
                                                                      Dimensions
                                                                          .paddingSizeExtraSmall),
                                                              child: Icon(
                                                                  Icons.remove,
                                                                  size: 24,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ),
                                                          Text(
                                                            cart
                                                                .cartList[
                                                                    cardIndex!]
                                                                .quantity
                                                                .toString(),
                                                            style: poppinsSemiBold.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeExtraLarge,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              if (cart
                                                                      .cartList[
                                                                          cardIndex!]
                                                                      .quantity! <
                                                                  cart
                                                                      .cartList[
                                                                          cardIndex]
                                                                      .stock!) {
                                                                Provider.of<CartProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setQuantity(
                                                                        true,
                                                                        cardIndex,
                                                                        context:
                                                                            context,
                                                                        showMessage:
                                                                            true);
                                                              } else {
                                                                showCustomSnackBar(
                                                                    'out_of_stock'
                                                                        .tr);
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 5,
                                                                  vertical:
                                                                      Dimensions
                                                                          .paddingSizeExtraSmall),
                                                              child: Icon(
                                                                  Icons.add,
                                                                  size: 24,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "MRP: ₹${product.variations![index].marketPrice}  ",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: poppinsRegular.copyWith(
                                                    color: Color(0xFF7C7C7C),
                                                    fontWeight: FontWeight.w400,
                                                    // decoration: TextDecoration.lineThrough,
                                                    fontSize: 08),
                                              ),
                                              Text(
                                                "(Approx- 600Gm-800Gm)",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: poppinsRegular.copyWith(
                                                    color: Color(0xFF0B4619),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 08),
                                              ),

                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "₹${product.marketPrice!}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: poppinsRegular.copyWith(
                                        color: Color(0xFF0B4619),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                  // Container(
                                  //   padding: const EdgeInsets.all(04),
                                  //   margin: const EdgeInsets.all(2),
                                  //   color: Colors.green,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.center,
                                  //     children: [
                                  //       Text(
                                  //         "Applicable Discount",
                                  //         maxLines: 1,
                                  //         overflow: TextOverflow.ellipsis,
                                  //         style: poppinsRegular.copyWith(
                                  //             color: Colors.white, fontWeight: FontWeight.w400, fontSize: 05),
                                  //       ),
                                  //       Text(
                                  //         "${product
                                  //             .variations![index].discount!}%",
                                  //         maxLines: 1,
                                  //         overflow: TextOverflow.ellipsis,
                                  //         style: poppinsRegular.copyWith(
                                  //             color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  !isExistInCart
                                      ? InkWell(
                                          onTap: () {
                                            if (product.variations == null ||
                                                product.variations!.isEmpty) {
                                              Navigator.of(context).pushNamed(
                                                RouteHelper
                                                    .getProductDetailsRoute(
                                                  product: product,
                                                  formSearch: productType ==
                                                      ProductType.searchItem,
                                                ),
                                              );
                                            } else {
                                              /*if(stock! > 0){
                                          cartModel = CartModel(
                                            product.id,    // product id
                                            product.image!.isNotEmpty ? product.image![0] : '',    // product image
                                            product.name,    // product name
                                            product.variations![index].marketPrice!.toDouble(),    // product price
                                            double.parse(product.variations![index].offerPrice!),    // product discount price
                                            int.parse(product.variations![index].quantity!),    // product quantity
                                            product.variations!.isNotEmpty ? product.variations![index] : null,    // product variation
                                            (price! -
                                                PriceConverter.convertWithDiscount(price,
                                                    double.parse(product.discount!), product.discountType)!),    // product discount
                                            (price -
                                                PriceConverter.convertWithDiscount(
                                                    price, product.tax, product.taxType)!),    // product tex
                                            product.capacity,    // product capacity
                                            product.unit,    // product unit
                                            stock,    // product stock
                                            product,    // product product
                                          );
                                          Provider.of<CartProvider>(context,
                                              listen: false)
                                              .addToCart(cartModel!);
                                          int? addedId = int.parse(product.id!.toString()+product.variations![index].quantity!);
                                          Provider.of<CartProvider>(context,
                                              listen: false)
                                              .addedCartListMethod(addedId);
                                          showCustomSnackBar('added_to_cart'.tr,
                                              isError: false);
                                        }*/
                                              if (!isExistInCart &&
                                                  stock! > 0) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .addToCart(cartModel!);
                                                showCustomSnackBar(
                                                    'added_to_cart'.tr,
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: Text(
                                              'ADD',
                                              style: poppinsRegular.copyWith(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Consumer<CartProvider>(
                                          builder: (context, cart, child) =>
                                              Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (cart.cartList[cardIndex!]
                                                          .quantity! >
                                                      1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .setQuantity(
                                                            false, cardIndex,
                                                            context: context,
                                                            showMessage: true);
                                                  } else {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFromCart(
                                                            cardIndex, context);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Icon(Icons.remove,
                                                      size: 24,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                              Text(
                                                cart.cartList[cardIndex!]
                                                    .quantity
                                                    .toString(),
                                                style: poppinsSemiBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (cart.cartList[cardIndex!]
                                                          .quantity! <
                                                      cart.cartList[cardIndex]
                                                          .stock!) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .setQuantity(
                                                            true, cardIndex,
                                                            context: context,
                                                            showMessage: true);
                                                  } else {
                                                    showCustomSnackBar(
                                                        'out_of_stock'.tr);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Icon(Icons.add,
                                                      size: 24,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                        /* product
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
                                      : 4.0,
                                  size: 10,
                                ),
                              )
                            : const SizedBox(),*/
                      ],
                    ),
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     !isExistInCart
                //         ? InkWell(
                //             onTap: () {
                //               if (product.variations == null ||
                //                   product.variations!.isEmpty) {
                //                 Navigator.of(context).pushNamed(
                //                   RouteHelper.getProductDetailsRoute(
                //                     product: product,
                //                     formSearch:
                //                         productType == ProductType.searchItem,
                //                   ),
                //                 );
                //               } else {
                //                 if (!isExistInCart && stock! > 0) {
                //                   Provider.of<CartProvider>(context,
                //                           listen: false)
                //                       .addToCart(cartModel!);
                //                   showCustomSnackBar('added_to_cart'.tr,
                //                       isError: false);
                //                 } else {
                //                   showCustomSnackBar(isExistInCart
                //                       ? 'already_added'.tr
                //                       : 'out_of_stock'.tr);
                //                 }
                //               }
                //             },
                //             child: Container(
                //               padding: const EdgeInsets.symmetric(
                //                   horizontal: 10, vertical: 4),
                //               margin: const EdgeInsets.all(2),
                //               color: Theme.of(context).primaryColor,
                //               child: Text(
                //                 'ADD',
                //                 style: poppinsRegular.copyWith(
                //                     color: Colors.white),
                //               ),
                //             ),
                //           )
                //         : Consumer<CartProvider>(
                //             builder: (context, cart, child) => Row(
                //               children: [
                //                 InkWell(
                //                   onTap: () {
                //                     if (cart.cartList[cardIndex!].quantity! >
                //                         1) {
                //                       Provider.of<CartProvider>(context,
                //                               listen: false)
                //                           .setQuantity(false, cardIndex,
                //                               context: context,
                //                               showMessage: true);
                //                     } else {
                //                       Provider.of<CartProvider>(context,
                //                               listen: false)
                //                           .removeFromCart(cardIndex, context);
                //                     }
                //                   },
                //                   child: Padding(
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 5,
                //                         vertical:
                //                             Dimensions.paddingSizeExtraSmall),
                //                     child: Icon(Icons.remove,
                //                         size: 24,
                //                         color: Theme.of(context).primaryColor),
                //                   ),
                //                 ),
                //                 Text(
                //                   cart.cartList[cardIndex!].quantity.toString(),
                //                   style: poppinsSemiBold.copyWith(
                //                       fontSize: Dimensions.fontSizeExtraLarge,
                //                       color: Theme.of(context).primaryColor),
                //                 ),
                //                 InkWell(
                //                   onTap: () {
                //                     if (cart.cartList[cardIndex!].quantity! <
                //                         cart.cartList[cardIndex].stock!) {
                //                       Provider.of<CartProvider>(context,
                //                               listen: false)
                //                           .setQuantity(true, cardIndex,
                //                               context: context,
                //                               showMessage: true);
                //                     } else {
                //                       showCustomSnackBar('out_of_stock'.tr);
                //                     }
                //                   },
                //                   child: Padding(
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 5,
                //                         vertical:
                //                             Dimensions.paddingSizeExtraSmall),
                //                     child: Icon(Icons.add,
                //                         size: 24,
                //                         color: Theme.of(context).primaryColor),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
