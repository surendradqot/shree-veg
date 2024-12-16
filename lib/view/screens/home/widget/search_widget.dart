import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../helper/route_helper.dart';
import '../../../../localization/language_constraints.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteHelper.searchProduct),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context)
                    .darkTheme
                    ? Theme.of(context).cardColor
                    : AppConstants.textFormFieldColor,
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    getTranslated('search_anything', context)!,
                    style: poppinsRegular.copyWith(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
