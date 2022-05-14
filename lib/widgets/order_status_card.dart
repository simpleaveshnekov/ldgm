import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:user/models/orderModel.dart';

class OrderStatusCard extends StatefulWidget {
  final Order order;
  OrderStatusCard(this.order) : super();

  @override
  _OrderStatusCardState createState() => _OrderStatusCardState(order);
}

class _OrderStatusCardState extends State<OrderStatusCard> {
  Order order;
  _OrderStatusCardState(this.order);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppLocalizations.of(context).lbl_order_id} #${order.cartid}",
                  style: textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    order.completedTime != null && order.orderStatus == 'Completed' ? "Delivered at ${order.completedTime}" : '',
                    style: textTheme.caption,
                  ),
                ),
                SizedBox(height: order.completedTime != null && order.orderStatus == 'Completed' ? 32 : 0),
                Text(
                  "${AppLocalizations.of(context).lbl_payment_method}",
                  style: textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${((order.paymentMethod!=null && '${order.paymentMethod}'.toUpperCase()=='COD')?'Pay Cash':order.paymentMethod)}",
                    style: textTheme.caption.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
            Spacer(),
            CircleAvatar(
              radius: 10,
              backgroundColor: order.orderStatus == 'Pending'
                  ? Colors.blue
                  : order.orderStatus == 'Confirmed'
                      ? Colors.amber
                      : order.orderStatus == 'Out_For_Delivery'
                          ? Colors.green
                          : order.orderStatus == 'Completed'
                              ? Colors.purple
                              : Colors.grey,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
            SizedBox(width: 8),
            Text(
              "${('${order.orderStatus}'.toUpperCase()=='PENDING'?'Order Placed':order.orderStatus)}",
              style: textTheme.bodyText1.copyWith(
                  color: order.orderStatus == 'Pending'
                      ? Colors.amber
                      : order.orderStatus == 'Confirmed'
                          ? Colors.amber
                          : order.orderStatus == 'Out_For_Delivery'
                              ? Colors.green
                              : order.orderStatus == 'Completed'
                                  ? Colors.purple
                                  : Colors.grey,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
