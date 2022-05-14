import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/controllers/order_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/cancelReasonModel.dart';
import 'package:user/models/orderModel.dart';
import 'package:user/screens/home_screen.dart';

class CancelOrderScreen extends BaseRoute {
  final Order order;
  final OrderController orderController;
  CancelOrderScreen({a, o, this.order, this.orderController}) : super(a: a, o: o, r: 'CancelOrderScreen');
  @override
  _CancelOrderScreenState createState() => _CancelOrderScreenState(order: order, orderController: orderController);
}

class _CancelOrderScreenState extends BaseRouteState {
  Order order;
  OrderController orderController;
  List<CancelReason> _cancelReasonsList = [];
  bool _isDataLoaded = false;
  CancelReason _selectedReason;
  GlobalKey<ScaffoldState> _scaffoldKey1;
  _CancelOrderScreenState({this.order, this.orderController});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // key: _scaffoldKey1,
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context).tle_cancel_order}",
          style: textTheme.headline6,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
      ),
      backgroundColor: Color(0xfffdfdfd),
      body: _isDataLoaded
          ? ListView.builder(
              itemCount: _cancelReasonsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: RadioListTile(
                      value: _cancelReasonsList[index],
                      groupValue: _selectedReason,
                      onChanged: (val) {
                        _selectedReason = val;
                        setState(() {});
                      },
                      title: Text(
                        _cancelReasonsList[index].reason,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                );
              })
          : _shimmer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(350.0),
            minimumSize: Size.fromHeight(55),
            primary: Color(0xffFF0000),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            if (_selectedReason != null && _selectedReason.reason != null && _selectedReason.reason.isNotEmpty) {
              _showCancelOrderDialog();
            } else {
              showSnackBar(key: _scaffoldKey1, snackBarMessage: '${AppLocalizations.of(context).txt_select_cancel_reason}');
            }
          },
          child: Text(
            "${AppLocalizations.of(context).tle_cancel_order}",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getCancelReasons() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getCancelReason().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _cancelReasonsList = result.data;
            } else {
              _cancelReasonsList = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey1);
      }
    } catch (e) {
      print("Exception - cancel_order_screen.dart - _getCancelReasons():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getCancelReasons();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - cancel_order_screen.dart - _init():" + e.toString());
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
                return SizedBox(height: 90, width: MediaQuery.of(context).size.width, child: Card());
              })),
    );
  }

  _showCancelOrderDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              "${AppLocalizations.of(context).tle_cancel_order}",
            ),
            content: Image.asset(
              "assets/images/cancel_order.png",
              fit: BoxFit.contain,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    showOnlyLoaderDialog();
                    await orderController.deleteOrder(order.cartid, _selectedReason.reason);

                    if (orderController.isDeleted.value != null) {
                      if (order.paymentMethod == "wallet") {
                        global.userProfileController.currentUser.wallet = global.userProfileController.currentUser.wallet + order.paidByWallet;
                      }

                      Get.to(() => HomeScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 2,
                          ));
                    }
                  },
                  child: Text('${AppLocalizations.of(context).btn_yes}')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('${AppLocalizations.of(context).btn_no}'))
            ],
          );
        });
  }
}
