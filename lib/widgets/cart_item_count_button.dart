import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/login_screen.dart';

class CartItemCountButton extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final CartController cartController;
  CartItemCountButton({this.analytics, this.observer, this.cartController}) : super();

  @override
  _CartItemCountButtonState createState() => _CartItemCountButtonState(analytics: analytics, observer: observer, cartController: cartController);
}

class _CartItemCountButtonState extends State<CartItemCountButton> {
  final dynamic analytics;
  final dynamic observer;
  CartController cartController;
  _CartItemCountButtonState({this.analytics, this.observer, this.cartController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: cartController,
      builder: (value) => global.cartCount != null && global.cartCount != 0
          ? SizedBox(
              height: 50,
              width: Get.width / 2,
              child: ElevatedButton.icon(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: Text("${global.cartCount} ${AppLocalizations.of(context).txt_items_cart}"),
                  onPressed: () {
                    if (global.currentUser.id == null) {
                      Get.to(() => LoginScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          ));
                    } else {
                      Get.to(() => CartScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          ));
                    }
                  }),
            )
          : SizedBox(),
    );
  }
}
