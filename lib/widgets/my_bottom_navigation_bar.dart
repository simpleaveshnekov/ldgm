import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final Function(int) onTap;

  MyBottomNavigationBar({this.onTap}) : super();

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState(onTap: onTap);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  Function(int) onTap;
  int _currentIndex = 0;
  _MyBottomNavigationBarState({this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (value) {
        setState(() {
          if (value != 2 && value != 1) {
            _currentIndex = value;
          }
          onTap(value);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "${AppLocalizations.of(context).txt_home}",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: "${AppLocalizations.of(context).txt_search}",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search_outlined,
            color: Colors.white,
          ),
          label: "${AppLocalizations.of(context).txt_cart}",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          label: "${AppLocalizations.of(context).tle_order}",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "${AppLocalizations.of(context).txt_profile}")
      ],
    );
  }
}
