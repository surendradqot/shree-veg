import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/address_model.dart';
import 'package:shreeveg/data/model/response/config_model.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/provider/order_provider.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/view/base/custom_button.dart';
import 'package:shreeveg/view/base/custom_snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ButtonsView extends StatelessWidget {
  final LocationProvider locationProvider;
  final bool isEnableUpdate;
  final bool fromCheckout;
  // final TextEditingController contactPersonNameController;
  // final TextEditingController contactPersonNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController areaTextController;
  final TextEditingController landTextController;
  final TextEditingController cityTextController;
  final TextEditingController stateTextController;
  final TextEditingController pinTextController;
  final AddressModel? address;
  final String location;
  const ButtonsView({
    Key? key,
    required this.locationProvider,
    required this.isEnableUpdate,
    required this.fromCheckout,
    // required this.contactPersonNumberController,
    // required this.contactPersonNameController,
    required this.address,
    required this.location,
    required this.houseNumberController,
    required this.areaTextController,
    required this.landTextController,
    required this.cityTextController,
    required this.stateTextController,
    required this.pinTextController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        locationProvider.addressStatusMessage != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  locationProvider.addressStatusMessage!.isNotEmpty
                      ? const CircleAvatar(
                          backgroundColor: Colors.green, radius: 5)
                      : const SizedBox.shrink(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationProvider.addressStatusMessage ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.green,
                              height: 1),
                    ),
                  )
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  locationProvider.errorMessage!.isNotEmpty
                      ? const CircleAvatar(
                          backgroundColor: Colors.red, radius: 5)
                      : const SizedBox.shrink(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationProvider.errorMessage ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.red,
                              height: 1),
                    ),
                  )
                ],
              ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Container(
          height: 50.0,
          width: 1170,
          child: !locationProvider.isLoading
              ? CustomButton(
                  borderRadius: 5,
                  buttonText: isEnableUpdate
                      ? getTranslated('update_address', context)
                      : getTranslated('save_and_proceed', context),
                  onPressed: locationProvider.loading
                      ? null
                      : () {

                    if(pinTextController.text.isEmpty) {
                      return showCustomSnackBar('Enter pin code of your area' ?? '');
                    }

                          // List<Branches> branches = Provider.of<SplashProvider>(
                          //         context,
                          //         listen: false)
                          //     .configModel!
                          //     .branches!;
                          // bool isAvailable = branches.length == 1 &&
                          //     (branches[0].latitude == null ||
                          //         branches[0].latitude!.isEmpty);
                          // if (!isAvailable) {
                          //   for (Branches branch in branches) {
                          //     double distance = Geolocator.distanceBetween(
                          //           double.parse(branch.latitude!),
                          //           double.parse(branch.longitude!),
                          //           locationProvider.position.latitude,
                          //           locationProvider.position.longitude,
                          //         ) /
                          //         1000;
                          //
                          //     print('branch dist is:: $distance');
                          //
                          //     if (distance > branch.coverage!) {
                          //       isAvailable = true;
                          //       break;
                          //     }
                          //   }
                          // }
                          // if (!isAvailable) {
                          //   showCustomSnackBar(getTranslated(
                          //       'service_is_not_available', context)!);
                          // }
                          // else {
                            AddressModel addressModel = AddressModel(
                              addressType: locationProvider.getAllAddressType[
                                  locationProvider.selectAddressIndex],
                              // contactPersonName:
                              //     contactPersonNameController.text,
                              // contactPersonNumber:
                              //     contactPersonNumberController.text,
                              address: locationProvider.pickAddress,
                              // address: "Jaipur, Rajasthan",
                              // latitude: "27.345390113900567",
                              //
                              // longitude: "76.11703600734472",
                              latitude: locationProvider.position.latitude.toString(),
                              longitude: locationProvider.position.longitude.toString(),
                              // floorNumber: floorNumberController.text,
                              houseNumber: houseNumberController.text,
                              area: areaTextController.text,
                              landmark: landTextController.text,
                              city: cityTextController.text,
                              pincode: int.parse(pinTextController.text)
                              // streetNumber: streetNumberController.text,
                            );
                            if (isEnableUpdate) {
                              addressModel.id = address!.id;
                              addressModel.userId = address!.userId;
                              addressModel.method = 'put';
                              locationProvider
                                  .updateAddress(context,
                                      addressModel: addressModel,
                                      addressId: addressModel.id)
                                  .then((value) {});
                            } else {
                              print('adddress modal is: $addressModel');
                              print('adddress modal is: ${addressModel.addressType}');
                              print('adddress modal is: ${addressModel.address}');
                              locationProvider
                                  .addAddress(addressModel, context)
                                  .then((value) {
                                if (value.isSuccess) {
                                  // Navigator.pop(context);
                                  if (fromCheckout) {
                                    Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .initAddressList();
                                    Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .setAddressIndex(-1);
                                  } else {
                                    showCustomSnackBar(value.message ?? '',
                                        isError: false);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  showCustomSnackBar(value.message!);
                                }
                              });
                            }
                          // }
                        },
                )
              : Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                )),
        )
      ],
    );
  }
}