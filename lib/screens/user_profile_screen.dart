import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/controllers/user_profile_controller.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/userModel.dart';
import 'package:user/screens/add_address_screen.dart';
import 'package:user/screens/addressListScreen.dart';
import 'package:user/screens/change_password_screen.dart';
import 'package:user/screens/profile_edit_screen.dart';
import 'package:user/widgets/profile_picture.dart';

class UserInfoTile extends StatefulWidget {
  final String value;
  final Widget leadingIcon;
  final String heading;
  final Function onPressed;
  final key;

  UserInfoTile(
      {@required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key})
      : super();

  @override
  _UserInfoTileState createState() => _UserInfoTileState(
      heading: heading,
      value: value,
      leadingIcon: leadingIcon,
      onPressed: onPressed,
      key: key);
}

class UserOrdersDashboardBox extends StatefulWidget {
  final String heading;
  final String value;

  UserOrdersDashboardBox({@required this.heading, this.value}) : super();

  @override
  _UserOrdersDashboardBoxState createState() =>
      _UserOrdersDashboardBoxState(heading: heading, value: value);
}

class UserProfileScreen extends BaseRoute {
  UserProfileScreen({a, o}) : super(a: a, o: o, r: 'UserProfileScreen');

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserInfoTileState extends State<UserInfoTile> {
  String value;
  Widget leadingIcon;
  String heading;
  Function onPressed;
  var key;

  _UserInfoTileState(
      {@required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      key: key,
      onTap: () => onPressed(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  leadingIcon ?? Container(),
                  leadingIcon == null ? Container() : SizedBox(width: 8),
                  Text(
                    heading,
                    style: textTheme.bodyText1.copyWith(
                        fontWeight:
                            value == null ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              value == null
                  ? Container()
                  : Text(
                      value,
                      style: textTheme.bodyText1
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
              value == null ? Container() : SizedBox(height: 8),
              Divider(
                thickness: 2.0,
              ),
            ],
          ),
          onPressed == null
              ? Container()
              : Positioned(
                  bottom: 24,
                  right: global.isRTL ? null : 0,
                  left: global.isRTL ? 0 : null,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
        ],
      ),
    );
  }
}

class _UserOrdersDashboardBoxState extends State<UserOrdersDashboardBox> {
  String value;
  Widget leadingIcon;
  String heading;
  Function onPressed;

  _UserOrdersDashboardBoxState({@required this.heading, this.value});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          heading,
          style: textTheme.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: textTheme.subtitle1,
        )
      ],
    );
  }
}

class _UserProfileScreenState extends BaseRouteState {
  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            "${AppLocalizations.of(context).txt_user_profile}",
            style: textTheme.headline6,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => ProfileEditScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      ));
                },
                icon: Icon(Icons.edit))
          ],
        ),
        body: _isDataLoaded
            ? GetBuilder<UserProfileController>(
                init: global.userProfileController,
                builder: (value) => RefreshIndicator(
                      onRefresh: () async {
                        _isDataLoaded = false;
                        global.userProfileController.currentUser =
                            new CurrentUser();
                        setState(() {});
                        await _getMyProfile();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                  child: ProfilePicture(
                                    isShow: false,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  global.userProfileController.currentUser
                                                  .name !=
                                              null &&
                                          global.userProfileController
                                                  .currentUser.name !=
                                              ''
                                      ? global.userProfileController.currentUser
                                          .name
                                      : 'User',
                                  style: textTheme.headline6,
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 32.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       UserOrdersDashboardBox(
                              //         heading: "${AppLocalizations.of(context).lbl_order}",
                              //         value: global.userProfileController.currentUser.totalOrders.toString(),
                              //       ),
                              //       UserOrdersDashboardBox(
                              //         value: '${global.appInfo.currencySign} ${global.userProfileController.currentUser.totalSaved}',
                              //         heading: "${AppLocalizations.of(context).lbl_saved}",
                              //       ),
                              //       UserOrdersDashboardBox(
                              //         value: '${global.appInfo.currencySign} ${global.userProfileController.currentUser.totalSpend}',
                              //         heading: "${AppLocalizations.of(context).lbl_spent}",
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              UserInfoTile(
                                  heading:
                                      "${AppLocalizations.of(context).lbl_phone_number}",
                                  value: global.userProfileController
                                      .currentUser.userPhone),
                              SizedBox(height: 8),
                              UserInfoTile(
                                key: UniqueKey(),
                                heading:
                                    "${AppLocalizations.of(context).txt_address}",
                                onPressed: () {
                                  global.userProfileController.addressList !=
                                              null &&
                                          global.userProfileController
                                                  .addressList.length >
                                              0
                                      ? Get.to(() => AddressListScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                          )).then((value) {
                                          setState(() {});
                                        })
                                      : Get.to(() => AddAddressScreen(
                                            new Address(),
                                            a: widget.analytics,
                                            o: widget.observer,
                                          )).then((value) {
                                          setState(() {});
                                        });
                                },
                                value: global.userProfileController
                                                .addressList !=
                                            null &&
                                        global.userProfileController.addressList
                                                .length >
                                            0
                                    ? global.userProfileController
                                        .addressList[0].houseNo
                                    : '${AppLocalizations.of(context).txt_nothing_to_show}',
                              ),
                              SizedBox(height: 8),
                              UserInfoTile(
                                heading:
                                    "${AppLocalizations.of(context).lbl_email}",
                                value: global
                                    .userProfileController.currentUser.email,
                              ),
                              SizedBox(height: 16),
                              UserInfoTile(
                                heading:
                                    "${AppLocalizations.of(context).lbl_reset_password}",
                                onPressed: () {
                                  Get.to(() => ChangePasswordScreen(
                                        a: widget.analytics,
                                        o: widget.observer,
                                      ));
                                },
                                leadingIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ))
            : _shimmer());
  }

  @override
  void initState() {
    super.initState();
    if (global.currentUser.id != null) {
      _getMyProfile();
    }
  }

  _getMyProfile() async {
    try {
      await global.userProfileController.getMyProfile();

      if (global.userProfileController.isDataLoaded.value == true) {
        _isDataLoaded = true;
      } else {
        _isDataLoaded = false;
      }
      setState(() {});
    } catch (e) {
      print("Exception - UserProfileScreen.dart - _getMyProfile():" +
          e.toString());
    }
  }

  _shimmer() {
    try {
      return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: Card(),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 60,
                        child: Card()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 80,
                          width: (MediaQuery.of(context).size.width - 30) / 3,
                          child: Card()),
                      SizedBox(
                          height: 80,
                          width: (MediaQuery.of(context).size.width - 30) / 3,
                          child: Card()),
                      SizedBox(
                          height: 80,
                          width: (MediaQuery.of(context).size.width - 30) / 3,
                          child: Card()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
              ],
            ),
          ));
    } catch (e) {
      print("Exception - UserProfileScreen.dart - _shimmer():" + e.toString());
    }
  }
}
