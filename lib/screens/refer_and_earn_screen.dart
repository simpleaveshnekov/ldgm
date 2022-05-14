import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;

class ReferAndEarnScreen extends BaseRoute {
  ReferAndEarnScreen({a, o}) : super(a: a, o: o, r: 'ReferAndEarnScreen');
  @override
  _ReferAndEarnScreenState createState() => new _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends BaseRouteState {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String referMessage;
  _ReferAndEarnScreenState() : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return null;
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                "${AppLocalizations.of(context).tle_invite_earn}",
                style: textTheme.headline6,
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.keyboard_arrow_left)),
            ),
            body: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.18,
                      ),
                      Text(
                        '${global.appInfo.refertext}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${global.appInfo.refertext}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Card(
                        child: InkWell(
                          customBorder: Theme.of(context).cardTheme.shape,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: "${global.currentUser.referralCode}"));
                          },
                          child: Container(
                            width: 180,
                            margin: EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${global.currentUser.referralCode}",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 25),
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context).txt_tap_to_copy}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      br.inviteFriendShareMessage();
                    },
                    child: Text('${AppLocalizations.of(context).btn_invite_friends}')),
              ),
            )),
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

    _init();
  }

  _init() async {
    setState(() {});
  }
}
