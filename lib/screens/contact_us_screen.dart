import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;

class ContactUsScreen extends BaseRoute {
  ContactUsScreen({a, o}) : super(a: a, o: o, r: 'ContactUsScreen');
  @override
  _ContactUsScreenState createState() => new _ContactUsScreenState();
}

class _ContactUsScreenState extends BaseRouteState {
  var _cFeedback = new TextEditingController();
  var _fFeedback = new FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<String> _storeName = ['Admin'];
  String _selectedStore = 'Admin';
  _ContactUsScreenState() : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        appBar: AppBar(
          title: Text("${AppLocalizations.of(context).tle_contact_us} ", style: textTheme.headline6),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.keyboard_arrow_left)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.expand_more,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  value: _selectedStore,
                  items: _storeName
                      .map((label) => DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(label.toString(), style: Theme.of(context).textTheme.bodyText1),
                            ),
                            value: label,
                          ))
                      .toList(),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '${AppLocalizations.of(context).lbl_select_store} ',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedStore = value;
                    });
                  },
                ),
                SizedBox(
                  height: 35,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "${AppLocalizations.of(context).lbl_callback_desc}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () async {
                          await _sendCallbackRequest();
                        },
                        child: Text('${AppLocalizations.of(context).btn_callback_request}')),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${AppLocalizations.of(context).lbl_contact_desc}",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "${AppLocalizations.of(context).lbl_your_feedback} ",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  margin: EdgeInsets.only(top: 5, bottom: 15),
                  padding: EdgeInsets.only(),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _cFeedback,
                    focusNode: _fFeedback,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: '${AppLocalizations.of(context).txt_type_here}',
                      contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () async {
                  await _submitFeedBack();
                },
                child: Text('${AppLocalizations.of(context).btn_submit}')),
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
    if (global.nearStoreModel!=null && global.nearStoreModel.id != null) {
      _storeName.insert(0, global.nearStoreModel.storeName);
    }
  }

  _sendCallbackRequest() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.calbackRequest(_selectedStore == 'Admin' ? null : _selectedStore).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_callback_request_sent} ', key: _scaffoldKey);
            } else {
              hideLoader();
              showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_something_went_wrong}, ${AppLocalizations.of(context).txt_please_try_again_after_sometime}', key: _scaffoldKey);
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - contact_us_screen.dart - _submitFeedBack():" + e.toString());
    }
  }

  _submitFeedBack() async {
    try {
      if (_cFeedback.text.trim().isNotEmpty) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          await apiHelper.sendUserFeedback(_cFeedback.text.trim()).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                hideLoader();
                showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_feedback_sent}', key: _scaffoldKey);
              } else {
                hideLoader();
                showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_something_went_wrong}, ${AppLocalizations.of(context).txt_please_try_again_after_sometime}', key: _scaffoldKey);
              }
            }
          });
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
      } else {
        showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_enter_feedback}', key: _scaffoldKey);
      }
    } catch (e) {
      print("Exception - contact_us_screen.dart - _submitFeedBack():" + e.toString());
    }
  }
}
