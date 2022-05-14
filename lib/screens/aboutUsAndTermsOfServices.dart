import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/models/aboutUsModel.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/termsOfServicesModel.dart';

class AboutUsAndTermsOfServiceScreen extends BaseRoute {
  final bool isAboutUs;
  AboutUsAndTermsOfServiceScreen(this.isAboutUs, {a, o}) : super(a: a, o: o, r: 'AboutUsAndTermsOfServiceScreen');
  @override
  _AboutUsAndTermsOfServiceScreenState createState() => new _AboutUsAndTermsOfServiceScreenState(this.isAboutUs);
}

class _AboutUsAndTermsOfServiceScreenState extends BaseRouteState {
  bool _isDataLoaded = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  final bool isAboutUs;
  String text;
  AboutUs _aboutUs = new AboutUs();
  TermsOfService _termsOfService = new TermsOfService();
  _AboutUsAndTermsOfServiceScreenState(this.isAboutUs) : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            isAboutUs ? '${AppLocalizations.of(context).tle_about_us}' : '${AppLocalizations.of(context).tle_term_of_service}',
            style: textTheme.headline6,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.keyboard_arrow_left)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isDataLoaded
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height - 120,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Html(
                      data: "$text",
                      style: {
                        "body": Style(color: Theme.of(context).textTheme.bodyText1.color),
                      },
                    ),
                  ),
                )
              : _shimmerList(),
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
    _init();
  }

  _init() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (isAboutUs) {
          await apiHelper.appAboutUs().then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _aboutUs = result.data;
                text = _aboutUs.description;
              }
            }
          });
        } else {
          await apiHelper.appTermsOfService().then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _termsOfService = result.data;
                text = _termsOfService.description;
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - aboutUsAndTermsOfServiceScreen.dart - _init():" + e.toString());
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
      print("Exception - aboutUsAndTermsOfServiceScreen.dart - _shimmerList():" + e.toString());
      return SizedBox();
    }
  }
}
