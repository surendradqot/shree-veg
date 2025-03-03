import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/localization/language_constraints.dart';
import 'package:shreeveg/main.dart';
import 'package:shreeveg/provider/profile_provider.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';

class SelectWarehouseScreen extends StatefulWidget {
  final bool? closeButton;

  const SelectWarehouseScreen({super.key, required this.closeButton});

  @override
  State<SelectWarehouseScreen> createState() => _SelectWarehouseScreenState();
}

class _SelectWarehouseScreenState extends State<SelectWarehouseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(
          getTranslated('Shree Veg', context)!,
          style: poppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          !widget.closeButton!
              ? Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(Get.context!).pop();
                    },
                  ),
                )
              : SizedBox(),
        ],
        leading: Container(
          margin: EdgeInsets.only(left: 08, top: 08, bottom: 08),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.red,
            image: DecorationImage(
              image: AssetImage("assets/image/shree_logo.png"),
            ),
          ),
        ),
      ),*/
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Column(
          // shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          children: [
            widget.closeButton!
                ? Align(
                    alignment: Alignment.topRight,
                    child: CloseButton(
                      color: Color(0xFF0B4619),
                      onPressed: () {
                        Navigator.of(Get.context!).pop();
                      },
                    ),
                  )
                : SizedBox(
              height: 50,
            ),
            Container(
              height: 100,
              // margin: EdgeInsets.only(left: 08,top: 08,bottom: 08),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.red,
                image: DecorationImage(
                  image: AssetImage("assets/image/shree_logo.png"),
                ),
              ),
            ),
            SizedBox(
               height: 25,
            ),
            Text(
              'Please choose a location from the list below. This will help us provide you with the best services tailored to your area. Tap on the desired location to proceed.',
         textAlign: TextAlign.center,
              style: poppinsRegular.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Color(0xFF0B4619),
              thickness: 2,
            ),

            Expanded(
              child: Consumer<ProfileProvider>(builder: (context, provider, child) {
                if (provider.loadingValue) {
                  return SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()));
                }
                return ListView.separated(
                    // itemCount: provider.items.length,
                    itemCount: 50,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF0B4619),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            provider.items[0].warehousesCity!,
                            style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
