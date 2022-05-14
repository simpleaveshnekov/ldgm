import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user/constants/image_constants.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/productFilterModel.dart';
import 'package:user/screens/filter_screen.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/cart_item_count_button.dart';
import 'package:user/widgets/products_menu.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultsScreen extends BaseRoute {
  @required
  final String searchParams;

  SearchResultsScreen({a, o, this.searchParams}) : super(a: a, o: o, r: 'SearchResultsScreen');

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState(searchParams: searchParams);
}

class _SearchResultsScreenState extends BaseRouteState {
  String searchParams;
  List<Product> _productSearchResult = [];
  ProductFilter _productFilter = new ProductFilter();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDataLoaded = false;
  TextEditingController _cSearch = new TextEditingController();
  int page = 1;
  final CartController cartController = Get.put(CartController());

  _SearchResultsScreenState({this.searchParams});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        return Get.to(() => SearchScreen(
              a: widget.analytics,
              o: widget.observer,
            ));
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _onRefresh();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GetBuilder<CartController>(
                    init: cartController,
                    builder: (value) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => Get.to(() => SearchScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )),
                                    child: Icon(
                                      Icons.keyboard_arrow_left,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      cursorColor: Colors.grey[800],
                                      autofocus: false,
                                      controller: _cSearch,
                                      style: textFieldHintStyle(context),
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.none,
                                      obscureText: false,
                                      readOnly: false,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.secondary,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          borderSide: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary, style: BorderStyle.none),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          borderSide: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary, style: BorderStyle.none),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            _cSearch.clear();
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_outlined,
                                          color: Colors.grey[800],
                                        ),
                                        hintText: "${AppLocalizations.of(context).hnt_search_product}",
                                        hintStyle: textFieldHintStyle(context),
                                        contentPadding: EdgeInsets.only(bottom: 12.0),
                                      ),
                                      onFieldSubmitted: (val) async {
                                        if (val != null && val != '') {
                                          setState(() {
                                            _productSearchResult.clear();
                                            _isDataLoaded = false;
                                            searchParams = val;
                                            _onRefresh();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Center(
                                    child: InkWell(
                                      onTap: () async {
                                        await _applyFilters();
                                      },
                                      child: SvgPicture.asset(
                                        ImageConstants.FILTER_SEARCH_LOGO_URL,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _isDataLoaded
                                ? Text(
                                    _productSearchResult != null && _productSearchResult.length > 0 ? "${_productSearchResult.length} Items Found" : "",
                                    style: textTheme.headline6,
                                  )
                                : SizedBox(),
                          ),
                          _isDataLoaded
                              ? _productSearchResult != null && _productSearchResult.length > 0
                                  ? ProductsMenu(
                                      analytics: widget.analytics,
                                      observer: widget.observer,
                                      categoryProductList: _productSearchResult,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 200, bottom: 200),
                                      child: Center(child: Text('${AppLocalizations.of(context).txt_nothing_to_show}')),
                                    )
                              : _shimmer(),
                        ],
                      ),
                    ),
                  ),
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
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cSearch.text = searchParams;
    _init();
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
              isProductAvailable: _productSearchResult != null && _productSearchResult.length > 0 ? true : false,
            )),
      ).then((value) async {
        if (value != null) {
          _isDataLoaded = false;
          if (_productSearchResult != null && _productSearchResult.length > 0) {
            _productSearchResult.clear();
          }

          setState(() {});
          _productFilter = value;
          await _init();
        }
      });
    } catch (e) {
      print("Exception - search_results_screen.dart - _applyFilters():" + e.toString());
    }
  }

  _getProductSearchResult() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getproductSearchResult(searchParams, _productFilter).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _productSearchResult = result.data;
            } else {
              _productSearchResult = null;
            }
          }
        });
        _productFilter.maxPriceValue = _productSearchResult != null && _productSearchResult.length > 0 ? _productSearchResult[0].maxprice : 0;
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - search_results_screen.dart - _getProductSearchResult():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getProductSearchResult();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - search_results_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - search_results_screen.dart - _onRefresh():" + e.toString());
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
              itemCount: 8,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 0,
                    ));
              })),
    );
  }
}
