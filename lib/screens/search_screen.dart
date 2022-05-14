import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/recentSearchModel.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/search_results_screen.dart';
import 'package:user/utils/navigation_utils.dart';
import 'package:user/widgets/chip_menu.dart';
import 'package:user/widgets/my_text_box.dart';

class SearchScreen extends BaseRoute {
  SearchScreen({a, o}) : super(a: a, o: o, r: 'SearchScreen');

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class SearchScreenHeader extends StatefulWidget {
  final TextTheme textTheme;
  final dynamic analytics;
  final dynamic observer;
  SearchScreenHeader({@required this.textTheme, this.analytics, this.observer}) : super();

  @override
  _SearchScreenHeaderState createState() => _SearchScreenHeaderState(textTheme: textTheme, analytics: analytics, observer: observer);
}

class _SearchScreenHeaderState extends State<SearchScreenHeader> {
  TextTheme textTheme;
  dynamic analytics;
  dynamic observer;
  TextEditingController _cSearch = new TextEditingController();
  _SearchScreenHeaderState({this.textTheme, this.analytics, this.observer});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyTextBox(
            key: Key('30'),
            autofocus: false,
            controller: _cSearch,
            suffixIcon: Icon(
              Icons.cancel,
              color: Theme.of(context).primaryColor,
            ),
            prefixIcon: Icon(
              Icons.search_outlined,
              color: Colors.grey[800],
            ),
            hintText: "${AppLocalizations.of(context).hnt_search_product}",
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {},
            onEditingComplete: () {
              Navigator.of(context).push(NavigationUtils.createAnimatedRoute(
                  1.0,
                  SearchResultsScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    searchParams: _cSearch.text.trim(),
                  )));
            }),
        SizedBox(width: 16),
        TextButton(
          onPressed: () => Get.to(() => HomeScreen(
                a: widget.analytics,
                o: widget.observer,
              )),
          child: Text(
            "${AppLocalizations.of(context).lbl_cancel}",
            style: textTheme.bodyText1.copyWith(
              color: Colors.grey[800],
            ),
          ),
        )
      ],
    );
  }
}

class _SearchScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  List<RecentSearch> _recentSearchList = [];
  List<Product> _trendingSearchProducts = [];
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        return Get.to(() => HomeScreen(
              a: widget.analytics,
              o: widget.observer,
            ));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: global.nearStoreModel != null
            ? null
            : AppBar(
                title: Text(
                  '${AppLocalizations.of(context).hnt_search_product}',
                  style: textTheme.headline6,
                ),
              ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: global.nearStoreModel != null
                ? RefreshIndicator(
                    onRefresh: () async {
                      await _onRefresh();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                              bottom: 32,
                            ),
                            child: SearchScreenHeader(
                              textTheme: textTheme,
                              analytics: widget.analytics,
                              observer: widget.observer,
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context).lbl_trending_products}",
                            style: textTheme.headline6,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: _isDataLoaded
                                ? _trendingSearchProducts != null && _trendingSearchProducts.length > 0
                                    ? ChipMenu(
                                        analytics: widget.analytics,
                                        observer: widget.observer,
                                        trendingSearchProductList: _trendingSearchProducts,
                                        onChanged: (value) {},
                                      )
                                    : Text('${AppLocalizations.of(context).txt_nothing_to_show}')
                                : _shimmer1(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "${AppLocalizations.of(context).lbl_recent_search}",
                              style: textTheme.headline6,
                            ),
                          ),
                          _isDataLoaded
                              ? _recentSearchList != null && _recentSearchList.length > 0
                                  ? ListView.builder(
                                      itemCount: _recentSearchList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(NavigationUtils.createAnimatedRoute(
                                              1.0,
                                              SearchResultsScreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                                searchParams: _recentSearchList[index].keyword,
                                              )));
                                        },
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.history_outlined,
                                          ),
                                          title: Text(
                                            _recentSearchList[index].keyword,
                                            style: textTheme.bodyText1,
                                          ),
                                          trailing: Icon(
                                            Icons.chevron_right,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text('${AppLocalizations.of(context).txt_nothing_to_show}')
                              : _shimmer2()
                        ],
                      ),
                    ),
                  )
                : Center(child: Text(global.locationMessage)),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (global.nearStoreModel != null) {
      _init();
    }
  }

  _getRecentSearchData() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.showRecentSearch().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _recentSearchList = result.data;
            } else {
              _recentSearchList = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - search_screen.dart - _getRecentSearchData():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getRecentSearchData();
      await _showTrendingSearchProducts();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - search_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - search_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer1() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Column(
          children: [
            SizedBox(
                height: 43,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ))
                  ],
                )),
            SizedBox(
                height: 43,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ))
                  ],
                )),
          ],
        ));
  }

  _shimmer2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(height: 60, width: MediaQuery.of(context).size.width, child: Card());
              })),
    );
  }

  _showTrendingSearchProducts() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.showTrendingSearchProducts().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _trendingSearchProducts = result.data;
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              _trendingSearchProducts = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - search_screen.dart - _getRecentSearchData():" + e.toString());
    }
  }
}
