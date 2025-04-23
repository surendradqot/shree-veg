import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shreeveg/data/model/response/new_category_product_modal.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/search_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/product_widget.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  String _currentText = "99.99%";

  // String _currentImage = "assets/image/ellipse.png";
  Color _textColor = Colors.white;
  double? fontSize = 7;
  ColorFilter? _imageColorFilter;
  bool isFirstVerticalItemUpdated = false;
  String? selectedIndex = "";
  late Timer _timer;
  Future apiCall() async {
    Provider.of<SearchProvider>(context,
        listen: false)
        .searchProduct("a", context,
        isUpdate: true);
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
    await Provider.of<SearchProvider>(context, listen: false)
        .initializeAllSortBy(notify: false);
    Provider.of<SearchProvider>(context,
        listen: false)
        .searchProduct("all_pro", context,
        isUpdate: false);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentText = _currentText == "99.99%" ? "Discount" : "99.99%";
        _textColor = _textColor == Colors.white ? Colors.black : Colors.white;
        // fontSize = fontSize == 5 ? 4 : 5;
        _imageColorFilter = _imageColorFilter == null
            ? ColorFilter.mode(Color(0xffFDC94C), BlendMode.srcATop)
            : null;
      });
    });
    apiCall();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  int? pageSize;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

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
          : AppBar(
              title: Text(getTranslated('search', context)!,
                  style: poppinsMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge, color: Colors.white)),
              backgroundColor: Color(0xFF0B4619),
              centerTitle: true,
              leading: BackButton(
                color: Colors.white,
              ),
            ),
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
                                  base64Encode(encoded);
                                  searchProvider.saveSearchAddress(searchText);
                                  Provider.of<SearchProvider>(context,
                                          listen: false)
                                      .initHistoryList();
                                  Provider.of<SearchProvider>(context,
                                          listen: false)
                                      .initializeAllSortBy(notify: false);
                                  Provider.of<SearchProvider>(context,
                                          listen: false)
                                      .saveSearchAddress(searchText,
                                          isUpdate: false);
                                  Provider.of<SearchProvider>(context,
                                          listen: false)
                                      .searchProduct(searchText, context,
                                          isUpdate: false);
                                } else {
                                  Provider.of<SearchProvider>(context,
                                          listen: false)
                                      .updateList();
                                }
                              },
                              isShowSuffixIcon: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                                    searchProvider.searchProductList != null &&
                                            searchProvider
                                                .searchProductList!.isNotEmpty
                                        ? GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 13
                                                            : 6,
                                                    mainAxisSpacing:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 13
                                                            : 6,
                                                    childAspectRatio:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? (1 / 1.4)
                                                            : 2.4,
                                                    crossAxisCount:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 5
                                                            : ResponsiveHelper
                                                                    .isTab(
                                                                        context)
                                                                ? 2
                                                                : 1),
                                            itemCount: searchProvider
                                                .searchProductList!.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return searchProvider
                                                          .searchProductList![
                                                              index]
                                                          .oneRsOfferEnable ==
                                                      1
                                                  ? oneRupeeOfferBox(
                                                      searchProvider
                                                          .searchProductList![index],0.0)
                                                  : searchProvider
                                                              .searchProductList![
                                                                  index]
                                                              .oneRsOfferEnable ==
                                                          1
                                                      ? bulkOfferBox(
                                                          searchProvider
                                                              .searchProductList![index])
                                                      : productList(searchProvider
                                                          .searchProductList![index]);
                                            },
                                          )
                                        : const NoDataScreen(isSearch: true),
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

  oneRupeeOfferBox(ProductData oneRupeeProductList, double? totalPrice) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) =>
        //         ProductDetailsScreen(product: oneRupeeProductList)));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffDCF1E1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xff14A236),
          ),
        ),
        child: Row(
          children: [
            productImageBox(
              oneRupeeProductList.leftTitle!.isNotEmpty
                  ? oneRupeeProductList.leftTitle!
                  : "",
              oneRupeeProductList.rightTile!.isNotEmpty
                  ? oneRupeeProductList.rightTile!
                  : "",
              oneRupeeProductList.singleImage!.isNotEmpty
                  ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${oneRupeeProductList.singleImage![0]}"
                  : "",
              oneRupeeProductList.hnName,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        child: Text(
                          oneRupeeProductList.name!.isNotEmpty
                              ? "${oneRupeeProductList.name!}"
                              : "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      oneRupeeProductList.appliedOneRupee! &&
                          double.parse(oneRupeeProductList.totalAddedWeight!
                              .toStringAsFixed(0)) >=
                              0
                          ? Container(
                        padding: EdgeInsets.all(06),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(06),
                            bottomLeft: Radius.circular(06),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total ",
                              style: poppinsMedium.copyWith(
                                  fontSize: 10, color: Colors.white),
                            ),
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 08),
                              decoration: BoxDecoration(
                                color: Color(0XFFFFDE4D),
                                // shape: BoxShape.oval,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.elliptical(15, 08),
                                  topLeft: Radius.elliptical(15, 08),
                                  bottomLeft: Radius.elliptical(15, 08),
                                  bottomRight: Radius.elliptical(15, 08),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                  "${oneRupeeProductList.totalAddedWeight!}",
                                  children: [
                                    TextSpan(
                                      text: oneRupeeProductList
                                          .appliedUnit!,
                                      style: poppinsMedium.copyWith(
                                        fontSize: 06,
                                        color: Color(0XFF80150E),
                                      ),
                                    ),
                                  ],
                                  style: poppinsMedium.copyWith(
                                    fontSize: 10,
                                    color: Color(0XFF80150E),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : SizedBox(),
                    ],
                  ),
                  oneRupeeProductList.appliedOneRupee! &&
                      double.parse(oneRupeeProductList.totalAddedWeight!
                          .toStringAsFixed(0)) >=
                          0
                      ? SizedBox(
                    height: 15,
                  )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 22,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color(0xff14A236)),
                        child: Text(
                          "1₹ Offer",
                          style: poppinsRegular.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color(0xffF64A4D)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 4),
                          child: Column(
                            children: [
                              Text(
                                "Time Remaining",
                                style: poppinsRegular.copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                timingBox(oneRupeeProductList.offerTimeLimit),
                                // "11h  :  15m  :  10s",
                                style: poppinsRegular.copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: "1",
                                style: poppinsRegular.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'st',
                                    style: poppinsRegular.copyWith(
                                        fontSize: 08,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: " Kg",
                                    style: poppinsRegular.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ]),
                          ),
                          Row(
                            children: [
                              Text(
                                "₹1.00",
                                style: poppinsRegular.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),

                              Text(
                                " MRP ",
                                style: poppinsRegular.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff828282),
                                    decorationColor: Color(0xff828282)),
                              ),
                              Text(
                                "₹${oneRupeeProductList.marketPrice}",
                                style: poppinsRegular.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff828282),
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Color(0xff828282)),
                              )
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        height: 27,
                        width: 27,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/image/discount.png"),
                            fit: BoxFit.fill,
                            colorFilter: _imageColorFilter,
                          ),
                        ),
                        child: Text(
                          _currentText == "Discount"
                              ? "OFF"
                              : "${oneRupeeProductList.discount.toString()}%",
                          style: poppinsRegular.copyWith(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              color: _textColor),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      oneRupeeProductList.appliedOneRupee!
                          ? GestureDetector(
                        onTap: () {
                          Provider.of<ProductProvider>(context,
                              listen: false)
                              .removeFromCart(
                            oneRupeeProductList,
                            "oneRupeeOffer",
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 63,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color(0xffa54e4e),
                            border: Border.all(
                              color: Color(0xffa54e4e),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "REMOVE",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xffececec),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          // child: Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: Color(0xffDAEEDF),
                          //           borderRadius: BorderRadius.only(
                          //             topLeft: Radius.circular(3),
                          //             bottomLeft: Radius.circular(3),
                          //           ),
                          //         ),
                          //         alignment: Alignment.center,
                          //         child: Icon(
                          //           Icons.remove,
                          //           color: Color(0xff0C4619),
                          //           size: 15,
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Center(
                          //         child: Text(
                          //           "20",
                          //           style: TextStyle(
                          //             fontWeight: FontWeight.w500,
                          //             color: Color(0xff0C4619),
                          //             fontSize: 12,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: Color(0xffDAEEDF),
                          //           borderRadius: BorderRadius.only(
                          //             topRight: Radius.circular(3),
                          //             bottomRight: Radius.circular(3),
                          //           ),
                          //         ),
                          //         alignment: Alignment.center,
                          //         child: Icon(
                          //           Icons.add,
                          //           color: Color(0xff0C4619),
                          //           size: 15,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ),
                      )
                          : GestureDetector(
                        onTap: () {
                          Provider.of<ProductProvider>(context,
                              listen: false)
                              .addToCart(
                              oneRupeeProductList,
                              1,
                              "oneRupeeOffer",
                              oneRupeeProductList.unit);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 63,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Color(0xff0C4619)),
                          child: Text(
                            "ADD",
                            style: poppinsRegular.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  Text(
                    // "* ₹${oneRupeeProductList.minPurchaseAmount} minimum purchase to claim the offer",
                    "*₹${oneRupeeProductList.minPurchaseAmount}",
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 9,
                      color: Color(0xffF64A4D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bulkOfferBox(ProductData bulkOfferProductList) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) =>
        //         ProductDetailsScreen(product: bulkOfferProductList)));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffFFECD0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xffFDC94C),
          ),
        ),
        child: Row(
          children: [
            productImageBox(
              bulkOfferProductList.leftTitle!.isNotEmpty
                  ? bulkOfferProductList.leftTitle!
                  : "",
              bulkOfferProductList.rightTile!.isNotEmpty
                  ? bulkOfferProductList.rightTile!
                  : "",
              bulkOfferProductList.singleImage!.isNotEmpty
                  ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${bulkOfferProductList.singleImage![0]}"
                  : "",
              bulkOfferProductList.hnName,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Text(
                            bulkOfferProductList.name!.isNotEmpty
                                ? "${bulkOfferProductList.name!}"
                                : "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: poppinsRegular.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      bulkOfferProductList.appliedBulkRupee! &&
                          double.parse(bulkOfferProductList
                              .totalAddedWeight!
                              .toStringAsFixed(0)) >=
                              0
                          ? Expanded(
                        child: Container(
                          padding: EdgeInsets.all(06),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(06),
                              bottomLeft: Radius.circular(06),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total ",
                                style: poppinsMedium.copyWith(
                                    fontSize: 10, color: Colors.white),
                              ),
                              Container(
                                padding:
                                EdgeInsets.symmetric(horizontal: 08),
                                decoration: BoxDecoration(
                                  color: Color(0XFFFFDE4D),
                                  // shape: BoxShape.oval,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.elliptical(15, 08),
                                    topLeft: Radius.elliptical(15, 08),
                                    bottomLeft: Radius.elliptical(15, 08),
                                    bottomRight:
                                    Radius.elliptical(15, 08),
                                  ),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: bulkOfferProductList
                                        .totalAddedWeight!
                                        .toStringAsFixed(0),
                                    children: [
                                      TextSpan(
                                        text: bulkOfferProductList
                                            .appliedUnit!,
                                        style: poppinsMedium.copyWith(
                                          fontSize: 06,
                                          color: Color(0XFF80150E),
                                        ),
                                      ),
                                    ],
                                    style: poppinsMedium.copyWith(
                                      fontSize: 10,
                                      color: Color(0XFF80150E),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : SizedBox(),
                    ],
                  ),
                  bulkOfferProductList.appliedBulkRupee! &&
                      double.parse(bulkOfferProductList.totalAddedWeight!
                          .toStringAsFixed(0)) >=
                          0
                      ? SizedBox(
                    height: 15,
                  )
                      : SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color(0xffFDC94C)),
                        child: Text(
                          "Bulk Order",
                          style: poppinsRegular.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 05),
                        // width: 200.0,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.red,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              ScaleAnimatedText('Limited Offer'),
                            ],
                            pause: Duration(milliseconds: 100),
                            isRepeatingAnimation: true,
                            totalRepeatCount: 10000,
                          ),
                        ),
                      )
                      // Container(
                      //   alignment: Alignment.center,
                      //   margin: EdgeInsets.only(right: 05),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(3),
                      //       color: Color(0xffF64A4D)),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 5.0, vertical: 4),
                      //     child: Column(
                      //       children: [
                      //         Text(
                      //           "Time Remaining",
                      //           style: poppinsRegular.copyWith(
                      //               fontSize: 8,
                      //               fontWeight: FontWeight.w500,
                      //               color: Colors.white),
                      //         ),
                      //         Text(
                      //           "11h  :  15m  :  10s",
                      //           style: poppinsRegular.copyWith(
                      //               fontSize: 8,
                      //               fontWeight: FontWeight.w500,
                      //               color: Colors.white),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: bulkOfferProductList.quantity!.isNotEmpty
                                    ? bulkOfferProductList.quantity!
                                    : "",
                                style: poppinsRegular.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: bulkOfferProductList
                                        .quantity!.isNotEmpty
                                        ? bulkOfferProductList.unit!
                                        : "",
                                    style: poppinsRegular.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ]),
                          ),
                          // (Sree Veg - ₹30.00 Par kg)
                          Text(
                            "(Shree Veg - ₹${(double.parse(bulkOfferProductList.amount!) / double.parse(bulkOfferProductList.quantity!))%1==0?(double.parse(bulkOfferProductList.amount!) / double.parse(bulkOfferProductList.quantity!)).toStringAsFixed(0):(double.parse(bulkOfferProductList.amount!) / double.parse(bulkOfferProductList.quantity!)).toStringAsFixed(2)}/${bulkOfferProductList.unit!})",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: poppinsRegular.copyWith(
                                fontSize: 06,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                          Row(
                            children: [
                              Text(
                                bulkOfferProductList.quantity!.isNotEmpty
                                    ? "₹${double.parse(bulkOfferProductList.amount!)%1==0?double.parse(bulkOfferProductList.amount!).toStringAsFixed(0):double.parse(bulkOfferProductList.amount!).toStringAsFixed(2)}"
                                    : "",
                                style: poppinsRegular.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                " MRP ",
                                style: poppinsRegular.copyWith(
                                  fontSize: 08,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff828282),
                                  decorationColor: Color(0xff828282),
                                ),
                              ),
                              Text(
                                "₹${(double.parse(bulkOfferProductList.quantity!) * double.parse(bulkOfferProductList.marketPrice!.toStringAsFixed(2))).toStringAsFixed(0)}",
                                style: poppinsRegular.copyWith(
                                  fontSize: 08,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff828282),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Color(0xff828282),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        height: 27,
                        width: 27,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/image/discount.png"),
                            fit: BoxFit.fill,
                            colorFilter: _imageColorFilter,
                          ),
                        ),
                        child: Text(
                          _currentText == "Discount"
                              ? "OFF"
                              : "${bulkOfferProductList.discount.toString()}%",
                          style: poppinsRegular.copyWith(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              color: _textColor),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      bulkOfferProductList.appliedBulkRupee!
                          ? Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 63,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          // color: Color(0xff0C4619),
                          border: Border.all(
                            color: Color(0xff0C4619),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (bulkOfferProductList
                                      .appliedBulkRupeeCount !=
                                      1) {
                                    Provider.of<ProductProvider>(context,
                                        listen: false)
                                        .addToCart(
                                        bulkOfferProductList,
                                        (bulkOfferProductList
                                            .appliedBulkRupeeCount! -
                                            1),
                                        "bulkOffer",
                                        bulkOfferProductList.unit);
                                  } else {
                                    Provider.of<ProductProvider>(context,
                                        listen: false)
                                        .removeFromCart(
                                      bulkOfferProductList,
                                      "bulkOffer",
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffDAEEDF),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      bottomLeft: Radius.circular(3),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.remove,
                                    color: Color(0xff0C4619),
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "${bulkOfferProductList.appliedBulkRupeeCount}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff0C4619),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (bulkOfferProductList
                                      .appliedBulkRupeeCount! <
                                      10) {
                                    Provider.of<ProductProvider>(context,
                                        listen: false)
                                        .addToCart(
                                        bulkOfferProductList,
                                        (bulkOfferProductList
                                            .appliedBulkRupeeCount! +
                                            1),
                                        "bulkOffer",
                                        bulkOfferProductList.unit);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffDAEEDF),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomRight: Radius.circular(3),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.add,
                                    color: Color(0xff0C4619),
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : GestureDetector(
                        onTap: () {
                          Provider.of<ProductProvider>(context,
                              listen: false)
                              .addToCart(bulkOfferProductList, 1,
                              "bulkOffer", bulkOfferProductList.unit);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 63,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Color(0xff0C4619)),
                          child: Text(
                            "ADD",
                            style: poppinsRegular.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  bulkOfferProductList.appliedBulkRupee! &&
                      double.parse(bulkOfferProductList.totalAddedWeight!
                          .toStringAsFixed(0)) >=
                          0
                      ? SizedBox(
                    height: 15,
                  )
                      : SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // oneRupeeOfferBox(ProductData oneRupeeProductList) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => ProductDetailsScreen(
  //               product: oneRupeeProductList)));
  //     },
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Color(0xffDCF1E1),
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(
  //           color: Color(0xff14A236),
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           productImageBox(
  //             oneRupeeProductList.leftTitle!.isNotEmpty
  //                 ? oneRupeeProductList.leftTitle!
  //                 : "",
  //             oneRupeeProductList.rightTile!.isNotEmpty
  //                 ? oneRupeeProductList.rightTile!
  //                 : "",
  //             oneRupeeProductList.singleImage!.isNotEmpty
  //                 ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${oneRupeeProductList.singleImage![0]}"
  //                 : "",
  //           ),
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(
  //                   child: Text(
  //                     oneRupeeProductList.name!.isNotEmpty
  //                         ? "${oneRupeeProductList.name!} ${oneRupeeProductList.hnName}"
  //                         : "",
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: poppinsRegular.copyWith(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w500,
  //                         color: Colors.black),
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(
  //                       alignment: Alignment.center,
  //                       height: 22,
  //                       width: 60,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(3),
  //                           color: Color(0xff14A236)),
  //                       child: Text(
  //                         "1₹ Offer",
  //                         style: poppinsRegular.copyWith(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.white),
  //                       ),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.center,
  //                       margin: EdgeInsets.only(right: 05),
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(3),
  //                           color: Color(0xffF64A4D)),
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 5.0, vertical: 4),
  //                         child: Column(
  //                           children: [
  //                             Text(
  //                               "Time Remaining",
  //                               style: poppinsRegular.copyWith(
  //                                   fontSize: 8,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.white),
  //                             ),
  //                             Text(
  //                               timingBox(oneRupeeProductList
  //                                   .offerTimeLimit),
  //                               // "11h  :  15m  :  10s",
  //                               style: poppinsRegular.copyWith(
  //                                   fontSize: 8,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.white),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         RichText(
  //                           text: TextSpan(
  //                               text: "1",
  //                               style: poppinsRegular.copyWith(
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.black),
  //                               children: [
  //                                 TextSpan(
  //                                   text: 'st',
  //                                   style: poppinsRegular.copyWith(
  //                                       fontSize: 08,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                                 TextSpan(
  //                                   text: " Kg",
  //                                   style: poppinsRegular.copyWith(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                               ]),
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "₹1.00",
  //                               style: poppinsRegular.copyWith(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.black),
  //                             ),
  //                             Text(
  //                               "MRP ₹${oneRupeeProductList.marketPrice}",
  //                               style: poppinsRegular.copyWith(
  //                                   fontSize: 9,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Color(0xff828282),
  //                                   decoration:
  //                                   TextDecoration.lineThrough,
  //                                   decorationColor: Color(0xff828282)),
  //                             )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     Spacer(),
  //                     Container(
  //                       alignment: Alignment.center,
  //                       height: 27,
  //                       width: 27,
  //                       decoration: BoxDecoration(
  //                         image: DecorationImage(
  //                           image:
  //                           AssetImage("assets/image/discount.png"),
  //                           fit: BoxFit.fill,
  //                           colorFilter: _imageColorFilter,
  //                         ),
  //                       ),
  //                       child: Text(
  //                         _currentText == "Discount"
  //                             ? "Discount"
  //                             : "${oneRupeeProductList.discount.toString()}%",
  //                         style: poppinsRegular.copyWith(
  //                             fontSize: fontSize,
  //                             fontWeight: FontWeight.w500,
  //                             color: _textColor),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     5 % 3 != 0
  //                         ? Container(
  //                       alignment: Alignment.center,
  //                       height: 22,
  //                       width: 60,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(3),
  //                         // color: Color(0xff0C4619),
  //                         border: Border.all(
  //                           color: Color(0xff0C4619),
  //                         ),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 color: Color(0xffDAEEDF),
  //                                 borderRadius: BorderRadius.only(
  //                                   topLeft: Radius.circular(3),
  //                                   bottomLeft: Radius.circular(3),
  //                                 ),
  //                               ),
  //                               alignment: Alignment.center,
  //                               child: Icon(
  //                                 Icons.remove,
  //                                 color: Color(0xff0C4619),
  //                                 size: 15,
  //                               ),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: Center(
  //                               child: Text(
  //                                 "20",
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Color(0xff0C4619),
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 color: Color(0xffDAEEDF),
  //                                 borderRadius: BorderRadius.only(
  //                                   topRight: Radius.circular(3),
  //                                   bottomRight: Radius.circular(3),
  //                                 ),
  //                               ),
  //                               alignment: Alignment.center,
  //                               child: Icon(
  //                                 Icons.add,
  //                                 color: Color(0xff0C4619),
  //                                 size: 15,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                         : Container(
  //                       alignment: Alignment.center,
  //                       height: 22,
  //                       width: 60,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(3),
  //                           color: Color(0xff0C4619)),
  //                       child: Text(
  //                         "ADD",
  //                         style: poppinsRegular.copyWith(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.white),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                   ],
  //                 ),
  //                 Text(
  //                   "*₹${oneRupeeProductList.minPurchaseAmount}",
  //                   // "* ₹${oneRupeeProductList.minPurchaseAmount} minimum purchase to claim the offer",
  //                   style: poppinsRegular.copyWith(
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 9,
  //                     color: Color(0xffF64A4D),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // bulkOfferBox(ProductData bulkOfferProductList) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => ProductDetailsScreen(
  //               product: bulkOfferProductList)));
  //     },
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Color(0xffFFECD0),
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(
  //           color: Color(0xffFDC94C),
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           productImageBox(
  //             bulkOfferProductList.leftTitle!.isNotEmpty
  //                 ? bulkOfferProductList.leftTitle!
  //                 : "",
  //             bulkOfferProductList.rightTile!.isNotEmpty
  //                 ? bulkOfferProductList.rightTile!
  //                 : "",
  //             bulkOfferProductList.singleImage!.isNotEmpty
  //                 ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${bulkOfferProductList.singleImage![0]}"
  //                 : "",
  //           ),
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(
  //                   child: Text(
  //                     bulkOfferProductList.name!.isNotEmpty
  //                         ? "${bulkOfferProductList.name!} ${bulkOfferProductList.hnName}"
  //                         : "",
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: poppinsRegular.copyWith(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w500,
  //                         color: Colors.black),
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(
  //                       alignment: Alignment.center,
  //                       padding: EdgeInsets.all(05),
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(3),
  //                           color: Color(0xffFDC94C)),
  //                       child: Text(
  //                         "Bulk Order",
  //                         style: poppinsRegular.copyWith(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.black),
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.only(right: 05),
  //                       // width: 200.0,
  //                       child: DefaultTextStyle(
  //                         style: const TextStyle(
  //                           fontSize: 12.0,
  //                           color: Colors.red,
  //                         ),
  //                         child: AnimatedTextKit(
  //                           animatedTexts: [
  //                             ScaleAnimatedText('Limited Offer'),
  //                           ],
  //                           pause: Duration(milliseconds: 100),
  //                           isRepeatingAnimation: true,
  //                           totalRepeatCount: 10000,
  //                         ),
  //                       ),
  //                     )
  //                     // Container(
  //                     //   alignment: Alignment.center,
  //                     //   margin: EdgeInsets.only(right: 05),
  //                     //   decoration: BoxDecoration(
  //                     //       borderRadius: BorderRadius.circular(3),
  //                     //       color: Color(0xffF64A4D)),
  //                     //   child: Padding(
  //                     //     padding: const EdgeInsets.symmetric(
  //                     //         horizontal: 5.0, vertical: 4),
  //                     //     child: Column(
  //                     //       children: [
  //                     //         Text(
  //                     //           "Time Remaining",
  //                     //           style: poppinsRegular.copyWith(
  //                     //               fontSize: 8,
  //                     //               fontWeight: FontWeight.w500,
  //                     //               color: Colors.white),
  //                     //         ),
  //                     //         Text(
  //                     //           "11h  :  15m  :  10s",
  //                     //           style: poppinsRegular.copyWith(
  //                     //               fontSize: 8,
  //                     //               fontWeight: FontWeight.w500,
  //                     //               color: Colors.white),
  //                     //         ),
  //                     //       ],
  //                     //     ),
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         RichText(
  //                           text: TextSpan(
  //                               text: bulkOfferProductList
  //                                   .quantity!
  //                                   .isNotEmpty
  //                                   ? bulkOfferProductList
  //                                   .quantity!
  //                                   : "",
  //                               style: poppinsRegular.copyWith(
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.black),
  //                               children: [
  //                                 TextSpan(
  //                                   text: bulkOfferProductList
  //                                       .quantity!
  //                                       .isNotEmpty
  //                                       ? bulkOfferProductList
  //                                       .unit!
  //                                       : "",
  //                                   style: poppinsRegular.copyWith(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                               ]),
  //                         ),
  //                         // (Sree Veg - ₹30.00 Par kg)
  //                         Text(
  //                           "(Shree Veg - ₹${double.parse(bulkOfferProductList.amount!) / double.parse(bulkOfferProductList.quantity!)}/kg)",
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: poppinsRegular.copyWith(
  //                               fontSize: 06,
  //                               fontWeight: FontWeight.w400,
  //                               color: Colors.red),
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               bulkOfferProductList
  //                                   .quantity!
  //                                   .isNotEmpty
  //                                   ? "₹${bulkOfferProductList.amount!}"
  //                                   : "",
  //                               style: poppinsRegular.copyWith(
  //                                   fontSize: 11,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.black),
  //                             ),
  //                             Text(
  //                               "MRP ₹${(double.parse(bulkOfferProductList.quantity!) * double.parse(bulkOfferProductList.marketPrice!.toStringAsFixed(2))).toStringAsFixed(0)}",
  //                               style: poppinsRegular.copyWith(
  //                                 fontSize: 08,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: Color(0xff828282),
  //                                 decoration: TextDecoration.lineThrough,
  //                                 decorationColor: Color(0xff828282),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     Spacer(),
  //                     Container(
  //                       alignment: Alignment.center,
  //                       height: 27,
  //                       width: 27,
  //                       decoration: BoxDecoration(
  //                         image: DecorationImage(
  //                           image:
  //                           AssetImage("assets/image/discount.png"),
  //                           fit: BoxFit.fill,
  //                           colorFilter: _imageColorFilter,
  //                         ),
  //                       ),
  //                       child: Text(
  //                         _currentText,
  //                         style: poppinsRegular.copyWith(
  //                             fontSize: fontSize,
  //                             fontWeight: FontWeight.w500,
  //                             color: _textColor),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     5 % 3 != 0
  //                         ? Container(
  //                       alignment: Alignment.center,
  //                       height: 22,
  //                       width: 60,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(3),
  //                         // color: Color(0xff0C4619),
  //                         border: Border.all(
  //                           color: Color(0xff0C4619),
  //                         ),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 color: Color(0xffDAEEDF),
  //                                 borderRadius: BorderRadius.only(
  //                                   topLeft: Radius.circular(3),
  //                                   bottomLeft: Radius.circular(3),
  //                                 ),
  //                               ),
  //                               alignment: Alignment.center,
  //                               child: Icon(
  //                                 Icons.remove,
  //                                 color: Color(0xff0C4619),
  //                                 size: 15,
  //                               ),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: Center(
  //                               child: Text(
  //                                 "20",
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Color(0xff0C4619),
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 color: Color(0xffDAEEDF),
  //                                 borderRadius: BorderRadius.only(
  //                                   topRight: Radius.circular(3),
  //                                   bottomRight: Radius.circular(3),
  //                                 ),
  //                               ),
  //                               alignment: Alignment.center,
  //                               child: Icon(
  //                                 Icons.add,
  //                                 color: Color(0xff0C4619),
  //                                 size: 15,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                         : Container(
  //                       alignment: Alignment.center,
  //                       height: 22,
  //                       width: 60,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(3),
  //                           color: Color(0xff0C4619)),
  //                       child: Text(
  //                         "ADD",
  //                         style: poppinsRegular.copyWith(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.white),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  productList(ProductData categoryProductList) {
    return productBox(categoryProductList);
  }

  productBox(ProductData categoryProductList) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(product: categoryProductList)));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xff0C4619),
          ),
        ),
        child: Row(
          children: [
            productImageBox(
              categoryProductList.leftTitle!.isNotEmpty
                  ? categoryProductList.leftTitle!
                  : "",
              categoryProductList.rightTile!.isNotEmpty
                  ? categoryProductList.rightTile!
                  : "",
              categoryProductList.singleImage!.isNotEmpty
                  ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${categoryProductList.singleImage![0]}"
                  : "",
              categoryProductList.hnName,
            ),
            productDetailBox(categoryProductList),
          ],
        ),
      ),
    );
  }

  productImageBox(String leftTitle, String rightTitle, String imageUrl, String? hindiName) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.height * 0.15,
      margin: EdgeInsets.all(05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xffCFCFCF),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Image.network(
              imageUrl,
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.height * 0.12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftTitle.isNotEmpty
                  ? Container(
                margin: EdgeInsets.only(top: 05),
                alignment: Alignment.center,
                width: 50,
                height: 15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/left_banner.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  leftTitle,
                  style: poppinsRegular.copyWith(
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              )
                  : SizedBox(),
              rightTitle.isNotEmpty
                  ? Container(
                margin: EdgeInsets.only(top: 05),
                alignment: Alignment.center,
                width: 50,
                height: 15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/right_banner.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  rightTitle,
                  style: poppinsRegular.copyWith(
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
                  : SizedBox(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: hindiName != null
                ? Container(
              padding: EdgeInsets.all(02),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                hindiName,
                style: poppinsMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Colors.white,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  productDetailBox(ProductData categoryProductList) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.32,
                  child: Text(
                    "${categoryProductList.name}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppinsRegular.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              categoryProductList.totalAddedWeight != 0.0 &&
                  !categoryProductList.appliedOneRupee! &&
                  !categoryProductList.appliedBulkRupee!
                  ? Expanded(
                child: Container(
                  padding: EdgeInsets.all(06),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(06),
                      bottomLeft: Radius.circular(06),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total ",
                        style: poppinsMedium.copyWith(
                            fontSize: 12, color: Colors.white),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 08),
                        decoration: BoxDecoration(
                          color: Color(0XFFFFDE4D),
                          // shape: BoxShape.oval,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.elliptical(15, 08),
                            topLeft: Radius.elliptical(15, 08),
                            bottomLeft: Radius.elliptical(15, 08),
                            bottomRight: Radius.elliptical(15, 08),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text:
                            "${categoryProductList.totalAddedWeight!}",
                            children: [
                              TextSpan(
                                text: categoryProductList.appliedUnit !=
                                    "gm"
                                    ? categoryProductList.appliedUnit!
                                    : "Kg",
                                style: poppinsMedium.copyWith(
                                  fontSize: 06,
                                  color: Color(0XFF80150E),
                                ),
                              ),
                            ],
                            style: poppinsMedium.copyWith(
                              fontSize: 10,
                              color: Color(0XFF80150E),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SizedBox(),
            ],
          ),
          categoryProductList.totalAddedWeight != 0.0
              ? SizedBox(
            height: 15,
          )
              : SizedBox(
            height: 20,
          ),
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, subIndex) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  categoryProductList.variations![subIndex]
                                      .quantity!.isNotEmpty
                                      ? weightBox(categoryProductList
                                      .variations![subIndex].quantity!)
                                      : "",
                                  style: poppinsRegular.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                weightBox(categoryProductList
                                    .variations![subIndex].quantity!)
                                    .contains("gm")
                                    ? Text(
                                  "(₹${approxBox(categoryProductList.variations![subIndex].quantity!, categoryProductList.variations![subIndex].offerPrice!)}/Kg)",
                                  style: poppinsRegular.copyWith(
                                      fontSize: 06,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                )
                                    : weightBox(categoryProductList
                                    .variations![subIndex]
                                    .quantity!)
                                    .contains("gm") ||
                                    weightBox(categoryProductList
                                        .variations![subIndex]
                                        .quantity!)
                                        .contains("Kg") &&
                                        weightBox(categoryProductList
                                            .variations![subIndex]
                                            .quantity!) !=
                                            "1 Kg"
                                    ? Text(
                                  "(₹${approxBox(categoryProductList.variations![subIndex].quantity!, categoryProductList.variations![subIndex].offerPrice!)}/Kg)",
                                  style: poppinsRegular.copyWith(
                                      fontSize: 06,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                )
                                    : SizedBox(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "₹${categoryProductList.variations![subIndex].offerPrice!.isNotEmpty ? double.parse(categoryProductList.variations![subIndex].offerPrice!) % 1 == 0 ? double.parse(categoryProductList.variations![subIndex].offerPrice!).toStringAsFixed(0) : double.parse(categoryProductList.variations![subIndex].offerPrice!).toStringAsFixed(2) : ""}",
                                  style: poppinsRegular.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                Text(
                                  " MRP ",
                                  style: poppinsRegular.copyWith(
                                    fontSize: 7,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff828282),
                                    decorationColor: Color(0xff828282),
                                  ),),
                                Text(
                                  "₹${categoryProductList.variations![subIndex].marketPrice!.toStringAsFixed(0).isNotEmpty ? categoryProductList.variations![subIndex].marketPrice!.toStringAsFixed(0) : ""}",
                                  style: poppinsRegular.copyWith(
                                    fontSize: 7,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff828282),
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Color(0xff828282),
                                  ),
                                )
                              ],
                            ),
                            categoryProductList.variations![subIndex]
                                .approxWeight!.isNotEmpty
                                ? Text(
                              categoryProductList
                                  .variations![subIndex].approxWeight!,
                              style: poppinsRegular.copyWith(
                                  fontSize: 06,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                                : SizedBox(),
                          ],
                        ),
                        Spacer(),
                        categoryProductList.variations![subIndex].quantity!
                            .isNotEmpty &&
                            categoryProductList.totalStock != null &&
                            double.parse(categoryProductList.totalStock!
                                .toString()) >=
                                double.parse(categoryProductList
                                    .variations![subIndex]
                                    .quantity!
                                    .isNotEmpty
                                    ? categoryProductList
                                    .variations![subIndex].quantity!
                                    : "0.0")
                            ? Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage("assets/image/discount.png"),
                              fit: BoxFit.fill,
                              colorFilter: _imageColorFilter,
                            ),
                          ),
                          child: Text(
                            _currentText != "Discount"
                                ? "${categoryProductList.variations![subIndex].discount!.toString().replaceAll("-", " ")}%"
                                : "OFF",
                            style: poppinsRegular.copyWith(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w500,
                                color: _textColor),
                          ),
                        )
                            : SizedBox(),
                        SizedBox(
                          width: 3,
                        ),
                        categoryProductList
                            .variations![subIndex].quantity!.isNotEmpty
                            ? categoryProductList.totalStock != null &&
                            double.parse(categoryProductList.totalStock!
                                .toString()) >=
                                double.parse(categoryProductList
                                    .variations![subIndex]
                                    .quantity!
                                    .isNotEmpty
                                    ? categoryProductList
                                    .variations![subIndex].quantity!
                                    : "0.0")
                            ? categoryProductList
                            .variations![subIndex].isSelected!
                            ? Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 63,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(3),
                            // color: Color(0xff0C4619),
                            border: Border.all(
                              color: Color(0xff0C4619),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (categoryProductList
                                        .variations![
                                    subIndex]
                                        .addCount !=
                                        1 &&
                                        categoryProductList
                                            .variations![
                                        subIndex]
                                            .addCount! <=
                                            10) {
                                      Provider.of<ProductProvider>(
                                          context,
                                          listen: false)
                                          .addToCart(
                                        categoryProductList,
                                        categoryProductList
                                            .variations![
                                        subIndex]
                                            .addCount! -
                                            1,
                                        "",
                                        weightBox(categoryProductList
                                            .variations![
                                        subIndex]
                                            .quantity!)
                                            .contains("gm")
                                            ? "gm"
                                            : "Kg",
                                        index: subIndex,
                                      );
                                    } else {
                                      Provider.of<ProductProvider>(
                                          context,
                                          listen: false)
                                          .removeFromCart(
                                        categoryProductList,
                                        "",
                                        index: subIndex,
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffDAEEDF),
                                      borderRadius:
                                      BorderRadius.only(
                                        topLeft:
                                        Radius.circular(3),
                                        bottomLeft:
                                        Radius.circular(3),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.remove,
                                      color: Color(0xff0C4619),
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${categoryProductList.variations![subIndex].addCount}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff0C4619),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (categoryProductList
                                        .variations![subIndex]
                                        .addCount! <
                                        10) {
                                      Provider.of<ProductProvider>(
                                          context,
                                          listen: false)
                                          .addToCart(
                                        categoryProductList,
                                        categoryProductList
                                            .variations![
                                        subIndex]
                                            .addCount! +
                                            1,
                                        "",
                                        weightBox(categoryProductList
                                            .variations![
                                        subIndex]
                                            .quantity!)
                                            .contains("gm")
                                            ? "gm"
                                            : "Kg",
                                        index: subIndex,
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffDAEEDF),
                                      borderRadius:
                                      BorderRadius.only(
                                        topRight:
                                        Radius.circular(3),
                                        bottomRight:
                                        Radius.circular(3),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xff0C4619),
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : GestureDetector(
                          onTap: () {
                            Provider.of<ProductProvider>(context,
                                listen: false)
                                .addToCart(
                              categoryProductList,
                              categoryProductList
                                  .variations![subIndex]
                                  .addCount! +
                                  1,
                              "",
                              weightBox(categoryProductList
                                  .variations![subIndex]
                                  .quantity!)
                                  .contains("gm")
                                  ? "gm"
                                  : "Kg",
                              index: subIndex,
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 25,
                            width: 63,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(3),
                                color: Color(0xff0C4619)),
                            child: Text(
                              "ADD",
                              style: poppinsRegular.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        )
                            : Container(
                          alignment: Alignment.center,
                          height: 20,
                          padding:
                          EdgeInsets.symmetric(horizontal: 05),
                          // width: 63,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color(0xffa54e4e),
                            border: Border.all(
                              color: Color(0xffa54e4e),
                            ),
                          ),
                          child: Text(
                            "Out Of Stock",
                            style: poppinsRegular.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        )
                            : Container(
                          alignment: Alignment.center,
                          height: 20,
                          padding: EdgeInsets.symmetric(horizontal: 05),
                          // width: 63,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            // color: Color(0xff4a9e60),
                            border: Border.all(
                              color: Color(0xff4a9e60),
                            ),
                          ),
                          child: Text(
                            "Coming Soon..",
                            style: poppinsRegular.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: categoryProductList.variations!.length),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  String weightBox(String weight) {
    String fixedWeight = "";
    if (weight.contains(".")) {
      if (double.parse(double.parse(weight)
                  .toStringAsFixed(3)
                  .toString()
                  .split(".")
                  .last) <=
              500 &&
          double.parse(double.parse(weight)
                  .toStringAsFixed(3)
                  .toString()
                  .split(".")
                  .first) <
              1) {
        fixedWeight =
            "${double.parse(weight).toStringAsFixed(3).toString().split(".").last}gm";
      } else if (double.parse(double.parse(weight)
                  .toStringAsFixed(3)
                  .toString()
                  .split(".")
                  .last) <=
              500 &&
          double.parse(double.parse(weight)
                  .toStringAsFixed(3)
                  .toString()
                  .split(".")
                  .first) >=
              1) {
        fixedWeight =
            "${double.parse(weight).toStringAsFixed(3).toString().split(".").first}Kg ${double.parse(weight).toStringAsFixed(3).toString().split(".").last}gm";
      }
    } else {
      fixedWeight = "$weight Kg";
    }
    return fixedWeight;
  }

  String approxBox(String weight, String price) {
    double fixedWeight = 0.00;
    if (weight.contains(".")) {
      if (double.parse(double.parse(weight)
          .toStringAsFixed(3)
          .toString()
          .split(".")
          .last) <=
          500 &&
          double.parse(double.parse(weight)
              .toStringAsFixed(3)
              .toString()
              .split(".")
              .first) <
              1) {
        fixedWeight = (double.parse(price) /
            double.parse(double.parse(weight).toStringAsFixed(2)));
      } else if (double.parse(double.parse(weight)
          .toStringAsFixed(3)
          .toString()
          .split(".")
          .last) <=
          500 &&
          double.parse(double.parse(weight)
              .toStringAsFixed(3)
              .toString()
              .split(".")
              .first) >=
              1) {
        fixedWeight = double.parse(price) / double.parse(weight);
      }
    } else {
      if (double.parse(double.parse(weight.isNotEmpty ? weight : "0.00")
          .toStringAsFixed(3)
          .toString()
          .split(".")
          .first) >=
          1) {
        fixedWeight = double.parse(price) / double.parse(weight);
      }
    }
    return fixedWeight % 1 == 0
        ? fixedWeight.toStringAsFixed(0)
        : fixedWeight.toStringAsFixed(2);
  }

  timingBox(String? eventDuration) {
    DateTime endTime = DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(eventDuration!);

    Timer? timer;
    Duration? duration = endTime.difference(DateTime.now());
    timer = null;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration = duration! - const Duration(seconds: 1);
    });
    int? days, hours, minutes, seconds;
    if (duration != null) {
      days = duration!.inDays;
      hours = duration!.inHours - days * 24;
      minutes = duration!.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = duration!.inSeconds -
          (24 * days * 60 * 60) -
          (hours * 60 * 60) -
          (minutes * 60);
    }
    return hours == 0
        ? minutes == 0 && hours == 0
        ? "${seconds.toString().replaceAll("-", "")}s"
        : "${minutes.toString().replaceAll("-", "")}m : ${seconds.toString().replaceAll("-", "")}s"
        : "${hours.toString().replaceAll("-", "")}h : ${minutes.toString().replaceAll("-", "")}m : ${seconds.toString().replaceAll("-", "")}s";
  }
}
