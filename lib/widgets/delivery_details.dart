import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:user/models/orderModel.dart';

class DeliveryDetails extends StatefulWidget {
  final Order order;
  final String address;
  DeliveryDetails({this.order, this.address}) : super();

  @override
  _DeliveryDetailsState createState() => _DeliveryDetailsState(order: order, address: address);
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  Order order;
  String address;
  _DeliveryDetailsState({this.order, this.address});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xffF4F4F4),
          width: 1.5,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 250,
                  child: Text(
                    "${AppLocalizations.of(context).txt_date_of_delivery} : ${order.deliveryDate}, ${order.timeSlot}",
                    maxLines: 2,
                    style: textTheme.bodyText1.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 250,
                  child: Text(
                    '$address',
                    maxLines: 2,
                    style: textTheme.bodyText1.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
