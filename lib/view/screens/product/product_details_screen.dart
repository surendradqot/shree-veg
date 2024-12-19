import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/cart_model.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/data/model/response/review_model.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/custom_zoom_widget.dart';
import 'package:shreeveg/view/base/rating_bar.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/product/widget/details_app_bar.dart';
import 'package:shreeveg/view/screens/product/widget/product_image_view.dart';
import 'package:shreeveg/view/screens/product/widget/product_title_view.dart';
import 'package:shreeveg/view/screens/product/widget/variation_view.dart';
import 'package:shreeveg/view/screens/product/widget/web_product_information.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import '../../../helper/route_helper.dart';
import '../../../provider/profile_provider.dart';
import 'widget/product_review.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool? fromSearch;
  const ProductDetailsScreen(
      {Key? key, required this.product, this.fromSearch = false, String? from})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    Provider.of<ProductProvider>(context, listen: false)
        .getProductReviews(context, '${widget.product.productId}');

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    Provider.of<CartProvider>(context, listen: false).setSelect(0, false);

    print(
        'selected variiiiiiiiiiiiiiiiiiii: ${widget.product.selectedVariation}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Variations? variation;

    if (widget.product.selectedVariation == null) {
      widget.product.updateSelectedVariation(0);
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : DetailsAppBar(key: UniqueKey(), product: widget.product),
      body: Consumer<CartProvider>(builder: (context, cart, child) {
        return Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
          double? price = 0;
          int? stock = 0;
          double? priceWithQuantity = 0;
          CartModel? cartModel;

          price = double.parse(widget.product
              .variations![widget.product.selectedVariation ?? 0].price!);
          stock = widget.product.totalStock;

          if (widget.product.variations != null) {
            for (int index = 0;
                index < widget.product.variations!.length;
                index++) {
              Variations variationData = widget.product.variations![index];
              if (index == widget.product.selectedVariation) {
                price = double.parse(variationData.price!);
                variation = variationData;
                break;
              }
            }
          }

          double? priceWithDiscount = 0;
          double? categoryDiscountAmount;

          if (widget.product.categoryDiscount != null) {
            categoryDiscountAmount = PriceConverter.convertWithDiscount(
              price,
              widget.product.categoryDiscount!.discountAmount,
              widget.product.categoryDiscount!.discountType,
              maxDiscount: widget.product.categoryDiscount!.maximumAmount,
            );
          }
          priceWithDiscount = PriceConverter.convertWithDiscount(
              price,
              double.parse(widget.product.discount!),
              widget.product.discountType);

          if (categoryDiscountAmount != null &&
              categoryDiscountAmount > 0 &&
              categoryDiscountAmount < priceWithDiscount!) {
            priceWithDiscount = categoryDiscountAmount;
          }

          cartModel = CartModel(
              widget.product.id,
              widget.product.image!.isNotEmpty ? widget.product.image![0] : '',
              widget.product.name,
              price,
              priceWithDiscount,
              productProvider.quantity,
              variation,
              (price! - priceWithDiscount!),
              (price -
                  PriceConverter.convertWithDiscount(
                      price, widget.product.tax, widget.product.taxType)!),
              double.parse(widget
                  .product
                  .variations![widget.product.selectedVariation ?? 0]
                  .quantity!),
              widget.product.unit,
              stock,
              widget.product);

          productProvider.setExistData(
              Provider.of<CartProvider>(context).isExistInCart(cartModel));

          try {
            priceWithQuantity = priceWithDiscount *
                (productProvider.cartIndex != null
                    ? cart.cartList[productProvider.cartIndex!].quantity!
                    : productProvider.quantity);
          } catch (e) {
            priceWithQuantity = priceWithDiscount;
          }

          return widget.product != null
              ? !ResponsiveHelper.isDesktop(context)
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: ResponsiveHelper.isMobilePhone()
                                ? const BouncingScrollPhysics()
                                : null,
                            child: Center(
                              child: SizedBox(
                                width: Dimensions.webScreenWidth,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        ProductImageView(
                                            productModel: widget.product),

                                        ProductTitleView(
                                            product: widget.product,
                                            stock: stock,
                                            cartIndex:
                                                productProvider.cartIndex),

                                        VariationView(product: widget.product),

                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeSmall),
                                          color: const Color(0xFFFFFFFF),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Container(
                                              color: const Color(0xFFFFE1CE),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${getTranslated('total_amount', context)}:',
                                                          style: poppinsMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge)),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      CustomDirectionality(
                                                          child: Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                priceWithQuantity),
                                                        style: poppinsBold
                                                            .copyWith(
                                                          color: Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                        ),
                                                      )),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Description
                                      ],
                                    ),
                                    _description(context, widget.product,
                                        productProvider),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 1170,
                            child: CustomButton(
                              margin: Dimensions.paddingSizeSmall,
                              buttonText: getTranslated(
                                  productProvider.cartIndex != null
                                      ? 'already_added'
                                      : stock! <= 0
                                          ? 'out_of_stock'
                                          : 'add_to_card',
                                  context),
                              onPressed: (productProvider.cartIndex == null &&
                                      stock! > 0)
                                  ? () {
                                      if (productProvider.cartIndex == null &&
                                          stock! > 0) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .addToCart(cartModel!);
                                        //   _key.currentState.shake();

                                        showCustomSnackBar(
                                            getTranslated(
                                                'added_to_cart', context)!,
                                            isError: false);
                                      } else {
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('already_added', context)), backgroundColor: Colors.red,));
                                        showCustomSnackBar(getTranslated(
                                            'already_added', context)!);
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: ResponsiveHelper.isDesktop(context)
                                    ? MediaQuery.of(context).size.height - 400
                                    : MediaQuery.of(context).size.height),
                            child: Column(children: [
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Center(
                                child: SizedBox(
                                  width: 1170,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                height: 350,
                                                child: Consumer<CartProvider>(
                                                    builder: (context,
                                                        cartProvider, child) {
                                                  return CustomZoomWidget(
                                                    image: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          Images.placeholder(
                                                              context),
                                                      fit: BoxFit.cover,
                                                      image:
                                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productProvider.product!.image!.isNotEmpty ? productProvider.product!.image![cartProvider.productSelect] : ''}',
                                                      imageErrorBuilder: (c, o,
                                                              s) =>
                                                          Image.asset(
                                                              Images
                                                                  .placeholder(
                                                                      context),
                                                              fit:
                                                                  BoxFit.cover),
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                              SizedBox(
                                                height: 100,
                                                child:
                                                    widget.product.image != null
                                                        ? ListView.builder(
                                                            itemCount: widget
                                                                .product
                                                                .image!
                                                                .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    right: Dimensions
                                                                        .paddingSizeSmall),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Provider.of<CartProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .setSelect(
                                                                            index,
                                                                            true);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.all(
                                                                        Provider.of<CartProvider>(context, listen: false).productSelect ==
                                                                                index
                                                                            ? 3
                                                                            : 0),
                                                                    width: 100,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Provider.of<CartProvider>(context, listen: false).productSelect == index
                                                                                ? Theme.of(context).primaryColor
                                                                                : ColorResources.getGreyColor(context),
                                                                            width: 1)),
                                                                    child: FadeInImage
                                                                        .assetNetwork(
                                                                      placeholder:
                                                                          Images.placeholder(
                                                                              context),
                                                                      image:
                                                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productProvider.product!.image![index]}',
                                                                      width:
                                                                          100,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      imageErrorBuilder: (c, o, s) => Image.asset(
                                                                          Images.placeholder(
                                                                              context),
                                                                          width:
                                                                              100,
                                                                          fit: BoxFit
                                                                              .cover),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            })
                                                        : const SizedBox(),
                                              )
                                            ],
                                          )),
                                      const SizedBox(width: 30),
                                      Expanded(
                                          flex: 6,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                widget.product != null
                                                    ? WebProductInformation(
                                                        product: widget.product,
                                                        stock: stock,
                                                        cartIndex:
                                                            productProvider
                                                                .cartIndex,
                                                        priceWithQuantity:
                                                            priceWithQuantity)
                                                    : CustomLoader(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraLarge),
                                                Builder(
                                                  builder: (context) => Center(
                                                    child: SizedBox(
                                                      width: 1170,
                                                      child: CustomButton(
                                                        buttonText: getTranslated(
                                                            productProvider.cartIndex != null
                                                                ? 'already_added'
                                                                : stock! <= 0
                                                                    ? 'out_of_stock'
                                                                    : 'add_to_card',
                                                            context),
                                                        onPressed: (productProvider
                                                                        .cartIndex ==
                                                                    null &&
                                                                stock! > 0)
                                                            ? () {
                                                                if (productProvider
                                                                            .cartIndex ==
                                                                        null &&
                                                                    stock! >
                                                                        0) {
                                                                  Provider.of<CartProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .addToCart(
                                                                          cartModel!);

                                                                  showCustomSnackBar(
                                                                      getTranslated(
                                                                          'added_to_cart',
                                                                          context)!,
                                                                      isError:
                                                                          false);
                                                                } else {
                                                                  showCustomSnackBar(
                                                                      getTranslated(
                                                                          'already_added',
                                                                          context)!);
                                                                }
                                                              }
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              //Description
                              Center(
                                  child: SizedBox(
                                      width: Dimensions.webScreenWidth,
                                      child: _description(context,
                                          widget.product, productProvider))),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                            ]),
                          ),
                          const FooterView(),
                        ],
                      ),
                    )
              : Center(
                  child: CustomLoader(color: Theme.of(context).primaryColor));
        });
      }),
    );
  }

  Widget _description(
      BuildContext context, Product product, ProductProvider productProvider) {
    return Column(
      children: [
        Center(
            child: Container(
          width: Dimensions.webScreenWidth,
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
            unselectedLabelStyle: poppinsRegular.copyWith(
              color: Theme.of(context).disabledColor,
              fontSize: Dimensions.fontSizeSmall,
            ),
            labelStyle: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).primaryColor,
            ),
            tabs: [
              Tab(text: getTranslated('description', context)),
              Tab(text: getTranslated('review', context)),
            ],
          ),
        )),
        _tabIndex == 0
            ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                width: Dimensions.webScreenWidth,
                child: Column(
                  children: [
                    HtmlWidget(
                      product.description ?? '',
                      textStyle: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    HtmlWidget(
                      product.hindiDescription ?? '',
                      textStyle: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                  ],
                ),
              )
            : Column(children: [
                SizedBox(
                  width: 700,
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                        return Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        int? userId =
                                            Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .userInfoModel!
                                                .userInfo!.id;

                                        ActiveReview? myReview;

                                        if (userId != null &&
                                            productProvider.activeReviews !=
                                                null &&
                                            productProvider
                                                .activeReviews!.isNotEmpty) {
                                          try {
                                            myReview = productProvider
                                                .activeReviews!
                                                .firstWhere((review) =>
                                                    review.userId == userId);
                                            print('mmmmmmmm: $myReview');
                                          } catch (e) {
                                            // Handle the case where no matching review is found
                                            print(
                                                'No review found for user with ID: $userId');
                                          }
                                        }

                                        Navigator.of(context).pushNamed(
                                          RouteHelper
                                              .getProductSubmitReviewRoute(
                                                  product: widget.product,
                                                  myReview: myReview),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text('Ratings and Reviews',
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${product.rating!.isNotEmpty ? double.parse(product.rating!.first.average!).toStringAsFixed(1) : 0.0}',
                                        style: poppinsRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeOverLarge,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                RatingBar(
                                  rating: product.rating!.isNotEmpty
                                      ? double.parse(
                                              product.rating![0].average!) -
                                          1
                                      : 4.0,
                                  size: 20,
                                  color: Colors.deepOrange,
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  '${productProvider.activeReviews != null ? productProvider.activeReviews!.length : 0} ${getTranslated('review', context)}',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Colors.deepOrange),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeSmall,
                    ),
                  ]),
                ),
                Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return productProvider.activeReviews != null
                        ? ListView.builder(
                            itemCount: productProvider.activeReviews != null
                                ? productProvider.activeReviews!.length
                                : 1,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeDefault,
                                horizontal: Dimensions.paddingSizeDefault),
                            itemBuilder: (context, index) {
                              return productProvider.activeReviews != null
                                  ? ReviewWidget(
                                      reviewModel:
                                          productProvider.activeReviews![index])
                                  : const ReviewShimmer();
                            },
                          )
                        : const SizedBox();
                  },
                )
              ]),
      ],
    );
  }
}
