import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/product_provider.dart';
import '../../../utill/styles.dart';
import 'filters_screen.dart';

class SortingFilters extends StatefulWidget {
  const SortingFilters({Key? key}) : super(key: key);

  @override
  State<SortingFilters> createState() => _SortingFiltersState();
}

class _SortingFiltersState extends State<SortingFilters> {
  bool clearSelected = false;

  void clearSortingFilters() {
    setState(() {
      clearSelected = true;
    });
    Provider.of<ProductProvider>(context, listen: false).clearSortingFilters();
  }

  void applySortingFilters() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
            children: [
              const Expanded(
                child: SortOptions(),
              ),
              FilterActions(
                clearSelected: clearSelected,
                clearFilters: clearSortingFilters,
                applyFilters: applySortingFilters,
              ),
            ],
          );
        },
      ),
    );
  }
}

class SortOptions extends StatelessWidget {
  const SortOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> sortingOptions = ['Price', 'Rating', 'Discount'];

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          sortingOptions.length,
          (index) {
            return SortOptionsList(
              tileName: sortingOptions[index],
            );
          },
        ),
      ),
    );
  }
}

class SortOptionsList extends StatelessWidget {
  final String tileName;

  const SortOptionsList({Key? key, required this.tileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> optionsList = tileName == 'Price'
        ? [
            'Low to High',
            'High to Low',
            'Rupee Saving - Low to High',
            'Rupee Saving - High to Low'
          ]
        : tileName == 'Rating'
            ? ['Low to High', 'High to Low']
            : ['Low to High', 'High to Low'];

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return SingleChildScrollView(
          child: ExpansionTile(
            textColor: Colors.white,
            iconColor: const Color(0xFF0B4619),
            collapsedTextColor: Colors.white,
            collapsedBackgroundColor: Colors.grey.shade100,
            title: Container(
                color: const Color(0xFF0B4619),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tileName),
                )),
            children: List.generate(
              optionsList.length,
              (index) {
                String _selectedOption = optionsList[index];

                return InkWell(
                  onTap: () => productProvider.updateSelectedSortingOption(
                      tileName, _selectedOption),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedOption,
                          style: poppinsRegular.copyWith(
                            color: getColor(
                                _selectedOption,
                                tileName == 'Price'
                                    ? productProvider.selectedPriceSort
                                    : tileName == 'Rating'
                                        ? productProvider.selectedRatingSort
                                        : productProvider.selectedDiscountSort),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Radio<String>(
                          activeColor: const Color(0xFF0B4619),
                          value: _selectedOption,
                          groupValue: tileName == 'Price'
                              ? productProvider.selectedPriceSort
                              : tileName == 'Rating'
                                  ? productProvider.selectedRatingSort
                                  : productProvider.selectedDiscountSort,
                          onChanged: (value) => productProvider
                              .updateSelectedSortingOption(tileName, value!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
