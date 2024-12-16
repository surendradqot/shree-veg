import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/provider/flash_deal_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/view/base/product_widget.dart';
import 'package:shreeveg/view/base/web_product_shimmer.dart';
import 'package:provider/provider.dart';

class HomeItemView extends StatelessWidget {
  final List<Product>? productList;
  final String  productType;

  const HomeItemView({Key? key, this.productList, required this.productType}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    print('listtt issss: $productList');

    return Consumer<FlashDealProvider>(
        builder: (context, flashDealProvider, child) {
      return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
        return productList != null
            ? Column(children: [
                ResponsiveHelper.isDesktop(context)
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (1 / 1.1),
                          crossAxisCount: 5,
                          mainAxisSpacing: 13,
                          crossAxisSpacing: 13,
                        ),
                        itemCount: productList!.length >= 10
                            ? 10
                            : productList!.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeLarge,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            isGrid: true,
                            product: productList![index],
                            productType: productType,
                          );
                        },
                      )
                    : SizedBox(
                        height: 200,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          itemCount: productList!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 195,
                              padding: const EdgeInsets.all(5),
                              child: Text("data"),
                              // child: ProductWidget(
                              //   isGrid: true,
                              //   product: productList![index],
                              //   productType: productType,
                              // ),
                            );
                          },
                        ),
                      ),
              ])
            : ResponsiveHelper.isDesktop(context)
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (1 / 1.3),
                      crossAxisCount: 5,
                      mainAxisSpacing: 13,
                      crossAxisSpacing: 13,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        const WebProductShimmer(isEnabled: true),
                  )
                : SizedBox(
                    height: 250,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 195,
                          padding: const EdgeInsets.all(5),
                          child: const WebProductShimmer(isEnabled: true),
                        );
                      },
                    ),
                  );
      });
    });
  }
}
