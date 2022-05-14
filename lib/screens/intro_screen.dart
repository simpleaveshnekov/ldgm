import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/screens/login_screen.dart';

class IntroScreen extends BaseRoute {
  IntroScreen({a, o}) : super(a: a, o: o, r: 'IntroScreen');
  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends BaseRouteState {
  int _currentIndex = 0;
  PageController _pageController;
  _IntroScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: Scaffold(
          body: Stack(children: [
        Container(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _currentIndex = index;
                setState(() {});
              },
              children: [
                Image.asset(
                  'assets/images/intro_1.png',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/images/intro_2.png',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/images/intro_3.png',
                  fit: BoxFit.cover,
                ),
              ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 25),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 15, top: 20),
                  width: 100,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < 3; i++)
                              if (i == _currentIndex) ...[circleBar(true)] else circleBar(false),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width / 3,
          bottom: 15,
          child: Align(
            alignment: Alignment.center,
            child: TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                if (_currentIndex < 2) {
                  _pageController.animateToPage(_currentIndex + 1, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                } else {
                  Get.to(() => LoginScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      ));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _currentIndex < 2 ? 'Next' : 'Get Started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffFF0000),
                      letterSpacing: 2.0,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_rounded,
                    size: 30,
                    color: Color(0xffFF0000),
                  )
                ],
              ),
            ),
          ),
        )
      ])),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 5 : 5,
      width: isActive ? 23 : 10,
      decoration: BoxDecoration(color: isActive ? Color(0xffFF0000) : Color(0xffFF0000).withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: _currentIndex);
    _pageController.addListener(() {});
  }
}
