import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/provider/banner_provider.dart';
import 'package:shreeveg/provider/flash_deal_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/view/screens/new%20category%20product%20screen/new_category_product_list_screen.dart';
import 'package:shreeveg/view/screens/product/image_zoom_screen.dart';
import 'package:provider/provider.dart';


class BannersView extends StatelessWidget {
  final String bannerType;
  final int? categoryId;

  const BannersView({Key? key, required this.bannerType, this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> myBanners = [];

    return Consumer<FlashDealProvider>(
      builder: (context, flash, child) {
        return Consumer<BannerProvider>(
          builder: (context, banner, child) {
            if (bannerType == 'home_page') {
              myBanners = banner.bannerList
                  .where((baner) => baner.itemType == bannerType)
                  .toList();
            }
            if (bannerType == 'flash') {
              myBanners = flash.flashResponseList;
            }
            if (bannerType == 'category') {
              myBanners = banner.bannerList
                  .where((baner) =>
                      baner.itemType == bannerType &&
                      baner.categoryId == categoryId)
                  .toList();
            }

            double width = MediaQuery.of(context).size.width;

            return Container(
              // width: MediaQuery.of(context).size.width,
              // height: ResponsiveHelper.isDesktop(context) ? 400 : myBanners.isNotEmpty?150:00,
              // padding: myBanners.isNotEmpty?const EdgeInsets.only(top: Dimensions.paddingSizeSmall):EdgeInsets.zero,
              child: myBanners.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          width: width,
                          height:
                              ResponsiveHelper.isDesktop(context) ? 400 : 125,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: myBanners.length > 1,
                              enlargeCenterPage: true,
                              viewportFraction: 1,
                              disableCenter: true,
                              autoPlayAnimationDuration: Duration(seconds: 1),
                              autoPlayInterval: Duration(seconds: 5),
                              onPageChanged: (index, reason) {
                                if (bannerType != 'flash') {
                                  Provider.of<BannerProvider>(context,
                                          listen: false)
                                      .setCurrentIndex(index);
                                }
                              },
                            ),
                            itemCount: myBanners.isEmpty ? 1 : myBanners.length,
                            itemBuilder: (context, index, _) {
                              var bannerTitle =
                                  bannerType == 'flash' ? 'Special Offer' : '';
                              return InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  if (bannerType == 'home_page') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductImageScreen(
                                                    title: "Banner",
                                                    imageList: [
                                                      '${bannerType == 'flash' ? Provider.of<SplashProvider>(context, listen: false).baseUrls!.flashSaleImageUrl : Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}'
                                                          '/${myBanners[index].banner}'
                                                    ])));
                                  } else if (bannerType == "flash") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryListScreen(catId: myBanners[index].categoryId.toString(), catName: "${myBanners[index].categoryName} ${myBanners[index].categoryHnName}", whereFrom: true,)));
                                  }
                                  // if (bannerType == 'flash') {
                                  //   var pageTitle =
                                  //       myBanners[index].dealType == 'one_rupee'
                                  //           ? ProductType.flashSale
                                  //           : ProductType.dailyItem;
                                  //   print(
                                  //       '${bannerType == 'flash' ? Provider.of<SplashProvider>(context, listen: false).baseUrls!.flashSaleImageUrl : Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}'
                                  //       '/${myBanners[index].banner}');
                                  //   Navigator.pushNamed(
                                  //     context,
                                  //     RouteHelper.getHomeItemRoute(
                                  //       productType: NewFlashDealModal(
                                  //           productImage:
                                  //               '${bannerType == 'flash' ? Provider.of<SplashProvider>(context, listen: false).baseUrls!.flashSaleImageUrl : Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}'
                                  //               '/${myBanners[index].banner}',
                                  //           productType: pageTitle),
                                  //     ),
                                  //   );
                                  // }
                                  // if (bannerType != 'flash') {
                                  //   if (myBanners[index].productId != null) {
                                  //     Product? product;
                                  //     for (Product prod in banner.productList) {
                                  //       if (prod.id ==
                                  //           banner
                                  //               .bannerList[index].productId) {
                                  //         product = prod;
                                  //         break;
                                  //       }
                                  //     }
                                  //     if (product != null) {
                                  //       Navigator.pushNamed(
                                  //         context,
                                  //         RouteHelper.getProductDetailsRoute(
                                  //             product: product),
                                  //         arguments: ProductDetailsScreen(
                                  //             product: product,
                                  //             from: 'banners'),
                                  //       );
                                  //     }
                                  //   } else if (myBanners[index].categoryId !=
                                  //       null) {
                                  //     CategoryModel? category;
                                  //     for (CategoryModel categoryModel
                                  //         in Provider.of<CategoryProvider>(
                                  //                 context,
                                  //                 listen: false)
                                  //             .categoryList!) {
                                  //       if (categoryModel.id ==
                                  //           myBanners[index].categoryId) {
                                  //         category = categoryModel;
                                  //         break;
                                  //       }
                                  //     }
                                  //     if (category != null) {
                                  //       Navigator.of(context).pushNamed(
                                  //         RouteHelper
                                  //             .getCategoryProductsRouteNew(
                                  //                 categoryModel: category),
                                  //       );
                                  //     }
                                  //   } else {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => ProductImageScreen(
                                  //             title: "Banner",
                                  //             imageList: [
                                  //               '${bannerType == 'flash' ? Provider.of<SplashProvider>(context, listen: false).baseUrls!.flashSaleImageUrl : Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}'
                                  //                   '/${myBanners[index].banner}'
                                  //             ])));
                                  //     // showImageDialog(
                                  //     //     Get.context!,
                                  //     //     '${bannerType == 'flash' ? Provider.of<SplashProvider>(context, listen: false).baseUrls!.flashSaleImageUrl : Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}'
                                  //     //     '/${myBanners[index].banner}');
                                  //   }
                                  // }
                                },
                                child: Container(
                                  width: width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder(context),
                                      image:
                                          '${bannerType == 'flash' ? Provider.of<SplashProvider>(context, listen: false).baseUrls!.flashSaleImageUrl : Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}'
                                          '/${myBanners[index].banner}',
                                      fit: BoxFit.fill,
                                      width: width,
                                      height: 125,
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                              Images.placeholder(context),
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        myBanners.length > 1
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: myBanners.map((bnr) {
                                  int index = myBanners.indexOf(bnr);
                                  return TabPageSelectorIndicator(
                                    backgroundColor:
                                        index == banner.currentIndex
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).cardColor,
                                    borderColor: index == banner.currentIndex
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).primaryColor,
                                    size: 6,
                                  );
                                }).toList(),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : SizedBox(),
              // : Shimmer(
              //     duration: const Duration(seconds: 2),
              //     enabled: myBanners.isEmpty,
              //     child: Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 10),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Colors.grey[300],
              //         )),
              //   ),
            );
          },
        );
      },
    );
  }

  void showImageDialog(BuildContext context, String? image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(
            image!,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
