import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/add_address_screen.dart';
import 'package:user/widgets/address_info_card.dart';

class ProductRequestScreen extends BaseRoute {
  ProductRequestScreen({a, o}) : super(a: a, o: o, r: 'ProductRequestScreen');

  @override
  _ProductRequestScreenState createState() => _ProductRequestScreenState();
}

class _ProductRequestScreenState extends BaseRouteState {
  final double height = Get.height;
  final double width = Get.width;
  final Color color = const Color(0xffFF0000);
  File tImage;
  Address _selectedAddress;
  GlobalKey<ScaffoldState> _scaffoldKey;

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${AppLocalizations.of(context).lbl_make_product_request}',
            style: textTheme.headline6,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.keyboard_arrow_left)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "${AppLocalizations.of(context).tle_cant_find_product}",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: ListTile(
                  onTap: () async {
                    await _showCupertinoModalSheet();
                  },
                  leading: Icon(
                    Icons.cloud_upload_outlined,
                    color: color,
                  ),
                  title: Text(
                    "${AppLocalizations.of(context).lbl_upload_image}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "${AppLocalizations.of(context).txt_choose_image_from_gallery}",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: tImage != null
                    ? Container(
                        height: 220,
                        width: 250,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.contain, image: FileImage(File(tImage.path)))),
                      )
                    : Container(
                        height: 220,
                        width: 250,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () async {
                            await _showCupertinoModalSheet();
                          },
                          child: Center(
                              child: Icon(
                            Icons.file_upload,
                            size: 50,
                          )),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: color,
                  ),
                  title: Text(
                    "${AppLocalizations.of(context).lbl_select_address}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              global.userProfileController.addressList != null && global.userProfileController.addressList.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: global.userProfileController.addressList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: AddressInfoCard(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            key: UniqueKey(),
                            address: global.userProfileController.addressList[index],
                            isSelected: global.userProfileController.addressList[index].isSelected,
                            value: global.userProfileController.addressList[index],
                            groupValue: _selectedAddress,
                            onChanged: (value) {
                              setState(() {
                                _selectedAddress = value;
                                global.userProfileController.addressList[index].isSelected = !global.userProfileController.addressList[index].isSelected;
                              });
                            },
                          ),
                        );
                      })
                  : InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressScreen(new Address(), a: widget.analytics, o: widget.observer))).then((value){
                          setState(() { });
                        });
                      },
                      child: SizedBox(
                          height: 150,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add_location_alt_sharp),
                              Text('${AppLocalizations.of(context).tle_add_new_address}'),
                            ],
                          )))),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8),
          child: InkWell(
            onTap: () async {
              await _makeProductRequest();
            },
            child: Container(
              height: height * 0.07,
              width: width * 0.9,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              child: Center(
                  child: Text(
                "${AppLocalizations.of(context).btn_submit}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _makeProductRequest() async {
    try {
      showOnlyLoaderDialog();
      await apiHelper.makeProductRequest(_selectedAddress.addressId, tImage).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            hideLoader();
            _showProductRequestConfirmationDialog(result.message);
          } else if (result.status == '2') {
            hideLoader();
            _showProductRequestConfirmationDialog(result.message);
          } else {
            hideLoader();
            showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_something_went_wrong}.');
          }
        }
      });
    } catch (e) {
      print("Exception - product_request_screen.dart - _makeProductRequest():" + e.toString());
    }
  }

  _showCupertinoModalSheet() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('${AppLocalizations.of(context).lbl_actions}'),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                '${AppLocalizations.of(context).lbl_take_picture}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                showOnlyLoaderDialog();
                tImage = await br.openCamera();
                hideLoader();

                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                '${AppLocalizations.of(context).txt_upload_image_desc}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                showOnlyLoaderDialog();
                tImage = await br.selectImageFromGallery();
                hideLoader();

                setState(() {});
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('${AppLocalizations.of(context).lbl_cancel}', style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print("Exception - product_request_screen.dart - _showCupertinoModalSheet():" + e.toString());
    }
  }

  _showProductRequestConfirmationDialog(String message) {
    return showDialog(
        context: context,
        barrierColor: Colors.grey[300].withOpacity(0.5),
        builder: (BuildContext context) {
          _timer = Timer(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return SimpleDialog(
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      message,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )))
            ],
          );
        }).then((val) {
      _timer.cancel();
      Get.back();
    });
  }
}
