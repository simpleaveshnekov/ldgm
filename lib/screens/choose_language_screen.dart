import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:user/l10n/l10n.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/provider/local_provider.dart';

class ChooseLanguageScreen extends BaseRoute {
  ChooseLanguageScreen({a, o}) : super(a: a, o: o, r: 'ChooseLanguageScreen');
  @override
  _ChooseLanguageScreenState createState() => new _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends BaseRouteState {
  bool isFavourite = false;
  _ChooseLanguageScreenState() : super();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LocaleProvider>(context);
    var locale = provider.locale ?? Locale('en');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${AppLocalizations.of(context).tle_languages}",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.keyboard_arrow_left),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  '${global.defaultImage}',
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: Text(
                  "${AppLocalizations.of(context).lbl_select_language}",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: L10n.languageListName.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          value: L10n.all[index].languageCode,
                          groupValue: global.languageCode,
                          onChanged: (val) {
                            global.languageCode = val;
                            final provider = Provider.of<LocaleProvider>(context, listen: false);
                            locale = Locale(L10n.all[index].languageCode);
                            provider.setLocale(locale);
                            global.languageCode = locale.languageCode;
                            if (global.rtlLanguageCodeLList.contains(locale.languageCode)) {
                              global.isRTL = true;
                            } else {
                              global.isRTL = false;
                            }
                            setState(() {});
                            Get.updateLocale(locale);
                          },
                          title: Text(
                            L10n.languageListName[index],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        index != L10n.languageListName.length - 1
                            ? Divider(
                                color: Color(0xFFDFE8EF),
                              )
                            : SizedBox(),
                      ],
                    );
                  },
                ),
              )
            ],
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
  }
}
