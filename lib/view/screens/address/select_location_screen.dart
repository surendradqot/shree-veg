import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/toast_service.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/screens/address/set_address_screen.dart';
import 'package:shreeveg/view/screens/address/widget/location_search_dialog.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/address/widget/permission_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/address_model.dart';
import '../../../helper/route_helper.dart';
import '../../base/custom_snackbar.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const SelectLocationScreen({Key? key, required this.googleMapController})
      : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  late final locationPro;
  @override
  void initState() {
    super.initState();
    getCurrentLatLong();
    locationPro = Provider.of<LocationProvider>(context, listen: false);
    // _initialPosition = const LatLng(26.920018572015636, 75.78795343637466
    // double.parse(Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .branches![0]
    //     .latitude!),
    // double.parse(Provider.of<SplashProvider>(context, listen: false)
    //     .configModel!
    //     .branches![0]
    //     .longitude!),
    // );
    _initialPosition = LatLng(
      locationPro.pickPosition.latitude,
      locationPro.pickPosition.longitude,
    );
    // _initialPosition = LatLng(
    //   27.345390113900567,
    //   76.11703600734472,
    // );
    print("lat long:::::: ${_initialPosition}");
    print("-----------------------------------------------------");

    Provider.of<LocationProvider>(context, listen: false).setPickData();
  }

  getCurrentLatLong() {
    print("getCurrentLatLong called");
    print("-----------------------------------------------------");
    Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLocation(context, false, mapController: _controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text =
          Provider.of<LocationProvider>(context).address ?? '';
    }

    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 1170,
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GoogleMap(
                      minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                      mapType: locationProvider.mapType,
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 50,
                      ),
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      indoorViewEnabled: true,
                      mapToolbarEnabled: true,
                      onCameraIdle: () {
                        locationProvider.updatePosition(
                            _cameraPosition, false, null, false);
                      },
                      onCameraMove: ((position) => _cameraPosition = position),
                      markers: Set<Marker>.of(locationProvider.markers),
                      onMapCreated: (GoogleMapController controller) {
                        Future.delayed(const Duration(milliseconds: 200))
                            .then((value) {
                          _controller = controller;
                          _controller!.moveCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: _initialPosition, zoom: 17)));
                        });
                        setState(() {});
                      },
                    ),
                    locationProvider.pickAddress != null && _controller != null
                        ? Card(
                            elevation: 4,
                            child: locationSearchWidget(
                                context, _controller!, true))
                        : const SizedBox.shrink(),

                    //floating buttons
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //at current location
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  elevation: 4,
                                  child: InkWell(
                                    onTap: () => _checkPermission(() {
                                      locationProvider.getCurrentLocation(
                                          context, false,
                                          mapController: _controller);
                                    }, context),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.paddingSizeSmall),
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Icon(
                                        Icons.my_location,
                                        color: Theme.of(context).primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  child: InkWell(
                                    onTap: () => _checkPermission(() {
                                      locationProvider.setMapType();
                                    }, context),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.paddingSizeSmall),
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Icon(
                                        Icons.map,
                                        color: Theme.of(context).primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //where you want service
                          Text(getTranslated('where_service', context)!,
                              style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  height: 2)),

                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeDefault),
                              child: CustomButton(
                                buttonText:
                                    getTranslated('save_location', context),
                                onPressed: locationProvider.loading
                                    ? null
                                    : () {
                                        // if (widget.googleMapController !=
                                        //     null) {
                                        //   widget.googleMapController!
                                        //       .setMapStyle('[]');
                                        //   widget.googleMapController!
                                        //       .animateCamera(CameraUpdate
                                        //           .newCameraPosition(
                                        //               CameraPosition(
                                        //                   target: LatLng(
                                        //                     locationProvider
                                        //                         .pickPosition
                                        //                         .latitude,
                                        //                     locationProvider
                                        //                         .pickPosition
                                        //                         .longitude,
                                        //                   ),
                                        //                   zoom: 16)));
                                        //
                                        //   if (ResponsiveHelper.isWeb()) {
                                        //     locationProvider
                                        //         .setAddAddressData(true);
                                        //   }
                                        // }

                                        AddressModel addressModel =
                                            AddressModel(
                                                addressType: 'home',
                                                // address: "Jaipur Rajasthan",
                                                // latitude: "27.345390113900567",
                                                // longitude: "76.11703600734472",
                                                address: locationProvider
                                                    .pickAddress,
                                                latitude: locationProvider
                                                    .position.latitude
                                                    .toString(),
                                                longitude: locationProvider
                                                    .position.longitude
                                                    .toString(),
                                                houseNumber: '',
                                                area: '',
                                                landmark: '',
                                                city: '',
                                                pincode: int.parse('000000'));

                                        if (kDebugMode) {
                                          print(
                                              'adddress modal is: $addressModel');
                                          print(
                                              'adddress modal is: ${addressModel.addressType}');
                                          print(
                                              'adddress modal is: ${addressModel.address}');
                                        }

                                        if (addressModel.address!.isNotEmpty) {
                                          locationProvider
                                              .addAddress(addressModel, context)
                                              .then((value) {
                                            if (value.isSuccess) {
                                              ToastService()
                                                  .show(value.message!);
                                              Navigator.pop(context);
                                            }
                                          });
                                        } else {
                                          ToastService()
                                              .show('Address is required');
                                        }
                                      },
                              ),
                            ),
                          ),

                          //manual location
                          SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, RouteHelper.getSetAddressRoute(),
                                  arguments: SetAddressScreen(
                                      fromCheckout: false,
                                      mapController: _controller!)),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeLarge),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: const Color(0xFF0B4619),
                                          width: 1)),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        getTranslated('enter_manual', context)!,
                                        textAlign: TextAlign.center,
                                        style: poppinsRegular.copyWith(
                                            color: const Color(0xFF0B4619),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            height: 2)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //floating location pin
                    Center(
                        child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    )),
                    locationProvider.loading
                        ? Center(
                            child: CustomLoader(
                                color: Theme.of(context).primaryColor))
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => const PermissionDialog());
    } else {
      callback();
    }
  }
}
