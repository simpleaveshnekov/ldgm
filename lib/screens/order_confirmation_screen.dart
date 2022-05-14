import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/orderModel.dart';
import 'package:user/screens/home_screen.dart';

class OrderConfirmationScreen extends BaseRoute {
  final int screenId;
  final Order order;
  final int status;
  OrderConfirmationScreen({a, o, this.order, this.screenId, this.status}) : super(a: a, o: o, r: 'OrderConfirmationScreen');
  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState(order: order, screenId: screenId, status: status);
}

class _OrderConfirmationScreenState extends BaseRouteState {
  Order order;
  int screenId;
  int status;
  _OrderConfirmationScreenState({this.order, this.screenId, this.status});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.3,
          ),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  status == 5 ? Icons.info : Icons.check,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                screenId == 3
                    ? '${AppLocalizations.of(context).txt_wallet_recharge_successfully}'
                    : screenId == 0
                        ? '${AppLocalizations.of(context).txt_reward_to_wallet}'
                        : screenId == 2
                            ? status == 5
                                ? "${AppLocalizations.of(context).tle_membership_expiry}"
                                : "${AppLocalizations.of(context).tle_membership_bought_sucessfully} "
                            : "${AppLocalizations.of(context).txt_order_success_description}",
                style: textTheme.headline6,
              ),
            ),
          ),
          screenId == 3 || screenId == 0 || screenId == 2
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    "${AppLocalizations.of(context).lbl_order_id}:  #${order.cartid}",
                    style: textTheme.caption.copyWith(fontSize: 17),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text("${AppLocalizations.of(context).btn_go_home}"),
                  ),
                  onPressed: () {
                    if (screenId != 1 || screenId != 0 || screenId != 2) {
                      global.cartCount = 0;
                    }

                    Get.offAll(() => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        ));
                    setState(() {});
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
