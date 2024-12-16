import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/search_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/search/search_result_screen.dart';
import 'package:provider/provider.dart';

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
          : const CustomAppBar(title: ''),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge),
            child: Center(
              child: SizedBox(
                width: 1170,
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
                              onSubmit: (text) {
                                final String searchText =
                                    _searchController.text.trim();
                                if (searchText.isNotEmpty &&
                                    _containsOnlyAscii(searchText)) {
                                  List<int> encoded = utf8.encode(searchText);
                                  String data = base64Encode(encoded);
                                  searchProvider.saveSearchAddress(searchText);
                                  Navigator.pushNamed(context,
                                      '${RouteHelper.searchResult}?text=$data',
                                      arguments: SearchResultScreen(
                                          searchString: searchText));
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
                      // for resent search section
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
                      Expanded(
                          child: Wrap(
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
                                      ))))
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
