import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/new_category_product_modal.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/search_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/modify_date_times.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/app_bar_base.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/not_login_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/cart/widget/cart_stores_view.dart';
import 'package:shreeveg/view/screens/checkout/checkout_screen.dart';
import 'package:shreeveg/view/screens/home/home_screens.dart';
import 'package:shreeveg/view/screens/product/product_details_screen.dart';
import 'package:shreeveg/view/screens/splash/splash_screen.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  String _currentText = "99.99%";
  Color _textColor = Colors.white;
  double? fontSize = 5;
  ColorFilter? _imageColorFilter;
  bool isFirstVerticalItemUpdated = false;
  Timer? timer;

  Future apiCall() async {
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
    await Provider.of<SearchProvider>(context, listen: false)
        .initializeAllSortBy(notify: false);
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentText = _currentText == "99.99%" ? "Discount" : "99.99%";
        _textColor = _textColor == Colors.white ? Colors.black : Colors.white;
        fontSize = fontSize == 5 ? 4 : 5;
        _imageColorFilter = _imageColorFilter == null
            ? ColorFilter.mode(Color(0xffFDC94C), BlendMode.srcATop)
            : null;
      });
    });
    apiCall();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  int selectedIndex = -1;
  int selectedStoreIndex = -1;
  bool? isLoggedIn = false;
  bool? noData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? AppBar(
              title: Text(
                getTranslated('my_cart', context)!,
                style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Colors.white),
              ),
              actions: [
                Consumer<ProfileProvider>(
                  builder: (context, provider, child) {
                    return GestureDetector(
                      onTap: () {
                        showCityDialog(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 04, vertical: 08),
                        margin: EdgeInsets.all(08),
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(08),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF0B4619),
                              ),
                            ),
                            Text(
                              sharedPreferences!.getString(
                                      AppConstants.selectedCityName) ??
                                  "Select City",
                              style: poppinsRegular.copyWith(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
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
                    );
                  },
                ),
              ],
            )
          : (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : const AppBarBase()) as PreferredSizeWidget?,
      body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
        double? totalMarketPrice = 0.0;
        double? totalUnit = 0.0;
        double? totalOfferPrice = 0.0;
        double? totalDeliveryCharges = 0.0;
        double? totalDeliveryFee = 0.0;
        double? totalDiscount = 0.0;
        if (cartProvider.newCartList.isNotEmpty) {
          for (CartModalNew cartData in cartProvider.newCartList) {
            totalDiscount = cartData.totalDiscount! + totalDiscount!;
            totalUnit = cartData.totalUnit! + totalUnit!;
            totalMarketPrice = cartData.itemPrice! + totalMarketPrice!;
            totalOfferPrice = cartData.totalPrice! + totalOfferPrice!;
            totalDeliveryCharges =
                cartData.deliveryCharge! + totalDeliveryCharges!;
          }
        }
        if (cartProvider.newOfferCartList.isNotEmpty) {
          for (CartModalNew cartData in cartProvider.newOfferCartList) {
            totalDiscount = cartData.totalDiscount! + totalDiscount!;
            totalUnit = cartData.totalUnit! + totalUnit!;
            totalMarketPrice = cartData.itemPrice! + totalMarketPrice!;
            totalOfferPrice = cartData.totalPrice! + totalOfferPrice!;
            totalDeliveryCharges =
                cartData.deliveryCharge! + totalDeliveryCharges!;
          }
        }
        if (totalDiscount != 0.0) {
          totalDiscount = totalDiscount! / cartProvider.cartLength!;
        }
        return
             cartProvider.cartLength != 0
                ? Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cartProvider.newCartList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: productList(cartProvider
                                            .newCartList[index].productData!),
                                      );
                                    }),
                                cartProvider.newOfferCartList.isNotEmpty
                                    ? Text(
                                        "OFFER",
                                        style: poppinsRegular.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      )
                                    : SizedBox(),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        cartProvider.newOfferCartList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: cartProvider
                                                    .newOfferCartList[index]
                                                    .productData!
                                                    .oneRsOfferEnable ==
                                                1
                                            ? oneRupeeOfferBox(
                                                cartProvider
                                                    .newOfferCartList[index]
                                                    .productData!,
                                                totalOfferPrice)
                                            : bulkOfferBox(cartProvider
                                                .newOfferCartList[index]
                                                .productData!),
                                      );
                                    }),
                                SizedBox(
                                  height: 20,
                                ),
                                DottedLine(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: Color(0xFFB5B5B5),
                                  // Updated color
                                  dashGradient: null,
                                  // Ensure no gradient overrides the dashColor
                                  dashRadius: 0.0,
                                  dashGapLength: 4.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapGradient: null,
                                  // Ensure no gradient overrides the dashGapColor
                                  dashGapRadius: 0.0,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Bill Details",
                                      style: poppinsRegular.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xffF64A4D)),
                                      child: Row(
                                        children: [
                                          Text(
                                            "MRP ",
                                            style: poppinsRegular.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "₹${totalMarketPrice!.toStringAsFixed(0)}",
                                            style: poppinsRegular.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Items (in unit)",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 14,
                                          color: Color(0xff37474F)),
                                    ),
                                    Text(
                                      "${totalUnit}kg",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff3C3C3C)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Shree Veg Price",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 14,
                                          color: Color(0xff37474F)),
                                    ),
                                    Text(
                                      "₹${totalOfferPrice!.toStringAsFixed(1)}",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff14A236)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Delivery Charge",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 14,
                                          color: Color(0xff37474F)),
                                    ),
                                    Text(
                                      "₹$totalDeliveryCharges",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff14A236)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Delivery Fee",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 14,
                                          color: Color(0xff37474F)),
                                    ),
                                    Text(
                                      "₹Free",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff14A236)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffDAEEDF),
                                      border: Border.all(
                                          color: Color(0xff0C4619)
                                              .withOpacity(0.37))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Additional Discount",
                                            style: poppinsRegular.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "₹${0}",
                                            style: poppinsRegular.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff14A236)),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "(*Applicable on Advance Payment or Self Pick-Up)",
                                        style: poppinsRegular.copyWith(
                                            fontSize: 9,
                                            color: Color(0xff4E4E4E)),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DottedLine(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: Color(0xFFB5B5B5),
                                  // Updated color
                                  dashGradient: null,
                                  // Ensure no gradient overrides the dashColor
                                  dashRadius: 0.0,
                                  dashGapLength: 4.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapGradient: null,
                                  // Ensure no gradient overrides the dashGapColor
                                  dashGapRadius: 0.0,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Select Stores",
                                  style: poppinsRegular.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CartStoreOptions(),
                                CartDeliveryTimeSlot(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5))),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: Color(0xff0C4619)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Discount",
                                        style: poppinsRegular.copyWith(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        "${totalDiscount!.toStringAsFixed(2)}%",
                                        style: poppinsRegular.copyWith(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    // flex:2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Grand Total: ₹${totalOfferPrice.toStringAsFixed(2)}",
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          style: poppinsRegular.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "(Incl. of all taxes)",
                                          style: poppinsRegular.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (cartProvider.selectedStoreId ==
                                          null) {
                                        ToastService().show(
                                            'Please select store to pickup');
                                      } else if (cartProvider
                                              .selectedDeliveryTimeSlot ==
                                          null) {
                                        ToastService().show(
                                            'Please select upcoming delivery time slot');
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CheckoutScreen(
                                              amount: totalOfferPrice!,
                                              orderType: "self_pickup",
                                              discount: totalDiscount,
                                              couponCode: "",
                                              freeDeliveryType: "",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 08, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xff14A236)),
                                      child: Text(
                                        "Place Your Order",
                                        style: poppinsRegular.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: const NoDataScreen(isCart: true),
                  )
            ;
      }),
    );
  }

  listContainerBulkOrder(int index) {
    return Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff0C4619))),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: 115,
                width: 118,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffCFCFCF))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/image/apple_img.png",
                      width: 82,
                      height: 60,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 15,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/premium.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text(
                    "Premium",
                    style: poppinsRegular.copyWith(
                        fontSize: 7,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Papaya",
                      style: poppinsRegular.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Total: ',
                        style: poppinsRegular.copyWith(
                            fontSize: 12, color: Colors.black),
                        children: [
                          TextSpan(
                            text: '4kg',
                            style: poppinsRegular.copyWith(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("500gm",
                            style: poppinsRegular.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        Row(
                          children: [
                            Text("₹2550.00",
                                style: poppinsRegular.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            SizedBox(
                              width: 1,
                            ),
                            Text("MRP ₹2650",
                                style: poppinsRegular.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff828282),
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Color(0xff828282)))
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 27,
                          width: 27,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/image/ellipse.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Text(
                            "99.99%",
                            style: poppinsRegular.copyWith(
                                fontSize: 6,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            alignment: Alignment.center,
                            height: 22,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
                                border: Border.all(color: Color(0xff0C4619))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 22,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(3),
                                          bottomLeft: Radius.circular(3)),
                                      color: Color(0xffDAEEDF)),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                  ),
                                ),
                                Text(
                                  "1",
                                  style: poppinsRegular.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Colors.black),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(3),
                                          bottomRight: Radius.circular(3)),
                                      color: Color(0xffDAEEDF)),
                                  height: 22,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '3 kg',
                            style: poppinsRegular.copyWith(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: '(₹330.00 par kg)',
                                style: poppinsRegular.copyWith(
                                    fontSize: 9,
                                    color: Color(0xffF64A4D),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text("₹2550.00",
                                style: poppinsRegular.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            SizedBox(
                              width: 1,
                            ),
                            Text("MRP ₹2650",
                                style: poppinsRegular.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff828282),
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Color(0xff828282)))
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 27,
                          width: 27,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/image/ellipse.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Text(
                            "99.99%",
                            style: poppinsRegular.copyWith(
                                fontSize: 6,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            alignment: Alignment.center,
                            height: 22,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
                                border: Border.all(color: Color(0xff0C4619))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 22,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(3),
                                          bottomLeft: Radius.circular(3)),
                                      color: Color(0xffDAEEDF)),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                  ),
                                ),
                                Text(
                                  "1",
                                  style: poppinsRegular.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Colors.black),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(3),
                                          bottomRight: Radius.circular(3)),
                                      color: Color(0xffDAEEDF)),
                                  height: 22,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  offerContainer() {
    return Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xffDCF1E1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff14A236))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 115,
                width: 118,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffCFCFCF))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      "assets/image/apple_img.png",
                      width: 82,
                      height: 57,
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/image/premium.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      "",
                      style: poppinsRegular.copyWith(
                          fontSize: 7,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: 118,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Color(0xffF64A4D)),
                  child: Text(
                    "Not Eligible",
                    style: poppinsRegular.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Papaya",
                        style: poppinsRegular.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "1st kg",
                        style: poppinsRegular.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
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
                            "MRP ₹50",
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
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
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
                                    "11h  :  15m  :  10s",
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 27,
                            width: 27,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/image/ellipse.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Text(
                              "99.99%",
                              style: poppinsRegular.copyWith(
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
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
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.52,
                child: Text(
                  "* ₹100.00 minimum purchase to claim the offer",
                  style: poppinsRegular.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    color: Color(0xffF64A4D),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  selectedStoreList(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9), color: Colors.white),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  "https://shreeveg.dqot.solutions/storage/app/public/product/2024-12-16-675ff37518d8d.png",
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedStoreIndex = index;
                      });
                    },
                    child: selectedStoreIndex == index
                        ? Container(
                            padding: EdgeInsets.all(2),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Color(0xff14A236))),
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff14A236)),
                            ),
                          )
                        : Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Store Name",
              style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black),
            ),
            Text(
              "Store Address",
              style: poppinsRegular.copyWith(
                  fontSize: 8, color: Color(0xff6C6C6C)),
            ),
          ],
        ),
      ),
    );
  }

  storeTimingContainer(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              border: Border.all(
                  color:
                      selectedIndex == index ? Color(0xff14A236) : Colors.white,
                  width: selectedIndex == index ? 2 : 1)),
          child: Column(
            children: [
              Text(
                "Morning",
                style: poppinsRegular.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Text(
                "7:00 AM - 10:00 AM",
                style: poppinsRegular.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff37474F)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  oneRupeeOfferBox(ProductData oneRupeeProductList, double? totalPrice) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(product: oneRupeeProductList)));
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
              totalItemsPrice: totalPrice,
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
                              ? "${oneRupeeProductList.name!} ${oneRupeeProductList.hnName}"
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
                                        fontSize: 08, color: Colors.white),
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
                                "MRP ₹${oneRupeeProductList.marketPrice}",
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
                              ? "Discount"
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
                                        oneRupeeProductList,
                                        1,
                                        "oneRupeeOffer",
                                        oneRupeeProductList.unit);
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
                  Text(
                    "* ₹${oneRupeeProductList.minPurchaseAmount} minimum purchase to claim the offer",
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(product: bulkOfferProductList)));
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
                                ? "${bulkOfferProductList.name!} ${bulkOfferProductList.hnName}"
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
                                          fontSize: 08, color: Colors.white),
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
                            "(Shree Veg - ₹${double.parse(bulkOfferProductList.amount!) / double.parse(bulkOfferProductList.quantity!)}/${bulkOfferProductList.unit!})",
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
                                    ? "₹${bulkOfferProductList.amount!}"
                                    : "",
                                style: poppinsRegular.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                "MRP ₹${(double.parse(bulkOfferProductList.quantity!) * double.parse(bulkOfferProductList.marketPrice!.toStringAsFixed(2))).toStringAsFixed(0)}",
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
                      bulkOfferProductList.appliedBulkRupee!
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

  productImageBox(String leftTitle, String rightTitle, String imageUrl,
      {double? totalItemsPrice}) {
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
          totalItemsPrice != null && totalItemsPrice < 100
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Color(0xffF64A4D)),
                    child: Text(
                      "Not Eligible",
                      style: poppinsRegular.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              : SizedBox(),
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
              categoryProductList.totalAddedWeight != 0.0
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
                                        onTap: () {
                                          if (categoryProductList
                                                      .variations![subIndex]
                                                      .addCount !=
                                                  1 &&
                                              categoryProductList
                                                      .variations![subIndex]
                                                      .addCount! <=
                                                  10) {
                                            Provider.of<ProductProvider>(
                                                    context,
                                                    listen: false)
                                                .addToCart(
                                              categoryProductList,
                                              categoryProductList
                                                      .variations![subIndex]
                                                      .addCount! -
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
                                    categoryProductList
                                            .variations![subIndex].addCount! +
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

/*  productImageBox(String leftTitle, String rightTitle, String imageUrl) {
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
            right: 0,
            left: 0,
            child: Container(
              alignment: Alignment.center,
              height: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Color(0xffF64A4D)),
              child: Text(
                "Not Eligible",
                style: poppinsRegular.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.32,
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
              2 % 2 == 0 && 2 % 2 == 0
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
                                text: "12.5",
                                children: [
                                  TextSpan(
                                    text: "Kg",
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
                                        "(₹${approxBox(categoryProductList.variations![subIndex].quantity!, categoryProductList.variations![subIndex].offerPrice!).toStringAsFixed(2)}/Kg)",
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
                                            "(₹${approxBox(categoryProductList.variations![subIndex].quantity!, categoryProductList.variations![subIndex].offerPrice!).toStringAsFixed(2)}/Kg)",
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
                        3 % 2 == 0 && 5 % 2 == 0
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
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "20",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff0C4619),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
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
                                  ],
                                ),
                              )
                            : Container(
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
  }*/

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

    Duration? duration = endTime.difference(DateTime.now());
    int? days, hours, minutes, seconds;
    days = duration.inDays;
    hours = duration.inHours - days * 24;
    minutes = duration.inMinutes - (24 * days * 60) - (hours * 60);
    seconds = duration.inSeconds -
        (24 * days * 60 * 60) -
        (hours * 60 * 60) -
        (minutes * 60);
    return "${hours}h : ${minutes}m : ${seconds}s";
  }
}

class CartDeliveryTimeSlot extends StatelessWidget {
  const CartDeliveryTimeSlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      int deliverySlotRows = 0;
      return Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          int timeSlotsLength = 0;
          if (profileProvider.userInfoModel != null &&
              profileProvider.userInfoModel!.deliveryTime!.isNotEmpty) {
            timeSlotsLength =
                profileProvider.userInfoModel!.deliveryTime!.length;
            print('time slots length is: $timeSlotsLength');
            if (timeSlotsLength.isEven) {
              deliverySlotRows = timeSlotsLength ~/ 2;
            } else {
              deliverySlotRows = (timeSlotsLength ~/ 2) + 1;
            }
          }
          return profileProvider.userInfoModel != null &&
                  profileProvider.userInfoModel!.deliveryTime!.isNotEmpty
              ? Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(Images.deliveryVan,
                            height: 20, width: 24, fit: BoxFit.fill),
                        const SizedBox(
                          width: Dimensions.paddingSizeExtraSmall,
                        ),
                        Text(
                          getTranslated('select_delivery_slot', context)!,
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeSmall,
                    ),
                    SizedBox(
                      height: (70 * deliverySlotRows).toDouble(),
                      child: Wrap(
                          children: List.generate(
                              timeSlotsLength,
                              (index) => InkWell(
                                    onTap: () {
                                      if (isSlotEnabled(profileProvider
                                          .userInfoModel!
                                          .deliveryTime![index]
                                          .open!)) {
                                        cartProvider.updateSelectedDeliveryTimeSlot(
                                            '${profileProvider.userInfoModel!.deliveryTime![index].open} - ${profileProvider.userInfoModel!.deliveryTime![index].close}');
                                      } else {
                                        ToastService().show(
                                            'Time slot closed at: ${getFormattedTimes(profileProvider.userInfoModel!.deliveryTime![index].open!, profileProvider.userInfoModel!.deliveryTime![index].close!, true, int.parse(profileProvider.userInfoModel!.deliveryTime![index].hideOptionBefore!))}');
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: cartProvider
                                                            .selectedDeliveryTimeSlot !=
                                                        null &&
                                                    cartProvider
                                                            .selectedDeliveryTimeSlot ==
                                                        '${profileProvider.userInfoModel!.deliveryTime![index].open} - ${profileProvider.userInfoModel!.deliveryTime![index].close}' &&
                                                    isSlotEnabled(
                                                        profileProvider
                                                            .userInfoModel!
                                                            .deliveryTime![
                                                                index]
                                                            .open!)
                                                ? const Color(
                                                    0xFFF1FFF4) // Color if the slot is both selected and enabled
                                                : isSlotEnabled(profileProvider
                                                        .userInfoModel!
                                                        .deliveryTime![index]
                                                        .open!)
                                                    ? Colors
                                                        .grey // Color if the slot is enabled but not selected
                                                    : Colors.grey.shade200,
                                            border: Border.all(
                                              width: 1,
                                              color: cartProvider
                                                              .selectedDeliveryTimeSlot !=
                                                          null &&
                                                      cartProvider
                                                              .selectedDeliveryTimeSlot ==
                                                          '${profileProvider.userInfoModel!.deliveryTime![index].open} - ${profileProvider.userInfoModel!.deliveryTime![index].close}' &&
                                                      isSlotEnabled(
                                                          profileProvider
                                                              .userInfoModel!
                                                              .deliveryTime![
                                                                  index]
                                                              .open!)
                                                  ? const Color(
                                                      0xFF039800) // Color if the slot is both selected and enabled
                                                  : isSlotEnabled(
                                                          profileProvider
                                                              .userInfoModel!
                                                              .deliveryTime![
                                                                  index]
                                                              .open!)
                                                      ? Colors
                                                          .grey // Color if the slot is enabled but not selected
                                                      : Colors.grey.shade300,
                                            )),
                                        // Default color (blue) if the slot is not enabled),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          child: Column(
                                            children: [
                                              Text(
                                                  getTimePeriod(profileProvider
                                                      .userInfoModel!
                                                      .deliveryTime![index]
                                                      .open!),
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall)),
                                              Text(
                                                  getFormattedTimes(
                                                      profileProvider
                                                          .userInfoModel!
                                                          .deliveryTime![index]
                                                          .open!,
                                                      profileProvider
                                                          .userInfoModel!
                                                          .deliveryTime![index]
                                                          .close!,
                                                      false,
                                                      0),
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeSmall,
                    ),
                  ],
                )
              : SizedBox();
        },
      );
    });
  }
}

/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/config_model.dart';
import 'package:shreeveg/helper/price_converter.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/coupon_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/app_bar_base.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_directionality.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/cart/widget/cart_product_widget.dart';
import 'package:provider/provider.dart';
import '../../../data/model/body/place_order_body.dart';
import '../../../main.dart';
import '../../../provider/location_provider.dart';
import '../../../utill/images.dart';
import '../../../utill/modify_date_times.dart';
import '../../base/custom_dialog.dart';
import '../checkout/checkout_screen.dart';
import '../checkout/order_successful_screen.dart';
import '../checkout/widget/digital_payment_view.dart';
import '../checkout/widget/offline_payment_dialog.dart';
import '../home/widget/location_view.dart';
import 'widget/cart_details_view.dart';
import 'dart:developer';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    _couponController.clear();
    // Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);

    Provider.of<OrderProvider>(context, listen: false)
        .setAddressIndex(0, notify: false);

    // if (Provider.of<SplashProvider>(context, listen: false)
    //         .configModel!
    //         .cashOnDelivery ==
    //     'true') {
    //   _paymentList.add('cash_on_delivery');
    // }
    //
    // if (Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .offlinePayment!) {
    //   _paymentList.add('offline_payment');
    // }
    //
    // if (Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .walletStatus!) {
    //   _paymentList.add('wallet_payment');
    // }
    //
    // for (var method in Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .activePaymentMethodList!) {
    //   if (!_paymentList.contains(method)) {
    //     _paymentList.add(method);
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    bool isSelfPickupActive = configModel.selfPickup == 1;
    bool kmWiseCharge = configModel.deliveryManagement!.status!;

    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? AppBar(
        title: Text(getTranslated('my_cart', context)!,style: poppinsMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color:
            Colors.white)),
      )
          : (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : const AppBarBase()) as PreferredSizeWidget?,
      body: Center(
        child: Consumer<CouponProvider>(builder: (context, couponProvider, _) {
          return Consumer<CartProvider>(
            builder: (context, cart, child) {
              double? deliveryCharge = 0;
              (Provider.of<OrderProvider>(context).orderType == 'delivery' && //8696491163
                      !kmWiseCharge)
                  ? deliveryCharge = configModel.deliveryCharge
                  : deliveryCharge = 0;

              if (couponProvider.couponType == 'free_delivery') {
                deliveryCharge = 0;
              }

              double itemPrice = 0;
              double marketPrice = 0;
              double shreePrice = 0;
              double discount = 0;
              double tax = 0;
              String? unit = '';
              double totalWeight = 0;
              for (var cartModel in cart.cartList) {
                itemPrice =
                    itemPrice + (cartModel.price! * cartModel.quantity!);
                marketPrice = marketPrice +
                    (cartModel.variation!.marketPrice! * cartModel.quantity!);
                shreePrice = shreePrice +
                    (double.parse(cartModel.variation!.offerPrice!) *
                        cartModel.quantity!);
                discount =
                    discount + (cartModel.discount! * cartModel.quantity!);
                tax = tax + (cartModel.tax! * cartModel.quantity!);
                unit = cartModel.product!.unit;
                totalWeight = totalWeight +
                    (cartModel.quantity! *
                        double.parse((cartModel.variation?.quantity!)!));
              }

              double subTotal =
                  itemPrice + (configModel.isVatTexInclude! ? 0 : tax);
              bool isFreeDelivery =
                  subTotal >= configModel.freeDeliveryOverAmount! &&
                          configModel.freeDeliveryStatus! ||
                      couponProvider.couponType == 'free_delivery';

              double total = subTotal -
                  discount -
                  Provider.of<CouponProvider>(context).discount! +
                  (isFreeDelivery ? 0 : deliveryCharge!);

              return cart.cartList.isNotEmpty
                  ? !ResponsiveHelper.isDesktop(context)
                      ? Column(children: [
                          const LocationView(locationColor: Colors.black54),
                          Expanded(
                              child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall,
                            ),
                            child: Center(
                                child: SizedBox(
                              width: Dimensions.webScreenWidth,
                              child: Column(children: [
                                // Product
                                const CartProductListView(),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),

                                CartDetailsView(
                                  couponController: _couponController,
                                  total: total,
                                  unit: unit!,
                                  totalWeight: totalWeight,
                                  isSelfPickupActive: isSelfPickupActive,
                                  kmWiseCharge: kmWiseCharge,
                                  isFreeDelivery: isFreeDelivery,
                                  itemPrice: itemPrice,
                                  totalMarketPrice: marketPrice,
                                  totalShreePrice: shreePrice,
                                  tax: tax,
                                  discount: discount,
                                  deliveryCharge: deliveryCharge!,
                                ),
                                const SizedBox(height: 40),
                                const CartDeliveryTimeSlot(),
                                // PaymentOptions(paymentList: _paymentList),
                                const DeliveryLocationView(
                                    locationColor: Colors.black54),
                              ]),
                            )),
                          )),
                          CartButtonView(
                            subTotal: subTotal,
                            configModel: configModel,
                            itemPrice: itemPrice,
                            total: total,
                            isFreeDelivery: isFreeDelivery,
                          ),
                        ])
                      : SingleChildScrollView(
                          child: Column(children: [
                          Center(
                              child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: ResponsiveHelper.isDesktop(context)
                                  ? MediaQuery.of(context).size.height - 560
                                  : MediaQuery.of(context).size.height,
                            ),
                            child: SizedBox(
                                width: 1170,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeLarge),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: CartProductListView()),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey[
                                                        Provider.of<ThemeProvider>(
                                                                    context)
                                                                .darkTheme
                                                            ? 900
                                                            : 300]!,
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  )
                                                ],
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeSmall,
                                              ).copyWith(
                                                      bottom: Dimensions
                                                          .paddingSizeLarge),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeLarge,
                                                vertical:
                                                    Dimensions.paddingSizeLarge,
                                              ),
                                              child: CartDetailsView(
                                                couponController:
                                                    _couponController,
                                                total: total,
                                                isSelfPickupActive:
                                                    isSelfPickupActive,
                                                kmWiseCharge: kmWiseCharge,
                                                isFreeDelivery: isFreeDelivery,
                                                itemPrice: itemPrice,
                                                totalMarketPrice: marketPrice,
                                                totalShreePrice: shreePrice,
                                                tax: tax,
                                                unit: unit!,
                                                totalWeight: totalWeight,
                                                discount: discount,
                                                deliveryCharge: deliveryCharge!,
                                              ),
                                            ),
                                            const CartDeliveryTimeSlot(),
                                            // PaymentOptions(
                                            //     paymentList: _paymentList),
                                            const DeliveryLocationView(
                                                locationColor: Colors.black54),
                                            CartButtonView(
                                              subTotal: subTotal,
                                              configModel: configModel,
                                              itemPrice: itemPrice,
                                              total: total,
                                              isFreeDelivery: isFreeDelivery,
                                            ),
                                          ]))
                                    ],
                                  ),
                                )),
                          )),
                          const FooterView(),
                        ]))
                  : const NoDataScreen(isCart: true);
            },
          );
        }),
      ),
    );
  }
}



// class PaymentOptions extends StatelessWidget {
//   final List<String> paymentList;
//   const PaymentOptions({Key? key, required this.paymentList}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           getTranslated('select_payment_mode', context)!,
//           style: poppinsRegular.copyWith(
//               fontSize: Dimensions.fontSizeLarge,
//               fontWeight: FontWeight.w500,
//               color: Colors.black),
//         ),
//         DigitalPaymentView(paymentList: paymentList),
//       ],
//     );
//   }
// }

class CartButtonView extends StatelessWidget {
  const CartButtonView({
    Key? key,
    required double subTotal,
    required ConfigModel configModel,
    required double itemPrice,
    required double total,
    required bool isFreeDelivery,
  })  : _subTotal = subTotal,
        _configModel = configModel,
        _isFreeDelivery = isFreeDelivery,
        _itemPrice = itemPrice,
        _total = total,
        super(key: key);

  final double _subTotal;
  final ConfigModel _configModel;
  final double _itemPrice;
  final double _total;
  final bool _isFreeDelivery;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: 1170,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(children: [
        Consumer<CouponProvider>(builder: (context, couponProvider, _) {
          return couponProvider.couponType == 'free_delivery'
              ? const SizedBox()
              : FreeDeliveryProgressBar(
                  subTotal: _subTotal, configModel: _configModel);
        }),
        Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
            return CustomCartButton(
              buttonText1:
                  '${PriceConverter.convertPrice(context, _total)} total',
              buttonText2: getTranslated('place_order', context),
              onPressed: () {
                bool isLoggedIn =
                Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
                if(isLoggedIn){
                  if (_itemPrice < _configModel.minimumOrderValue!) {
                    showCustomSnackBar(
                        ' ${getTranslated('minimum_order_amount_is', context)} ${PriceConverter.convertPrice(context, _configModel.minimumOrderValue)}, ${getTranslated('you_have', context)} ${PriceConverter.convertPrice(context, _itemPrice)} ${getTranslated('in_your_cart_please_add_more_item', context)}',
                        isError: true);
                  } else {
                    if (orderProvider.orderType == 'self_pickup' &&
                        cartProvider.selectedStoreId == null) {
                      return ToastService()
                          .show('Please select store to pickup');
                    }

                    if (orderProvider.orderType == 'delivery' &&
                        cartProvider.selectedDeliveryTimeSlot == null) {
                      return ToastService()
                          .show('Please select upcoming delivery time slot');
                    }

                    if (orderProvider.orderType == 'delivery' &&
                        Provider.of<LocationProvider>(context, listen: false)
                            .addressList!
                            .isEmpty) {
                      return ToastService().show('Please add delivery address');
                    }

                    if (orderProvider.orderType == 'delivery' &&
                        orderProvider.addressIndex == -1) {
                      return ToastService().show(
                          getTranslated('select_delivery_address', context)!);
                    }

                    if (kDebugMode) {
                      print(
                          'navigate to payment options ================================================');
                      print('total amount to pay: $_total');
                      print('type of order: ${orderProvider.orderType}');
                      print(
                          'time slot: ${cartProvider.selectedDeliveryTimeSlot}');
                      print('payment method: ${orderProvider.paymentMethod}');
                      print('is delivery free: $_isFreeDelivery');
                      print(
                          'slected store id: ${cartProvider.selectedStoreId}');
                      print(
                          'selected address id: ${Provider.of<LocationProvider>(context, listen: false).addressList![0].id}');
                      print(
                          'navigate to payment options================================================');
                    }

                    //  To navigate to payment options
                    Navigator.pushNamed(
                      context,
                      RouteHelper.getCheckoutRoute(
                        _total,
                        0,
                        orderProvider.orderType,
                        Provider.of<CouponProvider>(context, listen: false)
                            .code!,
                        _isFreeDelivery ? 'free_delivery' : '',
                      ),
                      arguments: CheckoutScreen(
                        amount: _total,
                        orderType: orderProvider.orderType,
                        discount: 0,
                        couponCode:
                            Provider.of<CouponProvider>(context, listen: false)
                                .code,
                        freeDeliveryType:
                            _isFreeDelivery ? 'free_delivery' : '',
                      ),
                    );
                  }

                  // String? orderType =
                  //     Provider.of<OrderProvider>(context, listen: false).orderType;
                  // double? discount =
                  //     Provider.of<CouponProvider>(context, listen: false).discount;

                  // PlaceOrderBody placeOrderBody = PlaceOrderBody(
                  //   cart: jsonEncode(cartProvider.cartList),
                  //   orderAmount: _total,
                  //   paymentMethod: orderProvider.paymentMethod,
                  //   orderType: orderProvider.orderType,
                  //   storeId: cartProvider.selectedStoreId,
                  //   branchId:
                  //       Provider.of<ProfileProvider>(context, listen: false)
                  //           .userInfoModel!
                  //           .warehouseId,
                  //   deliveryAddressId:
                  //       Provider.of<LocationProvider>(context, listen: false)
                  //           .addressList![0]
                  //           .id,
                  //   couponDiscountAmount:
                  //       Provider.of<CouponProvider>(context, listen: false)
                  //           .discount,
                  //   deliveryTimeSlot: cartProvider.selectedDeliveryTimeSlot,
                  //   deliveryDate: DateTime.now().toString(),
                  // );
                  //
                  // if (directPaymentList.contains(orderProvider.paymentMethod)) {
                  //   print(
                  //       'place order body order type is: ${placeOrderBody.orderType}');
                  //   print('payment method is: ${placeOrderBody.paymentMethod}');
                  //   print('store id is: ${placeOrderBody.storeId}');
                  //   print('order amount is: ${placeOrderBody.orderAmount}');
                  //   print('address id is: ${placeOrderBody.deliveryAddressId}');
                  //
                  //   log('place order:::::${placeOrderBody.cart}');
                  //
                  //   if (orderProvider.paymentMethod != 'offline_payment') {
                  //     // if (placeOrderBody.paymentMethod == 'cash_on_delivery' &&
                  //     //     configModel.maxAmountCodStatus! &&
                  //     //     placeOrderBody.orderAmount! >
                  //     //         configModel.maxOrderForCODAmount!) {
                  //     //   showCustomSnackBar(
                  //     //       '${getTranslated('for_cod_order_must_be', context)} ${configModel.maxOrderForCODAmount}');
                  //     // } else
                  //     if (orderProvider.paymentMethod == 'wallet_payment' &&
                  //         Provider.of<ProfileProvider>(context, listen: false)
                  //                 .userInfoModel!
                  //                 .walletBalance! <
                  //             placeOrderBody.orderAmount!) {
                  //       showCustomSnackBar(getTranslated(
                  //           'wallet_balance_is_insufficient', context)!);
                  //     } else {
                  //       orderProvider.placeOrder(placeOrderBody, _callback);
                  //     }
                  //   }
                  //   else {
                  //     showAnimatedDialog(
                  //         context,
                  //         OfflinePaymentDialog(
                  //           placeOrderBody: placeOrderBody,
                  //           callBack: (placeOrder) =>
                  //               orderProvider.placeOrder(placeOrder, _callback),
                  //         ),
                  //         dismissible: false,
                  //         isFlip: true);
                  //   }
                  // }
                }
                else{
                  ToastService().show("Please login for place orders");
                }
              },
            );
          });
        })
      ]),
    ));
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Provider.of<CartProvider>(Get.context!, listen: false).clearCartList();
      Provider.of<OrderProvider>(Get.context!, listen: false).stopLoader();
      if (Provider.of<OrderProvider>(Get.context!, listen: false)
              .paymentMethod !=
          'cash_on_delivery') {
        Navigator.pushReplacementNamed(
          Get.context!,
          '${'${RouteHelper.orderSuccessful}/'}$orderID/success',
          arguments: OrderSuccessfulScreen(
            orderID: orderID,
            status: 0,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(
            Get.context!, '${RouteHelper.orderSuccessful}/$orderID/success');
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
            content: Text(message),
            duration: const Duration(milliseconds: 600),
            backgroundColor: Colors.red),
      );
    }
  }
}

class FreeDeliveryProgressBar extends StatelessWidget {
  const FreeDeliveryProgressBar({
    Key? key,
    required double subTotal,
    required ConfigModel configModel,
  })  : _subTotal = subTotal,
        super(key: key);

  final double _subTotal;

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    return configModel.freeDeliveryStatus!
        ? Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Column(children: [
              Row(children: [
                Icon(Icons.discount_outlined,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                (_subTotal / configModel.freeDeliveryOverAmount!) < 1
                    ? CustomDirectionality(
                        child: Text(
                        '${PriceConverter.convertPrice(context, configModel.freeDeliveryOverAmount! - _subTotal)} ${getTranslated('more_to_free_delivery', context)}',
                      ))
                    : Text(getTranslated('enjoy_free_delivery', context)!),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              LinearProgressIndicator(
                value: (_subTotal / configModel.freeDeliveryOverAmount!),
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ]),
          )
        : const SizedBox();
  }
}
*/
