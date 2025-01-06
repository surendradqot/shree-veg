import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/product/widget/prices_view.dart';

class VariationView extends StatelessWidget {
  final Product product;
  const VariationView({Key? key, required this.product}) : super(key: key);

  void updateSelectedVariation(BuildContext context, int variationIndex) {
    Provider.of<ProductProvider>(context, listen: false)
        .setSelectedVariation(product, variationIndex);
  }

  @override
  Widget build(BuildContext context) {
    print('selected varrrrrrrrrrrrrr: ${product.selectedVariation}');

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: (1.5 / 0.5),
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: product.variations!.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    updateSelectedVariation(context, i);
                  },
                  child: Stack(
                    alignment: Alignment.topLeft,
                    fit: StackFit.loose,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1FFF4),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: product.selectedVariation == i
                                  ? const Color(0xFF039800)
                                  : ColorResources.getGreyColor(context),
                              width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${product.variations![i].quantity!} ${product.unit}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            ),

                            //prices row
                            PricesView(
                                marketPrice: product.variations![i].marketPrice!,
                                offerPrice: double.parse(
                                    product.variations![i].offerPrice!),
                              centerAlign: true,
                            ),
                            if(i!=0)
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "(₹${(double.parse(
                                        product.variations![i].offerPrice!)/double.parse(product.variations![i].quantity!)).toStringAsFixed(2)} per kg)",
                                    style: poppinsRegular.copyWith(
                                        color:  Color(0xFF848484),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 06,
                                    ),
                                  )),

                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 24,
                          width: 25,
                          margin: EdgeInsets.only(left: 05),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              // color: Color(0xFFe73838),
                              image: DecorationImage(image: AssetImage("assets/image/ribbon.png"),fit: BoxFit.contain)
                          ),
                          child: Text("${product.variations![i].discount!.split(".").first.replaceAll("-", "")}%\n Off",style: TextStyle(
                            fontSize: 07,
                            color: Colors.white,
                          ),),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
