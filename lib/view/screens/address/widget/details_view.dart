import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/address_model.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_text_field.dart';
import 'package:shreeveg/view/screens/address/widget/buttons_view.dart';

class DetailsView extends StatelessWidget {
  final LocationProvider locationProvider;
  final FocusNode addressNode;
  // final FocusNode nameNode;
  // final FocusNode numberNode;
  final bool isEnableUpdate;
  final bool fromCheckout;
  final TextEditingController locationTextController;
  final TextEditingController houseNumberController;
  final TextEditingController areaTextController;
  final TextEditingController landTextController;
  final TextEditingController cityTextController;
  final TextEditingController stateTextController;
  final TextEditingController pinTextController;
  final FocusNode houseNode;
  final FocusNode areaNode;
  final FocusNode landNode;
  final FocusNode cityNode;
  final FocusNode stateNode;
  final FocusNode pinNode;
  const DetailsView(
      {Key? key,
      required this.locationProvider,
      required this.addressNode,
      // required this.nameNode,
      // required this.numberNode,
      required this.isEnableUpdate,
      required this.fromCheckout,
      required this.locationTextController,
      required this.houseNumberController,
      required this.areaTextController,
      required this.landTextController,
      required this.cityTextController,
      required this.stateTextController,
      required this.pinTextController,
      required this.houseNode,
      required this.areaNode,
      required this.landNode,
      required this.cityNode,
      required this.stateNode,
      required this.pinNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                  BoxShadow(
                    color: ColorResources.cartShadowColor.withOpacity(0.2),
                    blurRadius: 10,
                  )
                ])
          : const BoxDecoration(),
      //margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeLarge),
      padding: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeLarge)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomTextField(
            fillColor: Colors.white,
            hintText: getTranslated('house_no', context),
            showLabel: true,
            borderRadius: 0,
            isPadding: false,
            isShowBorder: true,
            inputType: TextInputType.streetAddress,
            inputAction: TextInputAction.next,
            focusNode: houseNode,
            nextFocus: areaNode,
            controller: houseNumberController,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomTextField(
            fillColor: Colors.white,
            hintText: getTranslated('area', context),
            showLabel: true,
            borderRadius: 0,
            isPadding: false,
            isShowBorder: true,
            inputType: TextInputType.streetAddress,
            inputAction: TextInputAction.next,
            focusNode: areaNode,
            nextFocus: landNode,
            controller: areaTextController,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomTextField(
            fillColor: Colors.white,
            hintText: getTranslated('land_mark', context),
            showLabel: true,
            borderRadius: 0,
            isPadding: false,
            isShowBorder: true,
            inputType: TextInputType.streetAddress,
            inputAction: TextInputAction.next,
            focusNode: landNode,
            nextFocus: cityNode,
            controller: landTextController,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  fillColor: Colors.white,
                  hintText: getTranslated('city', context),
                  showLabel: true,
                  borderRadius: 0,
                  isPadding: false,
                  isShowBorder: true,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  focusNode: cityNode,
                  nextFocus: pinNode,
                  controller: cityTextController,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeLarge),
              Expanded(
                child: CustomTextField(
                  fillColor: Colors.white,
                  hintText: getTranslated('pin_code', context),
                  showLabel: true,
                  borderRadius: 0,
                  isPadding: false,
                  isShowBorder: true,
                  maxLength: 6,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  focusNode: pinNode,
                  nextFocus: stateNode,
                  controller: pinTextController,
                ),
              ),
            ],
          ),
          if (ResponsiveHelper.isDesktop(context))
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge),
              child: ButtonsView(
                locationProvider: locationProvider,
                isEnableUpdate: isEnableUpdate,
                fromCheckout: fromCheckout,
                location: locationTextController.text,
                houseNumberController: houseNumberController,
                areaTextController: areaTextController,
                landTextController: landTextController,
                cityTextController: cityTextController,
                stateTextController: stateTextController,
                pinTextController: pinTextController,
                address: AddressModel(
                    addressType: locationProvider
                        .getAllAddressType[locationProvider.selectAddressIndex],
                    address: locationTextController.text),
              ),
            )
        ],
      ),
    );
  }
}
