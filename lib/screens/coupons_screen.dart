import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/couponsModel.dart';
import 'package:user/models/orderModel.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/payment_screen.dart';
import 'package:user/widgets/coupon_card.dart';
import 'package:user/widgets/toastfile.dart';

class CouponsScreen extends BaseRoute {
  final int screenId;
  final int screenIdO;
  final String cartId;
  final CartController cartController;

  CouponsScreen(
      {a, o, this.screenId, this.cartId, this.cartController, this.screenIdO})
      : super(a: a, o: o, r: 'CouponsScreen');

  @override
  _CouponsScreenState createState() => _CouponsScreenState(
      screenId: screenId,
      cartId: cartId,
      cartController: cartController,
      screenIdO: screenIdO);
}

class _CouponsScreenState extends BaseRouteState {
  List<Coupon> _couponList = [];
  bool _isDataLoaded = false;
  CartController cartController;
  final Color color = const Color(0xffFF0000);
  GlobalKey<ScaffoldState> _scaffoldKey;
  int screenId;
  int screenIdO;
  String cartId;
  String _selectedCouponCode;
  Order order;

  _CouponsScreenState(
      {this.screenId, this.cartId, this.cartController, this.screenIdO});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
        actions: [
          global.cartCount != null && global.cartCount > 0
              ? FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  heroTag: null,
                  child: Badge(
                    badgeContent: Text(
                      "${global.cartCount}",
                      style: TextStyle(color: Colors.white, fontSize: 08),
                    ),
                    padding: EdgeInsets.all(6),
                    badgeColor: Colors.red,
                    child: Icon(
                      MdiIcons.shoppingOutline,
                      color: color,
                    ),
                  ),
                  mini: true,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CartScreen(a: widget.analytics, o: widget.observer),
                      ),
                    );
                  },
                )
              : SizedBox(),
          SizedBox(
            width: 15,
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "${AppLocalizations.of(context).lbl_my_coupons}  ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: _isDataLoaded
          ? _couponList != null && _couponList.length > 0
              ? RefreshIndicator(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: _couponList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CouponsCard(
                            coupon: _couponList[index],
                            onRedeem: () async {
                              _selectedCouponCode =
                                  _couponList[index].couponCode;
                              setState(() {});
                              if (screenId == 0) {
                                await _applyCoupon();
                              } else {
                                Clipboard.setData(
                                    ClipboardData(text: _selectedCouponCode));
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //   content: Text(
                                //     '${AppLocalizations.of(context).lbl_code_copied}',
                                //     textAlign: TextAlign.center,
                                //   ),
                                //   duration: Duration(seconds: 2),
                                // ));
                                showToast(AppLocalizations.of(context).lbl_code_copied);
                              }
                            },
                          );
                        }),
                  ),
                )
              : Center(
                  child:
                      Text('${AppLocalizations.of(context).txt_no_coupon_msg}'),
                )
          : _shimmer(),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _applyCoupon() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .applyCoupon(cartId: cartId, couponCode: _selectedCouponCode)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              order = result.data;
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              Get.to(() => PaymentGatewayScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    cartController: cartController,
                    order: order,
                    screenId: screenIdO,
                totalAmount: order.remPrice,
                  ));
            } else {
              Navigator.of(context).pop();
              order = null;
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }

      setState(() {});
    } catch (e) {
      print("Exception - coupons_screen.dart - _applyCoupon():" + e.toString());
    }
  }

  _getCouponsList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (screenId == 0) {
          await apiHelper.getCoupons(cartId: cartId).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _couponList = result.data;
              }
            }
          });
        } else {
          await apiHelper.getStoreCoupons().then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _couponList = result.data;
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }

      setState(() {});
    } catch (e) {
      print("Exception - coupons_screen.dart - _getCouponsList():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getCouponsList();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - coupons_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - coupons_screen.dart - _onRefresh():" + e.toString());
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
              itemCount: 4,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 0,
                    ));
              })),
    );
  }
}
