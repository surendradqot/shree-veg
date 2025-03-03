import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/body/review_body.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

class AllProductReviewWidget extends StatefulWidget {
  final ActiveReview activeReview;
  const AllProductReviewWidget({Key? key, required this.activeReview})
      : super(key: key);

  @override
  State<AllProductReviewWidget> createState() => _AllProductReviewWidgetState();
}

class _AllProductReviewWidgetState extends State<AllProductReviewWidget> {
  Product? reviewProduct;

  bool submittingReview = false;
  int newRating = 0;
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newRating = widget.activeReview.rating!;
    reviewController.text = widget.activeReview.comment!;
    getProduct();
  }

  Future<void> getProduct() async {
    reviewProduct = await Provider.of<ProductProvider>(context, listen: false)
        .getProductDetail(widget.activeReview.productId.toString());

    print(
        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${reviewProduct!.image!.isNotEmpty ? reviewProduct!.image![0] : ''}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Product details
        reviewProduct == null
            ? const Center(
                child:
                    CircularProgressIndicator(color: AppConstants.primaryColor),
              )
            : Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder(context),
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${reviewProduct!.image!.isNotEmpty ? reviewProduct!.image![0] : ''}',
                      height: 70,
                      width: 85,
                      fit: BoxFit.cover,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(reviewProduct!.name!,
                          style: poppinsMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),
                      CustomDirectionality(
                          child: Text(
                              PriceConverter.convertPrice(
                                context,
                                double.parse(reviewProduct!.price!),
                              ),
                              style: poppinsBold)),
                    ],
                  )),
                  Row(children: [
                    Text(
                      '${getTranslated('quantity', context)}: ',
                      style: poppinsMedium.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withOpacity(0.6)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '1',
                      style: poppinsMedium.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeSmall),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ],
              ),
        const Divider(height: 20),

        // Rate
        Text(
          getTranslated('rate_the_product', context)!,
          style: poppinsMedium.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color
                  ?.withOpacity(0.6)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        SizedBox(
          height: 30,
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return InkWell(
                child: Icon(
                  newRating < (i + 1) ? Icons.star_border : Icons.star,
                  size: 25,
                  color: newRating < (i + 1)
                      ? Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color
                          ?.withOpacity(0.6)
                      : Theme.of(context).primaryColor,
                ),
                onTap: () {
                  if (!submittingReview) {
                    setState(() {
                      newRating = i + 1;
                    });
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Text(
          getTranslated('share_your_opinion', context)!,
          style: poppinsMedium.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color
                  ?.withOpacity(0.6)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        CustomTextField(
          maxLines: 3,
          controller: reviewController,
          capitalization: TextCapitalization.sentences,
          isEnabled: !submittingReview,
          hintText: getTranslated('write_your_review_here', context),
          fillColor: Theme.of(context).cardColor,
        ),
        const SizedBox(height: 20),

        // Submit button
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge),
          child: Column(
            children: [
              !submittingReview
                  ? CustomButton(
                      buttonText: getTranslated('submit', context),
                      onPressed: submittingReview
                          ? null
                          : () {
                              if (!submittingReview) {
                                if (newRating == 0) {
                                  showCustomSnackBar(
                                      getTranslated('give_a_rating', context)!);
                                } else if (reviewController.text.isEmpty) {
                                  showCustomSnackBar(getTranslated(
                                      'write_a_review', context)!);
                                } else {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  ReviewBody reviewBody = ReviewBody(
                                    productId: widget.activeReview.productId
                                        .toString(),
                                    rating: newRating.toString(),
                                    comment: reviewController.text,
                                    orderId: null,
                                  );
                                  setState(() {
                                    submittingReview = true;
                                  });
                                  Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .submitProductReview(reviewBody, null)
                                      .then((value) {
                                    if (value.isSuccess) {
                                      ToastService().show(value.message!);
                                    } else {
                                      ToastService().show(value.message!);
                                    }
                                    setState(() {
                                      submittingReview = false;
                                    });
                                  });
                                }
                              }
                            },
                    )
                  : Center(
                      child:
                          CustomLoader(color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      ],
    );
  }
}
