import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/search_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/product_shimmer.dart';
import 'package:shreeveg/view/base/product_widget.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/base/web_product_shimmer.dart';
import 'package:shreeveg/view/screens/search/search_result_screen.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/search/widget/filter_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int? pageSize;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
    Provider.of<SearchProvider>(context, listen: false)
        .initializeAllSortBy(notify: false);
  }

  bool _containsOnlyAscii(String text) {
    for (int i = 0; i < text.length; i++) {
      if (text.codeUnitAt(i) > 127) {
        // Found a non-ASCII character
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: WebAppBar()) as PreferredSizeWidget
          : AppBar(title: Text(getTranslated('search', context)!,style: poppinsMedium.copyWith(
      fontSize: Dimensions.fontSizeLarge,
          color:
          Colors.white)),backgroundColor: Color(0xFF0B4619),centerTitle: true,leading: BackButton(color: Colors.white,),),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge),
            child: Center(
              child: SizedBox(
                // width: 1170,
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText:
                                  getTranslated('search_anything', context),
                              isShowBorder: true,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Icons.search,
                              controller: _searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onChanged: (text) {
                                final String searchText =
                                    _searchController.text.trim();
                                if (searchText.isNotEmpty &&
                                    _containsOnlyAscii(searchText)) {
                                  List<int> encoded = utf8.encode(searchText);
                                  String data = base64Encode(encoded);
                                  searchProvider.saveSearchAddress(searchText);
                                  Provider.of<SearchProvider>(context, listen: false).initHistoryList();
                                  Provider.of<SearchProvider>(context, listen: false)
                                      .initializeAllSortBy(notify: false);
                                  Provider.of<SearchProvider>(context, listen: false)
                                      .saveSearchAddress(searchText, isUpdate: false);
                                  Provider.of<SearchProvider>(context, listen: false)
                                      .searchProduct(searchText, context, isUpdate: false);
                                  // Navigator.pushNamed(context,
                                  //     '${RouteHelper.searchResult}?text=$data',
                                  //     arguments: SearchResultScreen(
                                  //         searchString: searchText));
                                }
                              },
                              isShowSuffixIcon: true,
                            ),
                          ),
                          // Consumer<LocationProvider>(
                          //   builder: (context, locationProvider, child) =>
                          //       TextButton(
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //     },
                          //     style: TextButton.styleFrom(
                          //       padding: const EdgeInsets.all(12),
                          //       shadowColor: Theme.of(context).primaryColor,
                          //     ),
                          //     child: DropdownButton<String>(
                          //       value: locationProvider.selectedCity,
                          //       onChanged: (String? newValue) {
                          //         // Setter method
                          //         locationProvider.setSelectedCity(newValue!);
                          //       },
                          //       items: <String>[
                          //         'Jaipur',
                          //         'Delhi',
                          //         'Mumbai'
                          //       ].map<DropdownMenuItem<String>>((String value) {
                          //         return DropdownMenuItem<String>(
                          //           value: value,
                          //           child: Text(value),
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      const SizedBox(height: 10),
                     /* // for resent search section
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('recent_search', context)!,
                            style: poppinsMedium.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withOpacity(0.6),
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                          searchProvider.historyList.isNotEmpty
                              ? TextButton(
                                  onPressed: searchProvider.clearSearchAddress,
                                  child: Text(
                                    getTranslated('remove_all', context)!,
                                    style: poppinsMedium.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color
                                            ?.withOpacity(0.6),
                                        fontSize: Dimensions.fontSizeLarge),
                                  ))
                              : const SizedBox.shrink(),
                        ],
                      ),

                      // for recent search list section
                      Wrap(
                          children: List.generate(
                              searchProvider.historyList.length,
                              (index) => InkWell(
                                    onTap: () {
                                      List<int> encoded = utf8.encode(
                                          searchProvider
                                              .historyList[index]!);
                                      String data = base64Encode(encoded);
                                      searchProvider.searchProduct(
                                          searchProvider
                                              .historyList[index]!,
                                          context);
                                      Navigator.pushNamed(context,
                                          '${RouteHelper.searchResult}?text=$data',
                                          arguments: SearchResultScreen(
                                              searchString: searchProvider
                                                  .historyList[index]));
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: searchProvider.historyList[index])));
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 9),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Card(
                                          elevation: 0.5,
                                          color: const Color(0xFFF0F1F2),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 5.0),
                                            child: Text(
                                              searchProvider
                                                  .historyList[index]!
                                                  .toCapitalized(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: Dimensions
                                                          .fontSizeSmall),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))),*/
                      Expanded(
                        child: Consumer<SearchProvider>(
                          builder: (context, searchProvider, child) =>
                              SingleChildScrollView(
                                child: Column(children: [
                                  Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: ResponsiveHelper.isDesktop(context)
                                              ? MediaQuery.of(context).size.height - 400
                                              : MediaQuery.of(context).size.height,
                                        ),
                                        child: SizedBox(
                                            // width: 1170,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // const SizedBox(height: 15),
                                                // !ResponsiveHelper.isDesktop(context)
                                                //     ? Container(
                                                //   height: 48,
                                                //   margin: const EdgeInsets.symmetric(
                                                //       horizontal:
                                                //       Dimensions.paddingSizeSmall),
                                                //   padding: const EdgeInsets.symmetric(
                                                //       horizontal:
                                                //       Dimensions.paddingSizeSmall),
                                                //   width: MediaQuery.of(context).size.width,
                                                //   decoration: BoxDecoration(
                                                //     borderRadius: BorderRadius.circular(7),
                                                //     color: Theme.of(context).cardColor,
                                                //     boxShadow: [
                                                //       BoxShadow(
                                                //         color: Colors.grey[
                                                //         Provider.of<ThemeProvider>(
                                                //             context)
                                                //             .darkTheme
                                                //             ? 700
                                                //             : 200]!,
                                                //         spreadRadius: 0.5,
                                                //         blurRadius: 0.5,
                                                //         offset: const Offset(0,
                                                //             3), // changes position of shadow
                                                //       ),
                                                //     ],
                                                //   ),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                //     children: [
                                                //       Text(
                                                //         _searchController.text,
                                                //         style: poppinsLight.copyWith(
                                                //             color: Theme.of(context)
                                                //                 .textTheme
                                                //                 .bodyLarge
                                                //                 ?.color
                                                //                 ?.withOpacity(0.6),
                                                //             fontSize:
                                                //             Dimensions.paddingSizeLarge),
                                                //       ),
                                                //       InkWell(
                                                //         onTap: () {
                                                //           Navigator.of(context).pop();
                                                //         },
                                                //         child: const Icon(Icons.close,
                                                //             color: Colors.red, size: 22),
                                                //       )
                                                //     ],
                                                //   ),
                                                // )
                                                //     : const SizedBox(),
                                                // const SizedBox(height: 13),
                                                // Container(
                                                //   height: 48,
                                                //   margin: const EdgeInsets.symmetric(
                                                //       horizontal: Dimensions.paddingSizeSmall),
                                                //   padding: const EdgeInsets.symmetric(
                                                //       horizontal: Dimensions.paddingSizeSmall),
                                                //   width: MediaQuery.of(context).size.width,
                                                //   decoration: BoxDecoration(
                                                //     borderRadius: BorderRadius.circular(7),
                                                //     color: Theme.of(context).cardColor,
                                                //     boxShadow: [
                                                //       BoxShadow(
                                                //         color: Colors.grey[
                                                //         Provider.of<ThemeProvider>(context)
                                                //             .darkTheme
                                                //             ? 700
                                                //             : 200]!,
                                                //         spreadRadius: 0.5,
                                                //         blurRadius: 0.5,
                                                //         offset: const Offset(
                                                //             0, 3), // changes position of shadow
                                                //       ),
                                                //     ],
                                                //   ),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                //     children: [
                                                //       Row(
                                                //         children: [
                                                //           searchProvider.searchProductList != null
                                                //               ? Text(
                                                //             "${searchProvider.searchProductList!.length}",
                                                //             style: poppinsMedium.copyWith(
                                                //                 color: Theme.of(context)
                                                //                     .primaryColor),
                                                //           )
                                                //               : const SizedBox.shrink(),
                                                //           Text(
                                                //             '${searchProvider.searchProductList != null ? "" : 0} ${getTranslated('items_found', context)}',
                                                //             style: poppinsMedium.copyWith(
                                                //                 color: Theme.of(context)
                                                //                     .textTheme
                                                //                     .bodyLarge
                                                //                     ?.color
                                                //                     ?.withOpacity(0.6)),
                                                //           )
                                                //         ],
                                                //       ),
                                                //       // searchProvider.searchProductList != null
                                                //       //     ? InkWell(
                                                //       //   onTap: () {
                                                //       //     showDialog(
                                                //       //         context: context,
                                                //       //         builder:
                                                //       //             (BuildContext context) {
                                                //       //           List<double?> prices = [];
                                                //       //           for (var product
                                                //       //           in searchProvider
                                                //       //               .filterProductList!) {
                                                //       //             prices.add(double.parse(product.price!));
                                                //       //           }
                                                //       //           prices.sort();
                                                //       //           double? maxValue =
                                                //       //           prices.isNotEmpty
                                                //       //               ? prices[
                                                //       //           prices.length - 1]
                                                //       //               : 1000;
                                                //       //
                                                //       //           return Dialog(
                                                //       //             shape:
                                                //       //             RoundedRectangleBorder(
                                                //       //                 borderRadius:
                                                //       //                 BorderRadius
                                                //       //                     .circular(
                                                //       //                     20.0)),
                                                //       //             child: FilterWidget(
                                                //       //                 maxValue: maxValue),
                                                //       //           );
                                                //       //         });
                                                //       //   },
                                                //       //   child: Container(
                                                //       //     padding: const EdgeInsets.all(5),
                                                //       //     decoration: BoxDecoration(
                                                //       //         borderRadius:
                                                //       //         BorderRadius.circular(4.0),
                                                //       //         border: Border.all(
                                                //       //             color: Theme.of(context)
                                                //       //                 .hintColor
                                                //       //                 .withOpacity(0.6)
                                                //       //                 .withOpacity(.5))),
                                                //       //     child: Row(
                                                //       //       children: [
                                                //       //         Icon(Icons.filter_list,
                                                //       //             color: Theme.of(context)
                                                //       //                 .textTheme
                                                //       //                 .bodyLarge
                                                //       //                 ?.color
                                                //       //                 ?.withOpacity(0.6)),
                                                //       //         Text(
                                                //       //           '  ${getTranslated('filter', context)}',
                                                //       //           style: poppinsMedium.copyWith(
                                                //       //               color: Theme.of(context)
                                                //       //                   .textTheme
                                                //       //                   .bodyLarge
                                                //       //                   ?.color
                                                //       //                   ?.withOpacity(0.6),
                                                //       //               fontSize: Dimensions
                                                //       //                   .fontSizeSmall),
                                                //       //         )
                                                //       //       ],
                                                //       //     ),
                                                //       //   ),
                                                //       // )
                                                //       //     : const SizedBox.shrink(),
                                                //     ],
                                                //   ),
                                                // ),
                                                Row(
                                                  children: [
                                                    searchProvider.searchProductList != null
                                                        ? Text(
                                                      "${searchProvider.searchProductList!.length}",
                                                      style: poppinsMedium.copyWith(
                                                          color: Theme.of(context)
                                                              .primaryColor),
                                                    )
                                                        : const SizedBox.shrink(),
                                                    Text(
                                                      '${searchProvider.searchProductList != null ? "" : 0} ${getTranslated('items_found', context)}',
                                                      style: poppinsMedium.copyWith(
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.color
                                                              ?.withOpacity(0.6)),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                searchProvider.searchProductList != null
                                                    ? searchProvider.searchProductList!.isNotEmpty
                                                    ? GridView.builder(
                                                  gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisSpacing:
                                                      ResponsiveHelper.isDesktop(
                                                          context)
                                                          ? 13
                                                          : 5,
                                                      mainAxisSpacing:
                                                      ResponsiveHelper.isDesktop(
                                                          context)
                                                          ? 13
                                                          : 5,
                                                      childAspectRatio:
                                                      ResponsiveHelper.isDesktop(
                                                          context)
                                                          ? (1 / 1.4)
                                                          : 2.5,
                                                      crossAxisCount: ResponsiveHelper
                                                          .isDesktop(context)
                                                          ? 5
                                                          : ResponsiveHelper.isTab(
                                                          context)
                                                          ? 2
                                                          : 1),
                                                  itemCount: searchProvider
                                                      .searchProductList!.length,
                                                  // padding: EdgeInsets.symmetric(
                                                  //     horizontal:
                                                  //     Dimensions.paddingSizeSmall,
                                                  //     vertical: ResponsiveHelper
                                                  //         .isDesktop(context)
                                                  //         ? Dimensions.paddingSizeLarge
                                                  //         : 0.0),
                                                  physics:
                                                  const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context, int index) =>
                                                      ProductWidget(
                                                        product: searchProvider
                                                            .searchProductList![index],
                                                        productType: ProductType.searchItem,
                                                      ),
                                                )
                                                    : const NoDataScreen(isSearch: true)
                                                    : GridView.builder(
                                                  gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing:
                                                    ResponsiveHelper.isDesktop(context)
                                                        ? 13
                                                        : 5,
                                                    mainAxisSpacing:
                                                    ResponsiveHelper.isDesktop(context)
                                                        ? 13
                                                        : 5,
                                                    childAspectRatio:
                                                    ResponsiveHelper.isDesktop(context)
                                                        ? (1 / 1.4)
                                                        : 4,
                                                    crossAxisCount:
                                                    ResponsiveHelper.isDesktop(context)
                                                        ? 5
                                                        : ResponsiveHelper.isTab(context)
                                                        ? 2
                                                        : 1,
                                                  ),
                                                  physics:
                                                  const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: 10,
                                                  itemBuilder: (context, index) =>
                                                  ResponsiveHelper.isDesktop(context)
                                                      ? WebProductShimmer(
                                                      isEnabled: searchProvider
                                                          .searchProductList ==
                                                          null)
                                                      : ProductShimmer(
                                                      isEnabled: searchProvider
                                                          .searchProductList ==
                                                          null),
                                                ),
                                              ],
                                            )),
                                      )),
                                  ResponsiveHelper.isDesktop(context)
                                      ? const FooterView()
                                      : const SizedBox(),
                                ]),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
