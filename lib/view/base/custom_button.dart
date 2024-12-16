import 'package:flutter/material.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';

class CustomButton extends StatelessWidget {
  final String? buttonText;
  final Function? onPressed;
  final double margin;
  final Color? textColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;
  const CustomButton(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      this.margin = 0,
      this.textColor,
      this.borderRadius = 25,
      this.backgroundColor,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: TextButton(
        onPressed: onPressed as void Function()?,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ??
              (onPressed == null
                  ? Theme.of(context).hintColor.withOpacity(0.6)
                  : Theme.of(context).primaryColor),
          minimumSize:
              Size(width ?? MediaQuery.of(context).size.width, height ?? 44),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: Text(buttonText!,
            style: poppinsMedium.copyWith(
              color: textColor ?? Theme.of(context).cardColor,
              fontSize: Dimensions.fontSizeLarge,
            )),
      ),
    );
  }
}

class CustomCartButton extends StatelessWidget {
  final String? buttonText1;
  final String? buttonText2;
  final Function? onPressed;
  final double margin;
  final Color? textColor;
  final Color? backgroundColor;
  final double borderRadius;
  const CustomCartButton(
      {Key? key,
      required this.buttonText1,
      required this.buttonText2,
      required this.onPressed,
      this.margin = 0,
      this.textColor,
      this.borderRadius = 25,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed as void Function()?,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ??
            (onPressed == null
                ? Theme.of(context).hintColor.withOpacity(0.6)
                : Theme.of(context).primaryColor),
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(buttonText1!,
                style: poppinsMedium.copyWith(
                  color: textColor ?? Theme.of(context).cardColor,
                  fontSize: Dimensions.fontSizeLarge,
                )),
            Text(buttonText2!,
                style: poppinsMedium.copyWith(
                  color: textColor ?? Theme.of(context).cardColor,
                  fontSize: Dimensions.fontSizeLarge,
                )),
          ],
        ),
      ),
    );
  }
}
