import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/controllers/order_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/home_screen.dart';
import 'package:user/widgets/order_history_card.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryScreen extends BaseRoute {
  OrderHistoryScreen({a, o}) : super(a: a, o: o, r: 'OrderHistoryScreen');

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends BaseRouteState {
  // private variable to switch tabs between orders
  int _tabIndex = 0;
  bool _isDataLoaded = false;
  OrderController orderController = Get.put(OrderController());

  ScrollController scrollController = ScrollController();

  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  int activeOrderPage = 1;
  int pastOrderPage = 1;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "${AppLocalizations.of(context).tle_order_history}",
            style: textTheme.headline6,
          ),
        ),
        body: global.nearStoreModel != null && global.nearStoreModel.id != null
            ? _isDataLoaded
                ? (orderController.completedOrderList != null && orderController.completedOrderList.length > 0) || (orderController.activeOrderList != null && orderController.activeOrderList.length > 0)
                    ? RefreshIndicator(
                        onRefresh: () async {
                          await _onRefresh();
                        },
                        child: GetBuilder<OrderController>(
                          init: orderController,
                          builder: (orderController) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 32.0, bottom: 16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: _tabIndex == 0 ? Theme.of(context).primaryColor : Colors.grey[100],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _tabIndex = 0;
                                                });
                                              },
                                              child: Text(
                                                "${AppLocalizations.of(context).lbl_all_orders}",
                                                style: textTheme.button.copyWith(
                                                  color: _tabIndex == 0 ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: _tabIndex == 1 ? Theme.of(context).primaryColor : Colors.grey[100],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _tabIndex = 1;
                                                });
                                              },
                                              child: Text(
                                                "${AppLocalizations.of(context).lbl_past_orders}",
                                                style: textTheme.button.copyWith(
                                                  color: _tabIndex == 1 ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  _tabIndex == 0
                                      ? orderController.activeOrderList != null && orderController.activeOrderList.length > 0
                                          ? Column(
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: orderController.activeOrderList.length,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return Column(
                                                      children: [
                                                        OrderHistoryCard(
                                                          analytics: widget.analytics,
                                                          observer: widget.observer,
                                                          order: orderController.activeOrderList[index],
                                                          orderController: orderController,
                                                          index: index,
                                                        ),
                                                        SizedBox(height: 8),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                orderController.isMoreDataLoaded1.value == true ? SizedBox(child: CircularProgressIndicator()) : SizedBox()
                                              ],
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(top: 150),
                                              child: Center(
                                                child: Text('${AppLocalizations.of(context).txt_nothing_to_show}'),
                                              ),
                                            )
                                      : SizedBox(),
                                  _tabIndex == 1
                                      ? orderController.completedOrderList != null && orderController.completedOrderList.length > 0
                                          ? Column(
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: orderController.completedOrderList.length,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, i) {
                                                    return Column(
                                                      children: [
                                                        OrderHistoryCard(
                                                          analytics: widget.analytics,
                                                          observer: widget.observer,
                                                          order: orderController.completedOrderList[i],
                                                          orderController: orderController,
                                                          index: i,
                                                        ),
                                                        SizedBox(height: 8),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                orderController.isMoreDataLoaded.value == true ? SizedBox(child: CircularProgressIndicator()) : SizedBox()
                                              ],
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(top: 150),
                                              child: Center(
                                                child: Text('${AppLocalizations.of(context).txt_nothing_to_show}'),
                                              ))
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : _emptyOrderListWidget()
                : _shimmer()
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(global.locationMessage),
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    orderController.page = 1.obs;
    if (orderController.activeOrderList != null && orderController.activeOrderList.length > 0) {
      orderController.activeOrderList.clear();
    }

    if (orderController.completedOrderList != null && orderController.completedOrderList.length > 0) {
      orderController.completedOrderList.clear();
    }

    orderController.isMoreDataLoaded = false.obs;
    orderController.isRecordPending = true.obs;

    orderController.page1 = 1.obs;

    orderController.isMoreDataLoaded1 = false.obs;
    orderController.isRecordPending1 = true.obs;

    _getOrderHistory();
  }

  Widget _emptyOrderListWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        color: Color(0xfffdfdfd),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Image.asset(
                "assets/images/no_order.png",
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 18,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size.fromWidth(350.0),
                    minimumSize: Size.fromHeight(55),
                    primary: Color(0xffFF0000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(a: widget.analytics, o: widget.observer),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                    //   Get.to(() => HomeScreen(
                    //     a: widget.analytics,
                    //     o: widget.observer,
                    // screenId: 0,
                    //   ))
                  ,
                  child: Text(
                    "${AppLocalizations.of(context).lbl_let_shop} ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getOrderHistory() async {
    await orderController.getActiveOrderList();
    await orderController.getCompletedOrderHistoryList();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !orderController.isMoreDataLoaded.value) {
        orderController.isMoreDataLoaded(true);
        if (_tabIndex == 0) {
          await orderController.getActiveOrderList();
        } else {
          await orderController.getCompletedOrderHistoryList();
        }

        orderController.isMoreDataLoaded(false);
      }
    });

    if (orderController.isDataLoaded.value == true && orderController.isDataLoaded1.value == true) {
      _isDataLoaded = true;
    } else {
      _isDataLoaded = false;
    }
    setState(() {});
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      _getOrderHistory();
    } catch (e) {
      print("Exception - order_history_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 50,
                          width: 160,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(height: 50, width: 160, child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 230, width: MediaQuery.of(context).size.width, child: Card());
                    }),
              ],
            ),
          )),
    );
  }
}
