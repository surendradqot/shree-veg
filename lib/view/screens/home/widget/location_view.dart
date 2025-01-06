import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/data/model/response/address_model.dart';
import 'package:shreeveg/provider/location_provider.dart';

import '../../../../utill/styles.dart';
import '../../address/address_screen.dart';

class LocationView extends StatelessWidget {
  final Color locationColor;
  const LocationView({Key? key, required this.locationColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddressScreen())),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const CircleAvatar(
                      backgroundColor: Color(0xFF0B4619),
                      child: Icon(Icons.location_on_outlined,
                          color: Colors.white)),
                  const SizedBox(width: 20),
                  Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) => Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Location',
                            style: poppinsRegular.copyWith(
                                color: locationColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            locationProvider.addressList != null
                                ? locationProvider.addressList!.isNotEmpty
                                    ? locationProvider.addressList![0].address!
                                    : 'Select location'
                                : 'Select location',
                            style: poppinsRegular.copyWith(
                                color: locationColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: locationColor,
            )
          ],
        ),
      ),
    );
  }
}

class DeliveryLocationView extends StatelessWidget {
  final Color locationColor;
  const DeliveryLocationView({Key? key, required this.locationColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Container(
              height: 40,
              width: 40,
              color: const Color(0xFFEBEBEB),
              child: const Icon(Icons.location_on_outlined,
                  size: 20, color: Colors.black)),
          const SizedBox(width: 10),
          Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deliver to',
                        style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AddressScreen())),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Change',
                            style: poppinsRegular.copyWith(
                                color: const Color(0xFFFE5B00),
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    locationProvider.addressList != null
                        ? locationProvider.addressList!.isNotEmpty
                            ? locationProvider.addressList![0].address!
                            : ''
                        : '',
                    style: poppinsRegular.copyWith(
                        color: locationColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
