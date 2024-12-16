import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final bool? showLabel;
  final double? borderRadius;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final int maxLength;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final String? prefixAssetUrl;
  final Function? onTap;
  final Function? onSuffixTap;
  final IconData? suffixIconUrl;
  final String? suffixAssetUrl;
  final IconData? prefixIconUrl;
  final bool isSearch;
  final Function? onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final bool isElevation;
  final bool isPadding;
  final Function? onChanged;
  final bool islogin;
  final bool isloginWithPhone;
  //final LanguageProvider languageProvider;

  const CustomTextField({
    Key? key,
    this.hintText = 'Write something...',
    this.showLabel = false,
    this.borderRadius,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.maxLength = 100,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.capitalization = TextCapitalization.none,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTap,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIconUrl,
    this.prefixIconUrl,
    this.prefixAssetUrl,
    this.isSearch = false,
    this.isElevation = true,
    this.onChanged,
    this.isPadding = true,
    this.suffixAssetUrl,
    this.islogin = false,
    this.isloginWithPhone = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  Key? _textFieldKey;

  @override
  void initState() {
    super.initState();
    _textFieldKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: _textFieldKey,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.w500),
      textInputAction: widget.inputAction,
      keyboardType: widget.islogin
          ? widget.isloginWithPhone
              ? TextInputType.phone
              : TextInputType.emailAddress
          : widget.inputType,
      cursorColor: AppConstants.primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
              LengthLimitingTextInputFormatter(10),
            ]
          : null,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.symmetric(
        //     vertical: 10, horizontal: widget.isPadding ? 22 : 0),
        counterText: '',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: AppConstants.primaryColor, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: AppConstants.primaryColor, width: 2)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.grey, width: 1)),
        isDense: true,
        labelText: widget.showLabel != null && widget.showLabel!
            ? widget.hintText
            : '',
        labelStyle: poppinsLight.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
            color: Theme.of(context).hintColor.withOpacity(0.8)),
        hintText: widget.hintText,
        fillColor: (widget.fillColor != null)
            ? widget.fillColor
            : Provider.of<ThemeProvider>(context).darkTheme
                ? Theme.of(context).cardColor
                : AppConstants.textFormFieldColor,
        hintStyle: poppinsLight.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).primaryColor.withOpacity(0.8)),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon
            ? widget.prefixAssetUrl != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Image.asset(
                      widget.prefixAssetUrl!,
                      width: 20,
                      height: 14,
                    ),
                  )
                : IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      widget.prefixIconUrl,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color
                          ?.withOpacity(0.6),
                    ),
                    onPressed: () {},
                  )
            : const SizedBox.shrink(),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: widget.isShowSuffixIcon
            ? widget.islogin
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: InkWell(
                        onTap: widget.onSuffixTap as void Function()?,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),
                          child: Text(
                            widget.isloginWithPhone ? 'Use Email' : 'Use Phone',
                            textAlign: TextAlign.center,
                            style: poppinsRegular.copyWith(
                                fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                : widget.isPassword
                    ? IconButton(
                        icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                Theme.of(context).hintColor.withOpacity(0.3)),
                        onPressed: _toggle)
                    : widget.isIcon
                        ? IconButton(
                            onPressed: widget.onSuffixTap as void Function()?,
                            icon: ResponsiveHelper.isDesktop(context)
                                ? Image.asset(
                                    widget.suffixAssetUrl!,
                                    width: 15,
                                    height: 15,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  )
                                : Icon(widget.suffixIconUrl,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.6)),
                          )
                        : null
            : null,
      ),
      onTap: widget.onTap as void Function()?,
      onChanged: widget.onChanged as void Function(String)?,
      onSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null
              ? widget.onSubmit!(text)
              : null,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isloginWithPhone != widget.isloginWithPhone) {
      // If isloginWithPhone changes, recreate the TextField
      _textFieldKey = GlobalKey();
    }
  }
}
