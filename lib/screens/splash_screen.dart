import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/userModel.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/intro_screen.dart';

class SplashScreen extends BaseRoute {
  SplashScreen({a, o}) : super(a: a, o: o, r: 'SplashScreen');
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends BaseRouteState {
  bool isloading = true;

  GlobalKey<ScaffoldState> _scaffoldKey;
  _SplashScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          // padding: EdgeInsets.all(32),
          child: Image.asset(
            'assets/images/icon.png',
            fit: BoxFit.contain,
            scale: 3,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _init();
  }

  _getAppInfo() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getAppInfo(null).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.appInfo = result.data;
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getAppInfo():" + e.toString());
    }
  }

  _getAppNotice() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getAppNotice().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.appNotice = result.data;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getAppNotice():" + e.toString());
    }
  }

  _getGoogleMapApiKey() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getGoogleMapApiKey().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.googleMap = result.data;
            } else {
              hideLoader();
              global.googleMap = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getGoogleMapApiKey():" + e.toString());
    }
  }

  _getMapBoxApiKey() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getMapBoxApiKey().then((result) {
          if (result != null) {
            if (result.status == "1") {
              global.mapBox = result.data;

              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getMapBoxApiKey():" + e.toString());
    }
  }

  _getMapByFlag() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getMapByFlag().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.mapby = result.data;
            } else {
              hideLoader();
              global.mapby = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getMapByFlag():" + e.toString());
    }
  }

  void _init() async {
    await br.getSharedPreferences();
    var duration = Duration(seconds: 3);
    await _getAppInfo();
    await _getMapByFlag();
    await _getGoogleMapApiKey();
    await _getMapBoxApiKey();
    await _getAppNotice();
    Timer(duration, () async {
      global.appDeviceId = await FirebaseMessaging.instance.getToken();

      if (global.sp.getString('currentUser') == null) {
        PermissionStatus permissionStatus = await Permission.phone.status;
        if (!permissionStatus.isGranted) {
          permissionStatus = await Permission.phone.request();
        }
      }

      bool isConnected = await br.checkConnectivity();

      if (isConnected) {
        if (global.sp.getString('currentUser') != null) {
          global.currentUser = CurrentUser.fromJson(json.decode(global.sp.getString("currentUser")));
          if (global.sp.getString('lastloc') != null) {
            List<String> _tlist = global.sp.getString('lastloc').split("|");
            global.lat = double.parse(_tlist[0]);
            global.lng = double.parse(_tlist[1]);
            await getAddressFromLatLng();
            await getNearByStore();

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          }
        } else {
          Get.to(() => IntroScreen(
                a: widget.analytics,
                o: widget.observer,
              ));
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    });
  }
}
