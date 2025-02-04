import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/new_category_product_modal.dart';
import 'package:shreeveg/localization/language_constraints.dart';

import '../../../../data/model/response/product_model.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';

class ProductTitleOnlyView extends StatelessWidget {
  final ProductData? product;
  final double? fontSize;
  const ProductTitleOnlyView({Key? key, required this.product, this.fontSize = Dimensions.fontSizeLarge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Flexible(
            child: Row(
              children: [
                Text(
                  product!.name ?? '',
                  style: poppinsMedium.copyWith(
                      fontSize: fontSize,
                      color:
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color
                          ?.withOpacity(1)
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Flexible(
                  child: Text(
                    ' (#${product!.productCode})',
                    style: poppinsMedium.copyWith(
                        fontSize: fontSize,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color
                            ?.withOpacity(0.6)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Spacer(),
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: Dimensions.paddingSizeSmall,
                //       vertical: 2),
                //   decoration: BoxDecoration(
                //     borderRadius:
                //     BorderRadius.circular(Dimensions.radiusSizeLarge),
                //     color:
                //     product!.totalStock! > 0
                //         ? const Color(0xFF039800)
                //         : Theme.of(context).primaryColor.withOpacity(0.3),
                //   ),
                //   child: Text(
                //     '${getTranslated(product!.totalStock! > 0 ? 'in_stock' : 'stock_out', context)}',
                //     style: poppinsMedium.copyWith(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      Row(
        children: [
          Flexible(
            child: Text(
              '(${product!.hnName})',
              style: poppinsMedium.copyWith(
                  fontSize: fontSize,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ],);
  }
}