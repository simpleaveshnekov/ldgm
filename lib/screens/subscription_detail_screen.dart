import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/membershipModel.dart';
import 'package:user/screens/payment_screen.dart';
import 'package:user/widgets/my_chip.dart';

class SubscriptionDetailScreen extends BaseRoute {
  final MembershipModel membershipModel;
  SubscriptionDetailScreen(this.membershipModel, {a, o}) : super(a: a, o: o, r: 'SubscriptionDetailScreen');
  @override
  _SubscriptionDetailScreenState createState() => new _SubscriptionDetailScreenState(this.membershipModel);
}

class _SubscriptionDetailScreenState extends BaseRouteState {
  bool isloading = true;
  final MembershipModel membershipModel;
  _SubscriptionDetailScreenState(this.membershipModel) : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          '${AppLocalizations.of(context).lbl_platinum_pro}',
          style: textTheme.headline6,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
            child: Text('${AppLocalizations.of(context).lbl_subscription_plan}', style: Theme.of(context).textTheme.subtitle1),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.all(4),
                      title: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        runSpacing: 0,
                        spacing: 10,
                        children: _wrapWidgetList(),
                      )),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.all(4),
                    title: Html(
                      data: "${membershipModel.planDescription}",
                      style: {
                        "body": Style(color: Theme.of(context).textTheme.bodyText1.color, fontFamily: Theme.of(context).textTheme.headline2.fontFamily, fontSize: FontSize(Theme.of(context).textTheme.bodyText1.fontSize), fontWeight: Theme.of(context).textTheme.bodyText1.fontWeight),
                      },
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: EdgeInsets.all(10.0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentGatewayScreen(
                        screenId: 2,
                        membershipModel: membershipModel,
                        totalAmount: membershipModel.price,
                        a: widget.analytics,
                        o: widget.observer,
                      ),
                    ),
                  );
                },
                child: Text(
                  '${AppLocalizations.of(context).btn_subscribe_this_plan}',
                )),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.transparent,
            ),
            margin: EdgeInsets.all(8.0),
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '${AppLocalizations.of(context).btn_explore_other_plan}',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400),
                )),
          ),
        ],
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
  }

  List<Widget> _wrapWidgetList() {
    List<Widget> _widgetList = [];
    try {
      if (membershipModel.freeDelivery != null && membershipModel.freeDelivery > 0) {
        _widgetList.add(
          MyChip(
            label: 'Free Delivery',
            isSelected: false,
          ),
        );
      }

      if (membershipModel.instantDelivery != null && membershipModel.instantDelivery > 0) {
        _widgetList.add(
          MyChip(
            label: 'Instant Delivery',
            isSelected: false,
          ),
        );
      }

      if (membershipModel.days != null && membershipModel.days > 0) {
        _widgetList.add(
          MyChip(
            label: '${membershipModel.days} Days',
            isSelected: false,
          ),
        );
      }

      if (membershipModel.reward != null && membershipModel.reward > 0) {
        _widgetList.add(
          MyChip(
            label: '${membershipModel.reward}x Reward Points',
            isSelected: false,
          ),
        );
      }
      if (membershipModel.price != null && membershipModel.price > 0) {
        _widgetList.add(
          MyChip(
            label: '${membershipModel.price} ${global.appInfo.currencySign}',
            isSelected: false,
          ),
        );
      }
      return _widgetList;
    } catch (e) {
      print("Exception - subscription_detail_screen.dart - _wrapWidgetList():   " + e.toString());
      _widgetList.add(SizedBox());
      return _widgetList;
    }
  }
}
