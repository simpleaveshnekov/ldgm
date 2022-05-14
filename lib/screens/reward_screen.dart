import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/controllers/user_profile_controller.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/userModel.dart';
import 'package:user/screens/order_confirmation_screen.dart';

class RewardScreen extends BaseRoute {
  RewardScreen({a, o}) : super(a: a, o: o, r: 'RewardScreen');
  @override
  _RewardScreenState createState() => new _RewardScreenState();
}

class _RewardScreenState extends BaseRouteState {
  APIHelper apiHelper = new APIHelper();
  bool isProcessing = true;
  GlobalKey<ScaffoldState> _scaffoldKey;
  _RewardScreenState() : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return null;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "${AppLocalizations.of(context).tle_reward_points}",
            style: textTheme.headline6,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.keyboard_arrow_left)),
        ),
        body: Center(
          child: isProcessing?CircularProgressIndicator(
            strokeWidth: 2,
          ):Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Text(
                  "${AppLocalizations.of(context).lbl_reward_points}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              GetBuilder<UserProfileController>(
                init: global.userProfileController,
                builder: (value) => Text(
                  "${global.userProfileController.currentUser.rewards} ",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: !isProcessing && global.currentUser.rewards != null && global.currentUser.rewards != 0
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await _redeemReward();
                      },
                      child: Text(
                        '${AppLocalizations.of(context).btn_redeem_points}',
                      )),
                ),
              )
            : SizedBox(),
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
    if (global.currentUser.id != null) {
      getMyProfile(true);
    }else{
      isProcessing = false;
      setState(() { });
    }
  }

  getMyProfile(bool initTure) async {
    try {
      await apiHelper.myProfile().then((result) async {
        isProcessing = false;
        if (result != null) {
          if (result.status == "1") {
            CurrentUser currentUser = result.data;
            global.currentUser = currentUser;
          }
        }
      });
      if(initTure){
        setState(() { });
      }
    } catch (e) {
      print("Exception - user_profile_controller.dart - _getMyProfile():" + e.toString());
    }
  }

  _redeemReward() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.redeemReward().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              global.userProfileController.currentUser.wallet = global.userProfileController.currentUser.wallet + global.userProfileController.currentUser.rewards;
              global.userProfileController.currentUser.rewards = 0;
              await getMyProfile(false);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => OrderConfirmationScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          screenId: 0,
                        )),
              );
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_something_went_wrong}.');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - reward_screen.dart - _redeemReward():" + e.toString());
    }
  }
}
