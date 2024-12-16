import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/screens/address/widget/buttons_view.dart';
import 'package:shreeveg/view/screens/address/widget/details_view.dart';
import 'package:shreeveg/view/screens/address/widget/location_search_dialog.dart';
import '../../../helper/responsive_helper.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/dimensions.dart';
import '../../base/custom_text_field.dart';

class SetAddressScreen extends StatefulWidget {
  final bool fromCheckout;
  final GoogleMapController mapController;
  const SetAddressScreen(
      {Key? key, required this.fromCheckout, required this.mapController})
      : super(key: key);

  @override
  State<SetAddressScreen> createState() => _SetAddressScreenState();
}

class _SetAddressScreenState extends State<SetAddressScreen> {
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _areaTextController = TextEditingController();
  final TextEditingController _landTextController = TextEditingController();
  final TextEditingController _cityTextController = TextEditingController();
  final TextEditingController _stateTextController = TextEditingController();
  final TextEditingController _pinTextController = TextEditingController();

  final FocusNode _addressNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _areaNode = FocusNode();
  final FocusNode _landNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _pinNode = FocusNode();

  _initLoading() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final userModel =
        Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
    // if (widget.address == null) {
    //   locationProvider.setAddAddressData(false);
    // }

    await locationProvider.initializeAllAddressType(context: context);
    locationProvider.updateAddressStatusMessage(message: '');
    locationProvider.updateErrorMessage(message: '');

    // if (widget.isEnableUpdate && widget.address != null) {
    //   _updateAddress = false;
    //
    //   locationProvider.updatePosition(
    //     CameraPosition(
    //         target: LatLng(double.parse(widget.address!.latitude!),
    //             double.parse(widget.address!.longitude!))),
    //     true,
    //     widget.address!.address,
    //     false,
    //   );
    //   _contactPersonNameController.text =
    //   '${widget.address!.contactPersonName}';
    //   _contactPersonNumberController.text =
    //   '${widget.address!.contactPersonNumber}';
    //   _streetNumberController.text = widget.address!.streetNumber ?? '';
    //   _houseNumberController.text = widget.address!.houseNumber ?? '';
    //   _florNumberController.text = widget.address!.floorNumber ?? '';
    //
    //   if (widget.address!.addressType == 'Home') {
    //     locationProvider.updateAddressIndex(0, false);
    //   } else if (widget.address!.addressType == 'Workplace') {
    //     locationProvider.updateAddressIndex(1, false);
    //   } else {
    //     locationProvider.updateAddressIndex(2, false);
    //   }
    // } else {
    //   _contactPersonNameController.text =
    //   userModel == null ? '' : '${userModel.fName}' ' ${userModel.lName}';
    //   _contactPersonNumberController.text =
    //   userModel == null ? '' : userModel.phone!;
    // }
  }

  @override
  void initState() {
    super.initState();

    _initLoading();

    // if (widget.address != null && !widget.fromCheckout) {
    //   _locationTextController.text = widget.address!.address!;
    // }
  }

  // void _openSearchDialog(
  //     BuildContext context, GoogleMapController? mapController) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) =>
  //           LocationSearchDialog(mapController: mapController));
  // }

  @override
  Widget build(BuildContext context) {
    _pinTextController.text = extractPincode(
        Provider.of<LocationProvider>(context, listen: false).pickAddress ??
            '');

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0F0),
      appBar: CustomAppBar(
          title: 'Set Address',
          backgroundColor: Theme.of(context).primaryColor,
          buttonTextColor: Colors.white),
      body: SafeArea(child: SingleChildScrollView(
        child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(getTranslated('save_delivery_location', context)!,
                //   style: poppinsRegular.copyWith(
                //       fontSize: 16, fontWeight: FontWeight.w500
                //   ),),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                // locationProvider.pickAddress != null
                //     ?
                // InkWell(
                //   onTap: () =>
                //       locationSearchWidget(context, widget.mapController, false),
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: Dimensions.paddingSizeLarge,
                //         vertical: 12.0),
                //     decoration: BoxDecoration(
                //         color: Theme.of(context).cardColor,
                //         borderRadius: BorderRadius.circular(
                //             Dimensions.paddingSizeSmall)),
                //     child: Builder(builder: (context) {
                //       _locationTextController.text =
                //       locationProvider.pickAddress!;
                //
                //       return Row(children: [
                //         Expanded(
                //             child: Text(
                //               locationProvider.pickAddress != null ? locationProvider.pickAddress! : 'Search Location',
                //               maxLines: 1,
                //               overflow: TextOverflow.ellipsis,
                //             )),
                //         const Icon(Icons.search, size: 24),
                //       ]);
                //     }),
                //   ),
                // ),

                locationSearchWidget(context, widget.mapController, false),

                // for label us
                if (!ResponsiveHelper.isDesktop(context))
                  DetailsView(
                    locationProvider: locationProvider,
                    locationTextController: _locationTextController,
                    addressNode: _addressNode,
                    fromCheckout: widget.fromCheckout,
                    isEnableUpdate: false, // widget.isEnableUpdate,
                    houseNumberController: _houseNumberController,
                    areaTextController: _areaTextController,
                    landTextController: _landTextController,
                    cityTextController: _cityTextController,
                    stateTextController: _stateTextController,
                    pinTextController: _pinTextController,
                    houseNode: _houseNode,
                    areaNode: _areaNode,
                    landNode: _landNode,
                    cityNode: _cityNode,
                    stateNode: _stateNode,
                    pinNode: _pinNode,
                  ),

                // for address type
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    getTranslated('tag_as', context)!,
                    style: poppinsRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: locationProvider.getAllAddressType.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        locationProvider.updateAddressIndex(index, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault,
                          horizontal: Dimensions.paddingSizeLarge,
                        ),
                        margin: const EdgeInsets.only(right: 17),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeSmall),
                          border: Border.all(
                              color:
                                  locationProvider.selectAddressIndex == index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.6)),
                          color: locationProvider.selectAddressIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.white.withOpacity(0.9),
                        ),
                        child: Text(
                          getTranslated(
                              locationProvider.getAllAddressType[index]
                                  .toLowerCase(),
                              context)!,
                          style: poppinsRegular.copyWith(
                            color: locationProvider.selectAddressIndex == index
                                ? Theme.of(context).cardColor
                                : Theme.of(context).hintColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                if (!ResponsiveHelper.isDesktop(context))
                  ButtonsView(
                    locationProvider: locationProvider,
                    isEnableUpdate: false,
                    fromCheckout: widget.fromCheckout,
                    address: null, // widget.address
                    location: _locationTextController.text,
                    houseNumberController: _houseNumberController,
                    areaTextController: _areaTextController,
                    landTextController: _landTextController,
                    cityTextController: _cityTextController,
                    stateTextController: _stateTextController,
                    pinTextController: _pinTextController,
                  ),
              ],
            ),
          );
        }),
      )),
    );
  }

  String extractPincode(String address) {
    // Using regular expression to find pin code
    RegExp pincodeRegex = RegExp(r'\b\d{6}\b');
    Iterable<Match> matches = pincodeRegex.allMatches(address);

    // Taking the first match as pin code
    if (matches.isNotEmpty) {
      return matches.first.group(0)!;
    }

    return '';
  }
}
