import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shreeveg/utill/app_constants.dart';
import 'package:shreeveg/utill/dimensions.dart';
import 'package:shreeveg/utill/styles.dart';
import 'package:shreeveg/view/base/custom_app_bar.dart';
import 'package:shreeveg/view/screens/filters/refine_filters.dart';
import 'package:shreeveg/view/screens/filters/sort_filters.dart';
import '../../../provider/product_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isRefineSelected = true;
  String? selectedFilter;
  String? selectedRefine;

  String? selectedPriceOption;

  String? selectedDiscountOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Filter'),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
            children: [
              RefineSortToggle(
                isRefineSelected: isRefineSelected,
                onTapRefine: () => setState(() => isRefineSelected = true),
                onTapSort: () => setState(() => isRefineSelected = false),
              ),
              Expanded(
                child: isRefineSelected
                    ? const RefineFilters()
                    : const SortingFilters(),
                // child: isRefineSelected
                //     ? RefineOptions(
                //         options: refineTiles,
                //         selectedOption: selectedRefine,
                //         onTapOption: (option) =>
                //             setState(() => selectedRefine = option),
                //       )
                //     : SortOptions(
                //         selectedRefine: selectedRefine,
                //         selectedRatingOption: selectedRatingOption,
                //         selectedPriceOption: selectedPriceOption,
                //         selectedDiscountOption: selectedDiscountOption,
                //         onTapRatingOption: (option) => setState(() {
                //           selectedFilter = selectedRatingOption = option;
                //           selectedPriceOption = null;
                //           selectedDiscountOption = null;
                //         }),
                //         onTapPriceOption: (option) => setState(() {
                //           selectedFilter = selectedPriceOption = option;
                //           selectedRatingOption = null;
                //           selectedDiscountOption = null;
                //         }),
                //         onTapDiscountOption: (option) => setState(() {
                //           selectedFilter = selectedDiscountOption = option;
                //           selectedRatingOption = null;
                //           selectedPriceOption = null;
                //         }),
                //       ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}

class RefineSortToggle extends StatelessWidget {
  const RefineSortToggle({
    Key? key,
    required this.isRefineSelected,
    required this.onTapRefine,
    required this.onTapSort,
  }) : super(key: key);

  final bool isRefineSelected;
  final VoidCallback onTapRefine;
  final VoidCallback onTapSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTapRefine,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Refine By'),
                  Container(
                    height: 2,
                    color: isRefineSelected
                        ? const Color(0xFF212121)
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onTapSort,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Sort By',
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color(0xFF4B4B4B),
                    ),
                  ),
                  Container(
                    height: 2,
                    color: !isRefineSelected
                        ? const Color(0xFF212121)
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterActions extends StatelessWidget {
  const FilterActions({
    Key? key,
    required this.clearSelected,
    required this.clearFilters,
    required this.applyFilters,
  }) : super(key: key);

  final bool clearSelected;
  final VoidCallback clearFilters;
  final VoidCallback applyFilters;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total items: ${productProvider.categoryProductList.length}',
                  style: poppinsBold.copyWith(color: AppConstants.primaryColor),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: clearFilters,
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0xFF0B4619)),
                      color: clearSelected
                          ? const Color(0xFF0B4619)
                          : const Color(0xFFFFFFFF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        'Clear All',
                        style: poppinsRegular.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: clearSelected
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeDefault,
                ),
                InkWell(
                  onTap: applyFilters,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFF0B4619),
                      ),
                      color: !clearSelected
                          ? const Color(0xFF0B4619)
                          : const Color(0xFFFFFFFF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        'Done',
                        style: poppinsRegular.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: !clearSelected
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Color getColor(String tileName, String? tileType) {
  if (tileType == tileName) return Colors.black;
  return Colors.grey;
}
