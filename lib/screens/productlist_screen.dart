import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/image_constants.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/productFilterModel.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/filter_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/widgets/products_menu.dart';

class ProductListScreen extends BaseRoute {
  final int screenId;
  final int categoryId;
  final String categoryName;
  ProductListScreen({a, o, this.screenId, this.categoryId, this.categoryName}) : super(a: a, o: o, r: 'ProductListScreen');

  @override
  _ProductListScreenState createState() => _ProductListScreenState(screenId: screenId, categoryId: categoryId, categoryName: categoryName);
}

class _ProductListScreenState extends BaseRouteState {
  final CartController cartController = Get.put(CartController());
  List<Product> _productsList = [];
  bool _isDataLoaded = false;
  int screenId;
  int categoryId;
  String categoryName;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;

  ProductFilter _productFilter = new ProductFilter();
  ScrollController _scrollController = ScrollController();

  int page = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _ProductListScreenState({this.screenId, this.categoryId, this.categoryName});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: textTheme.headline6,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
        actions: [
          GetBuilder<CartController>(
            init: cartController,
            builder: (value) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      global.currentUser.id == null
                          ? Get.to(LoginScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            ))
                          : Get.to(CartScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            ));
                    },
                  ),
                  global.cartCount != null && global.cartCount != 0
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(global.cartCount != null && global.cartCount != 0 ? '${global.cartCount}' : ''),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () async {
                await _applyFilters();
              },
              child: SvgPicture.asset(
                ImageConstants.FILTER_SEARCH_LOGO_URL,
                height: 23,
              ),
            ),
          )
        ],
      ),
      body: _isDataLoaded
          ? _productsList != null && _productsList.length > 0
              ? RefreshIndicator(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            ProductsMenu(
                              analytics: widget.analytics,
                              observer: widget.observer,
                              categoryProductList: _productsList,
                            ),
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
                      )),
                )
              : Center(child: Text('${AppLocalizations.of(context).txt_nothing_to_show}'))
          : _shimmer(),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _applyFilters() async {
    try {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(padding: EdgeInsets.only(top: 100), child: FilterScreen(_productFilter, isProductAvailable: _productsList != null && _productsList.length > 0 ? true : false)),
      ).then((value) async {
        if (value != null) {
          _isDataLoaded = false;
          _isRecordPending = true;
          if (_productsList != null && _productsList.length > 0) {
            _productsList.clear();
          }

          setState(() {});
          _productFilter = value;
          await _init();
        }
      });
    } catch (e) {
      print("Exception - productlist_screen.dart - _applyFilters():" + e.toString());
    }
  }

  _getCategoryProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper.getCategoryProducts(categoryId, page, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _productsList.addAll(_tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getCategoryProduct():" + e.toString());
    }
  }

  _getDealProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper.getDealProducts(page, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _productsList.addAll(_tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getDealProduct():" + e.toString());
    }
  }

  _getProductList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (screenId == 0) {
          await _getCategoryProduct();
        } else if (screenId == 1) {
          await _getDealProduct();
        } else if (screenId == 2) {
          await _getTagProducts();
        } else if (screenId == 3) {
          await _getWhatsNewProduct();
        } else if (screenId == 4) {
          await _getSpotLightProduct();
        } else if (screenId == 5) {
          await _getRecentSellingProduct();
        } else {
          await _getTopSellingProduct();
        }

        _productFilter.maxPriceValue = _productsList != null && _productsList.length > 0 ? _productsList[0].maxprice : 0;
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getProductList():" + e.toString());
    }
  }

  _getRecentSellingProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper.recentSellingProduct(page, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _productsList.addAll(_tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getRecentSellingProduct():" + e.toString());
    }
  }

  _getSpotLightProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper.spotLightProduct(page, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _productsList.addAll(_tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getSpotLightProduct():" + e.toString());
    }
  }

  _getTagProducts() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper.getTagProducts(categoryName, page, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _productsList.addAll(_tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getDealProduct():" + e.toString());
    }
  }

  _getTopSellingProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
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
              _productsList.addAll(_tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getTopSellingProduct():" + e.toString());
    }
  }

  _getWhatsNewProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper.whatsnewProduct(page, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _productsList.addAll(_tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getWhatsNewProduct():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getProductList();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getProductList();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - productlist_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      _isRecordPending = true;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - productlist_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(height: 100 * MediaQuery.of(context).size.height / 830, width: MediaQuery.of(context).size.width, child: Card());
              })),
    );
  }
}
