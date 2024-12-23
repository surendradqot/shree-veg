import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import '../../../provider/product_provider.dart';
import '../../../utill/dimensions.dart';
import '../../base/rating_bar.dart';
import 'filters_screen.dart';

class RefineFilters extends StatefulWidget {
  const RefineFilters({Key? key}) : super(key: key);

  @override
  State<RefineFilters> createState() => _RefineFiltersState();
}

class _RefineFiltersState extends State<RefineFilters> {
  bool clearSelected = false;

  void clearRefineFilters() {
    setState(() {
      clearSelected = true;
    });
    Provider.of<ProductProvider>(context, listen: false).clearRefineFilters();
  }

  void applyFilters() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: RefineOptions(),
          ),
          FilterActions(
            clearSelected: clearSelected,
            clearFilters: clearRefineFilters,
            applyFilters: applyFilters,
          ),
        ],
      ),
    );
  }
}

class RefineOptions extends StatelessWidget {
  const RefineOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> refineOptions = const ['Price', 'Rating', 'Discount'];
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          refineOptions.length,
          (index) {
            return RefineOptionsList(
              tileName: refineOptions[index],
            );
          },
        ),
      ),
    );
  }
}

class RefineOptionsList extends StatelessWidget {
  final String tileName;

  const RefineOptionsList({Key? key, required this.tileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> refineOptions = tileName == 'Rating'
        ? ['2.0 and above', '3.0 and above', '4.0 and above']
        : ['20% and above', '40% and above', '60% and above', '70% and above'];
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTile(
                textColor: Colors.white,
                iconColor: const Color(0xFF0B4619),
                collapsedTextColor: Colors.white,
                collapsedBackgroundColor: Colors.grey.shade100,
                title: Container(
                  color: const Color(0xFF0B4619),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tileName),
                  ),
                ),
                children: tileName == 'Price'
                    ? [
                        productProvider.filterSelectedPriceRange.isNotEmpty
                            ? FlutterSlider(
                                tooltip: FlutterSliderTooltip(
                                  alwaysShowTooltip: true,
                                  custom: (value) {
                                    return Text(
                                      value.toStringAsFixed(0),
                                    );
                                  },
                                ),
                                handler: FlutterSliderHandler(
                                  child: const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF0B4619),
                                    size: 24,
                                  ),
                                ),
                                rightHandler: FlutterSliderHandler(
                                  child: const Icon(
                                    Icons.chevron_left,
                                    color: Color(0xFF0B4619),
                                    size: 24,
                                  ),
                                ),
                                trackBar: FlutterSliderTrackBar(
                                  inactiveTrackBarHeight: 6,
                                  activeTrackBarHeight: 8,
                                  inactiveTrackBar: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFF0B4619)
                                        .withOpacity(0.4),
                                    border: Border.all(
                                      width: 3,
                                      color: const Color(0xFF0B4619)
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  activeTrackBar: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xFF0B4619),
                                  ),
                                ),
                                values:
                                    productProvider.filterSelectedPriceRange,
                                rangeSlider: true,
                                max: productProvider.maxFilterRange,
                                min: 0,
                                onDragging:
                                    (handlerIndex, lowerValue, upperValue) {
                                  print('lllllllllllllllll: $lowerValue');
                                  print('uuuuuuuuuuuuuuuuu: $upperValue');
                                  if (upperValue <
                                      productProvider.maxFilterRange) {
                                    if (lowerValue < upperValue &&
                                        upperValue > lowerValue) {
                                      productProvider.updatePriceRangeFilter(
                                          lowerValue, upperValue);
                                    }
                                  }
                                },
                              )
                            : const SizedBox(),
                      ]
                    : [
                        for (String option in refineOptions)
                          ListTile(
                            title: Text(option),
                            subtitle: tileName == 'Rating'
                                ? RatingBar(
                                    rating: double.parse(option[0]) - 1,
                                    size: Dimensions.paddingSizeDefault,
                                    color: const Color(0xFF0B4619),
                                  )
                                : null,
                            trailing: Checkbox(
                              activeColor: const Color(0xFF0B4619),
                              value: tileName == 'Rating'
                                  ? productProvider
                                          .filterSelectedRatings.isNotEmpty &&
                                      productProvider.filterSelectedRatings
                                          .contains(
                                        double.parse(option[0]),
                                      )
                                  : productProvider
                                          .filterSelectedDiscounts.isNotEmpty &&
                                      productProvider.filterSelectedDiscounts
                                          .contains(
                                        double.parse(
                                          option.replaceAll(
                                              RegExp(r'%| and above'), ''),
                                        ),
                                      ),
                              onChanged: (bool? value) {
                                if (value != null) {
                                  if (value) {
                                    tileName == 'Rating'
                                        ? productProvider.filterSelectedRatings
                                            .add(
                                            double.parse(option[0]),
                                          )
                                        : productProvider
                                            .filterSelectedDiscounts
                                            .add(
                                            double.parse(
                                              option.replaceAll(
                                                  RegExp(r'%| and above'), ''),
                                            ),
                                          );
                                  } else {
                                    tileName == 'Rating'
                                        ? productProvider.filterSelectedRatings
                                            .remove(
                                            double.parse(option[0]),
                                          )
                                        : productProvider
                                            .filterSelectedDiscounts
                                            .remove(
                                            double.parse(
                                              option.replaceAll(
                                                  RegExp(r'%| and above'), ''),
                                            ),
                                          );
                                  }
                                  tileName == 'Rating'
                                      ? productProvider.applyRatingFilter(
                                          productProvider.filterSelectedRatings)
                                      : productProvider.applyDiscountFilter(
                                          productProvider
                                              .filterSelectedDiscounts);
                                }
                              },
                            ),
                            onTap: () {
                              if (tileName == 'Rating') {
                                if (productProvider.filterSelectedRatings
                                    .contains(double.parse(option[0]))) {
                                  productProvider.filterSelectedRatings
                                      .remove(double.parse(option[0]));
                                } else {
                                  productProvider.filterSelectedRatings.add(
                                    double.parse(option[0]),
                                  );
                                }
                                productProvider.applyRatingFilter(
                                    productProvider.filterSelectedRatings);
                              } else {
                                if (productProvider.filterSelectedDiscounts
                                    .contains(double.parse(option.replaceAll(
                                        RegExp(r'%| and above'), '')))) {
                                  productProvider.filterSelectedDiscounts
                                      .remove(double.parse(option.replaceAll(
                                          RegExp(r'%| and above'), '')));
                                } else {
                                  productProvider.filterSelectedDiscounts.add(
                                      double.parse(option.replaceAll(
                                          RegExp(r'%| and above'), '')));
                                }
                                productProvider.applyDiscountFilter(
                                    productProvider.filterSelectedDiscounts);
                              }
                            },
                          ),
                      ],
              ),
            ],
          ),
        );
      },
    );
  }
}
