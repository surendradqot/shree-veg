import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/category_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/provider/localization_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/main_app_bar.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:shreeveg/view/screens/new%20category%20product%20screen/new_category_product_list_screen.dart';

// ignore: must_be_immutable
class Allcategoriescreen extends StatefulWidget {
  const Allcategoriescreen({Key? key}) : super(key: key);

  @override
  State<Allcategoriescreen> createState() => _AllcategoriescreenState();
}

class _AllcategoriescreenState extends State<Allcategoriescreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(
      context,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
      true,
    )
        .then((apiResponse) {
      if (apiResponse.response!.statusCode == 200 &&
          apiResponse.response!.data != null) {
        _load();
      }
    });
  }

  _load() async {
    final localizationProvider =
        Provider.of<LocalizationProvider>(context, listen: false);
    Provider.of<CategoryProvider>(context, listen: false).categoryList!.clear();
    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
        context, localizationProvider.locale.languageCode, false,
        id: Provider.of<ProfileProvider>(Get.context!, listen: false)
            .sharedPreferences!
            .getInt(AppConstants.selectedCityId));
    // final categoryProvider =
    //     Provider.of<CategoryProvider>(context, listen: false);
    // categoryProvider.changeIndex(0, notify: false);
    // if (categoryProvider.categoryList!.isNotEmpty) {
    //   categoryProvider.getSubCategoryList(
    //     context,
    //     categoryProvider.categoryList![0].id.toString(),
    //     Provider.of<LocalizationProvider>(context, listen: false)
    //         .locale
    //         .languageCode,
    //   );
    // }
  }

  late AnimationController controller;

  void shake() {
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const MainAppBar()
          : AppBar(
              title: Text(getTranslated('category', context)!,
                  style: poppinsMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge, color: Colors.white)),
              actions: [
                AnimatedBuilder(
                  animation: offsetAnimation,
                  builder: (buildContext, child) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: offsetAnimation.value + 15.0,
                          right: 15.0 - offsetAnimation.value),
                      child: IconButton(
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(Images.cartIcon,
                                width: 23, height: 25, color: Colors.white),
                            Positioned(
                              top: -7,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(05),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Text(
                                  '${Provider.of<CartProvider>(context).cartLength}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Provider.of<SplashProvider>(context, listen: false)
                              .setCurrentPageIndex(2);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(08),
        child: Consumer<CategoryProvider>(builder: (context, category, child) {
          return category.loading!?GridView.builder(
            itemCount: category.categoryList!.length,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (1),
              crossAxisCount: ResponsiveHelper.isMobilePhone()
                  ? 2
                  : ResponsiveHelper.isTab(context)
                      ? 4
                      : 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryListScreen(catId: category.categoryList![index].id.toString(), catName: "${category.categoryList![index].name} ${category.categoryList![index].hnName}", whereFrom: false,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? 0.05
                            : 1),
                    boxShadow: Provider.of<ThemeProvider>(context).darkTheme
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.grey[200]!,
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                  ),
                  child: Column(children: [
                    Expanded(
                      flex: ResponsiveHelper.isDesktop(context) ? 7 : 5,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFEBEBEC),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: category.categoryList![index].titleGold !=
                                          null &&
                                      category.categoryList![index].titleGold!
                                          .isNotEmpty
                                  ? Banner(
                                      message: category
                                          .categoryList![index].titleGold!,
                                      location: BannerLocation.topStart,
                                      color: const Color(0xFF0B4619),
                                      child: ClipRRect(
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              Images.placeholder(context),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}',
                                          fit: BoxFit.contain,
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholder(context),
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            Images.placeholder(context),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}',
                                        fit: BoxFit.contain,
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(
                                                Images.placeholder(context),
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                            ),
                            category.categoryList![index].titlePlatinum !=
                                        null &&
                                    category.categoryList![index].titlePlatinum!
                                        .isNotEmpty
                                ? Positioned(
                                    top: 0,
                                    right: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Banner(
                                        message: category.categoryList![index]
                                            .titlePlatinum!,
                                        location: BannerLocation.topEnd,
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          height: 180,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 05),
                      child: RichText(
                        text: TextSpan(
                          text: category.categoryList![index].name!,
                          children: [
                            TextSpan(
                              text: " (${category.categoryList![index].hnName ?? ""})",
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                  fontSize: 08, fontWeight: FontWeight.w500),
                            ),
                          ],
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          // textAlign: TextAlign.center,
                          // maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       category.categoryList![index].name!,
                    //       style: poppinsRegular.copyWith(
                    //           fontSize: Dimensions.fontSizeDefault,
                    //           fontWeight: FontWeight.w500),
                    //       textAlign: TextAlign.center,
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //     Text(
                    //       " (${category.categoryList![index].hnName ?? ""})",
                    //       style: poppinsRegular.copyWith(
                    //           fontSize: 08, fontWeight: FontWeight.w500),
                    //       textAlign: TextAlign.center,
                    //       maxLines: 1,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ],
                    // ),
                    Text(
                      category.categoryList![index].titleSilver ?? "",
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF600402)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall)
                  ]),
                ),
              );
            },
          ):Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }),
      ),
    );
  }
}
