import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/checkout_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/utils/navigation_utils.dart';
import 'package:user/widgets/cart_menu.dart';
import 'package:user/widgets/cart_screen_bottom_sheet.dart';

class CartScreen extends BaseRoute {
  CartScreen({
    a,
    o,
  }) : super(a: a, o: o, r: 'CartScreen');

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends BaseRouteState {
  final CartController cartController = Get.put(CartController());
  bool _isDataLoaded = false;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        return Get.to(() => HomeScreen(
              a: widget.analytics,
              o: widget.observer,
            ));
      },
      child: GetBuilder<CartController>(
          init: cartController,
          builder: (value) => Scaffold(
                appBar: AppBar(
                  title: Text(
                    "${AppLocalizations.of(context).txt_cart}",
                    style: textTheme.headline6,
                  ),
                  leading: IconButton(
                      onPressed: () {
                        Get.to(() => HomeScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            ));
                      },
                      icon: Icon(Icons.keyboard_arrow_left)),
                  actions: [
                    global.nearStoreModel != null
                        ? Padding(
                            padding: global.isRTL ? const EdgeInsets.only(left: 8.0) : const EdgeInsets.only(right: 8.0),
                            child: Center(
                              child: GetBuilder<CartController>(
                                init: cartController,
                                builder: (value) => Text(
                                  "${global.cartCount} ${AppLocalizations.of(context).lbl_items}",
                                  style: textTheme.subtitle1.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                body: global.nearStoreModel != null
                    ? _isDataLoaded
                        ? cartController.cartItemsList != null && cartController.cartItemsList.cartList != null && cartController.cartItemsList.cartList.length > 0
                            ? RefreshIndicator(
                                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  await _onRefresh();
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16.0,
                                          left: 16,
                                          right: 16,
                                          bottom: 0,
                                        ),
                                        child: CartMenu(
                                          cartController: cartController,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _emptyCartWidget()
                        : _shimmer()
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(global.locationMessage),
                      )),
                bottomNavigationBar: global.nearStoreModel != null
                    ? _isDataLoaded
                        ? cartController.cartItemsList != null && cartController.cartItemsList.cartList != null && cartController.cartItemsList.cartList.length > 0
                            ? GetBuilder<CartController>(
                                init: cartController,
                                builder: (value) => CartScreenBottomSheet(
                                  cartController: cartController,
                                  onButtonPressed: () => Navigator.of(context).push(
                                    NavigationUtils.createAnimatedRoute(
                                      1.0,
                                      CheckoutScreen(cartController: cartController, a: widget.analytics, o: widget.observer),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                        : _shimmer1()
                    : SizedBox(),
              )),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCartList();
    print('TOKEN:${global.appDeviceId}');
  }

  _emptyCartWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset(
              "assets/images/empty_cart.png",
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 18,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromWidth(350.0),
                  minimumSize: Size.fromHeight(55),
                  primary: Color(0xffFF0000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Get.to(() => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )),
                child: Text(
                  "${AppLocalizations.of(context).lbl_let_shop}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _getCartList() async {
    try {
      await cartController.getCartList();
      if (cartController.isDataLoaded.value == true) {
        _isDataLoaded = true;
      } else {
        _isDataLoaded = false;
      }
      setState(() {});
    } catch (e) {
      print("Exception -  cart_screen.dart - _getCartList():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _getCartList();
    } catch (e) {
      print("Exception -  cart_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 100 * MediaQuery.of(context).size.height / 830, width: MediaQuery.of(context).size.width, child: Card());
                    }),
              ),
            ],
          )),
    );
  }

  _shimmer1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: Card(elevation: 0),
                  ),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: Card(elevation: 0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: Card(elevation: 0),
                  ),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: Card(elevation: 0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: Card(elevation: 0),
                  ),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: Card(elevation: 0),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Card(elevation: 0),
              ),
            ],
          )),
    );
  }
}
