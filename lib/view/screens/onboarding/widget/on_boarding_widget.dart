import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/onboarding_model.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';

class OnBoardingWidget extends StatelessWidget {
  final OnBoardingModel onBoardingModel;
  const OnBoardingWidget({Key? key, required this.onBoardingModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(
              onBoardingModel.imageUrl,
            ),
          )),
      Expanded(
        flex: 2,
        child: Text(
          onBoardingModel.title,
          style: poppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeOverLarge,
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          onBoardingModel.description,
          style: poppinsLight.copyWith(
              fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }
}
