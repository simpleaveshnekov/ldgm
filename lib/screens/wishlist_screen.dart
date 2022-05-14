import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/image_constants.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/productFilterModel.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/filter_screen.dart';
import 'package:user/widgets/products_menu.dart';

class WishListScreen extends BaseRoute {
  WishListScreen({a, o}) : super(a: a, o: o, r: 'WishListScreen');
  @override
  _WishListScreenState createState() => new _WishListScreenState();
}

class _WishListScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  int page = 1;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ProductFilter _productFilter = new ProductFilter();
  List<Product> _wishListProductList = [];
  GlobalKey<ScaffoldState> _scaffoldKey;
  final CartController cartController = Get.put(CartController());
  ScrollController _scrollController = ScrollController();

  _WishListScreenState() : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "${AppLocalizations.of(context).btn_wishlist}",
            style: textTheme.headline6,
          ),
          leading: IconButton(
              onPressed: () {
                global.isNavigate = true;
                setState(() {});
                Get.back();
              },
              icon: Icon(Icons.keyboard_arrow_left)),
          actions: [
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
        body: GetBuilder<CartController>(
          init: cartController,
          builder: (value) => RefreshIndicator(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            color: Theme.of(context).primaryColor,
            onRefresh: () async {
              _isDataLoaded = false;
              _isRecordPending = true;
              _wishListProductList.clear();
              setState(() {});
              await _init();
            },
            child: _isDataLoaded
                ? global.nearStoreModel.id != null
                    ? _wishListProductList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  ProductsMenu(
                                    analytics: widget.analytics,
                                    observer: widget.observer,
                                    categoryProductList: _wishListProductList,
                                    callId: 0,
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
                            ))
                        : Center(
                            child: Text(
                              "${AppLocalizations.of(context).txt_nothing_to_show}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                    : Center(
                        child: Text(
                          "${global.locationMessage}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                : _productShimmer(),
          ),
        ),
        bottomNavigationBar: _isDataLoaded && _wishListProductList.length > 0
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await _addAllProductToCart();
                      },
                      child: Text('${AppLocalizations.of(context).txt_add_all_to_cart}')),
                ),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _addAllProductToCart() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.addWishListToCart().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.cartCount = global.cartCount + _wishListProductList.length;
              _wishListProductList.clear();
              hideLoader();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(a: widget.analytics, o: widget.observer),
                ),
              );
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - wishlist_screen.dart - _addAllProductToCart():" + e.toString());
    }
  }

  _applyFilters() async {
    try {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
            padding: EdgeInsets.only(top: 100),
            child: FilterScreen(
              _productFilter,
              isProductAvailable: _wishListProductList != null && _wishListProductList.length > 0 ? true : false,
            )),
      ).then((value) async {
        if (value != null) {
          _isDataLoaded = false;
          if (_wishListProductList != null && _wishListProductList.length > 0) {
            _wishListProductList.clear();
          }

          setState(() {});
          _productFilter = value;
          await _init();
        }
      });
    } catch (e) {
      print("Exception - wishlist_screen.dart - _applyFilters():" + e.toString());
    }
  }

  _getWishListProduct() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_wishListProductList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          await apiHelper.getWishListProduct(page, _productFilter).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                List<Product> _tList = result.data;
                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }
                _wishListProductList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
        _productFilter.maxPriceValue = _wishListProductList.length > 0 ? _wishListProductList[0].maxprice : 0;
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - wishlist_screen.dart - _getWishListProduct():" + e.toString());
    }
  }

  _init() async {
    try {
      if (global.nearStoreModel.id != null) {
        await _getWishListProduct();
        _scrollController.addListener(() async {
          if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {
            setState(() {
              _isMoreDataLoaded = true;
            });
            await _getWishListProduct();
            setState(() {
              _isMoreDataLoaded = false;
            });
          }
        });
      }

      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - wishlist_screen.dart - _init():" + e.toString());
    }
  }

  Widget _productShimmer() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - wishlist_screen.dart - _productShimmer():" + e.toString());
      return SizedBox();
    }
  }
}
