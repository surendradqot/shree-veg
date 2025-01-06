import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/app_localization.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final Color? color;
  const TitleWidget({super.key, required this.title, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ResponsiveHelper.isDesktop(context)
          ? ColorResources.getAppBarHeaderColor(context)
          : color ?? Theme.of(context).canvasColor,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(horizontal: 5)
          : EdgeInsets.zero,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title!,
            style: ResponsiveHelper.isDesktop(context)
                ? poppinsSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.6))
                : poppinsMedium),
        onTap != null
            ? InkWell(
                onTap: onTap as void Function()?,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
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
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
