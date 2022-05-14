import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryFilter.dart';
import 'package:user/models/categoryListModel.dart';
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/productFilterModel.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/screens/sub_categories_screen.dart';
import 'package:user/widgets/bundle_offers_menu.dart';
import 'package:user/widgets/cart_item_count_button.dart';
import 'package:user/widgets/my_chip.dart';
import 'package:user/widgets/products_menu.dart';

class CategoriesListButtons extends StatefulWidget {
  final List<CategoryList> categoriesList;
  final dynamic analytics;
  final dynamic observer;
  CategoriesListButtons(this.categoriesList, this.analytics, this.observer) : super();

  @override
  _CategoriesListButtonsState createState() => _CategoriesListButtonsState(this.categoriesList, this.analytics, this.observer);
}

class TopDealsScreen extends BaseRoute {
  TopDealsScreen({a, o}) : super(a: a, o: o, r: 'TopDealsScreen');

  @override
  _TopDealsScreenState createState() => _TopDealsScreenState();
}

class _CategoriesListButtonsState extends State<CategoriesListButtons> {
  dynamic analytics;
  dynamic observer;
  int _selectedIndex = 0;
  List<CategoryList> categoriesList;
  _CategoriesListButtonsState(this.categoriesList, this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categoriesList.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            MyChip(
              key: UniqueKey(),
              isSelected: _selectedIndex == index,
              onPressed: () {
                categoriesList.map((e) => e.isSelected = false).toList();
                _selectedIndex = index;
                if (_selectedIndex == index) {
                  categoriesList[index].isSelected = true;
                }

                Get.to(() => SubCategoriesScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      screenHeading: categoriesList[index].title,
                      categoryId: categoriesList[index].catId,
                    ));
              },
              label: categoriesList[index].title,
            ),
            SizedBox(width: 16),
          ],
        );
      },
    );
  }
}

class _TopDealsScreenState extends BaseRouteState {
  List<Product> _bundleOffersProductList = [];
  List<Product> _popularProductList = [];
  List<CategoryList> _categoriesList = [];
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  int page = 1;
  ProductFilter _productFilter = new ProductFilter();
  ScrollController _scrollController = ScrollController();
  final CartController cartController = Get.put(CartController());
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${AppLocalizations.of(context).lbl_deal_products}",
            style: textTheme.headline6,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.keyboard_arrow_left)),
          actions: [
            IconButton(
                onPressed: () async {
                  await openBarcodeScanner(_scaffoldKey);
                },
                icon: Icon(
                  MdiIcons.barcode,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: () => Get.to(() => SearchScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _onRefresh();
          },
          child: global.nearStoreModel != null && global.nearStoreModel.id != null
              ? Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              child: _isDataLoaded ? CategoriesListButtons(_categoriesList, widget.analytics, widget.observer) : _shimmer1(),
                            ),
                            _bundleOffersProductList != null && _bundleOffersProductList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text(
                                      "${AppLocalizations.of(context).lbl_bundle_offers}",
                                      style: textTheme.headline6,
                                    ),
                                  )
                                : SizedBox(),
                            _isDataLoaded
                                ? _bundleOffersProductList != null && _bundleOffersProductList.length > 0
                                    ? BundleOffersMenu(
                                        analytics: widget.analytics,
                                        observer: widget.observer,
                                        categoryProductList: _bundleOffersProductList,
                                      )
                                    : SizedBox()
                                : _shimmer2(),
                            _popularProductList != null && _popularProductList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text(
                                      "${AppLocalizations.of(context).lbl_popular}",
                                      style: textTheme.headline6,
                                    ),
                                  )
                                : SizedBox(),
                            _isDataLoaded
                                ? _popularProductList != null && _popularProductList.length > 0
                                    ? ProductsMenu(
                                        analytics: widget.analytics,
                                        observer: widget.observer,
                                        categoryProductList: _popularProductList,
                                      )
                                    : SizedBox()
                                : _shimmer3(),
                            _isMoreDataLoaded
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CartItemCountButton(
                          analytics: widget.analytics,
                          observer: widget.observer,
                          cartController: cartController,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(global.locationMessage),
                  ),
                ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getCategoriesList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getCategoryList(CategoryFilter(), page).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _categoriesList = result.data;
            } else {
              _categoriesList = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - top_deals_screen.dart - _getProductList():" + e.toString());
    }
  }

  _getDealProduct() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getDealProducts(1, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _bundleOffersProductList = result.data;
            } else {
              _bundleOffersProductList = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - top_deals_screen.dart - _getDealProduct():" + e.toString());
    }
  }

  _getTopSellingProduct() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_popularProductList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          await apiHelper.getTopSellingProducts(page, _productFilter).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                List<Product> _tList = result.data;
                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }
                _popularProductList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - top_deals_screen.dart - _getTopSellingProduct():" + e.toString());
    }
  }

  _init() async {
    try {
      _getCategoriesList();
      _getDealProduct();
      await _getTopSellingProduct();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getTopSellingProduct();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - top_deals_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      _isRecordPending = true;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - top_deals_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: SizedBox(
            height: 43,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 43,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 43,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 43,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ))
              ],
            )),
      ),
    );
  }

  _shimmer2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 264 / 796 - 20,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(width: MediaQuery.of(context).size.width * 220 / 411, child: Card()),
                  );
                }),
          )),
    );
  }

  _shimmer3() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(height: 100 * MediaQuery.of(context).size.height / 830, width: MediaQuery.of(context).size.width, child: Card());
              })),
    );
  }
}
