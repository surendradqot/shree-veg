import 'package:flutter/material.dart';
import 'package:shreeveg/helper/route_helper.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/images.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/menu_bar.dart' as widget;

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Theme.of(context).cardColor,
          width: 1170.0,
          height: 45.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () => Navigator.pushNamed(context, RouteHelper.main),
                    child: Row(
                      children: [
                        Image.asset(Images.appLogo,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Text(AppConstants.appName,
                            style: poppinsMedium.copyWith(
                                color: Theme.of(context).primaryColor)),
                      ],
                    )),
              ),
              const widget.MenuBarWidget(),
            ],
          )),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
