import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:user/controllers/order_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/orderModel.dart';
import 'package:user/screens/cancel_order_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/map_screen.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/delivery_details.dart';
import 'package:user/widgets/order_details_card.dart';
import 'package:user/widgets/order_status_card.dart';
import 'package:user/widgets/toastfile.dart';

class OrderSummaryScreen extends BaseRoute {
  final Order order;
  final OrderController orderController;
  OrderSummaryScreen({a, o, this.order, this.orderController}) : super(a: a, o: o, r: 'OrderSummaryScreen');
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState(order: order, orderController: orderController);
}

class _OrderSummaryScreenState extends BaseRouteState {
  Order order;
  int screenId;
  OrderController orderController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  _OrderSummaryScreenState({this.order, this.orderController});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context).tle_order_summary}",
          style: textTheme.headline6,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              OrderStatusCard(order),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: OrderDetailsCard(
                  order,
                  analytics: widget.analytics,
                  observer: widget.observer,
                ),
              ),
              DeliveryDetails(
                order: order,
                address: order.deliveryAddress,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: BottomButton(
                  loadingState: false,
                  disabledState: false,
                  onPressed: () {
                    _trackOrder();
                  },
                  child: Text("${AppLocalizations.of(context).tle_track_order}"),
                ),
              ),
              order.orderStatus == 'Pending' || order.orderStatus == 'Completed' || order.orderStatus == 'Confirmed'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: BottomButton(
                        loadingState: false,
                        disabledState: false,
                        onPressed: () {
                          if (order.orderStatus == 'Pending' || order.orderStatus == 'Confirmed') {
                            Get.to(() => CancelOrderScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  order: order,
                                  orderController: orderController,
                                ));
                          } else {
                            // reorder
                            _reOrderItems();
                          }
                        },
                        child: Text(
                          order.orderStatus == 'Pending' || order.orderStatus == 'Confirmed' ? '${AppLocalizations.of(context).tle_cancel_order}' : '${AppLocalizations.of(context).btn_re_order}',
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _reOrderItems() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(child: new CircularProgressIndicator()),
          );
        },
      );
      await apiHelper.reOrder(order.cartid).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            Navigator.of(context).pop();
            Get.to(() => CartScreen(
                  a: widget.analytics,
                  o: widget.observer,
                ));
          } else {
            Navigator.of(context).pop();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text(
            //     '${AppLocalizations.of(context).txt_something_went_wrong}.',
            //     textAlign: TextAlign.center,
            //   ),
            //   duration: Duration(seconds: 2),
            // ));
            showToast(AppLocalizations.of(context).txt_something_went_wrong);
          }
        }
      });
      setState(() {});
    } catch (e) {
      print("Exception -  order_summary_screen.dart - reOrderItems():" + e.toString());
    }
  }

  _trackOrder() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.trackOrder(order.cartid).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              Order _newOrder = new Order();
              _newOrder = result.data;
              Get.to(() => MapScreen(
                    _newOrder,
                    orderController,
                    a: widget.analytics,
                    o: widget.observer,
                  ));
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              order = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - order_summary_screen.dart - _trackOrder():" + e.toString());
    }
  }
}
