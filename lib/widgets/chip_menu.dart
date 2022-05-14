import 'package:flutter/material.dart';
import 'package:user/models/categoryListModel.dart';
import 'package:user/models/categoryProductModel.dart';
import 'package:user/screens/search_results_screen.dart';
import 'package:user/utils/navigation_utils.dart';

import 'my_chip.dart';

class ChipMenu extends StatefulWidget {
  @required
  final List<Product> trendingSearchProductList;
  final List<String> selectedItems;
  final List<CategoryList> categoryList;
  @required
  final Function(String) onChanged;
  final int screenId;
  final dynamic analytics;
  final dynamic observer;

  ChipMenu({this.trendingSearchProductList, this.onChanged, this.selectedItems, this.categoryList, this.screenId, this.analytics, this.observer}) : super();

  @override
  _ChipMenuState createState() => _ChipMenuState(trendingSearchProductList: trendingSearchProductList, selectedItems: selectedItems, onChanged: onChanged, categoryList: categoryList, screenId: screenId, analytics: analytics, observer: observer);
}

class _ChipMenuState extends State<ChipMenu> {
  List<Product> trendingSearchProductList;
  List<String> selectedItems;
  Function(String) onChanged;
  List<CategoryList> categoryList;
  int _selectedIndex;
  int screenId;
  dynamic analytics;
  dynamic observer;

  _ChipMenuState({this.trendingSearchProductList, this.onChanged, this.selectedItems, this.categoryList, this.screenId, this.analytics, this.observer});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 4.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: screenId == 1 ? _categoryList() : _productList());
  }

  List<Widget> _categoryList() {
    List<Widget> _categoriesList = [];
    for (int i = 0; i < categoryList.length; i++) {
      _categoriesList.add(MyChip(
        key: UniqueKey(),
        label: categoryList[i].title,
        isSelected: false,
        onPressed: () {},
      ));
    }
    return _categoriesList;
  }

  List<Widget> _productList() {
    List<Widget> _trendingSearchProducts = [];
    for (int i = 0; i < trendingSearchProductList.length; i++) {
      _trendingSearchProducts.add(MyChip(
        key: UniqueKey(),
        label: trendingSearchProductList[i].productName,
        isSelected: trendingSearchProductList[i].isSelected,
        onPressed: () {
          trendingSearchProductList.map((e) => e.isSelected = false).toList();
          setState(() {
            _selectedIndex = i;
            if (_selectedIndex == i) {
              trendingSearchProductList[i].isSelected = true;
            }
          });
          Navigator.of(context).push(NavigationUtils.createAnimatedRoute(
              1.0,
              SearchResultsScreen(
                a: widget.analytics,
                o: widget.observer,
                searchParams: trendingSearchProductList[i].productName,
              )));
        },
      ));
    }
    return _trendingSearchProducts;
  }
}
