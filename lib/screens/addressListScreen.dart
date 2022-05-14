import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/controllers/user_profile_controller.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/add_address_screen.dart';
import 'package:user/screens/home_screen.dart';

class AddressListScreen extends BaseRoute {
  AddressListScreen({a, o}) : super(a: a, o: o, r: 'AddressListScreen');
  @override
  _AddressListScreenState createState() => new _AddressListScreenState();
}

class _AddressListScreenState extends BaseRouteState {
  bool _isDataLoaded = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  _AddressListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
        onWillPop: () {
          return Get.to(() => HomeScreen(
                a: widget.analytics,
                o: widget.observer,
                screenId: 1,
              ));
        },
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onTap: () {
                  Get.to(() => HomeScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        screenId: 1,
                      ));
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.keyboard_arrow_left),
                ),
              ),
              centerTitle: true,
              title: Text(
                "${AppLocalizations.of(context).tle_my_address}",
                style: textTheme.headline6,
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddAddressScreen(new Address(), a: widget.analytics, o: widget.observer),
                      ),
                    ).then((value){
                      setState(() { });
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _isDataLoaded = false;
                setState(() {});
                await _getMyAddressList();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isDataLoaded
                    ? global.userProfileController.addressList != null && global.userProfileController.addressList.length > 0
                        ? GetBuilder<UserProfileController>(
                            init: global.userProfileController,
                            builder: (value) => ListView.builder(
                              itemCount: global.userProfileController.addressList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(7),
                                    title: Text(
                                      global.userProfileController.addressList[index].type,
                                      style: textTheme.bodyText1.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${global.userProfileController.addressList[index].houseNo}, ${global.userProfileController.addressList[index].landmark}, ${global.userProfileController.addressList[index].society}",
                                          style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => AddAddressScreen(global.userProfileController.addressList[index], a: widget.analytics, o: widget.observer),
                                                    ),
                                                  ).then((value){
                                                    setState(() { });
                                                  });
                                                },
                                                icon: Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () async {
                                                  await deleteConfirmationDialog(index);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Theme.of(context).primaryColor,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text('${AppLocalizations.of(context).txt_no_address}'),
                          )
                    : _shimmerList(),
              ),
            ),
          ),
        ));
  }

  Future deleteConfirmationDialog(int index) async {
    try {
      await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white),
          child: CupertinoAlertDialog(
            title: Text(
              " ${AppLocalizations.of(context).tle_delete_address} ",
            ),
            content: Text(
              "${AppLocalizations.of(context).lbl_delete_address_desc}  ",
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  '${AppLocalizations.of(context).btn_ok}',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  showOnlyLoaderDialog();
                  await _removeAddress(index);
                },
              ),
              CupertinoDialogAction(
                child: Text("${AppLocalizations.of(context).lbl_cancel} "),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print("Exception - addressListScreen.dart - deleteConfirmationDialog():" + e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getMyAddressList();
  }

  _getMyAddressList() async {
    try {
      if (global.nearStoreModel != null) {
        await global.userProfileController.getUserAddressList();
      }
      if (global.userProfileController.isDataLoaded.value == true) {
        _isDataLoaded = true;
      } else {
        _isDataLoaded = false;
      }
      setState(() {});
    } catch (e) {
      print("Exception - addressListScreen.dart - _getMyAddressList():" + e.toString());
    }
  }

  _removeAddress(int index) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        global.userProfileController.removeUserAddress(index);
        hideLoader();
      } else {
        hideLoader();
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - addressListScreen.dart - _removeAddress():" + e.toString());
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              top: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 112,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - addressListScreen.dart - _shimmerList():" + e.toString());
      return SizedBox();
    }
  }
}
