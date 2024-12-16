import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constraints.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/styles.dart';
import '../../../base/rating_bar.dart';

class CartStoreOptions extends StatelessWidget {
  const CartStoreOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      int storeRows = 0;
      return Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
        int storesLength = profileProvider.userInfoModel!.stores!.length;
        if (kDebugMode) {
          print('stores length is: $storesLength');
        }
        if (storesLength.isEven) {
          storeRows = storesLength ~/ 2;
        } else {
          storeRows = (storesLength ~/ 2) + 1;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranslated('stores', context)!,
              style: poppinsRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: (180 * storeRows).toDouble(),
              child: Wrap(
                  children: List.generate(
                      storesLength,
                      (index) => InkWell(
                            onTap: () {
                              cartProvider.updateSelectedStoreId(
                                  '${profileProvider.userInfoModel!.stores![index].id}');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 170,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: cartProvider.selectedStoreId !=
                                                  null &&
                                              cartProvider.selectedStoreId ==
                                                  '${profileProvider.userInfoModel!.stores![index].id}'
                                          ? const Color(
                                              0xFFF1FFF4) // Color if the slot is both selected and enabled
                                          : Colors.white54,
                                      border: Border.all(
                                        width: 1,
                                        color: cartProvider.selectedStoreId !=
                                                    null &&
                                                cartProvider.selectedStoreId ==
                                                    '${profileProvider.userInfoModel!.stores![index].id}'
                                            ? const Color(
                                                0xFF039800) // Color if the slot is both selected and enabled
                                            : Colors.grey,
                                      )), // Default color (blue) if the slot is not enabled),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  Images.placeholder(context),
                                              image:
                                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.storeImageUrl}/${profileProvider.userInfoModel!.stores![index].document}',
                                              width: 85,
                                              imageErrorBuilder: (c, o, s) =>
                                                  Image.asset(
                                                      Images.placeholder(
                                                          context),
                                                      width: 85),
                                            ),
                                          ),
                                        ),
                                        Text(
                                            profileProvider.userInfoModel!
                                                .stores![index].name,
                                            style: poppinsRegular.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                        Text(
                                            profileProvider.userInfoModel!
                                                .stores![index].address,
                                            style: poppinsRegular.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                        RatingBar(
                                            rating: double.parse(profileProvider
                                                    .userInfoModel!
                                                    .stores![index]
                                                    .adminRating) -
                                                1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))),
            ),
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
          ],
        );
      });
    });
  }
}
