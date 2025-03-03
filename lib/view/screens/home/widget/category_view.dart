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
import 'package:shreeveg/view/screens/new%20category%20product%20screen/new_category_product_list_screen.dart';

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
                      : Container(
                          color: Colors.grey.shade400,
                          // padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleWidget(
                                title: getTranslated(
                                    "Select Your Choice", context),
                                color: Colors.grey.shade400,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteHelper.searchProduct);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(04),
                                  margin: EdgeInsets.all(05),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(08),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Color(0xFF0B4619),
                                        size: 15,
                                      ),
                                      Text(
                                        getTranslated(
                                            'search_anything', context)!,
                                        style: poppinsRegular.copyWith(
                                            color: Color(0xFF0B4619),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  /*child: DropdownButton<int>(
                                                        value: selectedValue,
                                                        dropdownColor: Colors.white,
                                                        iconEnabledColor: Colors.white,
                                                        iconDisabledColor: Colors.white,
                                                        underline: SizedBox(),
                                                        isExpanded: true,
                                                        items: provider.items.map((item) {
                                                          return DropdownMenuItem<int>(
                                                            value: item.warehousesId,
                                                            // child: Text(item.warehousesCity!),
                                                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.location_on_outlined,
                                          color: Color(0xFF0B4619),),),
                                  Text(
                                    item.warehousesCity!,
                                    style: poppinsRegular.copyWith(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (int? newValue) async {
                                                          provider.selectItem(newValue);
                                                          await loadData(true, context);
                                                          // await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
                                                          //      context,
                                                          //      "en",
                                                          //      false,
                                                          //      id: newValue,
                                                          //  );
                                                        },
                                                      ),*/
                                ),
                              ),
                            ],
                          ),
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
                                if(index!=5){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryListScreen(catId: category.categoryList![index].id.toString(), catName: "${category.categoryList![index].name} ${category.categoryList![index].hnName}", whereFrom: false,)));
                                }else{ ResponsiveHelper.isMobilePhone()
                                    ? Provider.of<SplashProvider>(context,
                                    listen: false)
                                    .setPageIndex(1)
                                    : const SizedBox();
                                Provider.of<SplashProvider>(context, listen: false)
                                    .setCurrentPageIndex(1);
                                ResponsiveHelper.isWeb()
                                    ? Navigator.pushNamed(
                                    context, RouteHelper.categories)
                                    : const SizedBox();
                                }
                                /* if (index == 5) {
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
                                      .changeSelectedIndex(0, notify: false);
                                  Navigator.of(context).pushNamed(
                                    RouteHelper.getCategoryProductsRouteNew(
                                        categoryModel:
                                            category.categoryList![index]),
                                  );
                                }*/
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
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFEBEBEC),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: index != 5
                                       && category.categoryList![index]
                                                            .titleGold !=
                                                        null &&
                                                    category
                                                        .categoryList![index]
                                                        .titleGold!
                                                        .isNotEmpty
                                                ? Banner(
                                                    message: category
                                                        .categoryList![index]
                                                        .titleGold!,
                                                    location:
                                                        BannerLocation.topStart,
                                                    color:
                                                        const Color(0xFF0B4619),
                                                    child: index != 5
                                                        ? ClipRRect(
                                                            // borderRadius:
                                                            //     const BorderRadius.only(
                                                            //         topLeft:
                                                            //             Radius.circular(10),
                                                            //         topRight:
                                                            //             Radius.circular(10)),
                                                            child: FadeInImage
                                                                .assetNetwork(
                                                              placeholder: Images
                                                                  .placeholder(
                                                                      context),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.45,
                                                              image:
                                                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}',
                                                              fit: BoxFit
                                                                  .contain,
                                                              imageErrorBuilder: (c,
                                                                      o, s) =>
                                                                  Image.asset(
                                                                      Images.placeholder(
                                                                          context),
                                                                      fit: BoxFit
                                                                          .cover),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                '${category.categoryList!.length - 5}+',
                                                                style: poppinsRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .cardColor)),
                                                          ),
                                                  )
                                                : index != 5
                                                    ? ClipRRect(
                                                        // borderRadius:
                                                        //     const BorderRadius.only(
                                                        //         topLeft:
                                                        //             Radius.circular(10),
                                                        //         topRight:
                                                        //             Radius.circular(10)),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder: Images
                                                              .placeholder(
                                                                  context),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          image:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}',
                                                          fit: BoxFit.contain,
                                                          imageErrorBuilder: (c,
                                                                  o, s) =>
                                                              Image.asset(
                                                                  Images.placeholder(
                                                                      context),
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 100,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            '${category.categoryList!.length - 5}+',
                                                            style: poppinsRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor)),
                                                      ),
                                          ),
                                          index != 5 &&
                                                  category.categoryList![index]
                                                          .titlePlatinum !=
                                                      null &&
                                                  category.categoryList![index]
                                                      .titlePlatinum!.isNotEmpty
                                              ? Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Banner(
                                                      message: category
                                                          .categoryList![index]
                                                          .titlePlatinum!,
                                                      location:
                                                          BannerLocation.topEnd,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
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
                                      /*child: Stack(
                                        children: [
                                          index != 5
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
                                          // Left Ribbon
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Transform.rotate(
                                              angle: -0.785398, // 45 degrees in radians
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                color: Colors.green,
                                                child: Text(
                                                  'Left Ribbon',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Right Ribbon
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Transform.rotate(
                                              angle: 0.785398, // 45 degrees in radians
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                color: Colors.red,
                                                child: Text(
                                                  'Right Ribbon',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                         // Banner(message: "message", location: BannerLocation.topStart),
                                         // Align(
                                         //     alignment: Alignment.topRight,
                                         //     child: Banner(message: "message", location: BannerLocation.topEnd)),
                                        ],
                                      ),*/
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 05),
                                    child: RichText(
                                      text: TextSpan(
                                        text: index != 5
                                            ? category
                                            .categoryList![index].name!
                                            : getTranslated(
                                            'view_all', context)!,
                                        children: [
                                          TextSpan(
                                            text: index != 5
                                                ? " (${category.categoryList![index].hnName ?? ""})"
                                                : "",
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
                                  //       index != 5
                                  //           ? category
                                  //               .categoryList![index].name!
                                  //           : getTranslated(
                                  //               'view_all', context)!,
                                  //       style: poppinsRegular.copyWith(
                                  //           fontSize:
                                  //               Dimensions.fontSizeDefault,
                                  //           fontWeight: FontWeight.w500),
                                  //       textAlign: TextAlign.center,
                                  //       maxLines: 2,
                                  //       overflow: TextOverflow.ellipsis,
                                  //     ),
                                  //     Text(
                                  //       index != 5
                                  //           ? " (${category.categoryList![index].hnName ?? ""})"
                                  //           : "",
                                  //       style: poppinsRegular.copyWith(
                                  //           fontSize: 08,
                                  //           fontWeight: FontWeight.w500),
                                  //       textAlign: TextAlign.center,
                                  //       maxLines: 1,
                                  //       overflow: TextOverflow.ellipsis,
                                  //     ),
                                  //   ],
                                  // ),
                                  index != 5
                                      ? Text(
                                          category.categoryList![index]
                                                  .titleSilver ??
                                              "",
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraSmall,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0XFF600402)),
                                          textAlign: TextAlign.center,
                                        )
                                      : SizedBox(),
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
