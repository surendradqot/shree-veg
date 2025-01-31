// import 'package:flutter/material.dart';
// import 'package:shreeveg/data/model/response/category_model.dart';
// import 'package:shreeveg/helper/price_converter.dart';
// import 'package:shreeveg/helper/responsive_helper.dart';
// import 'package:shreeveg/localization/app_localization.dart';
// import 'package:shreeveg/localization/language_constraints.dart';
// import 'package:shreeveg/provider/cart_provider.dart';
// import 'package:shreeveg/provider/category_provider.dart';
// import 'package:shreeveg/provider/coupon_provider.dart';
// import 'package:shreeveg/provider/localization_provider.dart';
// import 'package:shreeveg/provider/order_provider.dart';
// import 'package:shreeveg/provider/product_provider.dart';
// import 'package:shreeveg/provider/splash_provider.dart';
// import 'package:shreeveg/utill/color_resources.dart';
// import 'package:shreeveg/utill/dimensions.dart';
// import 'package:shreeveg/utill/styles.dart';
// import 'package:shreeveg/view/base/custom_app_bar.dart';
// import 'package:shreeveg/view/base/custom_directionality.dart';
// import 'package:shreeveg/view/base/footer_view.dart';
// import 'package:shreeveg/view/base/no_data_screen.dart';
// import 'package:shreeveg/view/base/product_widget.dart';
// import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
// import 'package:shreeveg/view/base/web_product_shimmer.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';
// import 'package:shreeveg/view/screens/filters/filters_screen.dart';
// import 'package:shreeveg/view/screens/home/widget/search_widget.dart';
//
// import '../../../helper/route_helper.dart';
// import '../../../provider/banner_provider.dart';
// import '../../../provider/group_provider.dart';
// import '../../../utill/images.dart';
// import '../home/widget/banners_view.dart';
// import '../home/widget/group_view.dart';
//
// class CategoryProductScreenNew extends StatefulWidget {
//   final CategoryModel categoryModel;
//   final String? subCategoryName;
//
//   const CategoryProductScreenNew(
//       {Key? key, required this.categoryModel, this.subCategoryName})
//       : super(key: key);
//
//   @override
//   State<CategoryProductScreenNew> createState() =>
//       _CategoryProductScreenNewState();
// }
//
// class _CategoryProductScreenNewState extends State<CategoryProductScreenNew>
//     with SingleTickerProviderStateMixin {
//   void _loadData(BuildContext context) async {
//     if (Provider.of<CategoryProvider>(context, listen: false)
//             .categorieselectedIndex ==
//         0) {
//       Provider.of<CategoryProvider>(context, listen: false)
//           .getCategory(widget.categoryModel.id, context);
//
//       Provider.of<CategoryProvider>(context, listen: false).getSubCategoryList(
//           context,
//           widget.categoryModel.id.toString(),
//           Provider.of<LocalizationProvider>(context, listen: false)
//               .locale
//               .languageCode);
//       // Provider.of<ProductProvider>(context, listen: false)
//       //     .initCategoryProductList(
//       //   widget.categoryModel.id.toString(),
//       //   context,
//       //   Provider.of<LocalizationProvider>(context, listen: false)
//       //       .locale
//       //       .languageCode,
//       // );
//
//       Provider.of<GroupProvider>(context, listen: false)
//           .getGroupsList(context, false);
//     }
//   }
//
//   @override
//   void initState() {
//     _loadData(context);
//     controller = AnimationController(
//         duration: const Duration(milliseconds: 1000), vsync: this);
//     super.initState();
//   }
//
//   late AnimationController controller;
//
//   void shake() {
//     controller.forward(from: 0.0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
//         .chain(CurveTween(curve: Curves.elasticIn))
//         .animate(controller)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller.reverse();
//         }
//       });
//     String? appBarText = 'Sub Categories';
//     if (widget.subCategoryName != null && widget.subCategoryName != 'null') {
//       appBarText = widget.subCategoryName;
//     } else {
//       appBarText = Provider.of<CategoryProvider>(context).categoryModel != null
//           ? Provider.of<CategoryProvider>(context).categoryModel!.name
//           : 'name';
//     }
//     Provider.of<ProductProvider>(context, listen: false)
//         .initializeAllSortBy(context);
//     return Scaffold(
//       // appBar: (ResponsiveHelper.isDesktop(context)
//       //     ? const PreferredSize(
//       //         preferredSize: Size.fromHeight(120), child: WebAppBar())
//       //     : CustomAppBar(
//       //         title: appBarText,
//       //         isCenter: false,
//       //         isElevation: true,
//       //         fromcategoriescreen: true,
//       //       )) as PreferredSizeWidget?,
//       appBar: AppBar(
//         leading: BackButton(
//           color: Colors.white,
//         ),
//         // title: Text(widget.subCategoryName!,style: TextStyle(color: Colors.white),),
//         title: Text(
//           "Category Products",
//           style: poppinsMedium.copyWith(
//             fontSize: Dimensions.fontSizeLarge,
//             color: Colors.white,
//           ),
//         ),
//         leadingWidth: 20,
//         actions: [
//           AnimatedBuilder(
//             animation: offsetAnimation,
//             builder: (buildContext, child) {
//               return Container(
//                 padding: EdgeInsets.only(
//                     left: offsetAnimation.value + 15.0,
//                     right: 15.0 - offsetAnimation.value),
//                 child: IconButton(
//                   icon: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Image.asset(Images.cartIcon,
//                           width: 23, height: 25, color: Colors.white),
//                       Positioned(
//                         top: -7,
//                         right: -2,
//                         child: Container(
//                           padding: const EdgeInsets.all(05),
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle, color: Colors.white),
//                           child: Text(
//                             '${Provider.of<CartProvider>(context).cartList.length}',
//                             style: TextStyle(
//                                 color: Theme.of(context).primaryColor,
//                                 fontSize: 10),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   onPressed: () {
//                     Provider.of<SplashProvider>(context, listen: false)
//                         .setCurrentPageIndex(2);
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Consumer<ProductProvider>(
//             builder: (context, productProvider, child) {
//           return Column(
//             crossAxisAlignment: ResponsiveHelper.isDesktop(context)
//                 ? CrossAxisAlignment.center
//                 : CrossAxisAlignment.start,
//             children: [
//               // Row(
//               //   children: [
//               //     InkWell(
//               //       onTap: () => Navigator.of(context).pop(),
//               //       child: const Padding(
//               //         padding: EdgeInsets.all(8.0),
//               //         child: Icon(Icons.keyboard_arrow_left),
//               //       ),
//               //     ),
//               //     const Expanded(child: SearchWidget()),
//               //   ],
//               // ),
//               SearchWidget(),
//               Consumer<GroupProvider>(builder: (context, group, child) {
//                 return group.groupsList == null
//                     ? GroupsView(categoryModel: widget.categoryModel)
//                     : group.groupsList!.isEmpty
//                         ? const SizedBox()
//                         : GroupsView(categoryModel: widget.categoryModel);
//               }),
//
//               Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 30,
//                       decoration: const BoxDecoration(color: Color(0xffF3F3F3)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                               '${productProvider.categoryProductList.length} items'),
//                           InkWell(
//                             onTap: () => Navigator.of(context).pushNamed(
//                                 RouteHelper.filter,
//                                 arguments: const FilterScreen()),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Image.asset(Images.filterIcon,
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyLarge!
//                                         .color,
//                                     width: 20),
//                                 Center(
//                                     child: Text(
//                                   ' Filter',
//                                   style: poppinsRegular.copyWith(
//                                       fontSize: Dimensions.fontSizeDefault,
//                                       color: const Color(0xFF272727),
//                                       fontWeight: FontWeight.w400),
//                                 )),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ))),
//
//               // Stack(
//               //   children: [
//               //     BannersView(
//               //         bannerType: 'category',
//               //         categoryId: widget.categoryModel.id),
//               //     Positioned.fill(
//               //       child: Align(
//               //         alignment: Alignment.center,
//               //         child: Text(
//               //             'Fresh ${widget.categoryModel.name.toCapitalized()}',
//               //             style: poppinsRegular.copyWith(
//               //                 fontSize: 22,
//               //                 fontWeight: FontWeight.w700,
//               //                 color: Colors.white)),
//               //       ),
//               //     )
//               //   ],
//               // ),
//
//               SizedBox(
//                 height: 70,
//                 width: 1170,
//                 child: Consumer<CategoryProvider>(
//                     builder: (context, categoryProvider, child) {
//                   return categoryProvider.subCategoryList != null
//                       ? Container(
//                           margin: const EdgeInsets.symmetric(vertical: 15),
//                           height: 32,
//                           child: SizedBox(
//                             width: ResponsiveHelper.isDesktop(context)
//                                 ? 1170
//                                 : MediaQuery.of(context).size.width,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   child: SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Row(children: [
//                                         // Padding(
//                                         //   padding: const EdgeInsets.only(
//                                         //       left: Dimensions
//                                         //           .paddingSizeDefault),
//                                         //   child: InkWell(
//                                         //     onTap: () {
//                                         //       categoryProvider
//                                         //           .changeSelectedIndex(-1);
//                                         //
//                                         //       Provider.of<ProductProvider>(
//                                         //               context,
//                                         //               listen: false)
//                                         //           .filterSubCategoryWise('all');
//                                         //       // Provider.of<ProductProvider>(
//                                         //       //         context,
//                                         //       //         listen: false)
//                                         //       //     .initCategoryProductList(
//                                         //       //   widget.categoryModel.id
//                                         //       //       .toString(),
//                                         //       //   context,
//                                         //       //   Provider.of<LocalizationProvider>(
//                                         //       //           context,
//                                         //       //           listen: false)
//                                         //       //       .locale
//                                         //       //       .languageCode,
//                                         //       // );
//                                         //     },
//                                         //     hoverColor: Colors.transparent,
//                                         //     child: Container(
//                                         //       padding: const EdgeInsets
//                                         //           .symmetric(
//                                         //           horizontal: Dimensions
//                                         //               .paddingSizeLarge,
//                                         //           vertical: Dimensions
//                                         //               .paddingSizeExtraSmall),
//                                         //       alignment: Alignment.center,
//                                         //       margin: const EdgeInsets.only(
//                                         //           right: Dimensions
//                                         //               .paddingSizeSmall),
//                                         //       decoration: BoxDecoration(
//                                         //           color: categoryProvider
//                                         //                       .categorieselectedIndex ==
//                                         //                   -1
//                                         //               ? Theme.of(context)
//                                         //                   .primaryColor
//                                         //               : ColorResources
//                                         //                   .getGreyColor(
//                                         //                       context),
//                                         //           borderRadius:
//                                         //               BorderRadius.circular(7)),
//                                         //       child: Text(
//                                         //         getTranslated('all', context)!,
//                                         //         style: poppinsRegular.copyWith(
//                                         //           color: categoryProvider
//                                         //                       .categorieselectedIndex ==
//                                         //                   -1
//                                         //               ? Theme.of(context)
//                                         //                   .canvasColor
//                                         //               : Colors.black,
//                                         //         ),
//                                         //       ),
//                                         //     ),
//                                         //   ),
//                                         // ),
//                                         ListView.builder(
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(),
//                                             itemCount: categoryProvider
//                                                 .subCategoryList!.length,
//                                             shrinkWrap: true,
//                                             scrollDirection: Axis.horizontal,
//                                             itemBuilder: (BuildContext context,
//                                                 int index) {
//                                               return Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: Dimensions
//                                                         .paddingSizeDefault),
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     print(
//                                                         'sub cat parent id is: ${categoryProvider.subCategoryList![index].parentId}');
//                                                     print(
//                                                         'sub cat id is: ${categoryProvider.subCategoryList![index].id}');
//                                                     print(
//                                                         'sub cat name is: ${categoryProvider.subCategoryList![index].name}');
//                                                     // print('product sub cat name is: ${productProvider.categoryProductList[0]}')
//                                                     categoryProvider
//                                                         .changeSelectedIndex(
//                                                             index);
//
//                                                     Provider.of<ProductProvider>(
//                                                             context,
//                                                             listen: false)
//                                                         .filterSubCategoryWise(
//                                                             categoryProvider
//                                                                 .subCategoryList![
//                                                                     index]
//                                                                 .name!);
//
//                                                     // Provider.of<ProductProvider>(
//                                                     //         context,
//                                                     //         listen: false)
//                                                     //     .initCategoryProductList(
//                                                     //   categoryProvider
//                                                     //       .subCategoryList![index]
//                                                     //       .id
//                                                     //       .toString(),
//                                                     //   context,
//                                                     //   Provider.of<LocalizationProvider>(
//                                                     //           context,
//                                                     //           listen: false)
//                                                     //       .locale
//                                                     //       .languageCode,
//                                                     // );
//                                                   },
//                                                   hoverColor:
//                                                       Colors.transparent,
//                                                   child: Container(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: Dimensions
//                                                             .paddingSizeLarge,
//                                                         vertical: Dimensions
//                                                             .paddingSizeExtraSmall),
//                                                     alignment: Alignment.center,
//                                                     margin: const EdgeInsets
//                                                         .only(
//                                                         right: Dimensions
//                                                             .paddingSizeSmall),
//                                                     decoration: BoxDecoration(
//                                                         color: categoryProvider
//                                                                     .categorieselectedIndex ==
//                                                                 index
//                                                             ? Theme.of(context)
//                                                                 .primaryColor
//                                                             : ColorResources
//                                                                 .getGreyColor(
//                                                                     context),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(7)),
//                                                     child: Text(
//                                                       "${categoryProvider.subCategoryList![index].name!}(${categoryProvider.subCategoryList![index].hnName!})",
//                                                       style: poppinsRegular
//                                                           .copyWith(
//                                                         color:
//                                                             categoryProvider
//                                                                         .categorieselectedIndex ==
//                                                                     index
//                                                                 ? Theme.of(
//                                                                         context)
//                                                                     .canvasColor
//                                                                 : Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             }),
//                                       ])),
//                                 ),
//                                 // if(ResponsiveHelper.isDesktop(context)) Spacer(),
//                                 if (ResponsiveHelper.isDesktop(context))
//                                   PopupMenuButton(
//                                       color: Theme.of(context)
//                                           .textTheme
//                                           .bodyLarge
//                                           ?.color,
//                                       elevation: 20,
//                                       enabled: true,
//                                       icon: const Icon(
//                                         Icons.more_vert,
//                                         color: Colors.black,
//                                       ),
//                                       onSelected: (dynamic value) {
//                                         int index =
//                                             Provider.of<ProductProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .allSortBy
//                                                 .indexOf(value);
//
//                                         Provider.of<ProductProvider>(context,
//                                                 listen: false)
//                                             .sortCategoryProduct(index);
//                                       },
//                                       itemBuilder: (context) {
//                                         return Provider.of<ProductProvider>(
//                                                 context,
//                                                 listen: false)
//                                             .allSortBy
//                                             .map((choice) {
//                                           return PopupMenuItem(
//                                             value: choice,
//                                             child: Text("$choice"),
//                                           );
//                                         }).toList();
//                                       })
//                               ],
//                             ),
//                           ),
//                         )
//                       : const SubcategoryTitleShimmer();
//                 }),
//               ),
//               Expanded(
//                   child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     productProvider.categoryProductList.isNotEmpty
//                         ? Container(
//                             width: 1170,
//                             constraints: BoxConstraints(
//                                 minHeight: ResponsiveHelper.isDesktop(context)
//                                     ? MediaQuery.of(context).size.height - 400
//                                     : MediaQuery.of(context).size.height),
//                             child: GridView.builder(
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 childAspectRatio:
//                                     ResponsiveHelper.isDesktop(context)
//                                         ? (1 / 1.1)
//                                         : 2.5,
//                                 crossAxisCount:
//                                     ResponsiveHelper.isDesktop(context)
//                                         ? 5
//                                         : ResponsiveHelper.isMobilePhone()
//                                             ? 1
//                                             : ResponsiveHelper.isTab(context)
//                                                 ? 2
//                                                 : 1,
//                                 mainAxisSpacing: 13,
//                                 crossAxisSpacing: 13,
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: Dimensions.paddingSizeSmall,
//                                   vertical: Dimensions.paddingSizeSmall),
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount:
//                                   productProvider.categoryProductList.length,
//                               shrinkWrap: true,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return productProvider
//                                         .categoryProductList[index]
//                                         .variations!
//                                         .isNotEmpty
//                                     ? ProductWidget(
//                                         product: productProvider
//                                             .categoryProductList[index])
//                                     : SizedBox();
//                               },
//                             ),
//                           )
//                         : Center(
//                             child: SizedBox(
//                               width: 1170,
//                               child: productProvider.hasData!
//                                   ? Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal:
//                                               Dimensions.paddingSizeSmall),
//                                       child: ProductShimmer(
//                                           isEnabled:
//                                               Provider.of<ProductProvider>(
//                                                       context)
//                                                   .categoryProductList
//                                                   .isEmpty),
//                                     )
//                                   : const NoDataScreen(isSearch: true),
//                             ),
//                           ),
//                     ResponsiveHelper.isDesktop(context)
//                         ? const FooterView()
//                         : const SizedBox(),
//                   ],
//                 ),
//               )),
//               // _cartTile(context),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _cartTile(BuildContext context) {
//     bool kmWiseCharge = Provider.of<SplashProvider>(context, listen: false)
//             .configModel!
//             .deliveryManagement!
//             .status ??
//         false;
//     return Consumer<CartProvider>(builder: (context, cartProvider, _) {
//       double? deliveryCharge = 0;
//       (Provider.of<OrderProvider>(context).orderType == 'delivery' &&
//               !kmWiseCharge)
//           ? deliveryCharge = Provider.of<SplashProvider>(context, listen: false)
//               .configModel!
//               .deliveryCharge
//           : deliveryCharge = 0;
//       double itemPrice = 0;
//       double discount = 0;
//       double tax = 0;
//       for (var cartModel in cartProvider.cartList) {
//         itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
//         discount = discount + (cartModel.discount! * cartModel.quantity!);
//         tax = tax + (cartModel.tax! * cartModel.quantity!);
//       }
//       double subTotal = itemPrice + tax;
//       double total = subTotal -
//           discount -
//           Provider.of<CouponProvider>(context).discount! +
//           deliveryCharge!;
//       return (cartProvider.cartList.isNotEmpty && ResponsiveHelper.isMobile())
//           ? Container(
//               width: 1170,
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Provider.of<SplashProvider>(context, listen: false)
//                       .setPageIndex(2);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(12)),
//                     child: Column(
//                       children: [
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(getTranslated('total_item', context)!,
//                                   style: poppinsMedium.copyWith(
//                                     fontSize: Dimensions.fontSizeLarge,
//                                     color: Theme.of(context).cardColor,
//                                   )),
//                               Text(
//                                   '${cartProvider.cartList.length} ${getTranslated('items', context)}',
//                                   style: poppinsMedium.copyWith(
//                                       color: Theme.of(context).cardColor)),
//                             ]),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(getTranslated('total_amount', context)!,
//                                   style: poppinsMedium.copyWith(
//                                     fontSize: Dimensions.fontSizeLarge,
//                                     color: Theme.of(context).cardColor,
//                                   )),
//                               CustomDirectionality(
//                                   child: Text(
//                                 PriceConverter.convertPrice(context, total),
//                                 style: poppinsMedium.copyWith(
//                                     fontSize: Dimensions.fontSizeLarge,
//                                     color: Theme.of(context).cardColor),
//                               )),
//                             ]),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           : const SizedBox();
//     });
//   }
// }
//
// class SubcategoryTitleShimmer extends StatelessWidget {
//   const SubcategoryTitleShimmer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         padding: const EdgeInsets.only(left: 20),
//         itemCount: 5,
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             child: Shimmer(
//               duration: const Duration(seconds: 2),
//               enabled: true,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: Dimensions.paddingSizeLarge,
//                     vertical: Dimensions.paddingSizeExtraSmall),
//                 alignment: Alignment.center,
//                 margin:
//                     const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
//                 decoration: BoxDecoration(
//                     color: Theme.of(context).textTheme.titleLarge!.color,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Container(
//                   height: 20,
//                   width: 60,
//                   padding:
//                       const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: ColorResources.getGreyColor(context),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
//
// class ProductShimmer extends StatelessWidget {
//   final bool isEnabled;
//
//   const ProductShimmer({Key? key, required this.isEnabled}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1 / 1.4) : 3,
//         crossAxisCount: ResponsiveHelper.isDesktop(context)
//             ? 5
//             : ResponsiveHelper.isMobilePhone()
//                 ? 1
//                 : ResponsiveHelper.isTab(context)
//                     ? 2
//                     : 1,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//       ),
//       shrinkWrap: true,
//       padding: EdgeInsets.zero,
//       itemBuilder: (context, index) => ResponsiveHelper.isDesktop(context)
//           ? const WebProductShimmer(isEnabled: true)
//           : Container(
//               height: 85,
//               padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
//               margin:
//                   const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Theme.of(context).cardColor,
//               ),
//               child: Shimmer(
//                 duration: const Duration(seconds: 2),
//                 enabled: isEnabled,
//                 child: Row(children: [
//                   Container(
//                     height: 85,
//                     width: 85,
//                     padding:
//                         const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           width: 2,
//                           color:
//                               Theme.of(context).textTheme.titleLarge!.color!),
//                       borderRadius: BorderRadius.circular(10),
//                       color: Theme.of(context).textTheme.titleLarge!.color,
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: Dimensions.paddingSizeSmall),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                                 height: 15,
//                                 width: MediaQuery.of(context).size.width,
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .color),
//                             const SizedBox(height: 2),
//                             Container(
//                                 height: 15,
//                                 width: MediaQuery.of(context).size.width,
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .color),
//                             const SizedBox(height: 10),
//                             Container(
//                                 height: 10,
//                                 width: 50,
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .color),
//                           ]),
//                     ),
//                   ),
//                   Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                             height: 15,
//                             width: 50,
//                             color:
//                                 Theme.of(context).textTheme.titleLarge!.color),
//                         Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: 1,
//                                 color: Theme.of(context)
//                                     .hintColor
//                                     .withOpacity(0.6)
//                                     .withOpacity(0.2)),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Icon(Icons.add,
//                               color: Theme.of(context).primaryColor),
//                         ),
//                       ]),
//                 ]),
//               ),
//             ),
//       itemCount: 20,
//     );
//   }
// }
