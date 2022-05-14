import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/constants/image_constants.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/userModel.dart';
import 'package:user/screens/aboutUsAndTermsOfServices.dart';
import 'package:user/screens/all_categories_screen.dart';
import 'package:user/screens/app_setting_screen.dart';
import 'package:user/screens/chat_screen.dart';
import 'package:user/screens/choose_language_screen.dart';
import 'package:user/screens/contact_us_screen.dart';
import 'package:user/screens/coupons_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/membership_screen.dart';
import 'package:user/screens/product_request_screen.dart';
import 'package:user/screens/refer_and_earn_screen.dart';
import 'package:user/screens/reward_screen.dart';
import 'package:user/screens/top_deals_screen.dart';
import 'package:user/screens/wallet_screen.dart';
import 'package:user/screens/wishlist_screen.dart';
import 'package:user/widgets/app_menu_list_tile.dart';
import 'package:user/widgets/swiper_drawer.dart';

class AppMenuScreen extends BaseRoute {
  final Function onBackPressed;
  final GlobalKey<SwiperDrawerState> drawerKey;
  AppMenuScreen({a, o, this.onBackPressed, this.drawerKey}) : super(a: a, o: o, r: 'AppMenuScreen');
  @override
  _AppMenuScreenState createState() => _AppMenuScreenState(onBackPressed: onBackPressed, drawerKey: drawerKey);
}

class UserInfoTile extends StatefulWidget {
  final TextTheme textTheme;
  UserInfoTile({
    @required this.textTheme,
  }) : super();

  @override
  _UserInfoTileState createState() => _UserInfoTileState(textTheme: textTheme);
}

class _AppMenuScreenState extends BaseRouteState {
  Function onBackPressed;
  GlobalKey<SwiperDrawerState> drawerKey;
  _AppMenuScreenState({this.onBackPressed, this.drawerKey});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => onBackPressed()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (global.currentUser.id == null) {
                  Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                } else {
                  drawerKey.currentState.closeDrawer();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 1,
                          )));
                }
              },
              child: UserInfoTile(
                textTheme: textTheme,
              ),
            ),
            Container(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  global.nearStoreModel != null
                      ? AppMenuListTile(
                          label: "${AppLocalizations.of(context).tle_all_category}",
                          leadingIconUrl: ImageConstants.ALL_CATEGORIES_LOGO_URL,
                          onPressed: () => Get.to(() => AllCategoriesScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )),
                        )
                      : SizedBox(),
                  SizedBox(height: 8.0),
                  global.nearStoreModel != null
                      ? AppMenuListTile(
                          label: "${AppLocalizations.of(context).lbl_deal_products}  ",
                          leadingIconUrl: ImageConstants.TOP_DEALS_LOGO_URL,
                          onPressed: () => Get.to(() => TopDealsScreen(a: widget.analytics, o: widget.observer)),
                        )
                      : SizedBox(),
                  SizedBox(height: 8.0),
                  global.nearStoreModel != null
                      ? AppMenuListTile(
                          label: "${AppLocalizations.of(context).lbl_make_product_request}",
                          leadingIconUrl: ImageConstants.PRODUCT_REQUEST_LOGO_URL,
                          onPressed: () {
                            if (global.currentUser.id == null) {
                              Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                            } else {
                              Get.to(() => ProductRequestScreen(a: widget.analytics, o: widget.observer));
                            }
                          })
                      : SizedBox(),
                  SizedBox(height: 8.0),
                  global.nearStoreModel != null
                      ? AppMenuListTile(
                          label: "${AppLocalizations.of(context).btn_wishlist}  ",
                          leadingIconUrl: ImageConstants.TRACK_ORDER_LOGO_URL,
                          onPressed: () {
                            if (global.currentUser.id == null) {
                              Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                            } else {
                              Get.to(() => WishListScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  ));
                            }
                          },
                        )
                      : SizedBox(),
                  SizedBox(height: 8.0),
                  global.nearStoreModel != null
                      ? AppMenuListTile(
                          label: "${AppLocalizations.of(context).lbl_coupons}  ",
                          leadingIconUrl: ImageConstants.COUPONS_LOGO_URL,
                          onPressed: () => Get.to(() => CouponsScreen(a: widget.analytics, o: widget.observer)),
                        )
                      : SizedBox(),
                  // SizedBox(height: 8.0),
                  SizedBox(height: 8.0),
                  // AppMenuListTile(
                  //     label: "${AppLocalizations.of(context).btn_membership}  ",
                  //     icon: Icons.card_membership_sharp,
                  //     onPressed: () {
                  //       if (global.currentUser.id == null) {
                  //         Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                  //       } else {
                  //         Get.to(() => MemberShipScreen(a: widget.analytics, o: widget.observer));
                  //       }
                  //     }),
                  // SizedBox(height: 8.0),
                  AppMenuListTile(
                      label: "${AppLocalizations.of(context).lbl_reward}  ",
                      icon: Icons.wallet_giftcard_sharp,
                      onPressed: () {
                        if (global.currentUser.id == null) {
                          Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                        } else {
                          Get.to(() => RewardScreen(a: widget.analytics, o: widget.observer));
                        }
                      }),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                      label: "${AppLocalizations.of(context).btn_my_wallet}  ",
                      icon: Icons.account_balance_wallet_outlined,
                      onPressed: () {
                        if (global.currentUser.id == null) {
                          Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                        } else {
                          Get.to(() => WalletScreen(a: widget.analytics, o: widget.observer));
                        }
                      }),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                      label: "${AppLocalizations.of(context).btn_refer_earn}  ",
                      icon: MdiIcons.giftOutline,
                      onPressed: () {
                        if (global.currentUser.id == null) {
                          Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                        } else {
                          Get.to(() => ReferAndEarnScreen(a: widget.analytics, o: widget.observer));
                        }
                      }),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                    label: "${AppLocalizations.of(context).btn_app_setting}  ",
                    icon: Icons.settings_outlined,
                    onPressed: () => Get.to(() => SettingScreen(a: widget.analytics, o: widget.observer)),
                  ),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                    label: "${AppLocalizations.of(context).lbl_select_language}  ",
                    icon: Icons.translate_outlined,
                    onPressed: () => Get.to(() => ChooseLanguageScreen(a: widget.analytics, o: widget.observer)),
                  ),
                  SizedBox(height: 8.0),
                  global.nearStoreModel != null && global.nearStoreModel.id != null && global.appInfo.liveChat != null && global.appInfo.liveChat == 1
                      ? AppMenuListTile(
                      label: "${AppLocalizations.of(context).txt_live_chat}  ",
                      leadingIconUrl: ImageConstants.LIVE_CHAT_LOGO_URL,
                      onPressed: () {
                        if (global.currentUser.id == null) {
                          Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                        } else {
                          if (global.nearStoreModel != null) {
                            Get.to(() => ChatScreen(a: widget.analytics, o: widget.observer));
                          }
                        }
                      })
                      : SizedBox(),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                      label: "${AppLocalizations.of(context).tle_contact_us}  ",
                      icon: Icons.contact_page_outlined,
                      onPressed: () {
                        if (global.currentUser.id == null) {
                          Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                        } else {
                          Get.to(() => ContactUsScreen(a: widget.analytics, o: widget.observer));
                        }
                      }),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                      label: "${AppLocalizations.of(context).tle_about_us}  ",
                      icon: Icons.info_outline,
                      onPressed: () {
                        Get.to(() => AboutUsAndTermsOfServiceScreen(true, a: widget.analytics, o: widget.observer));
                      }),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                      label: "${AppLocalizations.of(context).tle_term_of_service}  ",
                      icon: Icons.design_services_outlined,
                      onPressed: () {
                        Get.to(() => AboutUsAndTermsOfServiceScreen(false, a: widget.analytics, o: widget.observer));
                      }),
                  SizedBox(height: 8.0),
                  AppMenuListTile(
                    label: global.currentUser.id == null ? '${AppLocalizations.of(context).btn_signup}  ' : "${AppLocalizations.of(context).btn_logout} ",
                    leadingIconUrl: ImageConstants.LOGOUT_LOGO_URL,
                    onPressed: () {
                      if (global.currentUser.id == null) {
                        Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
                      } else {
                        _signOutDialog();
                      }
                    },
                  ),
                  SizedBox(height: 32)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _signOutDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  '${AppLocalizations.of(context).btn_logout}  ',
                ),
                content: Text(
                  '${AppLocalizations.of(context).txt_logout_app_msg}  ',
                ),
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
                    child: Text('${AppLocalizations.of(context).btn_logout}'),
                    onPressed: () async {
                      global.sp.remove("currentUser");
                      global.currentUser= CurrentUser();
                      Get.offAll(() => LoginScreen(a: widget.analytics, o: widget.observer));
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - app_menu_screen.dart - exitAppDialog(): ' + e.toString());
    }
  }
}

class _UserInfoTileState extends State<UserInfoTile> {
  TextTheme textTheme;
  _UserInfoTileState({this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        global.currentUser.id != null
            ? global.currentUser.userImage != null
                ? CachedNetworkImage(
                    imageUrl: global.appInfo.imageUrl + global.currentUser.userImage,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 25,
                      backgroundImage: imageProvider,
                      backgroundColor: Colors.white,
                    ),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        )),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
            : CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
        SizedBox(width: 16),
        global.currentUser.id != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    global.currentUser.name,
                    style: textTheme.subtitle1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    global.currentUser.userPhone,
                    style: textTheme.subtitle1.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text('${AppLocalizations.of(context).txt_Login_SignUp}',
                style: textTheme.subtitle1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
      ],
    );
  }
}
