import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/homeScreenDataModel.dart';
import 'package:user/screens/all_categories_screen.dart';
import 'package:user/screens/chat_screen.dart';
import 'package:user/screens/location_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/notification_screen.dart';
import 'package:user/screens/product_description_screen.dart';
import 'package:user/screens/product_request_screen.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/screens/sub_categories_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/bundle_offers_menu.dart';
import 'package:user/widgets/dashboard_screen_heading.dart';
import 'package:user/widgets/products_menu.dart';
import 'package:user/widgets/select_category_card.dart';
// import 'package:marquee_widget/marquee_widget.dart' as m;

class DashboardScreen extends BaseRoute {
  final Function onAppDrawerButtonPressed;

  DashboardScreen({a, o, this.onAppDrawerButtonPressed})
      : super(a: a, o: o, r: 'DashboardScreen');

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState(onAppDrawerButtonPressed: onAppDrawerButtonPressed);
}

class _DashboardScreenState extends BaseRouteState {
  Function onAppDrawerButtonPressed;
  HomeScreenData _homeScreenData;
  bool _isDataLoaded = false;
  int _selectedIndex = 0;
  int _currentIndex = 0;
  int _secondBannercurrentIndex = 0;
  CarouselController _carouselController;
  CarouselController _secondCarouselController;
  IconData lastTapped = Icons.notifications;
  AnimationController menuAnimation;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

  _DashboardScreenState({this.onAppDrawerButtonPressed});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: global.nearStoreModel != null &&
                global.nearStoreModel.id != null &&
                global.currentUser != null &&
                global.currentUser.id != null
            ? SpeedDial(
                icon: Icons.menu,
                activeIcon: Icons.close,
                spacing: 3,
                overlayOpacity: 0.8,
                childPadding: const EdgeInsets.all(5),
                spaceBetweenChildren: 4,
                direction: SpeedDialDirection.up,
                closeManually: false,
                elevation: 8.0,
                isOpenOnStart: false,
                animationSpeed: 200,
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.share),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      onTap: () {
                        br.inviteFriendShareMessage(callId: 0);
                      }),
                  SpeedDialChild(
                      child: const Icon(Icons.call),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      onTap: () {
                        callNumberStore(global.nearStoreModel.phoneNumber);
                      }),
                  SpeedDialChild(
                      child: const Icon(MdiIcons.chatOutline),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      onTap: () {
                        if (global.currentUser.id == null) {
                          Get.to(() => LoginScreen(
                              a: widget.analytics, o: widget.observer));
                        } else {
                          if (global.nearStoreModel != null) {
                            Get.to(() => ChatScreen(
                                a: widget.analytics, o: widget.observer));
                          }
                        }
                      }),
                  SpeedDialChild(
                      child: const Icon(MdiIcons.clipboardTextOutline),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      visible: true,
                      onTap: () {
                        if (global.currentUser.id == null) {
                          Get.to(() => LoginScreen(
                              a: widget.analytics, o: widget.observer));
                        } else {
                          Get.to(() => ProductRequestScreen(
                              a: widget.analytics, o: widget.observer));
                        }
                      }),
                ],
              )
            : SizedBox(),
        appBar: AppBar(
          leadingWidth: 46,
          leading: IconButton(
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            icon: Icon(Icons.dashboard_outlined),
            onPressed: () => onAppDrawerButtonPressed(),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              global.currentLocation != null
                  ? Text(
                      "${AppLocalizations.of(context).txt_deliver}",
                      style: boldCaptionStyle(context),
                    )
                  : SizedBox(),
              GestureDetector(
                onTap: () async {
                  if (global.lat != null && global.lng != null) {
                    Get.to(() => LocationScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        ));
                  } else {
                    await getCurrentPosition().then((_) async {
                      if (global.lat != null && global.lng != null) {
                        Get.to(() => LocationScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            ));
                      }
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 135,
                      child: Text(
                        global.currentLocation != null
                            ? global.currentLocation
                            : '${AppLocalizations.of(context).txt_deliver} No Location',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: textTheme.bodyText1,
                      ),
                    ),
                    Transform.rotate(
                      angle: pi / 2,
                      child: Icon(
                        Icons.chevron_right,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await openBarcodeScanner(_scaffoldKey);
                },
                visualDensity: VisualDensity(horizontal: -4),
                icon: Icon(
                  MdiIcons.barcode,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
              visualDensity: VisualDensity(horizontal: -4),
              icon: Icon(Icons.search_outlined),
              onPressed: () => Get.to(() => SearchScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )),
            ),
            global.currentUser.id != null
                ? IconButton(
                    visualDensity: VisualDensity(horizontal: -4),
                    icon: Icon(Icons.notifications_none),
                    onPressed: () => Get.to(() => NotificationScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )),
                  )
                : SizedBox()
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _onRefresh();
          },
          child: global.nearStoreModel != null &&
                  global.nearStoreModel.id != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      global.appNotice != null &&
                              global.appNotice.status == 1 &&
                              global.appNotice.notice != null &&
                              global.appNotice.notice.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 23,
                              color: Theme.of(context).primaryColor,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: global.languageCode == 'en'
                                    ? Marquee(
                                        key: Key('1'),
                                        textDirection: TextDirection.ltr,
                                        text: '${global.appNotice.notice}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal),
                                      )
                                    : Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Marquee(
                                          key: Key('2'),
                                          text: '${global.appNotice.notice},',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                      ),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16,
                        ),
                        child: DashboardScreenHeading(),
                      ),
                      _isDataLoaded && _homeScreenData != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: _homeScreenData.banner != null &&
                                      _homeScreenData.banner != [] &&
                                      _homeScreenData.banner.length > 0
                                  ? CarouselSlider(
                                      items: _bannerItems(),
                                      carouselController: _carouselController,
                                      options: CarouselOptions(
                                          viewportFraction: 0.95,
                                          initialPage: _currentIndex,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, _) {
                                            _currentIndex = index;
                                            setState(() {});
                                          }))
                                  : SizedBox.shrink(),
                              // Text('${AppLocalizations.of(context).txt_nothing_to_show}'),
                            )
                          : _bannerShimmer(),
                      _isDataLoaded && _homeScreenData != null
                          ? _homeScreenData.banner != null &&
                                  _homeScreenData.banner != [] &&
                                  _homeScreenData.banner.length > 0
                              ? Center(
                                  child: DotsIndicator(
                                    dotsCount: _homeScreenData.banner.length > 0
                                        ? _homeScreenData.banner.length
                                        : 1,
                                    position: _currentIndex.toDouble(),
                                    onTap: (i) {
                                      _currentIndex = i.toInt();
                                      _carouselController.animateToPage(
                                          _currentIndex,
                                          duration: Duration(microseconds: 1),
                                          curve: Curves.easeInOut);
                                    },
                                    decorator: DotsDecorator(
                                      activeSize: const Size(6, 6),
                                      size: const Size(6, 6),
                                      activeShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50.0),
                                        ),
                                      ),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : SizedBox()
                          : SizedBox(),
                      _isDataLoaded && _homeScreenData != null && _homeScreenData.topCat.length>0?Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppLocalizations.of(context).tle_category}",
                              style: textTheme.headline6,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => AllCategoriesScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    ));
                              },
                              child: Text(
                                "${AppLocalizations.of(context).btn_view_all} ",
                                style: textTheme.caption.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ):SizedBox.shrink(),
                      _isDataLoaded && _homeScreenData != null && _homeScreenData.topCat.length>0
                          ? Container(
                              height: 120,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _homeScreenData.topCat.length,
                                  itemBuilder: (context, index) {
                                    return SelectCategoryCard(
                                      key: UniqueKey(),
                                      category: _homeScreenData.topCat[index],
                                      onPressed: () {
                                        setState(() {
                                          _homeScreenData.topCat
                                              .map((e) => e.isSelected = false)
                                              .toList();
                                          _selectedIndex = index;
                                          if (_selectedIndex == index) {
                                            _homeScreenData.topCat[index]
                                                .isSelected = true;
                                          }
                                        });
                                        Get.to(() => SubCategoriesScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                              screenHeading: _homeScreenData
                                                  .topCat[index].title,
                                              categoryId: _homeScreenData
                                                  .topCat[index].catId,
                                            ));
                                      },
                                      isSelected: _homeScreenData
                                          .topCat[index].isSelected,
                                    );
                                  }),
                            )
                          : _shimmer1(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: _isDataLoaded && _homeScreenData != null && _homeScreenData.dealproduct != null && _homeScreenData.dealproduct.length > 0
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppLocalizations.of(context).tle_bundle_offers}",
                              style: textTheme.headline6,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ProductListScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  screenId: 1,
                                  categoryName: '${AppLocalizations.of(context).tle_bundle_offers} ${AppLocalizations.of(context).tle_products}',
                                ));
                              },
                              child: Text(
                                "${AppLocalizations.of(context).btn_view_all} ",
                                style: textTheme.caption.copyWith(color: Theme.of(context).primaryColor, fontSize: 14),
                              ),
                            ),
                          ],
                        )
                            : SizedBox(),
                      ),
                      _isDataLoaded && _homeScreenData != null
                          ? _homeScreenData.dealproduct != null && _homeScreenData.dealproduct.length > 0
                          ? BundleOffersMenu(
                        analytics: widget.analytics,
                        observer: widget.observer,
                        categoryProductList: _homeScreenData.dealproduct,
                      )
                          : SizedBox()
                          : _shimmer2(),
                      _isDataLoaded &&
                              _homeScreenData != null &&
                              _homeScreenData.catProdList != null &&
                              _homeScreenData.catProdList.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _homeScreenData.catProdList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16.0,
                                        bottom: 8,
                                        left: 16,
                                        right: 16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${_homeScreenData.catProdList[index].cat_title}",
                                                style: textTheme.headline6,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => ProductListScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    screenId: 0,
                                                    categoryName: _homeScreenData.catProdList[index].cat_title,
                                                    categoryId: _homeScreenData.catProdList[index].cat_id,
                                                  ));
                                                },
                                                child: Text(
                                                  "${AppLocalizations.of(context).btn_view_all} ",
                                                  style: textTheme.caption.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              "${_homeScreenData.catProdList[index].description}",
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              style: normalCaptionStyle(context).copyWith(fontSize: 11,color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _isDataLoaded && _homeScreenData != null
                                        ? _homeScreenData.catProdList[index]
                                                        .products !=
                                                    null &&
                                                _homeScreenData
                                                        .catProdList[index]
                                                        .products
                                                        .length >
                                                    0
                                            ? BundleOffersMenu(
                                                analytics: widget.analytics,
                                                observer: widget.observer,
                                                categoryProductList:
                                                    _homeScreenData
                                                        .catProdList[index]
                                                        .products,
                                              )
                                            : SizedBox()
                                        : _shimmer2(),
                                  ],
                                );
                              })
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: _isDataLoaded &&
                                _homeScreenData != null &&
                                _homeScreenData.whatsnewProductList != null &&
                                _homeScreenData.whatsnewProductList.length > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context).lbl_whats_new}",
                                    style: textTheme.headline6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ProductListScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            screenId: 3,
                                            categoryName:
                                                '${AppLocalizations.of(context).lbl_whats_new} ${AppLocalizations.of(context).tle_products}',
                                          ));
                                    },
                                    child: Text(
                                      "${AppLocalizations.of(context).btn_view_all} ",
                                      style: textTheme.caption.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                      _isDataLoaded && _homeScreenData != null
                          ? _homeScreenData.whatsnewProductList != null &&
                                  _homeScreenData.whatsnewProductList.length > 0
                              ? BundleOffersMenu(
                                  analytics: widget.analytics,
                                  observer: widget.observer,
                                  categoryProductList:
                                      _homeScreenData.whatsnewProductList,
                                )
                              : SizedBox()
                          : _shimmer2(),
                      _isDataLoaded && _homeScreenData != null
                          ? Container(
                              margin: EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: _homeScreenData.secondBanner != null &&
                                      _homeScreenData.secondBanner != [] &&
                                      _homeScreenData.secondBanner.length > 0
                                  ? CarouselSlider(
                                      items: _secondBannerItems(),
                                      carouselController:
                                          _secondCarouselController,
                                      options: CarouselOptions(
                                          viewportFraction: 0.95,
                                          initialPage:
                                              _secondBannercurrentIndex,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, _) {
                                            _secondBannercurrentIndex = index;
                                            setState(() {});
                                          }))
                                  : Text(
                                      '${AppLocalizations.of(context).txt_nothing_to_show}'),
                            )
                          : _bannerShimmer(),
                      _isDataLoaded && _homeScreenData != null
                          ? _homeScreenData.secondBanner != null &&
                                  _homeScreenData.secondBanner != [] &&
                                  _homeScreenData.secondBanner.length > 0
                              ? Center(
                                  child: DotsIndicator(
                                    dotsCount:
                                        _homeScreenData.secondBanner.length > 0
                                            ? _homeScreenData
                                                .secondBanner.length
                                            : 1,
                                    position:
                                        _secondBannercurrentIndex.toDouble(),
                                    onTap: (i) {
                                      _secondBannercurrentIndex = i.toInt();
                                      _secondCarouselController.animateToPage(
                                          _secondBannercurrentIndex,
                                          duration: Duration(microseconds: 1),
                                          curve: Curves.easeInOut);
                                    },
                                    decorator: DotsDecorator(
                                      activeSize: const Size(6, 6),
                                      size: const Size(6, 6),
                                      activeShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50.0),
                                        ),
                                      ),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : SizedBox()
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: _isDataLoaded &&
                                _homeScreenData != null &&
                                _homeScreenData.spotLightProductList != null &&
                                _homeScreenData.spotLightProductList.length > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context).lbl_in_spotlight} ${AppLocalizations.of(context).tle_products}",
                                    style: textTheme.headline6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ProductListScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            screenId: 4,
                                            categoryName:
                                                '${AppLocalizations.of(context).lbl_in_spotlight} ${AppLocalizations.of(context).tle_products}',
                                          ));
                                    },
                                    child: Text(
                                      "${AppLocalizations.of(context).btn_view_all} ",
                                      style: textTheme.caption.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                      _isDataLoaded && _homeScreenData != null
                          ? _homeScreenData.spotLightProductList != null &&
                                  _homeScreenData.spotLightProductList.length >
                                      0
                              ? BundleOffersMenu(
                                  analytics: widget.analytics,
                                  observer: widget.observer,
                                  categoryProductList:
                                      _homeScreenData.spotLightProductList,
                                )
                              : SizedBox()
                          : _shimmer2(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: _isDataLoaded &&
                                _homeScreenData != null &&
                                _homeScreenData.recentSellingProductList !=
                                    null &&
                                _homeScreenData
                                        .recentSellingProductList.length >
                                    0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context).lbl_recent_selling} ${AppLocalizations.of(context).tle_products}",
                                    style: textTheme.headline6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ProductListScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            screenId: 5,
                                            categoryName:
                                                '${AppLocalizations.of(context).lbl_recent_selling} ${AppLocalizations.of(context).tle_products}',
                                          ));
                                    },
                                    child: Text(
                                      "${AppLocalizations.of(context).btn_view_all} ",
                                      style: textTheme.caption.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                      _isDataLoaded && _homeScreenData != null
                          ? _homeScreenData.recentSellingProductList != null &&
                                  _homeScreenData
                                          .recentSellingProductList.length >
                                      0
                              ? BundleOffersMenu(
                                  analytics: widget.analytics,
                                  observer: widget.observer,
                                  categoryProductList:
                                      _homeScreenData.recentSellingProductList,
                                )
                              : SizedBox()
                          : _shimmer2(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: _isDataLoaded &&
                                _homeScreenData != null &&
                                _homeScreenData.topselling != null &&
                                _homeScreenData.topselling.length > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context).tle_popular_products}",
                                    style: textTheme.headline6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ProductListScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            categoryName:
                                                '${AppLocalizations.of(context).tle_popular_products}',
                                          ));
                                    },
                                    child: Text(
                                      "${AppLocalizations.of(context).btn_view_all} ",
                                      style: textTheme.caption.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                      _isDataLoaded && _homeScreenData != null
                          ? _homeScreenData.topselling != null &&
                                  _homeScreenData.topselling.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: ProductsMenu(
                                    analytics: widget.analytics,
                                    observer: widget.observer,
                                    categoryProductList:
                                        _homeScreenData.topselling,
                                  ),
                                )
                              : SizedBox()
                          : _shimmer3(),
                    ],
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(global.locationMessage),
                  ),
                ),
        ));
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _init();
  }

  List<Widget> _bannerItems() {
    List<Widget> list = [];
    for (int i = 0; i < _homeScreenData.banner.length; i++) {
      list.add(InkWell(
        onTap: () {
          Get.to(() => ProductListScreen(
                a: widget.analytics,
                o: widget.observer,
                categoryId: _homeScreenData.banner[i].catId,
                screenId: 0,
                categoryName: _homeScreenData.banner[i].title,
              ));
        },
        child: CachedNetworkImage(
          imageUrl:
              global.appInfo.imageUrl + _homeScreenData.banner[i].bannerImage,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage('assets/images/icon.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  Widget _bannerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Card(),
          ),
        ],
      ),
    );
  }

  _getHomeScreenData() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getHomeScreenData().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _homeScreenData = result.data;
            } else {
              _homeScreenData = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - dashboard_screen.dart - _getHomeScreenData():" +
          e.toString());
    }
  }

  _init() async {
    try {
      if (global.lat == null && global.lng == null) {
        await getCurrentPosition().then((value) {
          if (global.lat == null && global.lng == null) {
            _init();
          }
        });
      } else {
        if (global.nearStoreModel != null && global.nearStoreModel.id != null) {
          await _getHomeScreenData();
          _isDataLoaded = true;
        } else {
          await getNearByStore().then((value) async {
            if (global.nearStoreModel != null &&
                global.nearStoreModel.id != null) {
              await _getHomeScreenData();
              _isDataLoaded = true;
            }
          });
        }
      }
      if (global.currentUser.id != null) {
        cartController.getCartList();
      }
      setState(() {});
    } catch (e) {
      print("Exception - dashboard_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - dashboard_screen.dart - _onRefresh():" + e.toString());
    }
  }

  List<Widget> _secondBannerItems() {
    List<Widget> list = [];
    for (int i = 0; i < _homeScreenData.secondBanner.length; i++) {
      list.add(InkWell(
        onTap: () {
          Get.to(() => ProductDescriptionScreen(
                a: widget.analytics,
                o: widget.observer,
                productId: _homeScreenData.secondBanner[i].varientId,
                screenId: 0,
              ));
        },
        child: CachedNetworkImage(
          imageUrl: global.appInfo.imageUrl +
              _homeScreenData.secondBanner[i].bannerImage,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage('assets/images/icon.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  _shimmer1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: SizedBox(
          height: 130,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: SizedBox(width: 90, child: Card()),
                );
              }),
        ),
      ),
    );
  }

  _shimmer2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 264 / 796 - 20,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 220 / 411,
                        child: Card()),
                  );
                }),
          )),
    );
  }

  _shimmer3() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
                    width: MediaQuery.of(context).size.width,
                    child: Card());
              })),
    );
  }

  void callNumberStore(store_number) async {
    await launch('tel:$store_number');
  }
}
