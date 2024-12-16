import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/provider/wallet_provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../main.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../base/custom_loader.dart';
import '../../../base/footer_view.dart';
import '../../../base/no_data_screen.dart';
import '../wallet_screen.dart';
import 'history_item.dart';

class WalletTransactions extends StatefulWidget {
  const WalletTransactions({Key? key}) : super(key: key);

  @override
  State<WalletTransactions> createState() => _WalletTransactionsState();
}

class _WalletTransactionsState extends State<WalletTransactions> {
  final bool _isLoggedIn =
      Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final walletProvide = Provider.of<WalletProvider>(context, listen: false);

    walletProvide.setCurrentTabButton(
      0,
      isUpdate: false,
    );

    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(Get.context!, listen: false).getUserInfo();
      Provider.of<WalletProvider>(context, listen: false)
          .getLoyaltyTransactionList('1', false, true);

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            walletProvide.transactionList != null &&
            !walletProvide.isLoading) {
          int pageSize = (walletProvide.popularPageSize! / 10).ceil();
          if (walletProvide.offset < pageSize) {
            walletProvide.setOffset = walletProvide.offset + 1;
            walletProvide.updatePagination(true);

            walletProvide.getLoyaltyTransactionList(
              walletProvide.offset.toString(),
              false,
              true,
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Wallet History',
        backgroundColor: AppConstants.primaryColor,
        buttonTextColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(children: [
            SizedBox(
              width: Dimensions.webScreenWidth,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Center(
                          child: SizedBox(
                            width: Dimensions.webScreenWidth,
                            child: Consumer<WalletProvider>(
                                builder: (context, walletProvider, _) {
                              return Column(children: [
                                Column(children: [
                                  walletProvider.transactionList != null
                                      ? walletProvider
                                              .transactionList!.isNotEmpty
                                          ? GridView.builder(
                                              key: UniqueKey(),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 50,
                                                mainAxisSpacing:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? Dimensions
                                                            .paddingSizeLarge
                                                        : 0.01,
                                                childAspectRatio: 1 == 1
                                                    ? !ResponsiveHelper
                                                            .isMobile()
                                                        ? 3.6
                                                        : 3
                                                    : ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? 5
                                                        : 4,
                                                crossAxisCount:
                                                    ResponsiveHelper.isMobile()
                                                        ? 1
                                                        : 2,
                                              ),
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: walletProvider
                                                  .transactionList!.length,
                                              padding: EdgeInsets.only(
                                                  top: ResponsiveHelper
                                                          .isDesktop(context)
                                                      ? 28
                                                      : 25),
                                              itemBuilder: (context, index) {
                                                return 1 == 1
                                                    ? WalletHistory(
                                                        transaction: walletProvider
                                                                .transactionList![
                                                            index],
                                                      )
                                                    : HistoryItem(
                                                        index: index,
                                                        formEarning: walletProvider
                                                                .selectedTabButtonIndex ==
                                                            1,
                                                        data: walletProvider
                                                            .transactionList,
                                                      );
                                              },
                                            )
                                          : const NoDataScreen(isSearch: true)
                                      : WalletShimmer(
                                          walletProvider: walletProvider),
                                  walletProvider.paginationLoader
                                      ? Center(
                                          child: Padding(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          child: CustomLoader(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ))
                                      : const SizedBox(),
                                ])
                              ]);
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (ResponsiveHelper.isDesktop(context))
              const SizedBox(height: Dimensions.paddingSizeDefault),
            if (ResponsiveHelper.isDesktop(context)) const FooterView(),
          ]),
        ),
      ),
    );
  }
}
