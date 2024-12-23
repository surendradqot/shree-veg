import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeveg/data/model/response/userinfo_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/auth_provider.dart';
import 'package:shreeveg/provider/cart_provider.dart';
import 'package:shreeveg/provider/category_provider.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/view/screens/home/home_screens.dart';
import 'package:shreeveg/view/screens/onboarding/on_boarding_screen.dart';
import 'package:provider/provider.dart';

import '../menu/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    _route();
  }

  int valueCheck = 1;

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

  Future apiCallNew() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences!.getBool("showPopup")!){
      sharedPreferences!.setBool("showPopup", false);
      print("<<<<<<<<<<<  $valueCheck >>>>>>>>>>>");
      valueCheck += 1;
      print("<<<<<<<<<<<  $valueCheck >>>>>>>>>>>");
      showCityDialog(Get.context!);
    }
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig()
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double minimumVersion = 0.0;
          if (Platform.isAndroid) {
            if (Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .playStoreConfig!
                    .minVersion !=
                null) {
              minimumVersion =
                  Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .playStoreConfig!
                          .minVersion ??
                      6.0;
            }
          } else if (Platform.isIOS) {
            if (Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .appStoreConfig!
                    .minVersion !=
                null) {
              minimumVersion =
                  Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .appStoreConfig!
                          .minVersion ??
                      6.0;
            }
          }

          if (AppConstants.appVersion < minimumVersion &&
              !ResponsiveHelper.isWeb()) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteHelper.getUpdateRoute(), (route) => false);
          } else {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              print('is login 2');
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteHelper.main, (route) => false,
                  arguments: const MainScreen());
              apiCallNew();
            } else {
              // if (!Provider.of<SplashProvider>(context, listen: false)
              //     .showIntro()) {
              //   Navigator.pushNamedAndRemoveUntil(
              //       context, RouteHelper.onBoarding, (route) => false,
              //       arguments: OnBoardingScreen());
              // } else {
              //   Navigator.of(context).pushNamedAndRemoveUntil(
              //       RouteHelper.main, (route) => false,
              //       arguments: const MainScreen());
              // }
              print('is login 3');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteHelper.main, (route) => false,
                  arguments: const MainScreen());
              apiCallNew();
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Images.shreeLogo, height: 130),
          ),
          const SizedBox(height: 30),

          // Text(AppConstants.appName,
          //     textAlign: TextAlign.center,
          //     style: poppinsMedium.copyWith(
          //       color: Theme.of(context).primaryColor,
          //       fontSize: 50,
          //     )),
        ],
      ),
    );
  }
}
