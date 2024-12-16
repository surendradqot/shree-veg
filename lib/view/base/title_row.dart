import 'package:flutter/material.dart';
import 'package:shreeveg/helper/product_type.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';

class TitleRow extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final Duration? eventDuration;
  final bool? isDetailsPage;
  const TitleRow(
      {Key? key,
      required this.title,
      this.onTap,
      this.eventDuration,
      this.isDetailsPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFlashDealScreen = ModalRoute.of(context)!.settings.name ==
        RouteHelper.getHomeItemRoute(ProductType.flashSale);
    int? days, hours, minutes, seconds;
    if (eventDuration != null) {
      days = eventDuration!.inDays;
      hours = eventDuration!.inHours - days * 24;
      minutes = eventDuration!.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = eventDuration!.inSeconds -
          (24 * days * 60 * 60) -
          (hours * 60 * 60) -
          (minutes * 60);
    }

    return Container(
      padding: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
          : const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(Dimensions.paddingSizeExtraSmall)),
        color: Theme.of(context).primaryColor.withOpacity(0.05),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          // Image.asset(Images.flashDeal, scale: 4),
          // const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(title!,
              style: ResponsiveHelper.isDesktop(context)
                  ? poppinsSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeOverLarge)
                  : poppinsMedium),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          if (eventDuration != null && !isFlashDealScreen)
            Expanded(
                child: Row(children: [
              const SizedBox(width: 5),
              TimerBox(time: days, day: 'day'.tr),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: hours, day: 'hour'.tr),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: minutes, day: 'min'.tr),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: seconds, day: 'sec'.tr),
            ])),
          onTap != null
              ? InkWell(
                  onTap: onTap as void Function()?,
                  child: isDetailsPage == null
                      ? Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                        child: Text(
                            'see_all'.tr,
                            style: ResponsiveHelper.isDesktop(context)
                                ? poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    color: Theme.of(context).primaryColor)
                                : poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.8)),
                          ),
                      )
                      : const SizedBox.shrink(),
                )
              : const SizedBox.shrink(),
          if (isFlashDealScreen && eventDuration != null)
            Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              const SizedBox(width: 5),
              TimerBox(time: days, day: 'day'.tr),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: hours, day: 'hour'.tr),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: minutes, day: 'min'.tr),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: seconds, day: 'sec'.tr),
            ])),
        ]),
      ),
    );
  }
}

class TimerBox extends StatelessWidget {
  final int? time;
  final bool isBorder;
  final String? day;

  const TimerBox(
      {Key? key, required this.time, this.isBorder = false, this.day})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: ResponsiveHelper.isDesktop(context)
          ? 40
          : MediaQuery.of(context).size.width / 9.5,
      height: ResponsiveHelper.isDesktop(context)
          ? 40
          : MediaQuery.of(context).size.width / 9.5,
      decoration: BoxDecoration(
        color: isBorder ? null : Theme.of(context).primaryColor,
        border: isBorder
            ? Border.all(width: 2, color: Theme.of(context).primaryColor)
            : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              time! < 10 ? '0$time' : time.toString(),
              style: poppinsRegular.copyWith(
                color: isBorder ? Theme.of(context).primaryColor : Colors.white,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
            Text(day!,
                style: poppinsRegular.copyWith(
                  color:
                      isBorder ? Theme.of(context).primaryColor : Colors.white,
                  fontSize: Dimensions.fontSizeSmall,
                )),
          ],
        ),
      ),
    );
  }
}
