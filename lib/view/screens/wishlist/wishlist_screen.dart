import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/wishlist_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/view/base/app_bar_base.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/not_login_screen.dart';
import 'package:shreeveg/view/base/product_widget.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/wishlist/wishlist_product.dart';

import '../../../data/model/response/product_model.dart';
import '../../../provider/localization_provider.dart';
import '../../../provider/product_provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    Provider.of<WishListProvider>(context, listen: false).getWishList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: ResponsiveHelper.isMobilePhone()
          ? CustomAppBar(
              title: getTranslated('my_wishlist', context),
              backgroundColor: Theme.of(context).primaryColor,
              buttonTextColor: Colors.white,
            )
          : (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : const AppBarBase()) as PreferredSizeWidget?,
      body: _isLoggedIn
          ? Consumer<WishListProvider>(
              builder: (context, wishlistProvider, child) {
                if (wishlistProvider.isLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)));
                }
                return wishlistProvider.wishList != null
                    ? wishlistProvider.wishList!.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<WishListProvider>(context,
                                      listen: false)
                                  .getWishList();
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight:
                                                !ResponsiveHelper.isDesktop(
                                                            context) &&
                                                        height < 600
                                                    ? height
                                                    : height - 400),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1,
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          child: SizedBox(
                                              width: 1170,
                                              child: Wrap(
                                                children: [
                                                  FutureBuilder(
                                                    future: Future.wait(
                                                        List.generate(
                                                            wishlistProvider
                                                                .wishList!
                                                                .length,
                                                            (index) {
                                                      int productId =
                                                          wishlistProvider
                                                              .wishList![index]
                                                              .productId;
                                                      return Provider.of<
                                                                  ProductProvider>(
                                                              context,
                                                              listen: false)
                                                          .getProductDetails(
                                                        context,
                                                        '$productId',
                                                        Provider.of<LocalizationProvider>(
                                                                context,
                                                                listen: false)
                                                            .locale
                                                            .languageCode,
                                                        searchQuery: false,
                                                      );
                                                    })),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                List<Product?>>
                                                            snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                            child:
                                                                CircularProgressIndicator()); // Show a loading indicator while fetching data
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}'); // Show an error message if fetching fails
                                                      } else {
                                                        // Once data is fetched, generate wishListItem widgets
                                                        return Wrap(
                                                          children:
                                                              List.generate(
                                                                  snapshot.data!
                                                                      .length,
                                                                  (index) {
                                                            return wishListItem(
                                                                context,
                                                                snapshot.data![
                                                                    index],
                                                                wishlistProvider);
                                                          }),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                              // child: GridView.builder(
                                              //   gridDelegate:
                                              //       SliverGridDelegateWithFixedCrossAxisCount(
                                              //           crossAxisSpacing:
                                              //               ResponsiveHelper
                                              //                       .isDesktop(
                                              //                           context)
                                              //                   ? 13
                                              //                   : 5,
                                              //           mainAxisSpacing:
                                              //               ResponsiveHelper
                                              //                       .isDesktop(
                                              //                           context)
                                              //                   ? 13
                                              //                   : 5,
                                              //           childAspectRatio:
                                              //               ResponsiveHelper
                                              //                       .isDesktop(
                                              //                           context)
                                              //                   ? (1 / 1.4)
                                              //                   : 3.0,
                                              //           crossAxisCount:
                                              //               ResponsiveHelper
                                              //                       .isDesktop(
                                              //                           context)
                                              //                   ? 5
                                              //                   : ResponsiveHelper
                                              //                           .isTab(
                                              //                               context)
                                              //                       ? 2
                                              //                       : 1),
                                              //   itemCount: wishlistProvider
                                              //       .wishList!.length,
                                              //   padding:
                                              //       const EdgeInsets.symmetric(
                                              //           horizontal: Dimensions
                                              //               .paddingSizeSmall),
                                              //   physics:
                                              //       const NeverScrollableScrollPhysics(),
                                              //   shrinkWrap: true,
                                              //   itemBuilder:
                                              //       (BuildContext context,
                                              //           int index) {
                                              //     return ResponsiveHelper
                                              //             .isDesktop(context)
                                              //         ? Padding(
                                              //             padding:
                                              //                 const EdgeInsets
                                              //                     .all(5.0),
                                              //             child: ProductWidget(
                                              //                 product:
                                              //                     wishlistProvider
                                              //                             .wishList![
                                              //                         index]),
                                              //           )
                                              //         : ProductWidget(
                                              //             product:
                                              //                 wishlistProvider
                                              //                         .wishList![
                                              //                     index]);
                                              //   },
                                              // )
                                              ),
                                        ),
                                      ),
                                    ),
                                    if (ResponsiveHelper.isDesktop(context))
                                      const FooterView(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const NoDataScreen()
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)));
              },
            )
          : const NotLoggedInScreen(),
    );
  }
}
