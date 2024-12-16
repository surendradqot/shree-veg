import 'package:flutter/material.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/splash_provider.dart';
import 'package:shreeveg/provider/theme_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/app_bar_base.dart';
import 'package:shreeveg/view/base/custom_dialog.dart';
import 'package:shreeveg/view/base/main_app_bar.dart';
import 'package:shreeveg/view/screens/settings/widget/currency_dialog.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';
import '../menu/widget/acount_delete_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).setFromSetting(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? null
          : (ResponsiveHelper.isDesktop(context)
              ? const MainAppBar()
              : const AppBarBase()) as PreferredSizeWidget?,
      body: Center(
        child: SizedBox(
          width: 1170,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall),
            children: [
              SwitchListTile(
                value: Provider.of<ThemeProvider>(context).darkTheme,
                onChanged: (bool isActive) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
                title: Text(getTranslated('dark_theme', context)!,
                    style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
              ),
              TitleButton(
                icon: Icons.language,
                title: getTranslated('choose_language', context),
                onTap: () =>
                    showAnimatedDialog(context, const CurrencyDialog()),
              ),
              authProvider.isLoggedIn()
                  ? ListTile(
                      onTap: () {
                        showAnimatedDialog(
                            context,
                            AccountDeleteDialog(
                              icon: Icons.question_mark_sharp,
                              title: getTranslated(
                                  'are_you_sure_to_delete_account', context),
                              description: getTranslated(
                                  'it_will_remove_your_all_information',
                                  context),
                              onTapFalseText: getTranslated('no', context),
                              onTapTrueText: getTranslated('yes', context),
                              isFailed: true,
                              onTapFalse: () => Navigator.of(context).pop(),
                              onTapTrue: () => authProvider.deleteUser(context),
                            ),
                            dismissible: false,
                            isFlip: true);
                      },
                      leading: Icon(Icons.delete,
                          size: 25, color: Theme.of(context).colorScheme.error),
                      title: Text(
                        getTranslated('delete_account', context)!,
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleButton extends StatelessWidget {
  final IconData icon;
  final String? title;
  final Function onTap;
  const TitleButton(
      {Key? key, required this.icon, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title!,
          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      onTap: onTap as void Function()?,
    );
  }
}
