import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/constants/image_constants.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/userModel.dart';
import 'package:user/screens/forgot_password_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/otp_verification_screen.dart';
import 'package:user/screens/signup_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/circular_image_cover.dart';
import 'package:user/widgets/my_ink_well.dart';
import 'package:user/widgets/my_text_field.dart';

class LoginScreen extends BaseRoute {
  LoginScreen({a, o}) : super(a: a, o: o, r: 'LoginScreen');

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseRouteState {
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  final fb = FacebookLogin();
  APIHelper apiHelper = APIHelper();
  bool isLoginWithEmail = false;
  List<SimCard> _simCard = <SimCard>[];
  TextEditingController _countryCodeController = new TextEditingController(
      text: '+' + global.appInfo.countryCode.toString());
  TextEditingController _cPhone = new TextEditingController();
  TextEditingController _cEmail = new TextEditingController();
  TextEditingController _cPassword = new TextEditingController();
  FocusNode _fEmail = FocusNode();
  FocusNode _fPassword = FocusNode();
  FocusNode _fPhone = FocusNode();
  bool _showPassword = true;
  GlobalKey<ScaffoldState> _scaffoldKey1;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    double screenHeight = MediaQuery.of(context).size.height;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      key: _scaffoldKey1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )),
                );
              },
              child: Text('${AppLocalizations.of(context).btn_skip_now}'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !isKeyboardOpen,
                child: Container(height: screenHeight * 0.18)),
            Text(
              isLoginWithEmail
                  ? "${AppLocalizations.of(context).txt_email_pass}"
                  : "${AppLocalizations.of(context).txt_enter_mobile}",
              style: normalHeadingStyle(context),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: MyInkWell(
                onPressed: null,
                introText: "${AppLocalizations.of(context).txt_for} ",
                mainText: "${AppLocalizations.of(context).txt_login_reg}",
              ),
            ),
            Text(
              isLoginWithEmail
                  ? "${AppLocalizations.of(context).lbl_email}"
                  : "${AppLocalizations.of(context).lbl_phone_number}",
              style: textTheme.bodyText1,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: isLoginWithEmail
                  ? Column(
                      children: [
                        MyTextField(
                          Key('17'),
                          controller: _cEmail,
                          hintText: 'user@gmail.com',
                          focusNode: _fEmail,
                          autofocus: false,
                          maxLines: 1,
                          inputTextFontWeight: FontWeight.bold,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (val) {
                            setState(() {
                              FocusScope.of(context).requestFocus(_fPassword);
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${AppLocalizations.of(context).lbl_password} ",
                              style: textTheme.bodyText1,
                            ),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _cPassword,
                          focusNode: _fPassword,
                          autofocus: false,
                          obscureText: _showPassword,
                          obscuringCharacter: '*',
                          keyboardType: TextInputType.emailAddress,
                          style: textFieldInputStyle(context, FontWeight.bold),
                          decoration: InputDecoration(
                            hintText:
                                '${AppLocalizations.of(context).lbl_password}',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.7,
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: IconTheme.of(context).color),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            hintStyle: textFieldHintStyle(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              '${AppLocalizations.of(context).lbl_forgot_password}',
                              style: TextStyle(fontSize: 13),
                            ),
                            onPressed: () {
                              Get.to(() => ForgotPasswordScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  ));
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: MyTextField(
                            Key('14'),
                            controller: _countryCodeController,
                            inputTextFontWeight: FontWeight.bold,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 5,
                          child: MyTextField(
                            Key('15'),
                            controller: _cPhone,
                            hintText:
                                "${AppLocalizations.of(context).txt_0XXXXXXXXX}",
                            autofocus: false,
                            focusNode: _fPhone,
                            maxLines: 1,
                            inputTextFontWeight: FontWeight.bold,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  global.appInfo.phoneNumberLength)
                            ],
                            onChanged: (value) {
                              setState(() {});
                            },
                            onFieldSubmitted: (val) {
                              // FocusScope.of(context).dispose();
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            Visibility(
              visible: !isKeyboardOpen,
              child: BottomButton(
                child: Text(isLoginWithEmail
                    ? "${AppLocalizations.of(context).btn_login}"
                    : "${AppLocalizations.of(context).txt_get_otp}"),
                loadingState: false,
                disabledState: false,
                onPressed: () =>
                    isLoginWithEmail ? loginWithEmail() : login(_cPhone.text),
              ),
            ),
            Visibility(
              visible: !isKeyboardOpen,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${AppLocalizations.of(context).txt_connect}",
                        style: textTheme.bodyText1),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        _loginS(context, _scaffoldKey1);
                        // signInWithFacebook(_scaffoldKey1);
                      },
                      child: CircularImageCover(
                        imageUrl: ImageConstants.FACEBOOK_LOGO_IMAGE_URL,
                        backgroundColor: ColorConstants.veryLightBlue,
                      ),
                    ),
                    SizedBox(width: 16),
                    Platform.isAndroid
                        ? GestureDetector(
                            onTap: () {
                              signInWithGoogle(_scaffoldKey1);
                            },
                            child: CircularImageCover(
                              imageUrl: ImageConstants.GOOGLE_LOGO_IMAGE_URL,
                              backgroundColor: ColorConstants.peach,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              _signInWithApple();
                            },
                            child: CircularImageCover(
                              imageUrl: ImageConstants.APPLE_LOGO_IMAGE_URL,
                              backgroundColor: ColorConstants.black,
                            ),
                          ),
                    SizedBox(width: 16),
                    isLoginWithEmail
                        ? GestureDetector(
                            onTap: () {
                              isLoginWithEmail = false;
                              setState(() {});
                            },
                            child: CircularImageCover(
                              icon: Icon(
                                Icons.phone_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                              backgroundColor: ColorConstants.veryLightBlue,
                            ),
                          )
                        : SizedBox(),
                    isLoginWithEmail
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              isLoginWithEmail = true;
                              setState(() {});
                            },
                            child: CircularImageCover(
                              icon: Icon(
                                Icons.mail_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              backgroundColor: ColorConstants.peach,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initMobileNumberState() async {
    String mobileNumber = '';
    try {
      _simCard = (await MobileNumber.getSimCards);
      _simCard.removeWhere((e) =>
          e.number == '' ||
          e.number == null ||
          e.number.contains(RegExp(r'[A-Z]')));
      if (_simCard.length > 1) {
        await _selectPhoneNumber();
      } else if (_simCard.length > 0) {
        mobileNumber =
            _simCard[0].number.substring(_simCard[0].number.length - 10);
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;

    setState(() {
      _cPhone.text = mobileNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  login(String userPhone) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_cPhone.text != null &&
            _cPhone.text.trim().isNotEmpty &&
            _cPhone.text.trim().length == global.appInfo.phoneNumberLength) {
          showOnlyLoaderDialog();
          global.currentUser = new CurrentUser();
          await apiHelper.login(_cPhone.text).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                if (global.appInfo.firebase != 'off') {
                  // if firebase is enabled then only we need to send OTP through firebase.
                  await sendOTP(_cPhone.text.trim());
                } else {
                  hideLoader();
                  Get.to(() => OtpVerificationScreen(
                      phoneNumber: _cPhone.text.trim(),
                      a: widget.analytics,
                      o: widget.observer));
                }
              } else {
                hideLoader();
                CurrentUser _currentUser = new CurrentUser();
                _currentUser.userPhone = _cPhone.text.trim();
                // registration required
                Get.to(() => SignUpScreen(
                      user: _currentUser,
                      a: widget.analytics,
                      o: widget.observer,
                      loginType: 0,
                    ));
              }
            }
          });
        } else if (_cPhone.text.trim().isEmpty) {
          showSnackBar(
              key: _scaffoldKey1,
              snackBarMessage:
                  '${AppLocalizations.of(context).txt_please_enter_mobile_number}');
        } else if (_cPhone.text.trim().length !=
            global.appInfo.phoneNumberLength) {
          showSnackBar(
              key: _scaffoldKey1,
              snackBarMessage:
                  '${AppLocalizations.of(context).txt_please_enter} ${global.appInfo.phoneNumberLength} ${AppLocalizations.of(context).txt_digit}');
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey1);
      }
    } catch (e) {
      hideLoader();
      print("Exception - login_screen.dart - login():" + e.toString());
    }
  }

  loginWithEmail() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_cEmail.text != null &&
            _cEmail.text.trim().isNotEmpty &&
            EmailValidator.validate(_cEmail.text) &&
            _cPassword != null &&
            _cPassword.text.trim().isNotEmpty) {
          showOnlyLoaderDialog();
          global.currentUser = new CurrentUser();
          await apiHelper
              .loginWithEmail(_cEmail.text.trim(), _cPassword.text.trim())
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                global.currentUser = result.data;
                global.userProfileController.currentUser = global.currentUser;
                global.sp.setString(
                    'currentUser', json.encode(global.currentUser.toJson()));

                hideLoader();

                Get.to(() => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    ));
              } else if (result.status == '2') {
                hideLoader();
                CurrentUser _currentUser = new CurrentUser();
                _currentUser.email = _cEmail.text;
                Get.to(
                  () => SignUpScreen(
                    user: _currentUser,
                    a: widget.analytics,
                    o: widget.observer,
                    loginType: 1,
                  ),
                );
              } else if (result.status == '0') {
                hideLoader();
                showSnackBar(
                    key: _scaffoldKey1, snackBarMessage: result.message);
              }
            }
          });
          // hideLoader();
        } else if (_cEmail.text.isEmpty) {
          showSnackBar(
              key: _scaffoldKey1,
              snackBarMessage:
                  '${AppLocalizations.of(context).txt_please_enter_your_email}');
        } else if (_cEmail.text.isNotEmpty &&
            !EmailValidator.validate(_cEmail.text)) {
          showSnackBar(
              key: _scaffoldKey1,
              snackBarMessage:
                  '${AppLocalizations.of(context).txt_please_enter_your_valid_email}');
        } else if (_cPassword.text.isEmpty) {
          showSnackBar(
              key: _scaffoldKey1,
              snackBarMessage:
                  '${AppLocalizations.of(context).txt_please_enter_your_password} ');
        }
      } else {
        hideLoader();
        showNetworkErrorSnackBar(_scaffoldKey1);
      }
    } catch (e) {
      hideLoader();
      print("Exception - login_screen.dart - loginWithEmail():" + e.toString());
    }
  }

  _init() async {
    try {
      PermissionStatus permissionStatus = await Permission.phone.status;
      if (Platform.isAndroid && permissionStatus.isGranted) {
        await initMobileNumberState();
      }
    } catch (e) {
      print("Exception - login_screen.dart - _init():" + e.toString());
    }
  }

  _selectPhoneNumber() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('${AppLocalizations.of(context).txt_select_phonenumber}'),
          actions: _simCard
              .map((e) => CupertinoActionSheetAction(
                    child: Text(
                        '${e.number.substring(e.number.length - global.appInfo.phoneNumberLength)}'),
                    onPressed: () async {
                      setState(() {
                        _cPhone.text = e.number.substring(
                            e.number.length - global.appInfo.phoneNumberLength);
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text('${AppLocalizations.of(context).lbl_cancel_reason}'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print("Exception - login_screen.dart - _showCupertinoModalSheet():" +
          e.toString());
    }
  }

  _signInWithApple() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();

        final _firebaseAuth = FirebaseAuth.instance;

        String generateNonce([int length = 32]) {
          final charset =
              '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
          final random = Random.secure();
          return List.generate(
              length, (_) => charset[random.nextInt(charset.length)]).join();
        }

        String sha256ofString(String input) {
          final bytes = utf8.encode(input);
          final digest = sha256.convert(bytes);
          return digest.toString();
        }

        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        ).catchError((e) {
          hideLoader();
        });
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          rawNonce: rawNonce,
        );
        final authResult = await _firebaseAuth
            .signInWithCredential(oauthCredential)
            .onError((error, stackTrace) {
          hideLoader();
          return null;
        }).catchError((e) {
          hideLoader();
        });
        await apiHelper
            .socialLogin(
                userEmail: credential.email != null ? credential.email : null,
                type: 'apple',
                appleId: authResult.user.uid)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.currentUser = result.data;
              global.sp.setString(
                  'currentUser', json.encode(global.currentUser.toJson()));

              await global.userProfileController.getMyProfile();
              hideLoader();
              Get.to(() => HomeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  ));
            } else {
              CurrentUser _currentUser = new CurrentUser();
              _currentUser.email = credential.email;
              _currentUser.name = credential.givenName;

              hideLoader();
              // registration required
              Get.to(
                () => SignUpScreen(
                  user: _currentUser,
                  a: widget.analytics,
                  o: widget.observer,
                  loginType: credential.email != null ? 1 : 2,
                ),
              );
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey1);
      }
    } catch (e) {
      hideLoader();
      print(
          "Exception - login_screen.dart - _signinWithApple():" + e.toString());
    }
  }

  void _loginS(
      BuildContext contextt, GlobalKey<ScaffoldState> scaffoldKey1) async {
    fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]).then((res) async {
      switch (res.status) {
        case FacebookLoginStatus.success:
          final FacebookAccessToken accessToken = res.accessToken;
          print('Access token: ${accessToken.token}');
          final profile = await fb.getUserProfile();
          final email =
              await fb.getUserEmail() != null ? fb.getUserEmail() : '';

          var resp = await http
              .post(Uri.parse('${global.baseUrl}social_login'), body: {
            "user_email": email,
            "fb_id": '${profile.userId}',
            "type": "facebook",
            "apple_id": '',
            'device_id': global.appDeviceId
          });
          var result = jsonDecode(resp.body);
          if (result != null) {
            if ('${result['status']}' == '1') {
              global.currentUser = CurrentUser.fromJson(result['data']);
              global.currentUser.token = result['token'];
              global.sp.setString(
                  'currentUser', json.encode(global.currentUser.toJson()));
              hideLoader();
              Get.to(() => HomeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  ));
            } else {
              CurrentUser _currentuser = new CurrentUser();
              _currentuser.email = email;
              _currentuser.name = profile.name;
              _currentuser.facebookId = '${profile.userId}';
              hideLoader();

              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                          user: _currentuser,
                          a: widget.analytics,
                          o: widget.observer,
                          loginType: email.toString().isNotEmpty &&
                                  email.toString().length > 0
                              ? 1
                              : 2,
                        )),
              );
            }
          } else {
            hideLoader();
            showSnackBar(
                key: scaffoldKey1,
                snackBarMessage:
                    '${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
          }

          break;
        case FacebookLoginStatus.cancel:
          hideLoader();
          showNetworkErrorSnackBar(scaffoldKey1);
          break;
        case FacebookLoginStatus.error:
          hideLoader();
          showNetworkErrorSnackBar(scaffoldKey1);
          break;
      }
    }).catchError((e) {
      hideLoader();
      showNetworkErrorSnackBar(scaffoldKey1);
      print(e);
    });
    // await facebookSignIn.logIn(['email'])
  }

// void hitgraphResponse(FacebookAccessToken accessToken, BuildContext contextt,
//     GlobalKey<ScaffoldState> scaffoldKey1) async {
//   try {
//     var http = Client();
//     var graphResponse = await http.get(Uri.parse(
//         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));
//     final profile = jsonDecode(graphResponse.body);
//     // var formData = FormData.fromMap();
//     var resp =
//         await http.post(Uri.parse('${global.baseUrl}social_login'), body: {
//       "user_email": (profile['email'] != null &&
//               profile['email'].toString().length > 0 &&
//               '${profile['email']}'.toUpperCase() != 'NULL')
//           ? profile['email']
//           : '',
//       "fb_id": '${profile['id']}',
//       "type": "facebook",
//       "apple_id": '',
//       'device_id': global.appDeviceId
//     });
//     var result = jsonDecode(resp.body);
//     if (result != null) {
//       print('in p');
//       print('in p ${result}');
//       print('in p ${result['status']}');
//       print('in p ${result['data']}');
//       if ('${result['status']}' == '1') {
//         print('in p1');
//         print('in p1 ${result['data']['status']}');
//         global.currentUser = CurrentUser.fromJson(result['data']);
//         global.currentUser.token = result['token'];
//         global.sp.setString(
//             'currentUser', json.encode(global.currentUser.toJson()));
//
//         hideLoader();
//         // if (global.nearStoreModel != null) {
//         //   await global.userProfileController.getUserAddressList();
//         // }
//         // await global.userProfileController.getMyProfile();
//         Get.to(() => HomeScreen(
//               a: widget.analytics,
//               o: widget.observer,
//             ));
//       } else {
//         CurrentUser _currentuser = new CurrentUser();
//         _currentuser.email = (profile['email'] != null &&
//                 profile['email'].toString().length > 0 &&
//                 '${profile['email']}'.toUpperCase() != 'NULL')
//             ? profile['email']
//             : '';
//         _currentuser.name = profile['name'];
//         _currentuser.facebookId = '${profile['id']}';
//         hideLoader();
//
//         Navigator.of(context).push(
//           MaterialPageRoute(
//               builder: (context) => SignUpScreen(
//                     user: _currentuser,
//                     a: widget.analytics,
//                     o: widget.observer,
//                     loginType: (profile['email'] != null &&
//                             profile['email'].toString().length > 0 &&
//                             '${profile['email']}'.toUpperCase() != 'NULL')
//                         ? 1
//                         : 2,
//                   )),
//         );
//       }
//     } else {
//       hideLoader();
//       showSnackBar(
//           key: scaffoldKey1,
//           snackBarMessage:
//               '${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
//     }
//   } catch (e) {
//     hideLoader();
//     showSnackBar(
//         key: scaffoldKey1,
//         snackBarMessage:
//             '${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
//     print(e);
//   }
// }
}
