import 'package:flutter/material.dart';
import 'package:shreeveg/helper/date_converter.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';

class CustomStepper extends StatelessWidget {
  final bool isActive;
  final bool haveTopBar;
  final String? title;
  final Widget? child;
  final double height;
  final String? time;

  const CustomStepper(
      {Key? key,
      required this.title,
      required this.isActive,
      this.child,
      this.haveTopBar = true,
      this.height = 30,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('step time is: $time');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      haveTopBar
          ? Row(children: [
              Container(
                height: height,
                width: 2,
                margin: const EdgeInsets.only(left: 14),
                color: isActive
                    ? Theme.of(context).primaryColor
                    : ColorResources.getGreyColor(context),
              ),
              child == null ? const SizedBox() : child!,
            ])
          : const SizedBox(),
      Row(children: [
        isActive
            ? Icon(Icons.check_circle_outlined,
                color: Theme.of(context).primaryColor, size: 30)
            : Container(
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorResources.getGreyColor(context), width: 2),
                    shape: BoxShape.circle),
              ),
        SizedBox(
            width: isActive
                ? Dimensions.paddingSizeExtraSmall
                : Dimensions.paddingSizeSmall),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title!,
                style: isActive
                    ? poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)
                    : poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
            Text(
                time == null
                    ? ''
                    : '${DateConverter.isoStringToLocalTimeWithAmPmAndDay(time!)} ${DateConverter.isoStringToLocalDateOnly(time!)}',
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall)),
          ],
        ),
      ]),
    ]);
  }
}
