import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/controllers/order_controller.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/orderModel.dart';
import 'package:user/screens/cancel_order_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/map_screen.dart';
import 'package:user/screens/order_summary_screen.dart';
import 'package:user/utils/string_formatter.dart';
import 'package:user/widgets/toastfile.dart';

class OrderHistoryCard extends StatefulWidget {
  final Order order;
  final dynamic analytics;
  final dynamic observer;
  final OrderController orderController;
  final int index;
  OrderHistoryCard({this.order, this.analytics, this.observer, this.orderController, this.index}) : super();

  @override
  _OrderHistoryCardState createState() => _OrderHistoryCardState(order: order, analytics: analytics, observer: observer, orderController: orderController, index: index);
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  Order order;
  dynamic analytics;
  dynamic observer;
  OrderController orderController;
  int index;
  APIHelper apiHelper = new APIHelper();
  final CartController cartController = Get.put(CartController());
  List<String> _productName = [];

  _OrderHistoryCardState({this.order, this.analytics, this.observer, this.orderController, this.index});
  @override
  Widget build(BuildContext context) {
    if (order.productList != null) {
      for (int i = 0; i < order.productList.length; i++) {
        _productName.add(order.productList[i].productName);
      }
      _productName = _productName.toSet().toList();
    }

    TextTheme textTheme = Theme.of(context).textTheme;
    return GetBuilder<OrderController>(
      init: orderController,
      builder: (orderController) => InkWell(
        onTap: () {
          Get.to(() => OrderSummaryScreen(
                a: widget.analytics,
                o: widget.observer,
                order: order,
                orderController: orderController,
              ));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xffF4F4F4),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EE, dd MMMM').format(DateTime.parse((order.productList[0].orderDate).toString())),
                      style: textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${global.appInfo.currencySign} ${(order.remPrice+order.paidByWallet).toStringAsFixed(2)} >",
                      style: textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 16,
                  ),
                  child: Text(
                    "${AppLocalizations.of(context).lbl_order_id}: ${order.cartid}",
                    style: textTheme.subtitle2.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    StringFormatter.convertListItemsToString(_productName),
                    style: textTheme.caption.copyWith(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _orderStatusNotifier(order, textTheme),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderStatusNotifier(Order order, TextTheme textTheme) {
    if (order.orderStatus == "Pending" || order.orderStatus == "Confirmed") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.blue,
              ),
              SizedBox(width: 8),
              Text(
                "${('${order.orderStatus}'.toUpperCase()=='PENDING'?'Order Placed':order.orderStatus)}",
                style: textTheme.bodyText1.copyWith(color: Colors.blue, fontSize: 15),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => CancelOrderScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        order: order,
                        orderController: orderController,
                      )),
                  child: Text(
                    "${AppLocalizations.of(context).tle_cancel_order}",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _trackOrder(),
                  child: Text(
                    "${AppLocalizations.of(context).tle_track_order}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else if (order.orderStatus == "Out_For_Delivery") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                "${AppLocalizations.of(context).lbl_out_of_delivery}",
                style: textTheme.bodyText1.copyWith(
                  color: Colors.green,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => _trackOrder(),
                  child: Text(
                    "${AppLocalizations.of(context).tle_track_order}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else if (order.orderStatus == "Completed") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.purple,
              ),
              SizedBox(width: 8),
              Text(
                "${AppLocalizations.of(context).txt_completed}",
                style: textTheme.bodyText1.copyWith(
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                global.nearStoreModel != null
                    ? TextButton(
                        onPressed: () {
                          _reOrderItems();
                        },
                        child: Text(
                          "${AppLocalizations.of(context).btn_reorder_items}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : SizedBox(),
                TextButton(
                  onPressed: () => _trackOrder(),
                  child: Text(
                    "${AppLocalizations.of(context).tle_track_order}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else if (order.orderStatus == "Cancelled") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.grey[600],
              ),
              SizedBox(width: 8),
              Text(
                "${AppLocalizations.of(context).lbl_order_cancel}",
                style: textTheme.bodyText1.copyWith(
                  color: Colors.grey[600],
                ),
              )
            ],
          ),
          TextButton(
            onPressed: () => _trackOrder(),
            child: Text(
              "${AppLocalizations.of(context).tle_track_order}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      );
    } else {
      return SizedBox();
    }
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
      print("Exception - order_history_card.dart - reOrderItems():" + e.toString());
    }
  }

  _trackOrder() async {
    try {
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
          }
        }
      });
    } catch (e) {
      print("Exception - order_history_card.dart - _trackOrder():" + e.toString());
    }
  }
}
