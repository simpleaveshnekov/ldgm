import 'dart:core';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/cityModel.dart';
import 'package:user/models/societyModel.dart';
import 'package:user/models/userModel.dart';
import 'package:user/screens/otp_verification_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/my_text_field.dart';
import 'package:user/widgets/profile_picture.dart';

class SignUpScreen extends BaseRoute {
  final CurrentUser user;
  final int loginType;
  SignUpScreen({a, o, this.user, this.loginType}) : super(a: a, o: o, r: 'SignUpScreen');

  @override
  _SignUpScreenState createState() => _SignUpScreenState(user: user,logintype:loginType);
}

class _SignUpScreenState extends BaseRouteState {
  CurrentUser user;
  TextEditingController _cName = new TextEditingController();

  TextEditingController _cPhoneNumber = new TextEditingController();
  TextEditingController _cEmail = new TextEditingController();
  TextEditingController _cPassword = new TextEditingController();
  TextEditingController _cConfirmPassword = new TextEditingController();
  TextEditingController _cCity = new TextEditingController();
  TextEditingController _cSociety = new TextEditingController();
  TextEditingController _cReferral = new TextEditingController();
  TextEditingController _cSearchCity = new TextEditingController();
  TextEditingController _cSearchSociety = new TextEditingController();
  FocusNode _fName = new FocusNode();
int logintype;
  FocusNode _fPhoneNumber = new FocusNode();
  FocusNode _fEmail = new FocusNode();
  FocusNode _fCity = new FocusNode();
  FocusNode _fSociety = new FocusNode();
  FocusNode _fReferral = new FocusNode();
  FocusNode _fPassword = new FocusNode();
  FocusNode _fConfirmPassword = new FocusNode();
  FocusNode _fSearchCity = new FocusNode();
  FocusNode _fSearchSociety = new FocusNode();
  FocusNode _fDismiss = new FocusNode();
  bool _isPasswordVisible = true;

  bool _isConfirmPasswordVisible = true;
  List<City> _citiesList = [];
  List<Society> _societyList = [];
  List<City> _tCityList = [];
  List<Society> _tSocietyList = [];
  City _selectedCity = new City();
  Society _selectedSociety = new Society();
  GlobalKey<ScaffoldState> _scaffoldKey;
  _SignUpScreenState({this.user, this.logintype});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: ProfilePicture(
                    isShow: true,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                Key('6'),
                controller: _cName,
                focusNode: _fName,
                hintText: "${AppLocalizations.of(context).lbl_name}",
                autofocus: false,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fPhoneNumber);
                },
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                Key('7'),
                controller: _cPhoneNumber,
                focusNode: _fPhoneNumber,
                hintText: 'Mobile No.',
                readOnly: logintype==0,
                autofocus: false,
                maxLines: 1,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(global.appInfo.phoneNumberLength)],
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fEmail);
                },
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                Key('8'),
                controller: _cEmail,
                focusNode: _fEmail,
                hintText: "${AppLocalizations.of(context).lbl_email}",
                autofocus: false,
                maxLines: 1,
                readOnly: logintype==1,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fPassword);
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _cPassword,
                focusNode: _fPassword,
                obscureText: _isPasswordVisible,
                style: textFieldInputStyle(context, FontWeight.normal),
                keyboardType: TextInputType.text,
                autofocus: false,
                readOnly: false,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  prefixStyle: textFieldInputStyle(context, FontWeight.normal),
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
                  hintText: "${AppLocalizations.of(context).lbl_password}",
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: IconTheme.of(context).color),
                    onPressed: () {
                      _isPasswordVisible = !_isPasswordVisible;
                      setState(() {});
                    },
                  ),
                  hintStyle: textFieldHintStyle(context),
                ),
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fConfirmPassword);
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _cConfirmPassword,
                focusNode: _fConfirmPassword,
                obscureText: _isConfirmPasswordVisible,
                style: textFieldInputStyle(context, FontWeight.normal),
                keyboardType: TextInputType.text,
                autofocus: false,
                readOnly: false,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  prefixStyle: textFieldInputStyle(context, FontWeight.normal),
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
                  hintText: "${AppLocalizations.of(context).lbl_confirm_password}",
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: IconTheme.of(context).color),
                    onPressed: () {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      setState(() {});
                    },
                  ),
                  hintStyle: textFieldHintStyle(context),
                ),
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fCity);
                },
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: MyTextField(
                  Key('111'),
                  controller: _cCity,
                  focusNode: _fCity,
                  readOnly: true,
                  autofocus: false,
                  hintText: '${AppLocalizations.of(context).hnt_select_city}',
                  onTap: () {
                    if (_citiesList != null && _citiesList.length > 0) {
                      _cCity.clear();
                      _cSociety.clear();
                      _cSearchCity.clear();
                      _cSearchSociety.clear();
                      _selectedCity = new City();
                      _selectedSociety = new Society();
                      _showCitySelectDialog();
                    } else {
                      showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_no_city}');
                    }

                    setState(() {});
                  },
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(_fSociety);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                Key('11'),
                controller: _cSociety,
                focusNode: _fSociety,
                hintText: '${AppLocalizations.of(context).hnt_select_society}',
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fReferral);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MyTextField(
                  Key('112'),
                  controller: _cReferral,
                  focusNode: _fReferral,
                  hintText: 'Referral Code',
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(_fDismiss);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, top: 5),
              child: BottomButton(
                child: Text("${AppLocalizations.of(context).btn_signup}"),
                loadingState: false,
                disabledState: false,
                onPressed: () {
                  _onSignUp();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${AppLocalizations.of(context).lbl_already_have_account}'),
                TextButton(
                  child: Text('${AppLocalizations.of(context).btn_login}'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _filldata() {
    try {
      _cPhoneNumber.text = user.userPhone;
      _cEmail.text = user.email;
      _cName.text = user.name;
    } catch (e) {
      print("Exception - signup_screen.dart - _filldata():" + e.toString());
    }
  }

  _getCities() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getCity().then((result) {
          if (result != null && result.statusCode == 200 && result.status == '1') {
            _citiesList = result.data;
            _tCityList.addAll(_citiesList);
          } else {
            _citiesList = [];
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - signup_screen.dart - _getCities():" + e.toString());
    }
  }

  _getSociety() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getSociety(_selectedCity.cityId).then((result) {
          if (result != null && result.statusCode == 200 && result.status == '1') {
            _societyList = result.data;
            _tSocietyList.addAll(_societyList);
            Navigator.of(context).pop();
            _cSearchCity.clear();
            _showSocietySelectDialog();
            setState(() {});
          } else {
            Navigator.of(context).pop();
            _cSearchCity.clear();
            _societyList = [];
            showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - signup_screen.dart - _getSociety():" + e.toString());
    }
  }

  _init() async {
    try {
      _filldata();
      await _getCities();
      setState(() {});
    } catch (e) {
      print("Exception - signup_screen.dart - _init():" + e.toString());
    }
  }

  _onSignUp() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_cName.text.isNotEmpty && EmailValidator.validate(_cEmail.text) && _cEmail.text.isNotEmpty && _cPhoneNumber.text.isNotEmpty && _cPhoneNumber.text.trim().length == global.appInfo.phoneNumberLength && _cPassword.text.isNotEmpty && _cPassword.text.trim().length >= 8 && _cConfirmPassword.text.isNotEmpty && _cPassword.text.trim().length == _cConfirmPassword.text.trim().length && _cPassword.text.trim() == _cConfirmPassword.text.trim() && _selectedCity != null && _selectedCity.cityId != null) {
          showOnlyLoaderDialog();
          CurrentUser _user = new CurrentUser();

          _user.name = _cName.text.trim();
          _user.email = _cEmail.text.trim();
          _user.userPhone = _cPhoneNumber.text.trim();
          _user.password = _cPassword.text.trim();
          _user.userImage = global.selectedImage != null ? global.selectedImage : null;
          _user.referralCode = _cReferral.text.trim();
          _user.userCity = _selectedCity.cityId;
          _user.userArea = _selectedSociety.societyId;
          _user.facebookId = user.facebookId;

          await apiHelper.signUp(_user).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                global.currentUser = result.data;
                global.userProfileController.currentUser = global.currentUser;

                if (global.appInfo.firebase != 'off') {
                  // if firebase is enabled then only we need to send OTP through firebase.
                  await sendOTP(_cPhoneNumber.text.trim());
                } else {
                  hideLoader();
                  Get.to(() => OtpVerificationScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        phoneNumber: _cPhoneNumber.text.trim(),
                        referalCode: _cReferral.text.trim(),
                      ));
                }
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
              }
            }
          });
        } else if (_cName.text.isEmpty) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_enter_your_name}');
        } else if (_cEmail.text.isEmpty) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_enter_your_email}');
        } else if (_cEmail.text.isNotEmpty && !EmailValidator.validate(_cEmail.text)) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_enter_your_valid_email}');
        } else if (_cPhoneNumber.text.isEmpty || (_cPhoneNumber.text.isNotEmpty && _cPhoneNumber.text.trim().length != global.appInfo.phoneNumberLength)) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_enter_valid_mobile_number}');
        } else if (_cPassword.text.isEmpty) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_enter_your_password}');
        } else if (_cPassword.text.isNotEmpty && _cPassword.text.trim().length < 8) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_password_should_be_of_minimum_8_character}');
        } else if (_cConfirmPassword.text.isEmpty && _cPassword.text.isNotEmpty) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_reEnter_your_password}');
        } else if (_cConfirmPassword.text.isNotEmpty && _cPassword.text.isNotEmpty && (_cConfirmPassword.text.trim() != _cPassword.text.trim())) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_password_do_not_match}');
        } else if (_selectedCity.cityId == null) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_select_city}');
        } else if (_selectedSociety.societyId == null) {
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_select_society}');
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - signup_screen.dart - _onSignUp():" + e.toString());
    }
  }

  _showCitySelectDialog() {
    try {
      showDialog(
          context: context,
          barrierColor: Colors.black38,
          builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) => Container(
                  child: AlertDialog(
                    elevation: 2,
                    scrollable: false,
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Column(
                      children: [
                        Text('${AppLocalizations.of(context).hnt_select_city}'),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: EdgeInsets.only(top: 5, bottom: 15),
                          padding: EdgeInsets.only(),
                          child: MyTextField(
                            Key('12'),
                            controller: _cSearchCity,
                            focusNode: _fSearchCity,
                            hintText: '${AppLocalizations.of(context).hnt_search_city}',
                            onChanged: (val) {
                              _citiesList.clear();
                              if (val.isNotEmpty && val.length > 2) {
                                _citiesList.addAll(_tCityList.where((e) => e.cityName.toLowerCase().contains(val.toLowerCase())));
                              } else {
                                _citiesList.addAll(_tCityList);
                              }

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: _citiesList != null && _citiesList.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _citiesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return RadioListTile(
                                    title: Text('${_citiesList[index].cityName}'),
                                    value: _citiesList[index],
                                    groupValue: _selectedCity,
                                    onChanged: (value) async {
                                      _selectedCity = value;
                                      _cCity.text = _selectedCity.cityName;
                                      await _getSociety();
                                      setState(() {});
                                    });
                              })
                          : Center(
                              child: Text(
                                '${AppLocalizations.of(context).txt_no_city}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text('${AppLocalizations.of(context).btn_close}'))
                    ],
                  ),
                ),
              ));
    } catch (e) {
      print("Exception - signup_screen.dart - _showCitySelectDialog():" + e.toString());
    }
  }

  _showSocietySelectDialog() {
    try {
      showDialog(
          context: context,
          useRootNavigator: true,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) => Container(
                  child: AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Column(
                      children: [
                        Text('${AppLocalizations.of(context).hnt_select_society}'),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: EdgeInsets.only(top: 5, bottom: 15),
                          padding: EdgeInsets.only(),
                          child: TextFormField(
                            controller: _cSearchSociety,
                            focusNode: _fSearchSociety,
                            style: Theme.of(context).textTheme.subtitle1,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                              hintText: '${AppLocalizations.of(context).htn_search_society}',
                              contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                            ),
                            onChanged: (val) {
                              _societyList.clear();
                              if (val.isNotEmpty && val.length > 2) {
                                _societyList.addAll(_tSocietyList.where((e) => e.societyName.toLowerCase().contains(val.toLowerCase())));
                              } else {
                                _societyList.addAll(_tSocietyList);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: _societyList != null && _societyList.length > 0
                          ? ListView.builder(
                              itemCount: _cSearchSociety.text.isNotEmpty && _tSocietyList != null && _tSocietyList.length > 0 ? _tSocietyList.length : _societyList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return RadioListTile(
                                    title: Text(_cSearchSociety.text.isNotEmpty && _tSocietyList != null && _tSocietyList.length > 0 ? '${_tSocietyList[index].societyName}' : '${_societyList[index].societyName}'),
                                    value: _cSearchSociety.text.isNotEmpty && _tSocietyList != null && _tSocietyList.length > 0 ? _tSocietyList[index] : _societyList[index],
                                    groupValue: _selectedSociety,
                                    onChanged: (value) async {
                                      _selectedSociety = value;
                                      _cSociety.text = _selectedSociety.societyName;
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    });
                              })
                          : Center(
                              child: Text(
                              '${AppLocalizations.of(context).txt_no_society}',
                              textAlign: TextAlign.center,
                            )),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text('${AppLocalizations.of(context).btn_close}'))
                    ],
                  ),
                ),
              ));
    } catch (e) {
      print("Exception - signup_screen.dart - _showSocietySelectDialog():" + e.toString());
    }
  }
}
