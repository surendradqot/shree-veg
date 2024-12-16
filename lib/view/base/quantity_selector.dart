import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import '../../data/model/response/product_model.dart';
import '../../provider/splash_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/images.dart';
import '../../utill/styles.dart';

class ParticularProductQuantitySelector extends StatelessWidget {
  final Product product;
  final int selectedVariation;
  final Function(BuildContext context, int variationIndex) callback;
  const ParticularProductQuantitySelector({Key? key, required this.product, required this.selectedVariation, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE8E8E8),
      child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
        return InkWell(
          onTap: () {
            print('change quantity');
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                // Content of the bottom sheet
                return Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color:
                                      ColorResources.getGreyColor(context)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  // color: ColorResources.getGreyColor(context),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                                    placeholder: (context, url) =>
                                        Image.asset(
                                            Images.placeholder(context)),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            Images.placeholder(context)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${product.name}', style: poppinsRegular.copyWith(fontSize: 14)),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text('Choose a pack size', style: poppinsRegular.copyWith(fontSize: 12),),

                      SizedBox(height: (75 * product.variations!.length).toDouble(),
                        child: ListView.builder(
                            itemCount: product.variations!.length,
                            itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen)),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${product.variations![index].quantity} ${product.unit}', style: poppinsRegular.copyWith(fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xFF000000)),),
                                        Row(
                                          children: [
                                            Text('₹${product.variations![index].offerPrice}', style: poppinsRegular.copyWith(fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xFF000000)),),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Text('₹${product.variations![index].marketPrice}', style: poppinsRegular.copyWith(fontWeight: FontWeight.w500, fontSize: 10, color: const Color(0xFF676767), decoration: TextDecoration.lineThrough),),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: const Color(0xFF026F00),
                                                    borderRadius: BorderRadius.circular(0)),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 2),
                                                margin: const EdgeInsets.all(2),
                                                child: Text('${product.variations![index].discount}% off',
                                                    style: poppinsRegular.copyWith(
                                                        color: Colors.white, fontSize: 8, fontWeight: FontWeight.w500)))
                                          ],
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                        onTap: () {
                                          callback(context, index);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                              Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(20)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 2),
                                            margin: const EdgeInsets.all(2),
                                            child: Text('Add',
                                                style: poppinsRegular.copyWith(
                                                    color: Colors.white))))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.variations!.isNotEmpty?'${product.variations![selectedVariation].quantity} ${product.unit}':"${product.unit}",
                  style: poppinsRegular.copyWith(fontSize: 10),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black54,
                )
              ],
            ),
          ),
        );}
      ),
    );
  }
}