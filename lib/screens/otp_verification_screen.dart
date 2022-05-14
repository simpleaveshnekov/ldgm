import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/change_password_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/bottom_button.dart';

class OtpVerificationScreen extends BaseRoute {
  final String phoneNumber;
  final String verificationCode;
  final String referalCode;
  final int screenId;
  OtpVerificationScreen({
    a,
    o,
    this.screenId,
    this.phoneNumber,
    this.verificationCode,
    this.referalCode,
  }) : super(a: a, o: o, r: 'OtpVerificationScreen');
  @override
  _OtpVerificationScreenState createState() => new _OtpVerificationScreenState(this.screenId, this.phoneNumber, this.verificationCode, this.referalCode);
}

class _OtpVerificationScreenState extends BaseRouteState {
  int _seconds = 60;
  Timer _countDown;
  String phoneNumber;
  String verificationCode;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String status;
  int screenId;
  String referalCode;
  final FocusNode _fOtp = FocusNode();
  var _cOtp = TextEditingController();

  _OtpVerificationScreenState(this.screenId, this.phoneNumber, this.verificationCode, this.referalCode) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 35),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 80, bottom: 50),
                  child: Text(
                    '${AppLocalizations.of(context).tle_verify_otp}',
                    style: normalHeadingStyle(context),
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context).tle_verify_otp_sent_desc}',
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    '${AppLocalizations.of(context).txt_enter_otp}',
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    width: 315,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.center,
                    child: PinFieldAutoFill(
                      key: Key("1"),
                      focusNode: _fOtp,
                      decoration: BoxLooseDecoration(
                        strokeColorBuilder: FixedColorBuilder(Theme.of(context).primaryColor),
                        hintText: '••••••',
                      ),
                      currentCode: _cOtp.text,
                      controller: _cOtp,
                      codeLength: 6,
                      keyboardType: TextInputType.number,
                      onCodeSubmitted: (code) {
                        setState(() {
                          _cOtp.text = code;
                        });
                      },
                      onCodeChanged: (code) async {
                        if (code.length == 6) {
                          _cOtp.text = code;
                          setState(() {});
                          await _checkOTP(_cOtp.text);
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                    )),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      stops: [0, .90],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                    ),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: BottomButton(
                      loadingState: false,
                      disabledState: false,
                      onPressed: () async {
                        if (_cOtp.text.length == 6) {
                          await _checkOTP(_cOtp.text);
                        } else {
                          showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_6_digit_msg}', key: _scaffoldKey);
                        }
                      },
                      child: Text('${AppLocalizations.of(context).btn_login}')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "${AppLocalizations.of(context).txt_didnt_receive_otp}",
                  ),
                ),
                _seconds != 0
                    ? Text("Wait 00:$_seconds")
                    : InkWell(
                        onTap: () async {
                          await _resendOTP();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '${AppLocalizations.of(context).btn_resend_otp}',
                          ),
                        ),
                      )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // SmsAutoFill().unregisterListener();
    // _cOtp.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // _init(); otp auto fetch
    startTimer();
  }

  Future startTimer() async {
    setState(() {});
    const oneSec = const Duration(seconds: 1);
    _countDown = new Timer.periodic(
      oneSec,
      (timer) {
        if (_seconds == 0) {
          setState(() {
            _countDown.cancel();
            timer.cancel();
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );

    setState(() {});
  }

//   _init() async {
//     try {
// // need to change design as well

//       OTPInteractor.getAppSignature().then((value) => print('signature - $value'));
//       _cOtp = OTPTextEditController(
//         codeLength: 6,
//         onCodeReceive: (code) {
//           print("code  1 $code");
//           setState(() {
//             _cOtp.text = code;
//           });
//         },
//       )..startListenUserConsent(
//           (code) {
//             print("code   $code");
//             final exp = RegExp(r'(\d{6})');
//             return exp.stringMatch(code ?? '') ?? '';
//           },
//           strategies: [],
//         );

//       await SmsAutoFill().listenForCode;
//     } catch (e) {
//       print("Exception - verifyOtpScreen.dart - _init():" + e.toString());
//     }
//   }

  Future _checkOTP(String otp) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (global.appInfo.firebase != 'off') {
          FirebaseAuth auth = FirebaseAuth.instance;
          var _credential = PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: otp.trim());
          showOnlyLoaderDialog();
          await auth.signInWithCredential(_credential).then((result) {
            status = 'success';
            hideLoader();
            if (screenId != null && screenId == 0) {
//screenId ==0 -> Forgot Password
              _firebaseOtpVerification(status);
            } else {
              _verifyViaFirebase(status);
            }
          }).catchError((e) {
            status = 'failed';
            hideLoader();

            if (screenId != null && screenId == 0) {
//screenId ==0 -> Forgot Password
              _firebaseOtpVerification(status);
            } else {
              _verifyViaFirebase(status);
            }
          }).onError((error, stackTrace) {
            hideLoader();
          });
        } else {
          if (screenId != null && screenId == 0) {
            showOnlyLoaderDialog();
            await apiHelper.verifyOTP(phoneNumber, _cOtp.text).then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  global.currentUser = result.recordList;
                  global.userProfileController.currentUser = global.currentUser;
                  global.sp.setString('currentUser', json.encode(global.currentUser.toJson()));

                  hideLoader();

                  Get.offAll(() => HomeScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      ));
                } else {
                  hideLoader();
                  showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
                }
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_something_went_wrong}');
              }
            });
          } else {
            showOnlyLoaderDialog();
            await apiHelper.verifyPhone(phoneNumber, _cOtp.text, referalCode).then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  global.currentUser = result.data;
                  global.sp.setString('currentUser', json.encode(global.currentUser.toJson()));
                  global.userProfileController.currentUser = global.currentUser;
                  hideLoader();

                  Get.offAll(() => HomeScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      ));
                } else {
                  hideLoader();
                  showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
                }
              } else {
                hideLoader();
              }
            });
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - otp_verification_screen.dart - _checkOTP():" + e.toString());
    }
  }

  _firebaseOtpVerification(String _status) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.firebaseOTPVerification(phoneNumber, _status).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              Get.offAll(() => ChangePasswordScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    screenId: 0,
                    phoneNumber: phoneNumber,
                  ));
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          } else {
            hideLoader();
          }
        }).catchError((e) {});
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - otp_verification_screen.dart - _verifyOtp():" + e.toString());
    }
  }

  Future _getOTP(String mobileNumber) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.verifyPhoneNumber(
        phoneNumber: '+${global.appInfo.countryCode}$mobileNumber',
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          var a = authCredential.providerId;
          print("a $a");
          setState(() {});
        },
        verificationFailed: (authException) {},
        codeSent: (String verificationId, [int forceResendingToken]) async {
          _cOtp.clear();
          _seconds = 60;
          startTimer();
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    } catch (e) {
      print("Exception - otp_verification_screen.dart - _getOTP():" + e.toString());
      return null;
    }
  }

  _resendOTP() async {
    try {
      if (global.appInfo.firebase != 'off') {
        // firebase resend OTP
        await _getOTP(phoneNumber);
      } else {
// resend API
        showOnlyLoaderDialog();
        await apiHelper.resendOTP(phoneNumber).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              _cOtp.clear();
              _seconds = 60;
              startTimer();
              setState(() {});
            } else {
              hideLoader();
            }
          }
        });
      }
    } catch (e) {
      print("Exception - otp_verification_screen.dart - _resendOTP():" + e.toString());
    }
  }

  _verifyViaFirebase(String _status) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.verifyViaFirebase(phoneNumber, _status, referalCode).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.currentUser = result.data;
              global.userProfileController.currentUser = global.currentUser;
              global.sp.setString('currentUser', json.encode(global.currentUser.toJson()));

              hideLoader();

              Get.to(() => HomeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  ));
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          } else {
            hideLoader();
          }
        }).catchError((e) {});
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - otp_verification_screen.dart - _verifyOtp():" + e.toString());
    }
  }
}
