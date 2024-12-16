import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/screens/product/widget/product_image_view.dart';
import 'package:shreeveg/view/screens/product/widget/product_title_only_view.dart';
import 'package:shreeveg/view/screens/product/widget/rating_bar.dart';
import '../../../data/model/body/review_body.dart';
import '../../../data/model/response/product_model.dart';
import '../../../helper/toast_service.dart';
import '../../../utill/dimensions.dart';

class AddProductReview extends StatefulWidget {
  final Product product;
  final ActiveReview? myReview;
  const AddProductReview({Key? key, required this.product, this.myReview})
      : super(key: key);

  @override
  State<AddProductReview> createState() => _AddProductReviewState();
}

class _AddProductReviewState extends State<AddProductReview> {
  int myRating = 0;
  final reviewController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.myReview != null) {
      myRating = widget.myReview!.rating!;
      reviewController.text = widget.myReview?.comment ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Review'),
      body: SingleChildScrollView(child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault),
              ProductImageView(productModel: widget.product),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
                child: ProductTitleOnlyView(product: widget.product),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: RatingLine(
                    productProvider: productProvider,
                  )),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(myRating == 0
                  ? ''
                  : myRating == 5
                      ? 'Excellent'
                      : myRating == 4
                          ? 'Good'
                          : myRating == 3
                              ? 'Average'
                              : myRating == 2
                                  ? 'Below Average'
                                  : 'Poor'),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Icon(
                        myRating < (i + 1) ? Icons.star_border : Icons.star,
                        size: 25,
                        color: myRating < (i + 1)
                            ? Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color
                                ?.withOpacity(0.6)
                            : Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        setState(() {
                          myRating = i + 1;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
                child: SizedBox(
                  height: 150,
                  child: Card(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Write a review'),
                                Card(
                                    color: Color(0xFFE2E2E2),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Upload Image'),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: reviewController,
                            maxLines: 100,
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Review Description',
                              fillColor: Color(0xFFF3F3F3),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
                child: productProvider.isLoading
                    ? const CircularProgressIndicator(
                        color: AppConstants.primaryColor,
                      )
                    : CustomButton(
                        buttonText: 'Submit',
                        onPressed: () {
                          if (myRating <= 0) {
                            ToastService().show('Please select star rating');
                            return;
                          }
                          if (reviewController.text == '') {
                            ToastService()
                                .show('Please add review description');
                            return;
                          }

                          ReviewBody reviewBody = ReviewBody(
                            productId: widget.product.productId.toString(),
                            rating: myRating.toString(),
                            comment: reviewController.text,
                            // fileUpload:
                          );

                          Provider.of<ProductProvider>(context, listen: false)
                              .submitProductReview(reviewBody, null)
                              .then((value) {
                            if (value.isSuccess) {
                              ToastService().show(value.message!);
                              Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .getProductReviews(
                                      context, '${widget.product.productId}');
                            } else {
                              ToastService().show(value.message!);
                            }
                          });
                        }),
              )
            ],
          );
        },
      )),
    );
  }
}
