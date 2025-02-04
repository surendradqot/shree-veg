import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/new_category_product_modal.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/localization_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/screens/filters/filters_screen.dart';
import 'package:shreeveg/view/screens/home/widget/search_widget.dart';
import 'package:shreeveg/view/screens/product/product_details_screen.dart';

class CategoryListScreen extends StatefulWidget {
  final String? catId;
  final String? catName;
  final bool? whereFrom;

  const CategoryListScreen(
      {super.key,
      required this.catId,
      required this.catName,
      required this.whereFrom});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Timer _timer;
  String _currentText = "99.99%";

  // String _currentImage = "assets/image/ellipse.png";
  Color _textColor = Colors.white;
  double? fontSize = 5;
  ColorFilter? _imageColorFilter;
  bool isFirstVerticalItemUpdated = false;
  String? selectedIndex = "";

  Future apiCall() async {
    Provider.of<ProductProvider>(context, listen: false)
        .initCategoryProductList(
      widget.catId.toString(),
      context,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
      widget.catName!,
      widget.whereFrom,
    );
  }

  @override
  void initState() {
    super.initState();

    apiCall();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        selectedIndex = widget.catName;
        _currentText = _currentText == "99.99%" ? "Discount" : "99.99%";
        _textColor = _textColor == Colors.white ? Colors.black : Colors.white;
        fontSize = fontSize == 5 ? 4 : 5;
        _imageColorFilter = _imageColorFilter == null
            ? ColorFilter.mode(Color(0xffFDC94C), BlendMode.srcATop)
            : null;
      });
    });
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
    return Consumer<ProductProvider>(builder: (context, snapshot, child) {
      return DefaultTabController(
        length: snapshot.tabList.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Products',
              style: poppinsRegular.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            centerTitle: true,
            leading: BackButton(
              color: Colors.white,
            ),
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
                                  shape: BoxShape.circle, color: Colors.white),
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
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: snapshot.loader!
              ? Column(
                  children: [
                    // SizedBox(height: 5),
                    SearchWidget(),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            decoration:
                                const BoxDecoration(color: Color(0xffF3F3F3)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${snapshot.oneRupeeProductList.length + snapshot.bulkOfferProductList.length + snapshot.categoryProductList.length} items'),
                                InkWell(
                                  onTap: () => Navigator.of(context).pushNamed(
                                      RouteHelper.filter,
                                      arguments: const FilterScreen()),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(Images.filterIcon,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                          width: 20),
                                      Center(
                                          child: Text(
                                        ' Filter',
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: const Color(0xFF272727),
                                            fontWeight: FontWeight.w400),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                    SizedBox(height: 5),
                    tabBox(snapshot.tabList),
                    // SizedBox(height: 5),
                    snapshot.marqueeText!.isNotEmpty
                        ? marqueeBox(snapshot.marqueeText!)
                        : SizedBox(),
                    // SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Column(
                            children: [
                              selectedIndex == "Bulk Order\nLimited Time"
                                  ? SizedBox()
                                  : snapshot.oneRupeeProductList.isNotEmpty
                                      ? oneRupeeOfferBox(
                                          snapshot.oneRupeeProductList)
                                      : SizedBox(),
                              selectedIndex == "Bulk Order\nLimited Time"
                                  ? SizedBox()
                                  : snapshot.oneRupeeProductList.isNotEmpty
                                      ? SizedBox(height: 08)
                                      : SizedBox(),
                              selectedIndex == "1₹ Offer"
                                  ? SizedBox()
                                  : snapshot.bulkOfferProductList.isNotEmpty
                                      ? bulkOfferBox(
                                          snapshot.bulkOfferProductList)
                                      : SizedBox(),
                              selectedIndex == "1₹ Offer"
                                  ? SizedBox()
                                  : snapshot.bulkOfferProductList.isNotEmpty
                                      ? SizedBox(height: 08)
                                      : SizedBox(),
                              !widget.whereFrom!
                                  ? productList(snapshot.categoryProductList)
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
        ),
      );
    });
  }

  tabBox(List<String> tabList) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 05,
            );
          },
          shrinkWrap: true,
          itemCount: tabList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("********* ${tabList[index]} *********");
                setState(() {
                  selectedIndex = tabList[index];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: tabList[index] == "1₹ Offer"
                      ? Color(0xff14A236)
                      : tabList[index] == "Bulk Order\nLimited Time"
                          ? Color(0xffFDC94C)
                          : tabList[index] == widget.catName
                              ? Color(0xff0C4619)
                              : Color(0xffEAF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Tab(
                  child: Text(
                    tabList[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tabList[index] == widget.catName ||
                              tabList[index] == "1₹ Offer"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  marqueeBox(String marqueeText) {
    return SizedBox(
      height: 30,
      child: Marquee(
        text: marqueeText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        blankSpace: 20.0,
        velocity: 50.0,
        pauseAfterRound: Duration(seconds: 0),
        startPadding: 05,
        accelerationDuration: Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }

  oneRupeeOfferBox(List<ProductData> oneRupeeProductList) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 08,
          );
        },
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: oneRupeeProductList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => ProductDetailsScreen(
              //         product: oneRupeeProductList[index])));
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
                    oneRupeeProductList[index].leftTitle!.isNotEmpty
                        ? oneRupeeProductList[index].leftTitle!
                        : "",
                    oneRupeeProductList[index].rightTile!.isNotEmpty
                        ? oneRupeeProductList[index].rightTile!
                        : "",
                    oneRupeeProductList[index].singleImage!.isNotEmpty
                        ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${oneRupeeProductList[index].singleImage![0]}"
                        : "",
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
                                oneRupeeProductList[index].name!.isNotEmpty
                                    ? "${oneRupeeProductList[index].name!} ${oneRupeeProductList[index].hnName}"
                                    : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: poppinsRegular.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            oneRupeeProductList[index].appliedOneRupee! &&
                                    double.parse(oneRupeeProductList[index]
                                            .totalAddedWeight!
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total ",
                                          style: poppinsMedium.copyWith(
                                              fontSize: 08,
                                              color: Colors.white),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 08),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFFFDE4D),
                                            // shape: BoxShape.oval,
                                            borderRadius: BorderRadius.only(
                                              topRight:
                                                  Radius.elliptical(15, 08),
                                              topLeft:
                                                  Radius.elliptical(15, 08),
                                              bottomLeft:
                                                  Radius.elliptical(15, 08),
                                              bottomRight:
                                                  Radius.elliptical(15, 08),
                                            ),
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              text:
                                                  "${oneRupeeProductList[index].totalAddedWeight!}",
                                              children: [
                                                TextSpan(
                                                  text:
                                                  oneRupeeProductList[index]
                                                      .appliedUnit!="gm"?oneRupeeProductList[index]
                                                          .appliedUnit!:"Kg",
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
                        oneRupeeProductList[index].appliedOneRupee! &&
                                double.parse(oneRupeeProductList[index]
                                        .totalAddedWeight!
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
                                      timingBox(oneRupeeProductList[index]
                                          .offerTimeLimit),
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
                                      "MRP ₹${oneRupeeProductList[index].marketPrice}",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff828282),
                                          decoration:
                                              TextDecoration.lineThrough,
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
                                  image:
                                      AssetImage("assets/image/discount.png"),
                                  fit: BoxFit.fill,
                                  colorFilter: _imageColorFilter,
                                ),
                              ),
                              child: Text(
                                _currentText == "Discount"
                                    ? "Discount"
                                    : "${oneRupeeProductList[index].discount.toString()}%",
                                style: poppinsRegular.copyWith(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w500,
                                    color: _textColor),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            oneRupeeProductList[index].appliedOneRupee!
                                ? Container(
                                    alignment: Alignment.center,
                                    height: 22,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      // color: Color(0xff0C4619),
                                      border: Border.all(
                                        color: Color(0xff0C4619),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "ADDED",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff0C4619),
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
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Provider.of<ProductProvider>(context,
                                              listen: false)
                                          .addToCart(
                                              oneRupeeProductList[index],
                                              1,
                                              "oneRupeeOffer",
                                              oneRupeeProductList[index].unit);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 22,
                                      width: 60,
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
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        Text(
                          "* ₹${oneRupeeProductList[index].minPurchaseAmount} minimum purchase to claim the offer",
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
        });
  }

  bulkOfferBox(List<ProductData> bulkOfferProductList) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 08,
          );
        },
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: bulkOfferProductList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => ProductDetailsScreen(
              //         product: bulkOfferProductList[index])));
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
                    bulkOfferProductList[index].leftTitle!.isNotEmpty
                        ? bulkOfferProductList[index].leftTitle!
                        : "",
                    bulkOfferProductList[index].rightTile!.isNotEmpty
                        ? bulkOfferProductList[index].rightTile!
                        : "",
                    bulkOfferProductList[index].singleImage!.isNotEmpty
                        ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${bulkOfferProductList[index].singleImage![0]}"
                        : "",
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
                                  bulkOfferProductList[index].name!.isNotEmpty
                                      ? "${bulkOfferProductList[index].name!} ${bulkOfferProductList[index].hnName}"
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
                            bulkOfferProductList[index].appliedBulkRupee! &&
                                    double.parse(bulkOfferProductList[index]
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total ",
                                            style: poppinsMedium.copyWith(
                                                fontSize: 08,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 08),
                                            decoration: BoxDecoration(
                                              color: Color(0XFFFFDE4D),
                                              // shape: BoxShape.oval,
                                              borderRadius: BorderRadius.only(
                                                topRight:
                                                    Radius.elliptical(15, 08),
                                                topLeft:
                                                    Radius.elliptical(15, 08),
                                                bottomLeft:
                                                    Radius.elliptical(15, 08),
                                                bottomRight:
                                                    Radius.elliptical(15, 08),
                                              ),
                                            ),
                                            child: RichText(
                                              text: TextSpan(
                                                text: bulkOfferProductList[index]
                                                    .totalAddedWeight!
                                                    .toStringAsFixed(0),
                                                children: [
                                                  TextSpan(
                                                    text: bulkOfferProductList[
                                                    index]
                                                        .appliedUnit!="gm"?bulkOfferProductList[
                                                            index]
                                                        .appliedUnit!:"Kg",
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
                        bulkOfferProductList[index].appliedBulkRupee! &&
                                double.parse(bulkOfferProductList[index]
                                        .totalAddedWeight!
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
                                      text: bulkOfferProductList[index]
                                              .quantity!
                                              .isNotEmpty
                                          ? bulkOfferProductList[index]
                                              .quantity!
                                          : "",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: bulkOfferProductList[index]
                                                  .quantity!
                                                  .isNotEmpty
                                              ? bulkOfferProductList[index]
                                                  .unit!
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
                                  "(Shree Veg - ₹${double.parse(bulkOfferProductList[index].amount!) / double.parse(bulkOfferProductList[index].quantity!)}/${bulkOfferProductList[index].unit!})",
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
                                      bulkOfferProductList[index]
                                              .quantity!
                                              .isNotEmpty
                                          ? "₹${bulkOfferProductList[index].amount!}"
                                          : "",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "MRP ₹${(double.parse(bulkOfferProductList[index].quantity!) * double.parse(bulkOfferProductList[index].marketPrice!.toStringAsFixed(2))).toStringAsFixed(0)}",
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
                                  image:
                                      AssetImage("assets/image/discount.png"),
                                  fit: BoxFit.fill,
                                  colorFilter: _imageColorFilter,
                                ),
                              ),
                              child: Text(
                                _currentText,
                                style: poppinsRegular.copyWith(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w500,
                                    color: _textColor),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                    bulkOfferProductList[index].appliedBulkRupee!
                                ? Container(
                                    alignment: Alignment.center,
                                    height: 22,
                                    width: 60,
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
                                              if (bulkOfferProductList[index]
                                                      .appliedBulkRupeeCount !=
                                                  1) {
                                                Provider.of<
                                                            ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .addToCart(
                                                        bulkOfferProductList[
                                                            index],
                                                        (bulkOfferProductList[
                                                                    index]
                                                                .appliedBulkRupeeCount! -
                                                            1),
                                                        "bulkOffer",
                                                        bulkOfferProductList[
                                                                index]
                                                            .unit);
                                              } else {
                                                Provider.of<
                                                    ProductProvider>(
                                                    context,
                                                    listen: false)
                                                    .removeFromCart(
                                                    bulkOfferProductList[
                                                    index],
                                                    "bulkOffer",
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffDAEEDF),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(3),
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
                                              "${bulkOfferProductList[index].appliedBulkRupeeCount}",
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
                                              if (bulkOfferProductList[index]
                                                      .appliedBulkRupeeCount! <
                                                  10) {
                                                Provider.of<
                                                            ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .addToCart(
                                                        bulkOfferProductList[
                                                            index],
                                                        (bulkOfferProductList[
                                                                    index]
                                                                .appliedBulkRupeeCount! +
                                                            1),
                                                        "bulkOffer",
                                                        bulkOfferProductList[
                                                                index]
                                                            .unit);
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffDAEEDF),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(3),
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
                                              bulkOfferProductList[index],
                                              1,
                                              "bulkOffer",
                                              bulkOfferProductList[index].unit);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 22,
                                      width: 60,
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
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        bulkOfferProductList[index].appliedBulkRupee! &&
                            double.parse(bulkOfferProductList[index]
                                .totalAddedWeight!
                                .toStringAsFixed(0)) >=
                                0
                            ? SizedBox(
                          height: 15,
                        )
                            : SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  productList(List<ProductData> categoryProductList) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return productBox(categoryProductList[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 08,
        );
      },
      itemCount: categoryProductList.length,
    );
  }

/*GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(product: categoryProductList)));
      },*/
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
              categoryProductList.leftTitle!.isNotEmpty
                  ? categoryProductList.leftTitle!
                  : "",
              categoryProductList.singleImage!.isNotEmpty
                  ? "${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/single/${categoryProductList.singleImage![0]}"
                  : "",
            ),
            productDetailBox(categoryProductList),
          ],
        ),
      ),
    );
  }

  productImageBox(String leftTitle, String rightTitle, String imageUrl) {
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
                    "${categoryProductList.name} ${categoryProductList.hnName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppinsRegular.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              categoryProductList.totalAddedWeight!=0.0
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
                                  fontSize: 08, color: Colors.white),
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
                                  text: "${categoryProductList.totalAddedWeight!}",
                                  children: [
                                    TextSpan(
                                      text: categoryProductList.appliedUnit!="gm"?categoryProductList.appliedUnit!:"Kg",
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
          SizedBox(
            height: 15,
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
                                        "(₹${approxBox(categoryProductList.variations![subIndex].quantity!, categoryProductList.variations![subIndex].offerPrice!).toStringAsFixed(0)}/Kg)",
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
                                            "(₹${approxBox(categoryProductList.variations![subIndex].quantity!, categoryProductList.variations![subIndex].offerPrice!).toStringAsFixed(0)}/Kg)",
                                            style: poppinsRegular.copyWith(
                                                fontSize: 06,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          )
                                        : SizedBox(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "₹${categoryProductList.variations![subIndex].offerPrice!.isNotEmpty ? categoryProductList.variations![subIndex].offerPrice : ""}",
                                  style: poppinsRegular.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                Text(
                                  "MRP ₹${categoryProductList.variations![subIndex].marketPrice!.toStringAsFixed(0).isNotEmpty ? categoryProductList.variations![subIndex].marketPrice!.toStringAsFixed(0) : ""}",
                                  style: poppinsRegular.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff828282),
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Color(0xff828282)),
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
                            _currentText != "Discount"
                                ? "${categoryProductList.variations![subIndex].discount!.replaceAll("-", " ")}%"
                                : "Discount",
                            style: poppinsRegular.copyWith(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w500,
                                color: _textColor),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                categoryProductList.variations![subIndex].isSelected!
                            ? Container(
                                alignment: Alignment.center,
                                height: 22,
                                width: 60,
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
                                        onTap:(){
                                          if(categoryProductList
                                              .variations![subIndex].addCount!=1 && categoryProductList
                                              .variations![subIndex].addCount!<=10){
                                            Provider.of<ProductProvider>(context,
                                                listen: false)
                                                .addToCart(
                                              categoryProductList,
                                              categoryProductList.variations![subIndex].addCount!-1,
                                              "",
                                              weightBox(categoryProductList
                                                  .variations![subIndex]
                                                  .quantity!)
                                                  .contains("gm")
                                                  ? "gm"
                                                  : "Kg",
                                              index: subIndex,
                                            );
                                          }
                                          else{
                                            Provider.of<ProductProvider>(context,
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
                                        onTap:(){
                                          if(categoryProductList
                                              .variations![subIndex].addCount!<10){
                                            Provider.of<ProductProvider>(context,
                                                listen: false)
                                                .addToCart(
                                              categoryProductList,
                                              categoryProductList.variations![subIndex].addCount!+1,
                                              "",
                                              weightBox(categoryProductList
                                                  .variations![subIndex]
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
                                      .addToCart(
                                          categoryProductList,
                                    categoryProductList.variations![subIndex].addCount!+1,
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
                                  height: 22,
                                  width: 60,
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
            "${double.parse(weight).toStringAsFixed(3).toString().split(".").first}Kg${double.parse(weight).toStringAsFixed(3).toString().split(".").last}gm";
      }
    } else {
      fixedWeight = "$weight Kg";
    }
    return fixedWeight;
  }

  double approxBox(String weight, String price) {
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
    return fixedWeight;
  }

  timingBox(String? eventDuration) {
    DateTime endTime = DateFormat("yyyy-MM-dd")
        .parse(eventDuration!)
        .add(const Duration(days: 1));

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
    return "${hours}h : ${minutes}m : ${seconds}s";
  }
}
