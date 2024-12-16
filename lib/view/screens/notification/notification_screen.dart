import 'package:flutter/material.dart';
import 'package:shreeveg/data/model/response/notification_model.dart';
import 'package:shreeveg/helper/date_converter.dart';
import 'package:shreeveg/helper/responsive_helper.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/provider/notification_provider.dart';
import 'package:shreeveg/utill/color_resources.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/base/custom_loader.dart';
import 'package:shreeveg/view/base/footer_view.dart';
import 'package:shreeveg/view/base/no_data_screen.dart';
import 'package:shreeveg/view/base/web_app_bar/web_app_bar.dart';
import 'package:shreeveg/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../helper/route_helper.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/images.dart';
import '../order/order_details_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<NotificationProvider>(context, listen: false)
        .initNotificationList(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: getTranslated('notification', context),
              backgroundColor: Theme.of(context).primaryColor,
              buttonTextColor: Colors.white)) as PreferredSizeWidget?,
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await notificationProvider.initNotificationList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeSmall, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              notificationProvider.setAlertSelected(true),
                          child: Column(
                            children: [
                              Text('Alert',
                                  style: poppinsRegular.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dimensions.fontSizeDefault)),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              notificationProvider.isAlertSelected
                                  ? Container(
                                      height: 4,
                                      color: const Color(0xFF212121),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              notificationProvider.setAlertSelected(false),
                          child: Column(
                            children: [
                              Text('Offers',
                                  style: poppinsRegular.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dimensions.fontSizeDefault)),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              !notificationProvider.isAlertSelected
                                  ? Container(
                                      height: 4,
                                      color: const Color(0xFF212121),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      // ResponsiveHelper.isDesktop(context) ? notificationProvider.notificationList.length<=4 ? SizedBox(height: 150) : SizedBox(): SizedBox(),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: ResponsiveHelper.isDesktop(context)
                                ? MediaQuery.of(context).size.height - 400
                                : MediaQuery.of(context).size.height),
                        child: Consumer<NotificationProvider>(
                            builder: (context, notificationProvider, child) {
                          List<NotificationModel>? notificationList =
                              notificationProvider.isAlertSelected
                                  ? notificationProvider.notificationListAlert
                                  : notificationProvider.notificationListOffer;
                          List<DateTime> dateTimeList = [];
                          return notificationList != null
                              ? notificationList.isNotEmpty
                                  ? Scrollbar(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6),
                                        child: ListView.builder(
                                            itemCount: notificationList.length,
                                            padding: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? const EdgeInsets.symmetric(
                                                    horizontal: 350,
                                                    vertical: 20)
                                                : EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              DateTime originalDateTime =
                                                  DateConverter
                                                      .isoStringToLocalDate(
                                                          notificationList[
                                                                  index]
                                                              .createdAt!);
                                              DateTime convertedDate = DateTime(
                                                  originalDateTime.year,
                                                  originalDateTime.month,
                                                  originalDateTime.day);
                                              bool addTitle = false;
                                              if (!dateTimeList
                                                  .contains(convertedDate)) {
                                                addTitle = true;
                                                dateTimeList.add(convertedDate);
                                              }
                                              return InkWell(
                                                onTap: () {
                                                  if (notificationList[index]
                                                          .type ==
                                                      'offer') {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return NotificationDialog(
                                                              notificationModel:
                                                                  notificationList[
                                                                      index]);
                                                        });
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushNamed(RouteHelper
                                                            .getOrderDetailsRoute(
                                                                notificationList[
                                                                        index]
                                                                    .orderId));
                                                  }
                                                },
                                                hoverColor: Colors.transparent,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    addTitle
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    2),
                                                            child: Text(
                                                                DateConverter.isoStringToLocalDateOnly(
                                                                    notificationList[
                                                                            index]
                                                                        .createdAt!),
                                                                style: poppinsRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeDefault)),
                                                          )
                                                        : const SizedBox(),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeLarge),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: Dimensions
                                                                  .paddingSizeDefault),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            // mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                child:
                                                                    Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal: ResponsiveHelper.isDesktop(
                                                                              context)
                                                                          ? Dimensions
                                                                              .paddingSizeLarge
                                                                          : 0),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              0.20)),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child: Icon(
                                                                      Icons
                                                                          .notifications_active_outlined,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                    // child: FadeInImage
                                                                    //     .assetNetwork(
                                                                    //   placeholder:
                                                                    //       Images.placeholder(
                                                                    //           context),
                                                                    //   image:
                                                                    //       '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${notificationProvider.notificationList![index].image}',
                                                                    //   height:
                                                                    //       150,
                                                                    //   width: MediaQuery.of(
                                                                    //           context)
                                                                    //       .size
                                                                    //       .width,
                                                                    //   fit: BoxFit
                                                                    //       .cover,
                                                                    //   imageErrorBuilder: (c, o, s) => Image.asset(
                                                                    //       Images.placeholder(
                                                                    //           context),
                                                                    //       height:
                                                                    //           150,
                                                                    //       width: MediaQuery.of(context)
                                                                    //           .size
                                                                    //           .width,
                                                                    //       fit: BoxFit
                                                                    //           .cover),
                                                                    // ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: Dimensions
                                                                      .paddingSizeDefault),
                                                              Expanded(
                                                                child: ListTile(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  title: Text(
                                                                    '${notificationList[index].orderId != null ? '#${notificationList[index].orderId} ' : ''}${notificationList[index].title!}',
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: poppinsBold
                                                                        .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeDefault,
                                                                    ),
                                                                  ),
                                                                  subtitle:
                                                                      Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        notificationList[index]
                                                                            .description!,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: poppinsLight
                                                                            .copyWith(
                                                                          color:
                                                                              Theme.of(context).hintColor,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          timeago.format(DateTime.parse(notificationList[index]
                                                                              .createdAt!)),
                                                                          style: poppinsRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeExtraSmall,
                                                                              fontWeight: FontWeight.w300))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                            ],
                                                          ),
                                                          Container(
                                                              height: 1,
                                                              color: ColorResources
                                                                      .getGreyColor(
                                                                          context)
                                                                  .withOpacity(
                                                                      1))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                  : const NoDataScreen()
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Center(
                                      child: CustomLoader(
                                          color:
                                              Theme.of(context).primaryColor)));
                        }),
                      ),
                      ResponsiveHelper.isDesktop(context)
                          ? const FooterView()
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
