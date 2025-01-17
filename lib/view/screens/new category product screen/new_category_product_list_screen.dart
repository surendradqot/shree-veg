import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/screens/home/widget/search_widget.dart';

class NewCategoryProductListScreen extends StatefulWidget {
  const NewCategoryProductListScreen({super.key});

  @override
  State<NewCategoryProductListScreen> createState() =>
      _NewCategoryProductListScreenState();
}

class _NewCategoryProductListScreenState
    extends State<NewCategoryProductListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

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
      appBar: AppBar(
        title: Text(
          'Products',
          style: poppinsRegular.copyWith(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
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
                            '${Provider.of<CartProvider>(context).cartList.length}',
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
        color: Colors.white,
        child: Column(
          // physics: BouncingScrollPhysics(),
          // shrinkWrap: true,
          children: [
            SearchWidget(),
            filterBox(),
            SizedBox(
              height: 10,
            ),
            categoryBox(),
            productList(),
          ],
        ),
      ),
    );
  }

  filterBox() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Color(0xffF3F3F3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('55 items'),
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 06),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(04),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.filterIcon,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    width: 20,
                  ),
                  Center(
                    child: Text(
                      ' Filter',
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: const Color(0xFF272727),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  categoryBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.06,
      child: ListView.separated(
          itemCount: 14,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10,
              height: 10,
            );
          },
          physics: ClampingScrollPhysics(),
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return index == 1
                ? Stack(
                    fit: StackFit.loose,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(06),
                            color: Color(0xff891919),
                          ),
                          padding: EdgeInsets.all(06),
                          alignment: Alignment.center,
                          child: Text(
                            "1₹ Offer",
                            style: poppinsSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 04,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            // width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(08),
                                border: Border.all(color: Color(0xffe6e5e5))),
                            padding: EdgeInsets.symmetric(
                                vertical: 01, horizontal: 08),
                            child: Text(
                              "Offer",
                              style: poppinsSemiBold.copyWith(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : index == 2
                    ? Stack(
                        fit: StackFit.loose,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(06),
                                color: Color(0xffFFF37F),
                              ),
                              padding: EdgeInsets.all(04),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Bulk Order",
                                    style: poppinsSemiBold.copyWith(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Limited Time",
                                    style: poppinsSemiBold.copyWith(
                                      color: Colors.black,
                                      fontSize: 05,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 04,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                // width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(08),
                                    border:
                                        Border.all(color: Color(0xffe6e5e5))),
                                padding: EdgeInsets.symmetric(
                                    vertical: 01, horizontal: 08),
                                child: Text(
                                  "Offer",
                                  style: poppinsSemiBold.copyWith(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        // height: MediaQuery.of(context).size.height*0.10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(06),
                          color: index == 0
                              ? Theme.of(context).primaryColor
                              : Color(0xffF3F3F3),
                        ),
                        padding: EdgeInsets.all(06),
                        alignment: Alignment.center,
                        child: Text(
                          "Fruit (A) फल",
                          style: poppinsSemiBold.copyWith(
                            color: index == 0 ? Colors.white : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
          }),
    );
  }

  productList() {
    return Expanded(
      child: ListView.builder(
          itemCount: 40,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              // padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: index == 0 ? Color(0xFFFFE55C) : Colors.white,
                  borderRadius: BorderRadius.circular(08),
                  border: Border.all(
                    color: Color(0xFF000000),
                  )),
              child: Column(
                children: [
                  index == 0
                      ? Container(
                          decoration: BoxDecoration(
                            color: Color(0xffBE59C2),
                            borderRadius: BorderRadius.circular(06),
                          ),
                          padding: EdgeInsets.all(06),
                          child: Text(
                            "REMAINING TIME TO AVAIL THIS OFFER",
                            style: poppinsRegular.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 08,
                            ),
                          ),
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: ColorResources.getGreyColor(context)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(left: 10, top: 10, right: 05),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: index != 50
                                  ? Banner(
                                      message: 'left title',
                                      location: BannerLocation.topStart,
                                      color: const Color(0xFF0B4619),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: CachedNetworkImage(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: 100,
                                          fit: BoxFit.contain,
                                          imageUrl:
                                              'https://shreeveg.dqot.solutions/storage/app/public/product/2024-12-21-6766f6ec4974b.png',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  Images.placeholder(context)),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  Images.placeholder(context)),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height: 150,
                                        fit: BoxFit.contain,
                                        imageUrl:
                                            'https://shreeveg.dqot.solutions/storage/app/public/product/2024-12-21-6766f6ec4974b.png',
                                        placeholder: (context, url) =>
                                            Image.asset(
                                                Images.placeholder(context)),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                Images.placeholder(context)),
                                      ),
                                    ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Banner(
                                  message: "right title",
                                  location: BannerLocation.topEnd,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 150,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: index != 50
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
                                        "सेब",
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
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(06),
                                    ),
                                    padding: EdgeInsets.all(06),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "11",
                                        style: poppinsRegular.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "H",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 07,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " : ",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "15",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "M",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 07,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " : ",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "25",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "S",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 07,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            index == 0
                                ? Text(
                                    "Apple",
                                    style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : index % 3 != 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Apple",
                                              style: poppinsMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Apple",
                                            style: poppinsMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(06),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(06),
                                                  bottomLeft:
                                                      Radius.circular(06),
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Product Total ",
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.elliptical(
                                                              15, 08),
                                                      topLeft:
                                                          Radius.elliptical(
                                                              15, 08),
                                                      bottomLeft:
                                                          Radius.elliptical(
                                                              15, 08),
                                                      bottomRight:
                                                          Radius.elliptical(
                                                              15, 08),
                                                    ),
                                                  ),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: "12",
                                                      children: [
                                                        TextSpan(
                                                          text: "Kg",
                                                          style: poppinsMedium
                                                              .copyWith(
                                                            fontSize: 06,
                                                            color: Color(
                                                                0XFF80150E),
                                                          ),
                                                        ),
                                                      ],
                                                      style: poppinsMedium
                                                          .copyWith(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0XFF80150E),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                            mrpBox(index),
                            index==0?Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("(*ऑफर का लाभ उठाने के लिए न्यूनतम ₹100 की खरीदारी आवश्यक है।)",style: poppinsRegular.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 10
                              ),),
                            ):SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
    );
  }

  mrpBox(int index) {
    return index == 0
        ? Row(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    // height:
                    //     MediaQuery.of(context).size.height *
                    //         0.07,
                    // width: MediaQuery.of(context).size.width*0.3,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Text(""),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "MRP- ",
                                style: poppinsRegular.copyWith(
                                  color: Color(0xff808080),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 08,
                                ),
                                children: [
                                  TextSpan(
                                    text: "₹49.5",
                                    style: poppinsRegular.copyWith(
                                      color: Color(0xff808080),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 08,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: "₹ ",
                                style: poppinsRegular.copyWith(
                                  color: Color(0xffFF0000),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                                children: [
                                  TextSpan(
                                    text: "1",
                                    style: poppinsRegular.copyWith(
                                      color: Color(0xff14A236),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " में",
                                    style: poppinsRegular.copyWith(
                                      color: Color(0xffFF0000),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          // height: 35,
                          // width: 70,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 15,
                                // width: 70,
                                padding: EdgeInsets.symmetric(horizontal: 06),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.elliptical(10, 10),
                                    bottomLeft: Radius.elliptical(10, 10),
                                    topRight: Radius.circular(10),
                                    // topLeft: Radius.circular(10),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Discount",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 08),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  "99.9%",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height:
                    // MediaQuery.of(context).size.height *
                    //     0.05,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff93FFAB),
                      border: Border.all(color: Colors.black),
                    ),
                    child: RichText(
                      text: TextSpan(
                          text: "1",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              style: TextStyle(
                                color: Color(0xffFF0000),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                              text: "\u02e2\u1d57",
                            ),
                            TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 06,
                                fontWeight: FontWeight.w500,
                              ),
                              text: "Kg",
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: index == 0
                    ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(06),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(05),
                  margin: EdgeInsets.all(06),
                  child: Text(
                    "ADD",
                    style: poppinsRegular.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                    // color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(06),
                    // border: Border.all(color: Colors.green,),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        // padding: EdgeInsets.all(05),
                        child: Text("15",style: poppinsRegular.copyWith(
                            fontSize: 10
                        ),),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.remove,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container(
            margin: EdgeInsets.only(top: 05),
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.separated(
                itemCount: 2,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, varIndex) {
                  return Row(
                    children: [
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            // height:
                            //     MediaQuery.of(context).size.height *
                            //         0.07,
                            // width: MediaQuery.of(context).size.width*0.3,
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Text(""),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "MRP- ",
                                        style: poppinsRegular.copyWith(
                                          color: Color(0xff808080),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 08,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "₹49.5",
                                            style: poppinsRegular.copyWith(
                                              color: Color(0xff808080),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 08,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "₹ ",
                                        style: poppinsRegular.copyWith(
                                          color: Color(0xffFF0000),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "53",
                                            style: poppinsRegular.copyWith(
                                              color: Color(0xff14A236),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  // height: 35,
                                  // width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 15,
                                        // width: 70,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 06),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomRight:
                                                Radius.elliptical(10, 10),
                                            bottomLeft:
                                                Radius.elliptical(10, 10),
                                            topRight: Radius.circular(10),
                                            // topLeft: Radius.circular(10),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Discount",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 08),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
                                          "99.9%",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height:
                            // MediaQuery.of(context).size.height *
                            //     0.05,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff93FFAB),
                              border: Border.all(color: Colors.black),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: varIndex == 0 ? "500" : "3",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: varIndex == 0 ? 10 : 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: varIndex == 0 ? 06 : 08,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      text: varIndex == 0 ? "\ngm" : "Kg",
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child:  varIndex==0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(06),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(05),
                                margin: EdgeInsets.all(06),
                                child: Text(
                                  "ADD",
                                  style: poppinsRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(06),
                                  // border: Border.all(color: Colors.green,),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      // padding: EdgeInsets.all(05),
                                      child: Text("15",style: poppinsRegular.copyWith(
                                        fontSize: 10
                                      ),),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                      ),
                    ],
                  );
                }),
          );
  }
}
