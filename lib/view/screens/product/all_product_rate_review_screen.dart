import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/screens/product/widget/all_product_review_widget.dart';
import 'package:shreeveg/view/screens/review/widget/deliver_man_review_widget.dart';
import 'package:shreeveg/view/screens/review/widget/product_review_widget.dart';
import '../../base/footer_view.dart';
import '../../base/web_app_bar/web_app_bar.dart';

class AllProductsRateReviewScreen extends StatefulWidget {
  const AllProductsRateReviewScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsRateReviewScreen> createState() =>
      _AllProductsRateReviewScreenState();
}

class _AllProductsRateReviewScreenState
    extends State<AllProductsRateReviewScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false)
        .getMyAllActiveReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : CustomAppBar(title: getTranslated('rate_review', context)))
          as PreferredSizeWidget?,
      body: Column(children: [
        Expanded(child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: ResponsiveHelper.isDesktop(context)
                              ? MediaQuery.of(context).size.height - 400
                              : MediaQuery.of(context).size.height),
                      child: SizedBox(
                        width: 1170,
                        child: productProvider.allActiveReviews != null
                            ? ListView.builder(
                                itemCount:
                                    productProvider.allActiveReviews?.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    margin: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: const Offset(0, 1))
                                      ],
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeSmall),
                                    ),
                                    child: AllProductReviewWidget(
                                        activeReview: productProvider
                                            .allActiveReviews![index]),
                                  );
                                },
                              )
                            : const SizedBox(),
                      ),
                    ),
                    ResponsiveHelper.isDesktop(context)
                        ? const FooterView()
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          },
        )),
      ]),
    );
  }
}
