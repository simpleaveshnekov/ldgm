library drawer_swipe;

import 'package:flutter/material.dart';

class SwiperDrawer extends StatefulWidget {
  // Drawer background color
  final Color backgroundColor;

  // screen body
  final Widget child;

  // screen drawerBody
  final Widget drawer;

  //  body width when opening the drawer
  final double bodySize;

  final double bodyBackgroundPeekSize;

  final double radius;

  // animation curve
  final Curve curve;

  /// show the clone body when the drawer if open
  final bool hasClone;
  final Key key;

  SwiperDrawer({@required this.child, @required this.drawer, @required this.key, this.bodySize = 80, this.radius = 0, this.hasClone = true, this.bodyBackgroundPeekSize = 50, this.curve = Curves.easeIn, this.backgroundColor = Colors.black}) : super();

  @override
  SwiperDrawerState createState() => SwiperDrawerState(child: child, drawer: drawer, backgroundColor: backgroundColor, bodyBackgroundPeekSize: bodyBackgroundPeekSize, bodySize: bodySize, curve: curve, hasClone: hasClone, radius: radius, key: key);
}

class SwiperDrawerState extends State<SwiperDrawer> with SingleTickerProviderStateMixin {
  Color backgroundColor;
  Widget child;
  Widget drawer;
  double bodySize;
  double bodyBackgroundPeekSize;
  double radius;
  Curve curve;
  bool hasClone;
  Key key;

  AnimationController animationController;
  Animation<double> animation;
  bool dragging = false;

  SwiperDrawerState({@required this.child, @required this.drawer, @required this.key, this.bodySize = 80, this.radius = 0, this.hasClone = true, this.bodyBackgroundPeekSize = 50, this.curve = Curves.easeIn, this.backgroundColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    //get Directionality
    TextDirection currentDirection = Directionality.of(context);
    bool isRTL = currentDirection == TextDirection.rtl;
    // get Screen Size
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: animation,
        builder: (context, snapshot) {
          double scale = .8 + .2 * (1 - animation.value);
          double scaleSmall = .7 + .3 * (1 - animation.value);
          double reverse = isRTL ? -1 : 1;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.translate(
                offset: Offset(0, 0),
                child: InkWell(
                  onTap: () => closeDrawer(),
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: backgroundColor,
                  ),
                ),
              ),
              if (hasClone)
                Opacity(
                  opacity: .3,
                  child: buildAnimationBody(scaleSmall, size, bodySize + bodyBackgroundPeekSize, reverse),
                ),
              GestureDetector(onHorizontalDragStart: (details) {}, behavior: HitTestBehavior.translucent, child: buildAnimationBody(scale, size, bodySize, reverse)),
              Transform.translate(
                offset: Offset(-size.width * (1 - animation.value) * reverse, 0),
                child: buildDrawer(size),
              ),
            ],
          );
        });
  }

  Transform buildAnimationBody(double scale, Size size, double move, double revers) {
    return Transform(
        transform: Matrix4.identity()
          ..scale(scale, scale)
          ..translate((revers) * (size.width - move) * (animation.value)),
        alignment: FractionalOffset.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isOpened() ? radius : 0),
          child: Container(color: Colors.white, child: child),
        ));
  }

  Container buildDrawer(Size size) {
    return Container(width: size.width - (bodySize + bodyBackgroundPeekSize), child: drawer);
  }

  closeDrawer() {
    animationController.reverse();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = CurvedAnimation(parent: animationController, curve: curve);
    super.initState();
  }

  bool isOpened() {
    return animationController.isCompleted;
  }

  openDrawer() {
    animationController.forward();
  }

  openOrClose() {
    if (isOpened())
      closeDrawer();
    else
      openDrawer();
  }
}
