import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/orderModel.dart';
import 'package:user/screens/rate_order_screen.dart';
import 'package:user/theme/style.dart';

class OrderDetailsCard extends StatefulWidget {
  final Order order;
  final dynamic analytics;
  final dynamic observer;
  OrderDetailsCard(this.order, {this.analytics, this.observer}) : super();

  @override
  _OrderDetailsCardState createState() => _OrderDetailsCardState(order, analytics, observer);
}

class OrderedProductsMenuItem extends StatefulWidget {
  final Product product;

  OrderedProductsMenuItem({
    @required this.product,
  }) : super();

  @override
  _OrderedProductsMenuItemState createState() => _OrderedProductsMenuItemState(product: product);
}

class _OrderDetailsCardState extends State<OrderDetailsCard> {
  Order order;
  dynamic analytics;
  dynamic observer;
  _OrderDetailsCardState(this.order, this.analytics, this.observer);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${AppLocalizations.of(context).lbl_items}",
                style: textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: order.productList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OrderedProductsMenuItem(product: order.productList[index]),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${order.productList[index].qty}",
                                  style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  ' | ',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                Text(
                                  "${global.appInfo.currencySign} ${order.productList[index].price}",
                                  style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                            order.orderStatus == "Completed"
                                ? order.productList[index].userRating != null && order.productList[index].userRating.toDouble() > 0.0
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: RatingBar.builder(
                                              initialRating: order.productList[index].userRating != null ? double.parse(order.productList[index].userRating.toString()).toDouble() : 0,
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              ignoreGestures: true,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              updateOnDrag: false,
                                              onRatingUpdate: (double value) {},
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: SizedBox(
                                              height: 25,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.to(() => RateOrderScreen(
                                                          order,
                                                          index,
                                                          a: widget.analytics,
                                                          o: widget.observer,
                                                        ));
                                                  },
                                                  child: Text('${AppLocalizations.of(context).btn_edit_review}', style: Theme.of(context).textTheme.overline.copyWith(color: Colors.white, fontSize: 13))),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: SizedBox(
                                          height: 25,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Get.to(() => RateOrderScreen(
                                                      order,
                                                      index,
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                    ));
                                              },
                                              child: Text('${AppLocalizations.of(context).btn_write_review}', style: Theme.of(context).textTheme.overline.copyWith(color: Colors.white, fontSize: 13))),
                                        ),
                                      )
                                : SizedBox(),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_total_price}",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    "${global.appInfo.currencySign} ${order.totalProductsMrp.toStringAsFixed(2)}",
                    style: textTheme.subtitle2,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_discount_price}",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    order.discountonmrp != null && order.discountonmrp > 0 ? "- ${global.appInfo.currencySign} ${order.discountonmrp.toStringAsFixed(2)}" : '${global.appInfo.currencySign} 0',
                    style: textTheme.subtitle2,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discounted Price",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    "${global.appInfo.currencySign} ${order.priceWithoutDelivery.toStringAsFixed(2)}",
                    style: textTheme.subtitle2,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_coupon_discount}",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    order.couponDiscount != null && order.couponDiscount > 0 ? "- ${global.appInfo.currencySign} ${order.couponDiscount.toStringAsFixed(2)}" : '${global.appInfo.currencySign} 0',
                    style: textTheme.subtitle2,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_delivery_charges}",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    "${global.appInfo.currencySign} ${order.deliveryCharge.toStringAsFixed(2)}",
                    style: textTheme.subtitle2,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_tax}",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    "${global.appInfo.currencySign} ${order.totalTaxPrice.toStringAsFixed(2)}",
                    style: textTheme.subtitle2,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Amount",
                    style: textTheme.bodyText1.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    "${global.appInfo.currencySign} ${(order.priceWithoutDelivery - order.couponDiscount).toStringAsFixed(2)}",
                    style: textTheme.subtitle2.copyWith(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).lbl_paid_by_wallet}",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    "-${global.appInfo.currencySign} ${order.paidByWallet.toStringAsFixed(2)}",
                    style: textTheme.subtitle2,
                  )
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Divider(),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Remaining Amount\n(Paid Online/COD)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${global.appInfo.currencySign} ${order.remPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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

class _OrderedProductsMenuItemState extends State<OrderedProductsMenuItem> {
  Product product;

  _OrderedProductsMenuItemState({
    @required this.product,
  });
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: 100 * screenHeight / 830,
      child: Card(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: global.appInfo.imageUrl + product.varientImage,
              imageBuilder: (context, imageProvider) => Container(
                color: Color(0xffF7F7F7),
                padding: EdgeInsets.all(5),
                child: Container(
                  height: 80,
                  width: 40,
                  decoration: BoxDecoration(color: Color(0xffF7F7F7), image: DecorationImage(image: imageProvider, fit: BoxFit.contain)),
                ),
              ),
              placeholder: (context, url) => SizedBox(height: 80, width: 40, child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => Container(
                height: 80,
                width: 40,
                child: Icon(
                  Icons.image,
                  color: Colors.grey[500],
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    product.productName,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  width: 140,
                  child: Text(
                    product.description != null && product.description != '' ? product.description : product.type,
                    overflow: TextOverflow.ellipsis,
                    style: normalCaptionStyle(context),
                  ),
                ),
                Text(
                  '${product.quantity} ${product.unit}',
                  overflow: TextOverflow.ellipsis,
                  style: normalCaptionStyle(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
