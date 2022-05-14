import 'package:flutter/material.dart';

class ConfirmationSlider extends StatefulWidget {
  /// Height of the slider. Defaults to 70.
  final double height;

  /// Width of the slider. Defaults to 300.
  final double width;

  /// The color of the background of the slider. Defaults to Colors.white.
  final Color backgroundColor;

  /// The color of the background of the slider when it has been slide to the end. By giving a value here, the background color
  /// will gradually change from backgroundColor to backgroundColorEnd when the user slides. Is not used by default.
  final Color backgroundColorEnd;

  /// The color of the moving element of the slider. Defaults to Colors.blueAccent.
  final Color foregroundColor;

  /// The color of the icon on the moving element. Defaults to Colors.white.
  final Color iconColor;

  /// The icon used on the moving element of the slider. Defaults to Icons.chevron_right.
  final IconData icon;

  /// The shadow below the slider. Defaults to BoxShadow(color: Colors.black38, offset: Offset(0, 2),blurRadius: 2,spreadRadius: 0,).
  final BoxShadow shadow;

  /// The text showed below the foreground. Used to specify the functionality to the user. Defaults to "Slide to confirm".
  final String text;

  /// The style of the text. Defaults to TextStyle(color: Colors.black26, fontWeight: FontWeight.bold,).
  final TextStyle textStyle;

  /// The callback when slider is completed. This is the only required field.
  final VoidCallback onConfirmation;

  /// The shape of the moving element of the slider. Defaults to a circular border radius
  final BorderRadius foregroundShape;

  /// The shape of the background of the slider. Defaults to a circular border radius
  final BorderRadius backgroundShape;

  ConfirmationSlider({this.height = 70, this.width = 300, this.backgroundColor = Colors.white, this.backgroundColorEnd, this.foregroundColor = Colors.blueAccent, this.iconColor = Colors.white, this.shadow, this.icon = Icons.chevron_right, this.text = "Slide to confirm", this.textStyle, @required this.onConfirmation, this.foregroundShape, this.backgroundShape}) : super();
  // assert(height >= 25 && width >= 250);

  @override
  _ConfirmationSliderState createState() => _ConfirmationSliderState(
        height: height,
        width: width,
        backgroundColor: backgroundColor,
        backgroundColorEnd: backgroundColorEnd,
        foregroundColor: foregroundColor,
        foregroundShape: foregroundShape,
        iconColor: iconColor,
        icon: icon,
        shadow: shadow,
        textStyle: textStyle,
        backgroundShape: backgroundShape,
        onConfirmation: onConfirmation,
        text: text,
      );
}

class _ConfirmationSliderState extends State<ConfirmationSlider> {
  double height;
  double width;
  Color backgroundColor;
  Color backgroundColorEnd;
  Color foregroundColor;
  Color iconColor;
  IconData icon;
  BoxShadow shadow;
  String text;
  TextStyle textStyle;
  VoidCallback onConfirmation;
  BorderRadius foregroundShape;
  BorderRadius backgroundShape;

  double _position = 0;
  int _duration = 0;
  _ConfirmationSliderState({this.height = 70, this.width = 300, this.backgroundColor = Colors.white, this.backgroundColorEnd, this.foregroundColor = Colors.blueAccent, this.iconColor = Colors.white, this.shadow, this.icon = Icons.chevron_right, this.text = "Slide to confirm", this.textStyle, this.onConfirmation, this.foregroundShape, this.backgroundShape});

  @override
  Widget build(BuildContext context) {
    BoxShadow shadow;
    if (shadow == null) {
      shadow = BoxShadow(
        color: Colors.black38,
        offset: Offset(0, 2),
        blurRadius: 2,
        spreadRadius: 0,
      );
    } else {
      shadow = shadow;
    }

    TextStyle style;
    if (textStyle == null) {
      style = TextStyle(
        color: Colors.black26,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = textStyle;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: _duration),
      curve: Curves.ease,
      height: height,
      width: width,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: backgroundShape ?? BorderRadius.all(Radius.circular(height)),
        color: backgroundColorEnd != null ? this.calculateBackground() : backgroundColor,
        boxShadow: <BoxShadow>[shadow],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              text,
              style: style,
            ),
          ),
          Positioned(
            left: height / 2,
            child: AnimatedContainer(
              height: height - 10,
              width: getPosition(),
              duration: Duration(milliseconds: _duration),
              curve: Curves.ease,
              decoration: BoxDecoration(
                borderRadius: backgroundShape ?? BorderRadius.all(Radius.circular(height)),
                color: backgroundColorEnd != null ? this.calculateBackground() : backgroundColor,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            curve: Curves.bounceOut,
            left: getPosition(),
            top: 0,
            child: GestureDetector(
              onPanUpdate: (details) => updatePosition(details),
              onPanEnd: (details) => sliderReleased(details),
              child: Container(
                height: height - 10,
                width: height - 10,
                decoration: BoxDecoration(
                  borderRadius: foregroundShape ?? BorderRadius.all(Radius.circular(height / 2)),
                  color: foregroundColor,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: height * 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color calculateBackground() {
    double percent;

    // calculates the percentage of the position of the slider
    if (_position > width - height) {
      percent = 1.0;
    } else if (_position / (width - height) > 0) {
      percent = _position / (width - height);
    } else {
      percent = 0.0;
    }

    int red = backgroundColorEnd.red;
    int green = backgroundColorEnd.green;
    int blue = backgroundColorEnd.blue;

    return Color.alphaBlend(Color.fromRGBO(red, green, blue, percent), backgroundColor);
  }

  double getPosition() {
    if (_position < 0) {
      return 0;
    } else if (_position > width - height) {
      return width - height;
    } else {
      return _position;
    }
  }

  void sliderReleased(details) {
    if (_position > width - height) {
      onConfirmation();
    }
    updatePosition(details);
  }

  void updatePosition(details) {
    if (details is DragEndDetails) {
      setState(() {
        _duration = 600;
        _position = 0;
      });
    } else if (details is DragUpdateDetails) {
      setState(() {
        _duration = 0;
        _position = details.localPosition.dx - (height / 2);
      });
    }
  }
}
