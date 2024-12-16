import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/provider/group_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/title_widget.dart';
import 'package:shreeveg/view/screens/home/web/web_categories.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return category.categoryList != null
            ? Column(
                children: [
                  ResponsiveHelper.isDesktop(context)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeDefault),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(getTranslated('category', context)!,
                                style: poppinsBold.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                        ?.withOpacity(0.6))),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                          child: TitleWidget(
                              title: getTranslated('category', context)),
                        ),
                  ResponsiveHelper.isDesktop(context)
                      ? const CategoriesWebView()
                      : GridView.builder(
                          itemCount: category.categoryList!.length > 5
                              ? 6
                              : category.categoryList!.length,
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                if (index == 5) {
                                  ResponsiveHelper.isMobilePhone()
                                      ? Provider.of<SplashProvider>(context,
                                              listen: false)
                                          .setPageIndex(1)
                                      : const SizedBox();
                                  ResponsiveHelper.isWeb()
                                      ? Navigator.pushNamed(
                                          context, RouteHelper.categories)
                                      : const SizedBox();
                                } else {
                                  Provider.of<GroupProvider>(context,
                                      listen: false)
                                      .setCurrentIndex(-1);
                                  Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .changeSelectedIndex(-1, notify: false);
                                  Navigator.of(context).pushNamed(
                                    RouteHelper.getCategoryProductsRouteNew(
                                        categoryModel:
                                            category.categoryList![index]),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(
                                      Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? 0.05
                                          : 1),
                                  boxShadow: Provider.of<ThemeProvider>(context)
                                          .darkTheme
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
                                    flex: ResponsiveHelper.isDesktop(context)
                                        ? 7
                                        : 5,
                                    child: Container(
                                      // height: 180,
                                      // margin: const EdgeInsets.all(
                                      //     Dimensions.paddingSizeExtraSmall),
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal:
                                      //         Dimensions.paddingSizeDefault),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFEBEBEC),
                                      ),
                                      child: index != 5
                                          ? ClipRRect(
                                              // borderRadius:
                                              //     const BorderRadius.only(
                                              //         topLeft:
                                              //             Radius.circular(10),
                                              //         topRight:
                                              //             Radius.circular(10)),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    Images.placeholder(context),
                                                image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}',
                                                fit: BoxFit.fill,
                                                imageErrorBuilder: (c, o, s) =>
                                                    Image.asset(
                                                        Images.placeholder(
                                                            context),
                                                        fit: BoxFit.cover),
                                              ),
                                            )
                                          : Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                  '${category.categoryList!.length - 5}+',
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeExtraSmall),
                                    child: Text(
                                      index != 5
                                          ? category.categoryList![index].name.toCapitalized()
                                          : getTranslated('view_all', context)!,
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeExtraSmall)
                                ]),
                              ),
                            );
                          },
                        ),
                ],
              )
            : const CategoriesShimmer();
      },
    );
  }
}

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      //physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio:
            ResponsiveHelper.isDesktop(context) ? (1 / 1.1) : (1 / 1.2),
        crossAxisCount: ResponsiveHelper.isWeb()
            ? 6
            : ResponsiveHelper.isMobilePhone()
                ? 3
                : ResponsiveHelper.isTab(context)
                    ? 4
                    : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(
                Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
            boxShadow: Provider.of<ThemeProvider>(context).darkTheme
                ? null
                : [
                    BoxShadow(
                        color: Colors.grey[200]!,
                        spreadRadius: 1,
                        blurRadius: 5)
                  ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled:
                Provider.of<CategoryProvider>(context).categoryList == null,
            child: Column(children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall,
                      vertical: Dimensions.paddingSizeLarge),
                  child:
                      Container(color: Colors.grey[300], width: 50, height: 10),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
