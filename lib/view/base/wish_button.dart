import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/new_category_product_modal.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/wishlist_provider.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class WishButton extends StatelessWidget {
  final ProductData? product;
  final EdgeInsetsGeometry edgeInset;
  const WishButton(
      {Key? key, required this.product, this.edgeInset = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishListProvider>(builder: (context, wishList, child) {
      return InkWell(
        onTap: () {
          // print('product idddddddd: ${product!.productId}');
          // if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
          //   wishList.wishIdList.contains(product!.productId)
          //       ? wishList.removeFromWishList(product!, context)
          //       : wishList.addToWishList(product!, context);
          // } else {
          //   showCustomSnackBar(
          //       getTranslated('now_you_are_in_guest_mode', context)!);
          // }
        },
        child: Padding(
          padding: edgeInset,
          child: Icon(
              wishList.wishIdList.contains(product!.productId)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: wishList.wishIdList.contains(product!.productId)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor),
        ),
      );
    });
  }
}
