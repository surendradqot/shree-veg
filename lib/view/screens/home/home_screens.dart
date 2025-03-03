import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/model/new_flash_modal.dart';
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
import 'package:shreeveg/view/screens/splash/splash_screen.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/images.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}
SharedPreferences? sharedPreferences;
class _HomeScreenState extends State<HomeScreen> {


  static Future<void> loadData(bool reload, BuildContext context) async {
    await Provider.of<ProfileProvider>(Get.context!, listen: false).getCityWhereHouse().then((onValue){

    });
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

  Future apiCallNew() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }


  @override
  void initState() {
    super.initState();
    apiCallNew();
    loadData(true, context);
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
          await loadData(true, context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : AppBar(
            // title: Text(getTranslated('Shree Veg', context)!,
            //     style: poppinsMedium.copyWith(
            //     fontSize: Dimensions.fontSizeLarge,
            //     color:
            //         Colors.white),
            // ),
            actions: [
              Consumer<ProfileProvider>(
                builder: (context, provider, child) {
                  return GestureDetector(
                    onTap: (){
                      showCityDialog(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 04,vertical: 08),
                      margin: EdgeInsets.all(08),
                      width:  MediaQuery.of(context).size.width*0.35,
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
                            child: Icon(Icons.location_on_outlined,
                              color: Color(0xFF0B4619),),),
                          Text(
                            sharedPreferences!.getString(AppConstants.selectedCityName)??"Select City",
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
              // IconButton(onPressed: (){
              //   Navigator.pushNamed(
              //       context, RouteHelper.searchProduct);
              // }, icon: Icon(Icons.search,color: Colors.white,)),
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
            // leadingWidth: 30,
            leading: Container(
              margin: EdgeInsets.only(left: 08,top: 08,bottom: 08),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.red,
                image: DecorationImage(image: AssetImage("assets/image/shree_logo.png"),),
              ),
            ),
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
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    const BannersView(bannerType: 'home_page'),
                    const SizedBox(height: 05),
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
                   /* if (splashProvider.configModel!.flashDealProductStatus!)
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
                      }),*/
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
