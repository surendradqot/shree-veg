import 'package:flutter/material.dart';
import 'package:shreeveg/provider/product_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool isCenter;
  final bool isElevation;
  final bool fromcategoriescreen;
  final Color? backgroundColor;
  final Color? buttonTextColor;
  final List<Widget>? actions;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.isCenter = true,
      this.isElevation = false,
      this.fromcategoriescreen = false,
      this.backgroundColor,
      this.buttonTextColor,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!,
          style: poppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: buttonTextColor ??
                  Theme.of(context).textTheme.bodyLarge!.color)),
      centerTitle: isCenter ? true : false,
      leading: isBackButtonExist
          ? IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Icon(Icons.arrow_back_ios,
                    color: buttonTextColor ??
                        Theme.of(context).textTheme.bodyLarge!.color),
              ),
              color: buttonTextColor ??
                  Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pop(context),
            )
          : const SizedBox(),
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
      elevation: isElevation ? 2 : 0,
      actions: actions ??
          [
            fromcategoriescreen
                ? PopupMenuButton(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    elevation: 20,
                    enabled: true,
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    onSelected: (dynamic value) {
                      int index =
                          Provider.of<ProductProvider>(context, listen: false)
                              .allSortBy
                              .indexOf(value);
                      Provider.of<ProductProvider>(context, listen: false)
                          .sortCategoryProduct(index);
                    },
                    itemBuilder: (context) {
                      return Provider.of<ProductProvider>(context,
                              listen: false)
                          .allSortBy
                          .map((choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text("$choice"),
                        );
                      }).toList();
                    })
                : const SizedBox(),
          ],
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
