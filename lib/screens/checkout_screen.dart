import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/membershipStatusModel.dart';
import 'package:user/models/orderModel.dart';
import 'package:user/models/timeSlotModel.dart';
import 'package:user/screens/add_address_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/membership_screen.dart';
import 'package:user/screens/payment_screen.dart';
import 'package:user/widgets/address_info_card.dart';
import 'package:user/widgets/confirmation_slider.dart';
import 'package:user/widgets/date_time_selector.dart';
import 'package:user/widgets/toastfile.dart';

class CheckoutScreen extends BaseRoute {
  final CartController cartController;

  CheckoutScreen({a, o, this.cartController})
      : super(a: a, o: o, r: 'CheckoutScreen');

  @override
  _CheckoutScreenState createState() =>
      _CheckoutScreenState(cartController: cartController);
}

class _CheckoutScreenState extends BaseRouteState {
  CartController cartController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Address _selectedAddress = new Address();
  List<TimeSlot> _timeSlotList = [];
  DateTime _selectedDate;
  TimeSlot _selectedTimeSlot;
  var _openingTime;
  var _closingTime;
  bool _isClosingTime = false;
  ScrollController _scrollController = ScrollController();
  Order orderDetails;

  MembershipStatus _membershipStatus = new MembershipStatus();

  bool isWantInstant = false;

  _CheckoutScreenState({this.cartController});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    TextStyle subHeadingStyle = textTheme.subtitle1.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    _membershipStatus.status = 'running';
    return WillPopScope(
      onWillPop: () {
        return Get.to(() =>
            CartScreen(
              a: widget.analytics,
              o: widget.observer,
            ));
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${AppLocalizations
                  .of(context)
                  .btn_proceed_to_checkout}",
              style: textTheme.headline6,
            ),
            leading: IconButton(
                onPressed: () {
                  Get.to(() =>
                      CartScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      ));
                },
                icon: Icon(Icons.keyboard_arrow_left)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    global.userProfileController.addressList != null &&
                        global.userProfileController.addressList.length > 0
                        ? "${AppLocalizations
                        .of(context)
                        .lbl_shipping_to} Shipping to "
                        : "${AppLocalizations
                        .of(context)
                        .txt_no_address}",
                    style: subHeadingStyle,
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.3,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: global.userProfileController.addressList != null &&
                        global.userProfileController.addressList.length > 0
                        ? ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        global.userProfileController.addressList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 6.0),
                            child: InkWell(
                              onTap: () {
                                // setState(() {});
                              },
                              child: AddressInfoCard(
                                analytics: widget.analytics,
                                observer: widget.observer,
                                key: UniqueKey(),
                                address: global.userProfileController
                                    .addressList[index],
                                isSelected: global.userProfileController
                                    .addressList[index].isSelected,
                                value: global.userProfileController
                                    .addressList[index],
                                groupValue: _selectedAddress,
                                onChanged: (value) {
                                  _selectAddressForCheckout(
                                      selectedAddressId:
                                      value.addressId,addressSelected: value,index: index);
                                  // setState(() {
                                  //   _selectedAddress = value;
                                  //   global.userProfileController.addressList[index].isSelected =
                                  //   !global.userProfileController
                                  //       .addressList[index].isSelected;
                                  // });
                                },
                              ),
                            ),
                          );
                        })
                        : InkWell(
                      onTap: () {
                        Get.to(() =>
                            AddAddressScreen(
                              Address(),
                              a: widget.analytics,
                              o: widget.observer,
                              screenId: 0,
                            )).then((value) {
                          setState(() {});
                        });
                      },
                      child: Center(
                        child: Text(
                          "${AppLocalizations
                              .of(context)
                              .tle_add_new_address}",
                          style: textTheme.subtitle1.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12.0),
                    child: global.userProfileController.addressList != null &&
                        global.userProfileController.addressList.length > 0
                        ? InkWell(
                      onTap: () {
                        Get.to(() =>
                            AddAddressScreen(
                              Address(),
                              a: widget.analytics,
                              o: widget.observer,
                              screenId: 0,
                            )).then((value) {
                          setState(() {});
                        });
                      },
                      child: Text(
                        "${AppLocalizations
                            .of(context)
                            .tle_add_new_address} ",
                        style: textTheme.subtitle1.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    )
                        : SizedBox(),
                  ),
                  _isClosingTime == false &&
                      global.nearStoreModel.storeOpeningTime != null &&
                      global.nearStoreModel.storeOpeningTime != '' &&
                      global.nearStoreModel.storeClosingTime != null &&
                      global.nearStoreModel.storeClosingTime != '' &&
                      DateTime.now().isAfter(_openingTime) &&
                      DateTime.now().isBefore(
                          _closingTime.subtract(Duration(hours: 1)))
                      ? SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: SwitchListTile(
                      tileColor: Theme
                          .of(context)
                          .primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: isWantInstant,
                      activeColor: Theme
                          .of(context)
                          .primaryColorLight,
                      onChanged: (val) async {
                        if (_isClosingTime == false &&
                            global.nearStoreModel.storeOpeningTime !=
                                null &&
                            global.nearStoreModel.storeOpeningTime !=
                                '' &&
                            global.nearStoreModel.storeClosingTime !=
                                null &&
                            global.nearStoreModel.storeClosingTime !=
                                '' &&
                            DateTime.now().isAfter(_openingTime) &&
                            DateTime.now().isBefore(_closingTime
                                .subtract(Duration(hours: 1)))) {
                          if (val) {
                            _selectedDate = DateTime.now();
                            isWantInstant = true;
                          } else {
                            _selectedDate = null;
                            // _membershipStatus.status = 'Pending';
                            // if (_scrollController.hasClients) {
                            //   Future.delayed(Duration(milliseconds: 50),
                            //           () {
                            //         _scrollController?.jumpTo(
                            //             _scrollController
                            //                 .position.maxScrollExtent);
                            //       });
                            // }
                            isWantInstant = false;
                          }
                        } else {
                          _isClosingTime = true;
                        }

                        setState(() {});
                      },
                      title: Text(
                        _membershipStatus.status == 'running'
                            ? '${AppLocalizations
                            .of(context)
                            .btn_instant_delivery}'
                            : "${AppLocalizations
                            .of(context)
                            .btn_req_instant_delivery}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .button
                            .copyWith(fontSize: 15),
                      ),
                    ),
                  )
                      : SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Instant delivery not available as store closing time is near.'),
                          ))),
                  !isWantInstant
                      ? Padding(
                    padding:
                    const EdgeInsets.only(top: 24.0, bottom: 8.0),
                    child: Text(
                      "${AppLocalizations
                          .of(context)
                          .txt_preferred_time}",
                      style: subHeadingStyle,
                    ),
                  )
                      : SizedBox(),
                  !isWantInstant
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          _selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now().add(Duration(days: 1)),
                            initialDate: DateTime.now().add(Duration(days: 1)),
                            lastDate:
                            DateTime.now().add(Duration(days: 10)),
                            initialDatePickerMode: DatePickerMode.day,
                            currentDate: DateTime.now().add(Duration(days: 1)),
                            builder:
                                (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData(
                                  primaryColor:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  colorScheme: ColorScheme.light(
                                      primary:
                                      Theme
                                          .of(context)
                                          .primaryColor),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child,
                              );
                            },
                          );
                          if (_selectedDate != null) {
                            await _getTimeSlotList();
                          }
                          setState(() {});
                        },
                        child: DateTimeSelector(
                          key: UniqueKey(),
                          heading:
                          "${AppLocalizations
                              .of(context)
                              .lbl_date} ",
                          selectedDate: _selectedDate,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 80,
                          color: Color(0xffF6F6F6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${AppLocalizations
                                      .of(context)
                                      .txt_time} ',
                                  style: textTheme.caption,
                                ),
                                Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: DropdownButton(
                                      value: _selectedTimeSlot,
                                      isExpanded: false,
                                      isDense: true,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                      underline: SizedBox(),
                                      hint: Text(
                                        '${AppLocalizations
                                            .of(context)
                                            .lbl_select_time_slot} ',
                                        style:
                                        textTheme.bodyText1.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      items: _timeSlotList.map<
                                          DropdownMenuItem<TimeSlot>>(
                                              (TimeSlot timeSlot) {
                                            return DropdownMenuItem<TimeSlot>(
                                              value: timeSlot,
                                              enabled:
                                              timeSlot.availibility ==
                                                  "available"
                                                  ? true
                                                  : false,
                                              child: Text(
                                                timeSlot.timeslot,
                                                style: timeSlot
                                                    .availibility ==
                                                    "available"
                                                    ? textTheme.bodyText1
                                                    .copyWith(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                )
                                                    : textTheme.bodyText1
                                                    .copyWith(
                                                  color:
                                                  Colors.grey[400],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTimeSlot = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppLocalizations
                              .of(context)
                              .txt_items_in_cart} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${global.cartCount}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations
                            .of(context)
                            .lbl_total_amount} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cartController.cartItemsList != null
                            ? "${global.appInfo.currencySign} ${cartController
                            .cartItemsList.totalPrice.toStringAsFixed(2)}"
                            : '${global.appInfo.currencySign} 0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ConfirmationSlider(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 32,
                      height: 60,
                      backgroundColor: Color(0xffFBE8E6),
                      foregroundColor: Theme
                          .of(context)
                          .primaryColor,
                      backgroundShape: BorderRadius.circular(5),
                      foregroundShape: BorderRadius.circular(5),
                      text:
                      "${AppLocalizations
                          .of(context)
                          .txt_swipe_to_order}",
                      onConfirmation: () async {
                        await _makeOrder();
                      })
                ],
              ),
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    if (global.nearStoreModel.storeOpeningTime != null &&
        global.nearStoreModel.storeOpeningTime != '' &&
        global.nearStoreModel.storeClosingTime != null &&
        global.nearStoreModel.storeClosingTime != '') {
      _openingTime = DateFormat('yyyy-MM-dd hh:mm a')
          .parse((global.nearStoreModel.storeOpeningTime).toUpperCase());
      _closingTime = DateFormat('yyyy-MM-dd hh:mm a')
          .parse((global.nearStoreModel.storeClosingTime).toUpperCase());
    }
  }

  _checkMembershipStatus() async {
    try {
      _membershipStatus = await checkMemberShipStatus(_scaffoldKey);
      _membershipStatus.status = 'running';
      // if (_membershipStatus.status == 'running') {} else {
      //   Get.to(() => MemberShipScreen(a: widget.analytics, o: widget.observer));
      // }
    } catch (e) {
      print("Exception - checkout_screen.dart - _checkMembershipStatus():" +
          e.toString());
    }
  }

  _getTimeSlotList() async {
    try {
      showOnlyLoaderDialog();
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getTimeSlot(_selectedDate).then((result) async {
          _selectedTimeSlot = TimeSlot();
          if (result != null) {
            if (result.status == "1") {
              _timeSlotList = result.data;
              _selectedTimeSlot = _timeSlotList[0];
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              _timeSlotList = [];
            }
          }
          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      hideLoader();
    } catch (e) {
      print("Exception - checkout_screen.dart - _getTimeSlotList():" +
          e.toString());
    }
  }

  _makeOrder() async {
    try {
      if (_selectedAddress == null ||
          (_selectedAddress != null && _selectedAddress.addressId == null)) {
        showToast(AppLocalizations
            .of(context)
            .txt_select_deluvery_address);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   backgroundColor: Theme
        //       .of(context)
        //       .primaryColor,
        //   content: Text(
        //     '${AppLocalizations
        //         .of(context)
        //         .txt_select_deluvery_address}',
        //     textAlign: TextAlign.center,
        //   ),
        //   duration: Duration(seconds: 2),
        // ));
      }else{
        if(!isWantInstant){
          if (_selectedDate == null ) {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   backgroundColor: Theme
            //       .of(context)
            //       .primaryColor,
            //   content: Text(
            //     '${AppLocalizations
            //         .of(context)
            //         .txt_select_date}',
            //     textAlign: TextAlign.center,
            //   ),
            //   duration: Duration(seconds: 2),
            // ));
            showToast(AppLocalizations
                .of(context)
                .txt_select_date);
          }
          else if (_selectedTimeSlot.timeslot == null) {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   backgroundColor: Theme
            //       .of(context)
            //       .primaryColor,
            //   content: Text(
            //     '${AppLocalizations
            //         .of(context)
            //         .txt_select_time_slot}',
            //     textAlign: TextAlign.center,
            //   ),
            //   duration: Duration(seconds: 2),
            // ));
            showToast(AppLocalizations
                .of(context)
                .txt_select_time_slot);
          }
          else {
            // print(_selectedTimeSlot.timeslot);
            showOnlyLoaderDialog();
            bool isConnected = await br.checkConnectivity();
            if (isConnected) {
              await apiHelper
                  .makeOrder(
                  selectedDate: _selectedDate,
                  selectedTime: _membershipStatus.status == 'running'
                      ? 'instant'
                      : _selectedTimeSlot.timeslot)
                  .then((result) async {
                if (result != null) {
                  if (result.status == "1") {
                    orderDetails = result.data;
                    hideLoader();
                    Get.to(() =>
                        PaymentGatewayScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 1,
                            totalAmount: orderDetails.remPrice,
                            cartController: cartController,
                            order: orderDetails));
                  } else {
                    hideLoader();
                    showToast(result.message);
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   backgroundColor: Theme
                    //       .of(context)
                    //       .primaryColor,
                    //   content: Text(
                    //     result.message,
                    //     textAlign: TextAlign.center,
                    //   ),
                    //   duration: Duration(seconds: 2),
                    // ));
                  }
                }
              });
            } else {
              showNetworkErrorSnackBar(_scaffoldKey);
            }
          }
        }else{
          showOnlyLoaderDialog();
          bool isConnected = await br.checkConnectivity();
          if (isConnected) {
            await apiHelper
                .makeOrder(
                selectedDate: _selectedDate,
                selectedTime: isWantInstant ? 'instant'
                    : _selectedTimeSlot.timeslot)
                .then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  orderDetails = result.data;
                  hideLoader();
                  Get.to(() =>
                      PaymentGatewayScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          screenId: 1,
                          totalAmount: orderDetails.remPrice,
                          cartController: cartController,
                          order: orderDetails));
                } else {
                  hideLoader();
                  showToast(result.message);
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   backgroundColor: Theme
                  //       .of(context)
                  //       .primaryColor,
                  //   content: Text(
                  //     result.message,
                  //     textAlign: TextAlign.center,
                  //   ),
                  //   duration: Duration(seconds: 2),
                  // ));
                }
              }
            });
          } else {
            showNetworkErrorSnackBar(_scaffoldKey);
          }
        }
      }


    } catch (e) {
      print("Exception - checkout_screen.dart - _makeOrder():" + e.toString());
    }
  }

  _selectAddressForCheckout({int selectedAddressId, Address addressSelected, int index}) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper
            .selectAddressForCheckout(selectedAddressId)
            .then((result) async {
          hideLoader();
          if (result != null) {
            if (result.status == "1") {
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   backgroundColor: Theme
              //       .of(context)
              //       .primaryColor,
              //   content: Text(
              //     result.message,
              //     textAlign: TextAlign.center,
              //   ),
              //   duration: Duration(seconds: 2),
              // ));
              showToast(result.message);
              setState(() {
                _selectedAddress = addressSelected;
                global.userProfileController.addressList[index].isSelected =
                !global.userProfileController
                    .addressList[index].isSelected;
              });
            } else {
              showToast(result.message);
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - checkout_screen.dart - _selectAddressForCheckout():" +
          e.toString());
    }
  }
}
