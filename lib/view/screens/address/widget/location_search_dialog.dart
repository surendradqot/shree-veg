// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/location_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

Widget locationSearchWidget(
    BuildContext context, GoogleMapController mapController, bool showBack,
    {String? selectedItem, List<String>? placesList}) {
  final typeController = TextEditingController();
  final locationProvider =
      Provider.of<LocationProvider>(context, listen: false);
  typeController.text = locationProvider.pickAddress ?? '';

  return TypeAheadField(
    controller: typeController,
    builder: (context, controller, focusNode) {
      return TextField(
        controller: typeController,
        focusNode: focusNode,
        autofocus: false,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
            hintText: getTranslated('search_location', context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(style: BorderStyle.none, width: 0),
            ),
            hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).disabledColor,
                ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            // suffixIcon: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: Container(
            //     height: 30,
            //     decoration: BoxDecoration(color: Colors.white),
            //     child: DropdownButton<String>(
            //       value: locationProvider.selectedPlace,
            //       style:
            //           TextStyle(color: const Color(0xFF0B4619), fontSize: 18),
            //       icon: Icon(
            //         Icons.arrow_drop_down,
            //         color: const Color(0xFF0B4619),
            //       ),
            //       onChanged: (String? newValue) {
            //         locationProvider.setSelectedPlace(newValue ?? "");
            //       },
            //       items: locationProvider.placesList
            //           .map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // ),
            prefixIcon: showBack
                ? IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Theme.of(context).primaryColor,
                    ))
                : null),
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: Dimensions.fontSizeDefault,
            ),
      );
    },
    suggestionsCallback: (pattern) async {
      return await Provider.of<LocationProvider>(context, listen: false)
          .searchLocation(context, pattern);
    },
    itemBuilder: (context, Prediction suggestion) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Row(children: [
          const Icon(Icons.location_on),
          Expanded(
            child: Text(suggestion.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: Dimensions.fontSizeDefault,
                    )),
          ),
        ]),
      );
    },
    onSelected: (Prediction suggestion) {
      Provider.of<LocationProvider>(context, listen: false).setLocation(
          suggestion.placeId, suggestion.description, mapController);
    },
  );
}
