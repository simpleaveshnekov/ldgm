import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user/dialog/openImageDialog.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/businessRule.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/imageModel.dart';
import 'package:user/models/membershipStatusModel.dart';
import 'package:user/models/userModel.dart';
import 'package:user/screens/chat_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/otp_verification_screen.dart';
import 'package:user/screens/product_description_screen.dart';
import 'package:user/screens/signup_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/widgets/toastfile.dart';

class Base extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String routeName;

  Base({this.analytics, this.observer, this.routeName});

  @override
  BaseState createState() => BaseState();

  void showNetworkErrorSnackBar(GlobalKey<ScaffoldState> scaffoldKey) {}
}

class BaseState extends State<Base> with TickerProviderStateMixin, WidgetsBindingObserver {
  bool bannerAdLoaded = false;
  APIHelper apiHelper;

  BusinessRule br;
  GlobalKey<ScaffoldState> _scaffoldKey;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  BaseState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
  }

  Future<bool> addRemoveWishList(int varientId) async {
    bool _isAddedSuccesFully = false;
    try {
      showOnlyLoaderDialog();
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1" || result.status == "2") {
            _isAddedSuccesFully = true;
            hideLoader();
          } else {
            _isAddedSuccesFully = false;
            hideLoader();
            showToast(AppLocalizations.of(context).txt_please_try_again_after_sometime);
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text(
            //     '${AppLocalizations.of(context).txt_please_try_again_after_sometime}',
            //     textAlign: TextAlign.center,
            //   ),
            //   duration: Duration(seconds: 2),
            // ));
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - addRemoveWishList():" + e.toString());
      return _isAddedSuccesFully;
    }
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

  Future<MembershipStatus> checkMemberShipStatus(GlobalKey<ScaffoldState> scaffoldKey) async {
    MembershipStatus _membershipStatus = MembershipStatus();
    _membershipStatus.status = 'running';
    return _membershipStatus;
    // try {
    //   bool _isConnected = await br.checkConnectivity();
    //   if (_isConnected) {
    //     showOnlyLoaderDialog();
    //     await apiHelper.membershipStatus().then((result) async {
    //       if (result != null) {
    //         if (result.status == "1") {
    //           hideLoader();
    //
    //           _membershipStatus = result.data;
    //         } else {
    //           hideLoader();
    //
    //           showSnackBar(key: scaffoldKey, snackBarMessage: '${result.message}');
    //         }
    //       }
    //     });
    //   } else {
    //     showNetworkErrorSnackBar(scaffoldKey);
    //   }
    //   return _membershipStatus;
    // } catch (e) {
    //   print("Exception - base.dart - checkMemberShipStatus():" + e.toString());
    //   return null;
    // }
  }

  void closeDialog() {
    Navigator.of(context).pop();
  }

  dialogToOpenImage(String name, List<ImageModel> imageList, int index) {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OpenImageDialog(
              a: widget.analytics,
              o: widget.observer,
              imageList: imageList,
              index: index,
              name: name,
            );
          });
    } catch (e) {
      print("Exception - base.dart - dialogToOpenImage() " + e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print('appLifeCycleState inactive');

    if (global.sp!=null && global.sp.getString("currentUser") != null) {
      if (global.localNotificationModel != null && !global.isChatNotTapped) {
        global.currentUser = CurrentUser.fromJson(json.decode(global.sp.getString("currentUser")));
        if (global.localNotificationModel.route == 'chatlist_screen') {
          if (state == AppLifecycleState.resumed) {
            setState(() {
              global.isChatNotTapped = true;
            });
            Get.to(() => ChatScreen(a: widget.analytics, o: widget.observer));
          }
        }
      }
    } else if (global.localNotificationModel != null && global.localNotificationModel.chatId != null && !global.isChatNotTapped) {
      if (state == AppLifecycleState.resumed) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> dontCloseDialog() async {
    return false;
  }

  Future exitAppDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  "${AppLocalizations.of(context).lbl_exit_app}",
                  style: TextStyle(
                    fontFamily: 'AvenirLTStd',
                  ),
                ),
                content: Text("${AppLocalizations.of(context).txt_exit_app_msg}",
                    style: TextStyle(
                      fontFamily: 'AvenirLTStd',
                    )),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      '${AppLocalizations.of(context).lbl_cancel}',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("${AppLocalizations.of(context).btn_exit}"),
                    onPressed: () async {
                      exit(0);
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - base.dart - exitAppDialog(): ' + e.toString());
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(global.lat, global.lng);

      Placemark place = placemarks[0];

      setState(() {
        global.currentLocation = "${place.name}, ${place.locality} ";
      });
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - getAddressFromLatLng():" + e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) async {
      setState(() {
        global.lat = position.latitude;
        global.lng = position.longitude;
      });
      await getAddressFromLatLng();
      await getNearByStore();
    }).catchError((e) {
      hideLoader();
      print("Exception -  base.dart - getCurrentLocation():" + e.toString());
    });
    return ;
  }

  Future<void> getCurrentPosition() async {
    try {
      if (Platform.isIOS) {
        LocationPermission s = await Geolocator.checkPermission();
        if (s == LocationPermission.denied || s == LocationPermission.deniedForever) {
          s = await Geolocator.requestPermission();
        }
        if (s != LocationPermission.denied || s != LocationPermission.deniedForever) {
          await getCurrentLocation();
        } else {
          global.locationMessage = '${AppLocalizations.of(context).txt_please_enablet_location_permission_to_use_app}';
        }
      } else {
        PermissionStatus permissionStatus = await Permission.location.status;
        if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
          permissionStatus = await Permission.location.request();
        }
        if (permissionStatus.isGranted) {
          await getCurrentLocation();
        } else {
          global.locationMessage = '${AppLocalizations.of(context).txt_please_enablet_location_permission_to_use_app}';
        }
      }
    } catch (e) {
      hideLoader();
      print("Exception -  base.dart - getCurrentPosition():" + e.toString());
    }

    return;
  }

  Future<void> getNearByStore() async {
    try {
      await apiHelper.getNearbyStore().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            global.nearStoreModel = result.data;
            if (global.appInfo.lastLoc == 1) {
              global.sp.setString("lastloc", '${global.lat}|${global.lng}');
            }
            if (global.currentUser.id != null) {
              await apiHelper.updateFirebaseUserFcmToken(global.currentUser.id, global.appDeviceId);
            }
            if (global.currentUser.id != null) {
              await global.userProfileController.getUserAddressList();
            }
          } else if (result.status == "0") {
            global.nearStoreModel = null;
            global.locationMessage = result.message;
          }
        }
      });

      if (global.currentUser.id != null) {
        await global.userProfileController.getMyProfile();
      }
    } catch (e) {
      hideLoader();
      print("Exception -  base.dart - _getNearByStore():" + e.toString());
    }

    return;
  }

  void hideLoader() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  openBarcodeScanner(GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      String barcodeScanRes;
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (barcodeScanRes != '-1') {
        await _getBarcodeResult(scaffoldKey, barcodeScanRes);
      }
    } catch (e) {
      hideLoader();
      print("Exception - businessRule.dart - openBarcodeScanner():" + e.toString());
    }
  }

  sendOTP(String phoneNumber, {int screenId}) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+${global.appInfo.countryCode}$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          hideLoader();
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
        },
        codeSent: (String verificationId, int resendToken) async {
          hideLoader();
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      verificationCode: verificationId,
                      phoneNumber: phoneNumber,
                      screenId: screenId,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - _sendOTP():" + e.toString());
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  showNetworkErrorSnackBar(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
      // bool isConnected;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(days: 1),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'No internet available',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(textColor: Colors.white, label: 'RETRY', onPressed: () async {}),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar():" + e.toString());
    }
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }

  void showSnackBar({String snackBarMessage, GlobalKey<ScaffoldState> key}) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   key: key,
    //   content: Text(
    //     snackBarMessage,
    //     textAlign: TextAlign.center,
    //   ),
    //   duration: Duration(seconds: 2),
    // ));
    showToast(snackBarMessage);
  }

  // signInWithFacebook(GlobalKey<ScaffoldState> scaffoldKey) async {
  //   try {
  //     bool isConnected = await br.checkConnectivity();
  //     if (isConnected) {
  //       showOnlyLoaderDialog();
  //       final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ["email", "public_profile"]);
  //       if(loginResult != null && loginResult.accessToken != null){
  //
  //       final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);
  //       var authCredentials = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //       if (authCredentials != null && authCredentials.user != null) {
  //
  //       }
  //       hideLoader();
  //       }else{
  //          hideLoader();
  //         showSnackBar(key: _scaffoldKey, snackBarMessage: "${AppLocalizations.of(context).txt_something_went_wrong} ${AppLocalizations.of(context).txt_please_try_again_after_sometime}");
  //       }
  //     } else {
  //       hideLoader();
  //       showNetworkErrorSnackBar(scaffoldKey);
  //     }
  //   } catch (e) {
  //     hideLoader();
  //     print("Exception - base.dart - signInWithFacebook():" + e.toString());
  //   }
  // }

  signInWithGoogle(GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await _googleSignIn.signIn().then((result) {
        if (result != null) {
          result.authentication.then((googleKey) async {
            if (_googleSignIn.currentUser != null) {
              showOnlyLoaderDialog();
              await apiHelper.socialLogin(userEmail: _googleSignIn.currentUser.email, type: 'google').then((result) async {
                if (result != null) {
                  if (result.status == "1") {
                    global.currentUser = result.data;
                    global.sp.setString('currentUser', json.encode(global.currentUser.toJson()));

                    await global.userProfileController.getMyProfile();
                    hideLoader();
                    Get.to(() => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        ));
                  } else {
                    CurrentUser _currentUser = new CurrentUser();
                    _currentUser.email = _googleSignIn.currentUser.email;
                    _currentUser.name = _googleSignIn.currentUser.displayName;

                    hideLoader();
                    // registration required
                    Get.to(
                      () => SignUpScreen(user: _currentUser, a: widget.analytics, o: widget.observer),
                    );
                  }
                }
              });
            }
          });
        }
      });
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - _signInWithGoogle():" + e.toString());
    }
  }

  _getBarcodeResult(GlobalKey<ScaffoldState> scaffoldKey, String code) async {
    try {
      bool _isConnected = await br.checkConnectivity();
      if (_isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.barcodeScanResult(code).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDescriptionScreen(productDetail: result.data, a: widget.analytics, o: widget.observer),
                ),
              );
            } else {
              hideLoader();

              showSnackBar(key: scaffoldKey, snackBarMessage: '${result.message}');
            }
          } else {
            hideLoader();
          }
        });
      } else {
        showNetworkErrorSnackBar(scaffoldKey);
      }
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - _getBarcodeResult():" + e.toString());
    }
  }

 


}
