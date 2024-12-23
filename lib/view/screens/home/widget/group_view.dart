import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/category_model.dart';
import 'package:shreeveg/data/model/response/product_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/banner_provider.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/provider/group_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../provider/localization_provider.dart';
import '../../../../provider/product_provider.dart';
import '../../../../utill/styles.dart';

class GroupsView extends StatelessWidget {
  final CategoryModel categoryModel;
  const GroupsView({Key? key, required this.categoryModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Consumer<GroupProvider>(
          builder: (context, group, child) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: ResponsiveHelper.isDesktop(context) ? 400 : 125,
              child: group.groupsList != null
                  ? group.groupsList!.isNotEmpty
                      ? Row(
                          children: [
                            InkWell(
                              onTap: () {
                                print('all fruits');
                                categoryProvider.changeSelectedIndex(-1);
                                group.setCurrentIndex(-1);
                                Provider.of<ProductProvider>(context,
                                        listen: false)
                                    .filterGroupCategoryProductList('-1');
                                // Provider.of<ProductProvider>(context,
                                //         listen: false)
                                //     .initCategoryProductList(
                                //   categoryModel.id.toString(),
                                //   context,
                                //   Provider.of<LocalizationProvider>(context,
                                //           listen: false)
                                //       .locale
                                //       .languageCode,
                                // );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: group.currentIndex == -1
                                                  ? Theme.of(context)
                                                      .primaryColorDark
                                                  : Colors.transparent,
                                              width: 2),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(35),),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(35),
                                        child: Image.asset(
                                            categoryModel.name == 'Fruits'
                                                ? Images.allFruits
                                                : Images.allVegetables,
                                            fit: BoxFit.cover,),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: 64,
                                      child: Text(
                                        categoryModel.name == 'Fruits'
                                            ? 'All Fruits'
                                            : 'All Vegetables',
                                        style: poppinsRegular.copyWith(
                                            color: group.currentIndex == -1
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: group.groupsList?.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      print('all fruits');
                                      group.setCurrentIndex(index);
                                      Provider.of<ProductProvider>(context,
                                              listen: false)
                                          .filterGroupCategoryProductList(group
                                              .groupsList![index].id
                                              .toString());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: group.currentIndex ==
                                                            index
                                                        ? Theme.of(context)
                                                            .primaryColorDark
                                                        : Colors.transparent,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(35)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    Images.placeholder(context),
                                                image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.groupImageUrl}'
                                                    '/${group.groupsList![index].image}',
                                                fit: BoxFit.cover,
                                                imageErrorBuilder: (c, o, s) =>
                                                    Image.asset(
                                                        Images.placeholder(
                                                            context),
                                                        fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          SizedBox(
                                            width: 64,
                                            child: Text(
                                              group.groupsList![index].name!,
                                              style: poppinsRegular.copyWith(
                                                  color: group.currentIndex ==
                                                          index
                                                      ? Theme.of(context)
                                                          .primaryColorDark
                                                      : Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                              getTranslated('no_group_available', context)!))
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: group.groupsList == null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          )),
                    ),
            );
          },
        );
      },
    );
  }
}
