import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/orderModel.dart';
import 'package:user/screens/home_screen.dart';

class RateOrderScreen extends BaseRoute {
  final Order order;
  final int index;
  RateOrderScreen(this.order, this.index, {a, o}) : super(a: a, o: o, r: 'RateOrderScreen');
  @override
  _RateOrderScreenState createState() => new _RateOrderScreenState(this.order, this.index);
}

class _RateOrderScreenState extends BaseRouteState {
  Order order;
  int index;
  var _cComment = new TextEditingController();
  double _userRating = 0;
  var _fComment = new FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey;

  _RateOrderScreenState(this.order, this.index) : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        appBar: AppBar(
          title: Text(
            "${AppLocalizations.of(context).btn_rate_order}",
            style: textTheme.headline6,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).lbl_order_id}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '#${order.cartid}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).lbl_number_of_items}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '${order.productList.length}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).lbl_delivered_on}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '${order.deliveryDate}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).lbl_total_amount}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '${global.appInfo.currencySign} ${order.remPrice}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Color(0xFFCCD6DF),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("${AppLocalizations.of(context).lbl_rate_overall_exp}", style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: order.productList[index].userRating != null ? double.parse(order.productList[index].userRating.toString()).toDouble() : 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Theme.of(context).primaryColor,
                  ),
                  updateOnDrag: false,
                  onRatingUpdate: (rating) {
                    _userRating = rating;
                    setState(() {});
                  },
                  tapOnlyMode: true,
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Color(0xFFCCD6DF),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(),
                  child: TextFormField(
                    controller: _cComment,
                    focusNode: _fComment,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      hintText: '${AppLocalizations.of(context).hnt_comment}',
                      contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () async {
                  await _submitRating();
                },
                child: Text('${AppLocalizations.of(context).btn_submit_rating}')),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cComment = TextEditingController(text: order.productList[index].ratingDescription);
    _userRating = order.productList[index].userRating.toDouble();
  }

  _submitRating() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_userRating != null && _userRating > 0 && _cComment.text.trim().isNotEmpty) {
          showOnlyLoaderDialog();
          await apiHelper.addProductRating(order.productList[index].varientId, _userRating, _cComment.text.trim()).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(a: widget.analytics, o: widget.observer),
                    ),
                  );
                });
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_something_went_wrong}');
              }
            }
          });
        } else if (_userRating == 0) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_give_ratings}');
        } else if (_cComment.text.isEmpty) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_enter_description}');
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - rate_order_screen.dart - _submitRating():" + e.toString());
    }
  }
}
