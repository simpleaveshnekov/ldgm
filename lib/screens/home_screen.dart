import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/app_drawer_wrapper_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/order_history_screen.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/screens/user_profile_screen.dart';
import 'package:user/widgets/my_bottom_navigation_bar.dart';

class HomeScreen extends BaseRoute {
  final int screenId;
  final Function onAppDrawerButtonPressed;
  HomeScreen({a, o, this.onAppDrawerButtonPressed, this.screenId}) : super(a: a, o: o, r: 'HomeScreen');
  @override
  _HomeScreenState createState() => _HomeScreenState(onAppDrawerButtonPressed: onAppDrawerButtonPressed, screenId: screenId);
}

class _HomeScreenState extends BaseRouteState {
  int _currentIndex = 0;
  int screenId;
  Function onAppDrawerButtonPressed;
  final CartController cartController = Get.put(CartController());

  _HomeScreenState({this.onAppDrawerButtonPressed, this.screenId});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _homeScreenItems = [
      AppDrawerWrapperScreen(
        a: widget.analytics,
        o: widget.observer,
      ),
      Container(),
      Container(),
      OrderHistoryScreen(a: widget.analytics, o: widget.observer),
      UserProfileScreen(a: widget.analytics, o: widget.observer),
    ];

    return WillPopScope(
      onWillPop: () {
        exitAppDialog();
        return null;
      },
      child: Scaffold(
        body: _homeScreenItems[_currentIndex],
        bottomNavigationBar: MyBottomNavigationBar(
          onTap: (value) {
            if (value == 1) return Get.to(() => SearchScreen(a: widget.analytics, o: widget.observer));
            if (value == 2) {
              if (global.currentUser.id == null) {
                return Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
              }
            }
            if (value == 3) {
              if (global.currentUser.id == null) {
                return Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
              }
            }

            if (value == 4) {
              if (global.currentUser.id == null) {
                return Get.to(() => LoginScreen(a: widget.analytics, o: widget.observer));
              }
            }
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add_shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              if (global.currentUser.id == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(a: widget.analytics, o: widget.observer),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(a: widget.analytics, o: widget.observer),
                  ),
                );
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('uID ${global.currentUser.id}');
    if (screenId == 1) {
      _currentIndex = 4;
    } else if (screenId == 2) {
      _currentIndex = 3;
    } else {
      _currentIndex = 0;
    }
    global.isNavigate = false;
  }
}
