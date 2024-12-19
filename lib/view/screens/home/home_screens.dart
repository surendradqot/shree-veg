import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/model/response/config_model.dart';
import 'package:shreeveg/data/model/response/userinfo_model.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/banner_provider.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/provider/flash_deal_provider.dart';
import 'package:shreeveg/provider/localization_provider.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/title_row.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/home/widget/banners_view.dart';
import 'package:shreeveg/view/screens/home/widget/category_view.dart';
import 'package:shreeveg/view/screens/home/widget/home_item_view.dart';
import 'package:shreeveg/view/screens/home/widget/location_view.dart';
import 'package:shreeveg/view/screens/home/widget/search_widget.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/view/screens/home_items_screen/widget/flash_deals_view.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/images.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static Future<void> loadData(bool reload, BuildContext context) async {
    await Provider.of<ProfileProvider>(Get.context!, listen: false).getCityWhereHouse();
    // final productProvider =
    //     Provider.of<ProductProvider>(context, listen: false);
    final flashDealProvider =
        Provider.of<FlashDealProvider>(context, listen: false);
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // final withLListProvider =
    //     Provider.of<WishListProvider>(context, listen: false);
    final localizationProvider =
        Provider.of<LocalizationProvider>(context, listen: false);

    ConfigModel config =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    if (reload) {
      Provider.of<SplashProvider>(context, listen: false).initConfig();
    }

    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context,
      localizationProvider.locale.languageCode,
      reload,
      id: Provider.of<ProfileProvider>(Get.context!, listen: false).sharedPreferences!.getInt(AppConstants.selectedCityId)
    );

    Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);

    // await Provider.of<ProductProvider>(context, listen: false).getItemList(
    //   '1',
    //   true,
    //   localizationProvider.locale.languageCode,
    //   ProductType.dailyItem,
    // );

    // if (config.mostReviewedProductStatus!) {
    //   await productProvider.getItemList(
    //     '1',
    //     true,
    //     localizationProvider.locale.languageCode,
    //     ProductType.mostReviewed,
    //   );
    // }

    // if (config.featuredProductStatus!) {
    //   await productProvider.getItemList(
    //     '1',
    //     true,
    //     localizationProvider.locale.languageCode,
    //     ProductType.featuredItem,
    //   );
    // }
    // if (config.trendingProductStatus!) {
    //   await productProvider.getItemList(
    //     '1',
    //     true,
    //     localizationProvider.locale.languageCode,
    //     ProductType.trendingProduct,
    //   );
    // }

    // if (config.recommendedProductStatus!) {
    //   await productProvider.getItemList(
    //     '1',
    //     true,
    //     localizationProvider.locale.languageCode,
    //     ProductType.recommendProduct,
    //   );
    // }

    // await productProvider.getItemList(
    //   '1',
    //   true,
    //   localizationProvider.locale.languageCode,
    //   ProductType.popularProduct,
    // );

    // await productProvider.getLatestProductList('1', true);
    // if (authProvider.isLoggedIn()) {
    //   await withLListProvider.getWishList();
    // }

    if (config.flashDealProductStatus!) {
      await flashDealProvider.getFlashDealList(true, false);
    }
  }
}
SharedPreferences? sharedPreferences;
class _HomeScreenState extends State<HomeScreen> {

  Future apiCall() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences!.getBool("showPopup")!){
      sharedPreferences!.setBool("showPopup", false);
      showCityDialog(Get.context!);
    }
  }


  @override
  void initState() {
    super.initState();
apiCall();
  }

  void showCityDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Prevent closing the dialog if no city is selected
            return false;
          },
          child: AlertDialog(
            title: Text('Select your location'),
            content: Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                if (provider.loadingValue) {
                  return SizedBox(
                    height: 80,
                      child: Center(child: CircularProgressIndicator()));
                }

                return DropdownButtonFormField<WarehouseCityList>(
                  items: provider.items.map((WarehouseCityList city) {
                    return DropdownMenuItem<WarehouseCityList>(
                      value: city,
                      child: Text(city.warehousesCity ?? ''),
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    provider.selectItem(newValue!.cityId!);
                    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
                      context,
                      "en",
                      false,
                      id: newValue.cityId!,
                    ).then((onValue){
                      Navigator.of(Get.context!).pop();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Location',
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (kDebugMode) {
      print('home build:     $isLoggedIn');
    }

    final ScrollController scrollController = ScrollController();

    return Consumer<SplashProvider>(builder: (context, splashProvider, child) {
      return RefreshIndicator(
        onRefresh: () async {
          Provider.of<ProductProvider>(context, listen: false).offset = 1;
          Provider.of<ProductProvider>(context, listen: false).popularOffset =
              1;
          await HomeScreen.loadData(true, context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : AppBar(
            title: Text(getTranslated('Shree Veg', context)!,style: poppinsMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color:
                    Colors.white)),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamed(
                    context, RouteHelper.searchProduct);
              }, icon: Icon(Icons.search,color: Colors.white,)),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child){
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(
                            RouteHelper.profile,
                            arguments: const ProfileScreen());
                      },
                      child: ClipOval(
                        child: isLoggedIn
                            ? Provider.of<SplashProvider>(context,
                            listen: false)
                            .baseUrls !=
                            null
                            ? Builder(builder: (context) {
                          return FadeInImage.assetNetwork(
                            placeholder:
                            Images.placeholder(context),
                            image:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                                '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.userInfo!.image : ''}',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (c, o, s) =>
                                Image.asset(
                                    Images.placeholder(
                                        context),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover),
                          );
                        })
                            : const SizedBox()
                            : Image.asset(Images.placeholder(context),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(children: [
              Center(
                  child: SizedBox(
                width: 1170,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height - 400
                        : MediaQuery.of(context).size.height,
                  ),
                  child: Column(children: [
                    // const SizedBox(
                    //   height: Dimensions.paddingSizeLarge,
                    // ),
                    //
                    // Consumer<ProfileProvider>(
                    //   builder: (context, profileProvider, child) => Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       Expanded(
                    //         child: ListTile(
                    //           tileColor: Color(0xFF0B4619),
                    //           // Provider.of<ThemeProvider>(context)
                    //           //     .darkTheme ||
                    //           //     ResponsiveHelper.isDesktop(
                    //           //         context)
                    //           //     ? Theme.of(context)
                    //           //     .hintColor
                    //           //     .withOpacity(0.1)
                    //           //     : Theme.of(context)
                    //           //     .primaryColor,
                    //           onTap: () {
                    //             Navigator.of(context).pushNamed(
                    //                 RouteHelper.profile,
                    //                 arguments: const ProfileScreen());
                    //           },
                    //           trailing: ClipOval(
                    //             child: isLoggedIn
                    //                 ? Provider.of<SplashProvider>(context,
                    //                                 listen: false)
                    //                             .baseUrls !=
                    //                         null
                    //                     ? Builder(builder: (context) {
                    //                         return FadeInImage.assetNetwork(
                    //                           placeholder:
                    //                               Images.placeholder(context),
                    //                           image:
                    //                               '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                    //                               '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                    //                           height: 30,
                    //                           width: 30,
                    //                           fit: BoxFit.cover,
                    //                           imageErrorBuilder: (c, o, s) =>
                    //                               Image.asset(
                    //                                   Images.placeholder(
                    //                                       context),
                    //                                   height: 30,
                    //                                   width: 30,
                    //                                   fit: BoxFit.cover),
                    //                         );
                    //                       })
                    //                     : const SizedBox()
                    //                 : Image.asset(Images.placeholder(context),
                    //                     height: 50,
                    //                     width: 50,
                    //                     fit: BoxFit.cover),
                    //           ),
                    //           // title: Column(
                    //           //     crossAxisAlignment:
                    //           //     CrossAxisAlignment.start,
                    //           //     children: [
                    //           //       isLoggedIn
                    //           //           ? profileProvider
                    //           //           .userInfoModel !=
                    //           //           null
                    //           //           ? Text(
                    //           //         '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                    //           //         style: poppinsRegular
                    //           //             .copyWith(
                    //           //           color: Provider.of<
                    //           //               ThemeProvider>(
                    //           //               context)
                    //           //               .darkTheme
                    //           //               ? Theme.of(
                    //           //               context)
                    //           //               .textTheme
                    //           //               .bodyLarge
                    //           //               ?.color
                    //           //               ?.withOpacity(
                    //           //               0.6)
                    //           //               : ResponsiveHelper
                    //           //               .isDesktop(
                    //           //               context)
                    //           //               ? ColorResources
                    //           //               .getDarkColor(
                    //           //               context)
                    //           //               : Theme.of(
                    //           //               context)
                    //           //               .canvasColor,
                    //           //         ),
                    //           //       )
                    //           //           : Container(
                    //           //           height: 10,
                    //           //           width: 150,
                    //           //           color: ResponsiveHelper
                    //           //               .isDesktop(
                    //           //               context)
                    //           //               ? ColorResources
                    //           //               .getDarkColor(
                    //           //               context)
                    //           //               : Theme.of(
                    //           //               context)
                    //           //               .canvasColor)
                    //           //           : Text(
                    //           //         getTranslated(
                    //           //             'guest', context)!,
                    //           //         style: poppinsRegular
                    //           //             .copyWith(
                    //           //           color: Provider.of<
                    //           //               ThemeProvider>(
                    //           //               context)
                    //           //               .darkTheme
                    //           //               ? Theme.of(
                    //           //               context)
                    //           //               .textTheme
                    //           //               .bodyLarge
                    //           //               ?.color
                    //           //               ?.withOpacity(
                    //           //               0.6)
                    //           //               : ResponsiveHelper
                    //           //               .isDesktop(
                    //           //               context)
                    //           //               ? ColorResources
                    //           //               .getDarkColor(
                    //           //               context)
                    //           //               : Theme.of(
                    //           //               context)
                    //           //               .canvasColor,
                    //           //         ),
                    //           //       ),
                    //           //       if (isLoggedIn)
                    //           //         const SizedBox(
                    //           //             height: Dimensions
                    //           //                 .paddingSizeSmall),
                    //           //       if (isLoggedIn &&
                    //           //           profileProvider
                    //           //               .userInfoModel !=
                    //           //               null)
                    //           //         Text(
                    //           //             profileProvider
                    //           //                 .userInfoModel!
                    //           //                 .phone ??
                    //           //                 '',
                    //           //             style:
                    //           //             poppinsRegular.copyWith(
                    //           //               color: Provider.of<
                    //           //                   ThemeProvider>(
                    //           //                   context)
                    //           //                   .darkTheme
                    //           //                   ? Theme.of(context)
                    //           //                   .textTheme
                    //           //                   .bodyLarge
                    //           //                   ?.color
                    //           //                   ?.withOpacity(0.6)
                    //           //                   : ResponsiveHelper
                    //           //                   .isDesktop(
                    //           //                   context)
                    //           //                   ? ColorResources
                    //           //                   .getDarkColor(
                    //           //                   context)
                    //           //                   : Theme.of(
                    //           //                   context)
                    //           //                   .canvasColor,
                    //           //             )),
                    //           //     ]),
                    //           // trailing: IconButton(
                    //           //   icon: Icon(Icons.notifications,
                    //           //       color: Provider.of<ThemeProvider>(
                    //           //           context)
                    //           //           .darkTheme
                    //           //           ? Theme.of(context)
                    //           //           .textTheme
                    //           //           .bodyLarge
                    //           //           ?.color
                    //           //           ?.withOpacity(0.6)
                    //           //           : ResponsiveHelper.isDesktop(
                    //           //           context)
                    //           //           ? ColorResources.getDarkColor(
                    //           //           context)
                    //           //           : Theme.of(context)
                    //           //           .canvasColor),
                    //           //   onPressed: () {
                    //           //     Navigator.pushNamed(
                    //           //         context, RouteHelper.notification,
                    //           //         arguments:
                    //           //         const NotificationScreen());
                    //           //   },
                    //           // ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Consumer<ProfileProvider>(
                      builder: (context, provider, child) {
                        int? selectedValue = sharedPreferences!.getInt(AppConstants.selectedCityId);
                        print("************** $selectedValue  ****************");
                        return provider.items.isNotEmpty?Container(
                          padding: EdgeInsets.all(08),
                          margin: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // height: MediaQuery.of(context).size.height*0.08,
                          child: DropdownButton<int>(
                              value: selectedValue,
                              dropdownColor: Colors.white,
                              underline: SizedBox(),
                              isExpanded: true,
                              items: provider.items.map((item) {
                                return DropdownMenuItem<int>(
                                  value: item.cityId,
                                  // child: Text(item.warehousesCity!),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                          backgroundColor: Color(0xFF0B4619),
                                          child: Icon(Icons.location_on_outlined,
                                              color: Colors.white)),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Your Location',
                                            style: poppinsRegular.copyWith(
                                                color: Colors.grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            item.warehousesCity!,
                                            style: poppinsRegular.copyWith(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (int? newValue) async {
                                provider.selectItem(newValue);
                                await HomeScreen.loadData(true, context);
                               // await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
                               //      context,
                               //      "en",
                               //      false,
                               //      id: newValue,
                               //  );
                              },
                            ),
                        ):const LocationView(locationColor: Colors.black54);
                      },
                    ),
                    // const LocationView(locationColor: Colors.black54),
                    //
                    const BannersView(bannerType: 'home_page'),

                    const SizedBox(height: Dimensions.paddingSizeSmall),

// const SearchWidget(),
                    //Offer Banners
                    if (splashProvider.configModel!=null && splashProvider.configModel!.flashDealProductStatus!)
                      Consumer<FlashDealProvider>(
                        builder: (context, flashProvider, child) {
                          return const BannersView(bannerType: 'flash');
                        },
                      ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    //Search Widget


                    // Category
                    const CategoryView(),

                    SizedBox(
                        height: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.paddingSizeLarge
                            : Dimensions.paddingSizeSmall),

                    //Special Offers
                    if (splashProvider.configModel!.flashDealProductStatus!)
                      Consumer<FlashDealProvider>(
                          builder: (context, flashDealProvider, child) {
                        return flashDealProvider.specialFlashDealList.isEmpty
                            ? const SizedBox()
                            : Column(children: [
                                TitleRow(
                                  isDetailsPage: null,
                                  title:
                                      getTranslated('special_offers', context),
                                  eventDuration:
                                      flashDealProvider.flashDeal != null
                                          ? flashDealProvider.duration
                                          : null,
                                  onTap: () => Navigator.pushNamed(
                                      context,
                                      RouteHelper.getHomeItemRoute(
                                          ProductType.flashSale)),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeDefault),
                                !ResponsiveHelper.isDesktop(context)
                                    ? SizedBox(
                                  height:
                                  MediaQuery.of(context).size.width *
                                      .75,
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                        bottom: Dimensions
                                            .paddingSizeDefault),
                                    child: FlashDealsView(
                                        isHomeScreen: true,
                                        productType:
                                        ProductType.flashSaleSpecial),
                                  ),
                                )
                                    : HomeItemView(
                                        productList: flashDealProvider
                                            .specialFlashDealList,
                                        productType:
                                            ProductType.flashSaleSpecial)
                                    // : SizedBox(child: Text("data"),)
                              ]);
                      }),

                    //Daily Sale
                    if (splashProvider.configModel!.flashDealProductStatus!)
                      Consumer<FlashDealProvider>(
                          builder: (context, flashDealProvider, child) {
                        return flashDealProvider.dailyFlashDealList.isEmpty
                            ? const SizedBox()
                            : Column(children: [
                                TitleRow(
                                  isDetailsPage: null,
                                  title: getTranslated('daily_sale', context),
                                  eventDuration: null,
                                  onTap: () => Navigator.pushNamed(
                                      context,
                                      RouteHelper.getHomeItemRoute(
                                          ProductType.dailyItem)),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeDefault),
                                !ResponsiveHelper.isDesktop(context)
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .75,
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              bottom: Dimensions
                                                  .paddingSizeDefault),
                                          child: FlashDealsView(
                                              isHomeScreen: true,
                                              productType:
                                                  ProductType.flashSaleDaily),
                                        ),
                                      )
                                    : HomeItemView(
                                        productList: flashDealProvider
                                            .dailyFlashDealList,
                                        productType: ProductType.flashSaleDaily)
                              ]);
                      }),
                  ]),
                ),
              )),
              ResponsiveHelper.isDesktop(context)
                  ? const FooterView()
                  : const SizedBox(),
            ]),
          ),
        ),
      );
    });
  }
}
