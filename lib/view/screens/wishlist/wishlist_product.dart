import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/provider/wishlist_provider.dart';
import 'package:shreeveg/utill/styles.dart';
import '../../../data/model/response/product_model.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';

Widget wishListItem(
    BuildContext context, Product? product, WishListProvider wishlistProvider) {
  return Padding(
    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
    child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.465,
        height: MediaQuery.of(context).size.width * 0.55,
        child: Column(
          children: [
            Card(
              elevation: 2,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder(context),
                            fit: BoxFit.fill,
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image!.isNotEmpty ? product.image![0] : ''}',
                            imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholder(context),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      const Positioned(
                          top: 10,
                          left: 10,
                          child:
                              Icon(Icons.favorite, color: Color(0xFFE70606))),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => wishlistProvider
                                .removeFromWishList(product, context),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Text(
                          product.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '(${product.hindiName!})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          PriceConverter.convertPrice(
                              context, double.parse(product.price!)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0B4619)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
  );
}
