import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/flash_deal_provider.dart';
import 'package:shreeveg/provider/localization_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/product_widget.dart';
import 'package:shreeveg/view/base/title_row.dart';
import 'package:shreeveg/view/base/title_widget.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';

class HomeItemScreen extends StatefulWidget {
  final String? productType;

  const HomeItemScreen({Key? key, this.productType}) : super(key: key);

  @override
  State<HomeItemScreen> createState() => _HomeItemScreenState();
}

class _HomeItemScreenState extends State<HomeItemScreen> {
  late int pageSize;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    if (widget.productType != ProductType.flashSale) {
      Provider.of<ProductProvider>(context, listen: false).popularOffset = 1;
      Provider.of<ProductProvider>(context, listen: false).getItemList(
        '1',
        false,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .languageCode,
        widget.productType,
      );

      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      scrollController.addListener(() {
        if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels &&
            (productProvider.popularProductList != null ||
                productProvider.dailyItemList != null) &&
            !productProvider.isLoading) {
          pageSize = (productProvider.popularPageSize! / 10).ceil();
          if (productProvider.popularOffset < pageSize) {
            productProvider.popularOffset++;
            productProvider.showBottomLoader();

            productProvider.getItemList(
              productProvider.popularOffset.toString(),
              false,
              Provider.of<LocalizationProvider>(context, listen: false)
                  .locale
                  .languageCode,
              widget.productType,
            );
          }
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: getTranslated(widget.productType, context),
            )) as PreferredSizeWidget?,
      body: SingleChildScrollView(
          controller: scrollController,
          child: Center(
              child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height - 400
                        : MediaQuery.of(context).size.height),
                child: Column(children: [
                  ResponsiveHelper.isDesktop(context)
                      ? const SizedBox(height: 20)
                      : const SizedBox.shrink(),
                  if (ResponsiveHelper.isDesktop(context) &&
                      widget.productType != ProductType.flashSale)
                    SizedBox(
                        width: 1170,
                        child: TitleWidget(
                          title:
                              getTranslated('${widget.productType}', context),
                        )),
                  SizedBox(
                      width: Dimensions.webScreenWidth,
                      child: Column(children: [
                        Consumer<FlashDealProvider>(
                            builder: (context, flashDealProvider, _) {
                          return flashDealProvider.flashDeal!=null && flashDealProvider.specialFlashDealList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSizeDefault),
                                    child: FadeInImage.assetNetwork(
                                      width: double.maxFinite,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      placeholder: Images.placeholder(context),
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.flashSaleImageUrl}'
                                          '/${flashDealProvider.flashDeal!.banner ?? ''}',
                                      fit: BoxFit.fitWidth,
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                              Images.placeholder(context),
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        }),
                        if (widget.productType == ProductType.flashSale)
                          Consumer<FlashDealProvider>(
                              builder: (context, flashDealProvider, _) {
                            return Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              child: TitleRow(
                                isDetailsPage: true,
                                title: getTranslated('flash_deal', context),
                                eventDuration: flashDealProvider.duration,
                              ),
                            );
                          }),
                      ])),
                  SizedBox(
                      width: 1170,
                      child: Consumer<FlashDealProvider>(
                          builder: (context, flashDealProvider, child) {
                        return Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                            List<Product>? productList;

                            switch (widget.productType) {
                              case ProductType.popularProduct:
                                productList =
                                    productProvider.popularProductList;
                                break;
                              case ProductType.dailyItem:
                                productList = productProvider.dailyItemList;
                                break;
                              case ProductType.featuredItem:
                                productList =
                                    productProvider.featuredProductList;
                                break;
                              case ProductType.mostReviewed:
                                productList =
                                    productProvider.mostViewedProductList;
                                break;
                              case ProductType.trendingProduct:
                                productList = productProvider.trendingProduct;
                                break;
                              case ProductType.recommendProduct:
                                productList = productProvider.recommendProduct;
                                break;
                              case ProductType.flashSale:
                                productList =
                                    flashDealProvider.specialFlashDealList;
                                break;
                            }

                            return productList != null
                                ? productList.isNotEmpty
                                    ? Column(
                                        children: [
                                          GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? 5
                                                  : ResponsiveHelper.isMobile()
                                                      ? 2
                                                      : 4,
                                              mainAxisSpacing:
                                                  ResponsiveHelper.isDesktop(
                                                          context)
                                                      ? 13
                                                      : 10,
                                              crossAxisSpacing:
                                                  ResponsiveHelper.isDesktop(
                                                          context)
                                                      ? 13
                                                      : 10,
                                              childAspectRatio: (1 / 1.4),
                                            ),
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeSmall),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: productList.length,
                                            itemBuilder: (context, index) {
                                              return ProductWidget(
                                                  product: productList![index],
                                                  isGrid: true);
                                            },
                                          ),
                                          if (productProvider.isLoading)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Theme.of(context)
                                                            .primaryColor),
                                              )),
                                            )
                                        ],
                                      )
                                    : const NoDataScreen()
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: Center(
                                        child: CustomLoader(
                                            color: Theme.of(context)
                                                .primaryColor)));
                          },
                        );
                      })),
                ]),
              ),
              ResponsiveHelper.isDesktop(context)
                  ? const FooterView()
                  : const SizedBox(),
            ],
          ))),
    );
  }
}
